package KQuest.database;

import KQuest.GUI.KQuestApplicationView;
import KQuest.GUI.ConnectionType;
import KQuest.clients.KQuestGUIApplication;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.Query;
import javax.swing.SwingWorker;
import org.apache.commons.io.FileUtils;
import org.jdesktop.application.ResourceMap;

/**
 * Utility class for data management
 */
public class DataManagement {

    private static EntityManager localEntityManager = null;
    private static EntityManager changesEntityManager = null;
    final static String PROPERTY_LOCAL_ENTITY_MANAGER = "entityManager.localPersistenceUnit";
    final static String PROPERTY_CHANGES_ENTITY_MANAGER = "entityManager.changesPersistenceUnit";
    final static String PROPERTY_ONLINE_ENTITY_MANAGER = "entityManager.onlinePersistenceUnit";
    final static String PROPERTY_LOCAL_DERBY_CONNECTION = "database.localDerbyConnection";

    final static String TABLE_NAME_KQUEST_SEQ = "KQuestSeq";
    final static String TABLE_NAME_KQUEST_INDEP = "KQuestIndep";
    final static String TABLE_NAME_KQUEST_SUB_SEQ = "KQuestSubSeq";
    final static String TABLE_NAME_KQUEST_SEQ_PK = "KQuestSeqPK";
    final static String TABLE_NAME_KQUEST_INDEP_PK = "KQuestIndepPK";
    final static String TABLE_NAME_KQUEST_SUB_SEQ_PK = "KQuestSubSeqPK";

    final static String TABLE_NAME_USER_DATA_EXP = "UserDataExp";
    final static String TABLE_NAME_USER_DATA_EXP_PK = "UserDataExpPK";
    final static String TABLE_NAME_USER_DATA_DS = "UserDataDS";
    final static String TABLE_NAME_USER_DATA_DS_PK = "UserDataDSPK";
    final static String TABLE_NAME_USER_DATA_CELL = "UserDataCell";
    final static String TABLE_NAME_USER_DATA_CELL_PK = "UserDataCellPK";
    final static String TABLE_NAME_USER_DATA_CELL_CF = "UserDataCellCF";
    final static String TABLE_NAME_USER_DATA_CELL_CF_PK = "UserDataCellCFPK";
    final static String TABLE_NAME_USER_DATA_BAD_SUB_SEQ = "UserDataBadSubSeq";
    final static String TABLE_NAME_USER_DATA_BAD_SUB_SEQ_PK = "UserDataBadSubSeqPK";

    final static String TABLE_NAME_USER_DATA_EXPOSED = "UserDataExposed";
    final static String TABLE_NAME_USER_DATA_LEFT_RIGHT = "UserDataLeftRight";
    final static String TABLE_NAME_USER_DATA_REC_LOC = "UserDataRecLoc";
    final static String TABLE_NAME_USER_DATA_SPECIES = "UserDataSpecies";
    final static String TABLE_NAME_USER_DATA_SPIKES = "UserDataSpikes";
    final static String TABLE_NAME_USER_DATA_PSTH = "UserDataPSTH";
    final static String TABLE_NAME_USER_DATA_CELL_VALUES = "UserDataCellValues";
    final static String TABLE_NAME_USER_DATA_FYS = "UserDataFys";
    
    private static String datadir;
    static {
        final ResourceMap resourceMap = org.jdesktop.application.Application.
                getInstance(KQuest.clients.KQuestGUIApplication.class).getContext().
                getResourceMap(KQuestGUIApplication.class);
        datadir = resourceMap.getString("Application.dataDir");
    }

    /*
     * Delete all caches when the signalling directory doDelete is present.
     * It is necessary to do this at startup because we cannot do that anymore
     * once our databases are locked.
     */
    static {
        if (new File(datadir + "/doDelete").exists()) {
            for (File file : new File(datadir).listFiles()) {
                if (file.isDirectory()) {
                    try {
                        FileUtils.deleteDirectory(file);
                    } catch (IOException ioexc) {
                        try {
                            System.out.println("Error deleting " + file.getCanonicalPath());
                        } catch (IOException e) {
                            // We should not get here!
                            ioexc.printStackTrace();
                            throw new RuntimeException(e);
                        }
                    }
                }
            }
        }
    }

    // Do not instantiate this class
    private DataManagement() {}

    public static EntityManager getLocalEntityManager()
            throws LocalEntityCreationException {
        if (localEntityManager == null) {
            try {
                localEntityManager =
                        getEntityManager(PROPERTY_LOCAL_ENTITY_MANAGER);
            } catch (Exception e) {
                e.printStackTrace();
                throw new LocalEntityCreationException();
            }
        }
        return localEntityManager;
    }

    public static EntityManager getChangesEntityManager()
            throws LocalEntityCreationException {
        if (changesEntityManager == null) {
            try {
                changesEntityManager =
                        getEntityManager(PROPERTY_CHANGES_ENTITY_MANAGER);
            } catch (Exception e) {
                throw new LocalEntityCreationException();
            }

        }
        return changesEntityManager;
    }

    public static EntityManager getTemporaryLocalEntityManager()
            throws LocalEntityCreationException {
        try {
            return getEntityManager(PROPERTY_LOCAL_ENTITY_MANAGER);
        } catch (Exception e) {
            throw new LocalEntityCreationException();
        }
    }

    public static EntityManager getOnlineTempEntityManager()
            throws OnlineEntityCreationException {
        try {
            KQuestApplicationView.getInstance()
                    .setConnType(ConnectionType.CONNECTION_CONNECTING);
            EntityManager onlineEntityManager =
                    getEntityManager(PROPERTY_ONLINE_ENTITY_MANAGER);
            KQuestApplicationView.getInstance()
                    .setConnType(ConnectionType.CONNECTION_ONLINE);
            return onlineEntityManager;
        } catch (Exception e) {
            KQuestApplicationView.getInstance()
                    .setConnType(ConnectionType.CONNECTION_OFFLINE);
            throw new OnlineEntityCreationException();
        }
    }

    public static EntityManager getOnlineTempEntityManagerNoSideEffects()
            throws OnlineEntityCreationException {
        return getEntityManager(PROPERTY_ONLINE_ENTITY_MANAGER);
    }

    private static EntityManager getEntityManager(String propertyString) {
        final ResourceMap resourceMap = org.jdesktop.application.Application.
                getInstance(KQuest.clients.KQuestGUIApplication.class).getContext().
                getResourceMap(KQuestGUIApplication.class);
        EntityManager entityManager;
        entityManager = javax.persistence.Persistence.
                createEntityManagerFactory(resourceMap.getString(propertyString)).
                createEntityManager();
        return entityManager;
    }

    public static List<String> getTableNames() {
        List<String> tableNames = new ArrayList<String>();
        tableNames.addAll(getDatasetsTableNames());
        tableNames.addAll(getUserDataMainTableNames());
        tableNames.addAll(getUserDataListTableNames());

        return tableNames;
    }

    public static List<String> getDatasetsTableNames() {
        List<String> tableNames = new ArrayList<String>(3);
        tableNames.add(TABLE_NAME_KQUEST_SEQ);
        tableNames.add(TABLE_NAME_KQUEST_INDEP);
        tableNames.add(TABLE_NAME_KQUEST_SUB_SEQ);

        return tableNames;
    }

    public static List<String> getUserDataMainTableNames() {
        List<String> tableNames = new ArrayList<String>(5);
        tableNames.add(TABLE_NAME_USER_DATA_EXP);
        tableNames.add(TABLE_NAME_USER_DATA_DS);
        tableNames.add(TABLE_NAME_USER_DATA_CELL);
        tableNames.add(TABLE_NAME_USER_DATA_CELL_CF);
        tableNames.add(TABLE_NAME_USER_DATA_BAD_SUB_SEQ);

        return tableNames;
    }

    public static List<String> getUserDataListTableNames() {
        List<String> tableNames = new ArrayList<String>(8);
        tableNames.add(TABLE_NAME_USER_DATA_EXPOSED);
        tableNames.add(TABLE_NAME_USER_DATA_LEFT_RIGHT);
        tableNames.add(TABLE_NAME_USER_DATA_REC_LOC);
        tableNames.add(TABLE_NAME_USER_DATA_SPECIES);
        tableNames.add(TABLE_NAME_USER_DATA_SPIKES);
        tableNames.add(TABLE_NAME_USER_DATA_PSTH);
        tableNames.add(TABLE_NAME_USER_DATA_CELL_VALUES);
        tableNames.add(TABLE_NAME_USER_DATA_FYS);

        return tableNames;
    }

    @Deprecated
    private static void localSqlStatus() {
        final ResourceMap resourceMap = org.jdesktop.application.Application.
                getInstance(KQuest.clients.KQuestGUIApplication.class).getContext().
                getResourceMap(KQuestGUIApplication.class);
        Connection con = null;
        try {
            con = DriverManager.getConnection(
                    resourceMap.getString(PROPERTY_LOCAL_DERBY_CONNECTION));

            // Database and driver info
            DatabaseMetaData meta = con.getMetaData();
            System.out.println("Server name: "
                    + meta.getDatabaseProductName());
            System.out.println("Server version: "
                    + meta.getDatabaseProductVersion());
            System.out.println("Driver name: "
                    + meta.getDriverName());
            System.out.println("Driver version: "
                    + meta.getDriverVersion());
            System.out.println("JDBC major version: "
                    + meta.getJDBCMajorVersion());
            System.out.println("JDBC minor version: "
                    + meta.getJDBCMinorVersion());

            ResultSet res = meta.getTables(null, null, null, new String[]{"TABLE"});
            System.out.println("List of tables: ");
            while (res.next()) {
                System.out.println(
                        "   " + res.getString("TABLE_CAT")
                        + ", " + res.getString("TABLE_SCHEM")
                        + ", " + res.getString("TABLE_NAME")
                        + ", " + res.getString("TABLE_TYPE")
                        + ", " + res.getString("REMARKS"));
            }

            con.close();
        } catch (Exception e) {
            System.err.println("Exception: " + e.getMessage());
        }
    }

    public static void uploadChangesTables() {
        (new ChangesUploader()).execute();
    }

    public static void purgeChangesTables() {
        (new SwingWorker<Void, Void>() {

            @Override
            protected Void doInBackground() throws Exception {

                EntityManager changesEntityManager = null;
                try {
                    changesEntityManager = getChangesEntityManager();
                } catch (LocalEntityCreationException e) {
                    KQuestApplicationView.getInstance().showErrorMessageDialog(
                            "Something went wrong, this shouldn't happen. "
                            + "Please contact a developer.", "Error");
                    e.printStackTrace();
                }
                try {
                    changesEntityManager = getChangesEntityManager();
                    changesEntityManager.getTransaction().begin();
                    for (String dataTable : getTableNames()) {
                        Query deleteQuery = changesEntityManager.createQuery(
                                "DELETE FROM " + dataTable + " q");
                        deleteQuery.executeUpdate();
                    }
                    changesEntityManager.getTransaction().commit();
                } catch (Exception e) {
                    e.printStackTrace();
                    changesEntityManager.getTransaction().rollback();
                }
                
                return null;
            }

            @Override
            protected void done() {
                DataManagement.updateTable();
            }
        }).execute();
    }

    public static void revertRootChange(final String fileName) {
        (new SwingWorker<Void, Void>() {

            @Override
            protected Void doInBackground() throws Exception {

                EntityManager changesEntityManager = null;
                try {
                    changesEntityManager = DataManagement.getChangesEntityManager();
                } catch (LocalEntityCreationException e) {
                    KQuestApplicationView.getInstance().showErrorMessageDialog(
                            "Something went wrong, this shouldn't happen. "
                            + "Please contact a developer.", "Error");
                    e.printStackTrace();
                }
                try {
                    changesEntityManager.getTransaction().begin();
                    Query deleteQuery = changesEntityManager.createQuery(
                            "DELETE FROM " + TABLE_NAME_USER_DATA_EXP + " q"
                            + " WHERE q.userDataExpPK.fileName=:fileName");
                    deleteQuery.setParameter("fileName", fileName);
                    deleteQuery.executeUpdate();
                    changesEntityManager.getTransaction().commit();
                } catch (Exception e) {
                    e.printStackTrace();
                    changesEntityManager.getTransaction().rollback();
                }
                
                return null;
            }

            @Override
            protected void done() {
                DataManagement.updateTable();
            }
        }).execute();
    }

    public static void revertExperimentChange(final String fileName, final int cellNr) {
        (new SwingWorker<Void, Void>() {

            @Override
            protected Void doInBackground() throws Exception {

                EntityManager changesEntityManager = null;
                try {
                    changesEntityManager = DataManagement.getChangesEntityManager();
                } catch (LocalEntityCreationException e) {
                    KQuestApplicationView.getInstance().showErrorMessageDialog(
                            "Something went wrong, this shouldn't happen. "
                            + "Please contact a developer.", "Error");
                    e.printStackTrace();
                }
                try {
                    changesEntityManager = DataManagement.getChangesEntityManager();
                    changesEntityManager.getTransaction().begin();
                    Query deleteQuery = changesEntityManager.createQuery(
                            "DELETE FROM " + TABLE_NAME_USER_DATA_CELL + " q"
                            + " WHERE q.userDataCellPK.fileName=:fileName"
                            + " AND q.userDataCellPK.nr=:cellnr");
                    deleteQuery.setParameter("fileName", fileName);
                    deleteQuery.setParameter("cellnr", cellNr);
                    deleteQuery.executeUpdate();
                    changesEntityManager.getTransaction().commit();

                    changesEntityManager.getTransaction().begin();
                    deleteQuery = changesEntityManager.createQuery(
                            "DELETE FROM " + TABLE_NAME_USER_DATA_CELL_CF + " q"
                            + " WHERE q.userDataCellCFPK.fileName=:fileName"
                            + " AND q.userDataCellCFPK.iCell=:cellnr");
                    deleteQuery.setParameter("fileName", fileName);
                    deleteQuery.setParameter("cellnr", cellNr);
                    deleteQuery.executeUpdate();
                    changesEntityManager.getTransaction().commit();
                } catch (Exception e) {
                    e.printStackTrace();
                    changesEntityManager.getTransaction().rollback();
                }

                return null;
            }

            @Override
            protected void done() {
                DataManagement.updateTable();
            }
        }).execute();
    }

    public static void revertCellChange(final String fileName, final int seqNr) {
        (new SwingWorker<Void, Void>() {

            @Override
            protected Void doInBackground() throws Exception {
                EntityManager changesEntityManager = null;
                try {
                    changesEntityManager = DataManagement.getChangesEntityManager();
                } catch (LocalEntityCreationException e) {
                    KQuestApplicationView.getInstance().showErrorMessageDialog(
                            "Something went wrong, this shouldn't happen. "
                            + "Please contact a developer.", "Error");
                    e.printStackTrace();
                }
                try {
                    changesEntityManager.getTransaction().begin();

                    Query deleteQuery = changesEntityManager.createQuery(
                            "DELETE FROM " + TABLE_NAME_USER_DATA_DS + " q"
                            + " WHERE q.userDataDSPK.fileName=:fileName"
                            + " AND q.userDataDSPK.iSeq=:seqnr")
                            .setParameter("fileName", fileName)
                            .setParameter("seqnr", seqNr);
                    deleteQuery.executeUpdate();

                    deleteQuery = changesEntityManager.createQuery(
                            "DELETE FROM " + TABLE_NAME_KQUEST_SEQ + " q"
                            + " WHERE q.kQuestSeqPK.fileName = :fileName"
                            + " AND q.kQuestSeqPK.iSeq=:seqnr")
                            .setParameter("fileName", fileName)
                            .setParameter("seqnr", seqNr);
                    deleteQuery.executeUpdate();

                    changesEntityManager.getTransaction().commit();
                } catch (Exception e) {
                    e.printStackTrace();
                    changesEntityManager.getTransaction().rollback();
                }
                
                return null;
            }

            @Override
            protected void done() {
                DataManagement.updateTable();
            }
        }).execute();
    }

    public static void revertSequenceChange(final String fileName,
            final int seqNr, final int subSeqNr) {
        (new SwingWorker<Void, Void>() {

            @Override
            protected Void doInBackground() throws Exception {
                EntityManager changesEntityManager = null;
                try {
                    changesEntityManager = DataManagement.getChangesEntityManager();
                } catch (LocalEntityCreationException e) {
                    KQuestApplicationView.getInstance().showErrorMessageDialog(
                            "Something went wrong, this shouldn't happen. "
                            + "Please contact a developer.", "Error");
                    e.printStackTrace();
                }
                try {
                    changesEntityManager.getTransaction().begin();

                    Query deleteQuery = changesEntityManager.createQuery(
                            "DELETE FROM " + TABLE_NAME_USER_DATA_BAD_SUB_SEQ + " q"
                            + " WHERE q.userDataBadSubSeqPK.fileName=:fileName"
                            + " AND q.userDataBadSubSeqPK.iSeq=:seqnr"
                            + " AND q.userDataBadSubSeqPK.subSeqNr=:subseqnr")
                            .setParameter("fileName", fileName)
                            .setParameter("seqnr", seqNr)
                            .setParameter("subseqnr", subSeqNr);
                    deleteQuery.executeUpdate();

                    deleteQuery = changesEntityManager.createQuery(
                            "DELETE FROM " + TABLE_NAME_KQUEST_SUB_SEQ + " q"
                            + " WHERE q.kQuestSubSeqPK.fileName=:filename"
                            + " AND q.kQuestSubSeqPK.iSeq=:iseq"
                            + " AND q.kQuestSubSeqPK.subSeqNr=:isubseq")
                            .setParameter("filename", fileName)
                            .setParameter("iseq", seqNr)
                            .setParameter("isubseq", subSeqNr);
                    deleteQuery.executeUpdate();

                    changesEntityManager.getTransaction().commit();
                } catch (Exception e) {
                    e.printStackTrace();
                    changesEntityManager.getTransaction().rollback();
                }

                return null;
            }

            @Override
            protected void done() {
                DataManagement.updateTable();
            }
        }).execute();
    }

    private static void updateTable() {
        // TODO: ugly flash on revert
        //fireTableCellUpdated(rowNumber, columnNumber);
        //fireTableDataChanged();
        KQuestApplicationView.getInstance().updateTable();
    }

    /**
     * Remove all cached database entries in the data dir.
     * Doing this is necessary when the database format is changed
     * (e.g. a table is added).
     * After this action the application should be restarted and thus we
     * explicitely run exit() here.
     */
    public static void removeAllCachesAndExit() {
        final String message = "The database format has changed, this requires"
                + " you to drop all local caches and re-download the database."
                + "\nIf you had changes stored locally that were not uploaded"
                + " yet, you might be able to checkout a previous subversion"
                + " revision and upload the changes from there, press Cancel"
                + " if you'd like to try that."
                + "\nIf you press OK, all locally stored caches will be dropped"
                + " and permanently lost."
                + "\n\nDelete all database caches under " + datadir + "?"
                + "\nThe application will be terminated after this action.";

        final boolean doDelete =
                KQuestApplicationView.getInstance().showConfirmDialog(message,
                "Drop all caches?");

        if (doDelete) {
            new File(datadir + "/doDelete").mkdir();
        }
        System.exit(0);
    }
}
