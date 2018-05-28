package KQuest.clients;

import KQuest.database.DataManagement;
import KQuest.database.LocalEntityCreationException;
import KQuest.database.OnlineEntityCreationException;
import java.util.HashMap;
import java.util.Map;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.Query;

public class KQuestDatabaseClient {
    
    final EntityManager entityManager;

    private KQuestDatabaseClient() {
        this.entityManager = getEntityManager();
    }

    /*
     * First try to get an online entity manager to query the database at
     * lan-srv-01 directly. If this fails we try to get a local entity manager
     * to query the cached version of the database.
     */
    private EntityManager getEntityManager() {
        EntityManager tmpEntityManager = null;

        try {
            tmpEntityManager = DataManagement.getOnlineTempEntityManagerNoSideEffects();
        } catch (OnlineEntityCreationException oExcp) {
            try {
                tmpEntityManager = DataManagement.getLocalEntityManager();
            } catch (LocalEntityCreationException lExcp) {
                System.err.println("Creation of both a local and an online entity" +
                        " manager failed! Below are the exceptions that occured." +
                        "\nThe most likely scenario is that lan-srv-01 is" +
                        " unreachable and another application has locked the" +
                        " local database." +
                        "\nThis application is terminated.");
                System.err.println(oExcp.getMessage());
                System.err.println(lExcp.getMessage());
                System.exit(1);
            }
        }

        return tmpEntityManager;
    }

    // Abuse type erasure a bit to express this method
    @SuppressWarnings("unchecked")
    private <T> Map<String, T> queryResultToMap(final Object result,
            final String[] names) {
        Map<String, T> resultMap = new HashMap<String, T>(names.length);

        T[] sequences = null;
        if (result != null) {
            //Object[] resultArray = (Object[]) result;
            sequences = (T[]) ((Object[]) result);
            //sequences = Arrays.asList(resultArray).toArray((T[]) resultArray);
        }

        for (int i = 0; i < names.length; i++) {
            resultMap.put(names[i], result != null ? sequences[i] : null);
        }

        return resultMap;
    }

    public Map<String, String> getUserdataForExperiment(final String experiment) {
        Query query = entityManager.createQuery(
                "SELECT exp.aim, exp.chan1, exp.chan2, " +
                "exp.dss1, exp.dss2, exp.eval, exp.exposed, exp.recLoc, " +
                "exp.recSide, exp.species, exp.stimChan " +
                "FROM UserDataExp exp " +
                "WHERE exp.userDataExpPK.fileName=:experiment");
        query.setParameter("experiment", experiment);

        Object result = null;
        try {
            result = query.getSingleResult();
        } catch (NoResultException exp) {
            //NO-OP;
        }

        String[] names = new String[] {"Aim", "Chan1", "Chan2", "DSS1", "DSS2", "Eval",
                    "Exposed", "RecLoc", "RecSide", "Species", "StimChan"};

        return queryResultToMap(result, names);
    }

    public Map<String, String> getUserdataForFile(final String filename) {
        Query query = entityManager.createQuery(
            "SELECT ds.eval, ds.ignoreDS, ds.userDataDSPK.iSeq "
            + "FROM UserDataDS ds WHERE ds.userDataDSPK.fileName=:filename");
        query.setParameter("filename", filename);

        Object result = null;
        try {
            result = query.getSingleResult();
        } catch (NoResultException exp) {
            //NO-OP;
        }

        String[] names = new String[] {"Eval", "Ignore_DS", "iSeq"};

        return queryResultToMap(result, names);
    }

    public static void main(String[] args) throws LocalEntityCreationException {
        Map<?,?> map = new HashMap<Object, Object>();
        //map = new KQuestDatabaseClient().getUserdataForExperiment("c94110");
        map = new KQuestDatabaseClient().getUserdataForFile("a0242");
        return;
    }
}
