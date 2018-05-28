package KQuest.database;

import KQuest.GUI.KQuestApplicationView;
import KQuest.database.entities.AbstractEntity;
import KQuest.database.entities.KQuestEntity;
import java.util.List;
import java.util.concurrent.ExecutionException;
import javax.persistence.EntityManager;
import javax.persistence.Query;
import javax.swing.SwingWorker;

/**
 * @author Ramses de Norre
 */
public class ChangesUploader extends SwingWorker<Boolean, Void> {

    {
        KQuestApplicationView.getInstance().setSaveMode(true);
    }

    @Override
    protected Boolean doInBackground() throws Exception {
        Boolean success = Boolean.TRUE;

        try {
            uploadChangesTables();
        } catch (Exception e) {
            e.printStackTrace();
            success = Boolean.FALSE;
        }

        return success;
    }

    @Override
    protected void done() {
        Boolean success = Boolean.FALSE;
        try {
            success = get();
        } catch (InterruptedException ex) {
            ex.printStackTrace();
        } catch (ExecutionException ex) {
            ex.printStackTrace();
        }

        if (! success) {
            KQuestApplicationView.getInstance().showErrorMessageDialog(
                    "There was an unknown error uploading local changes to "
                    + "the server. Check your connection, restart KQuest, "
                    + "and contact a programmer if the problem persists.",
                    "Error uploading changes");
        } else {
            KQuestApplicationView.getInstance().
                    showMessageDialog("Succesfully uploaded all changes.", "Succes");
        }
        KQuestApplicationView.getInstance().setSaveMode(false);
        KQuestApplicationView.getInstance().updateTable();
    }

    public static void uploadChangesTables()
            throws LocalEntityCreationException, OnlineEntityCreationException, Exception {
        EntityManager onlineEntityManager = DataManagement.getOnlineTempEntityManager();
        EntityManager localEntityManager = DataManagement.getLocalEntityManager();
        EntityManager changesEntityManager = DataManagement.getChangesEntityManager();

        final List<String> changeableTables = DataManagement.getUserDataMainTableNames();
        changeableTables.addAll(DataManagement.getDatasetsTableNames());

        for (String dataTable : changeableTables) {
            Query changesQuery = changesEntityManager.createQuery(
                    "SELECT r FROM " + dataTable + " r");
            @SuppressWarnings("unchecked")
            List<KQuestEntity<?>> changedRows = changesQuery.getResultList();
            for (KQuestEntity<?> changedRow : changedRows) {

                /*
                 * Upload the changed row
                 */
                Object onlineRow = onlineEntityManager
                        .find(changedRow.getClass(), changedRow.getPrimaryKey());
                if (onlineRow != null) {
                    try {
                        onlineEntityManager.getTransaction().begin();
                        onlineEntityManager.merge(changedRow);
                        onlineEntityManager.getTransaction().commit();
                    } catch (Exception e) {
                        e.printStackTrace();
                        // Let doInBackground() handle this further
                        throw(e);
                    }
                } else {
                    onlineEntityManager.getTransaction().begin();
                    onlineEntityManager.persist(changedRow);
                    onlineEntityManager.getTransaction().commit();
                }

                /*
                 * Merge the changes into our local database
                 */
                AbstractEntity localRow = localEntityManager
                        .find(changedRow.getClass(), changedRow.getPrimaryKey());
                localEntityManager.getTransaction().begin();
                if (localRow != null) {
                    localEntityManager.merge(changedRow);
                } else {
                    localEntityManager.persist(changedRow);
                }
                localEntityManager.getTransaction().commit();

                /*
                 * Remove the uploaded row from the changes database
                 */
                changesEntityManager.getTransaction().begin();
                changesEntityManager.remove(changedRow);
                changesEntityManager.getTransaction().commit();
            }
        }
        onlineEntityManager.close();
    }
}
