package KQuest.database;

import KQuest.GUI.KQuestApplicationView;
import KQuest.clients.KQuestGUIApplication;
import KQuest.database.entities.UserDataEntity;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.Query;
import javax.swing.SwingWorker;
import org.jdesktop.application.Application;
import org.jdesktop.application.ResourceMap;

public class DatabaseUpdater
        extends SwingWorker<String[], PublishDataContainer> {

    private final static int CHUNK_SIZE;
    
    static {
        ResourceMap resourceMap = Application.
                getInstance(KQuest.clients.KQuestGUIApplication.class).getContext().
                getResourceMap(KQuestGUIApplication.class);
        CHUNK_SIZE = Integer.parseInt(resourceMap.getString("databaseUpdater.chunkSize"));
    }

    /*
     * The capacity of 60 is a rough estimate, since we reuse the StringBuilder
     * by setting its length to zero, an underestimation of the capacity is not
     * so bad
     */
    private final static StringBuilder builder = new StringBuilder(60);

    @Override
    protected String[] doInBackground() {
        final List<String> userdataTables = DataManagement.getUserDataListTableNames();
        userdataTables.addAll(DataManagement.getUserDataMainTableNames());
        final List<String> datasetTables = DataManagement.getDatasetsTableNames();
        final String[] messages = new String[]{"", ""};

        final int numberOfTables = userdataTables.size() + datasetTables.size();
        int count = 1;

        try {
            for (String userdataTable : userdataTables) {
                publish(new PublishDataContainer(-1, -1, userdataTable,
                        count, numberOfTables));
                updateUserdataTable(userdataTable, count, numberOfTables);
                count++;
            }
            for (String datasetTable : datasetTables) {
                publish(new PublishDataContainer(-1, -1, datasetTable,
                        count, numberOfTables));
                updateDatasetTable(datasetTable, count, numberOfTables);
                count++;
            }
            assert count == numberOfTables;
        } catch (final OnlineEntityCreationException ex) {
            messages[0] = "Could not connect to online server. Working offline.";
            messages[1] = ex.getMessage();
        } catch (final LocalEntityCreationException ex) {
            KQuestApplicationView.getInstance().reportLocalDatabaseErrorAndExit();
            messages[0] = ex.getMessage();
        } catch (final Exception ex) {
            messages[1] = ex.getMessage();
        }
        return messages;
    }

    @Override
    protected void process(final List<PublishDataContainer> progressList) {
        final PublishDataContainer progress = progressList.get(progressList.size() - 1);

        // Clear the StringBuilder
        builder.setLength(0);
        
        builder.append("Updating table ").append(progress.getDataTable())
                .append(" (").append(progress.getTableCount()).append("/")
                .append(progress.getNumberOfTables()).append(")");

        if (progress.getProgress() != -1 && progress.getTotal() != -1) {
            builder.append(": ").append(progress.getPercentage()).append("%");
        }
        KQuestApplicationView.getInstance().setStatusText(builder.toString());
    }

    @Override
    protected void done() {
        try {
            KQuestApplicationView.getInstance().updateGUI();

            final String[] messages = get();
            
            if (! messages[0].isEmpty()) {
                KQuestApplicationView.getInstance().setStatusText(messages[0]);
            } else if (messages[1].isEmpty()) {
                KQuestApplicationView.getInstance().setStatusText(
                        "Finished downloading tables.");
            } else {
                KQuestApplicationView.getInstance().setStatusText(
                        "Not all tables could be updated.");
                System.out.println("\nError while downloading tables: "
                        + messages[1] + "\n");
                DataManagement.removeAllCachesAndExit();
            }
        } catch (final InterruptedException ex) {
           ex.printStackTrace();
        } catch (final ExecutionException ex) {
            ex.printStackTrace();
        }
    }

    private void updateDatasetTable(final String datasetTable,
            final int tableCount, final int numberOfTables) {
        // TODO: _decent error handling
        try {
            publish(new PublishDataContainer(-1, -1, datasetTable, tableCount,
                    numberOfTables));

            EntityManager temporaryLocalEntityManager =
                    DataManagement.getTemporaryLocalEntityManager();
            final Query query = temporaryLocalEntityManager.createQuery(
                    "SELECT seq.idx FROM " + datasetTable + " seq");
            final List<Integer> localSequences = query.getResultList();
            temporaryLocalEntityManager.close();

            final String whereClause;
            if (!localSequences.isEmpty()) {
                // stringify the list of local sequences, and strip off the brackets '[' and ']'
                String queryInClause = localSequences.toString()
                        .substring(1, localSequences.toString().length() - 1);
                whereClause = "WHERE seq.idx NOT IN (" + queryInClause + ")";
            } else {
                whereClause = "";
            }

            // get amount of Sequences to download
            EntityManager onlineEntityManager = DataManagement.getOnlineTempEntityManager();
            final Query countQuery = onlineEntityManager.createQuery(
                    "SELECT COUNT(seq) " + "FROM " + datasetTable + " seq "
                    + whereClause);
            final Long totalResults = (Long) countQuery.getSingleResult();
            onlineEntityManager.close();

            // Download sequences in chuncks of size CHUNK_SIZE, and store locally
            Boolean resultsFound = false;
            Integer firstResult = 0; // used for pagination in downloaded results
            do {
                publish(new PublishDataContainer(firstResult, totalResults,
                        datasetTable, tableCount, numberOfTables));
                List<Object> downloadedSequences = new ArrayList<Object>();
                onlineEntityManager = DataManagement.getOnlineTempEntityManager();
                Query onlineQuery = onlineEntityManager.createQuery(
                        "SELECT seq" + " FROM " + datasetTable + " seq "
                        + whereClause);
                onlineQuery.setMaxResults(CHUNK_SIZE); // pagination
                onlineQuery.setFirstResult(firstResult);
                downloadedSequences = onlineQuery.getResultList();
                onlineEntityManager.close();

                resultsFound = !downloadedSequences.isEmpty();
                if (resultsFound) {
                    try {
                        temporaryLocalEntityManager =
                                DataManagement.getTemporaryLocalEntityManager();
                        EntityTransaction transaction =
                                temporaryLocalEntityManager.getTransaction();
                        try {
                            transaction.begin();
                            for (Object downloadedSequence : downloadedSequences) {
                                temporaryLocalEntityManager.persist(downloadedSequence);
                            }
                            transaction.commit();
                        } finally {
                            // TODO: _decent error handling
                            if (transaction.isActive()) {
                                transaction.rollback();
                            }
                        }
                    } finally {
                        temporaryLocalEntityManager.close();
                    }
                }
                firstResult += downloadedSequences.size();
            } while (resultsFound);

        } catch (final Exception e) {
            e.printStackTrace();
        }
    }

    private void updateUserdataTable(final String table,
            final int tableCount, final int numberOfTables)
            throws OnlineEntityCreationException, LocalEntityCreationException {
        Boolean resultsFound;
        EntityManager onlineEntityManager =
                DataManagement.getOnlineTempEntityManager();

        Long nRows = 0L;
        try {
            final Query countQuery = onlineEntityManager.createQuery(
                    "SELECT COUNT(row) FROM " + table + " row");
            nRows = (Long) countQuery.getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            onlineEntityManager.close();
        }

        int firstResult = 0;
        do {
            publish(new PublishDataContainer(firstResult, nRows, table,
                    tableCount, numberOfTables));

            List<UserDataEntity> entities = new ArrayList<UserDataEntity>();
            onlineEntityManager = DataManagement.getOnlineTempEntityManager();
            try {
                Query onlineQuery = onlineEntityManager.createQuery(
                        "SELECT row FROM " + table + " row");
                onlineQuery.setMaxResults(CHUNK_SIZE);
                onlineQuery.setFirstResult(firstResult);
                entities = onlineQuery.getResultList();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                onlineEntityManager.close();
            }

            resultsFound = !entities.isEmpty();
            if (resultsFound) {
                EntityManager temporaryLocalEntityManager =
                        DataManagement.getTemporaryLocalEntityManager();
                try {
                    EntityTransaction transaction =
                            temporaryLocalEntityManager.getTransaction();
                    try {
                        transaction.begin();
                        for (Object entity : entities) {
                            temporaryLocalEntityManager.merge(entity);
                        }
                        transaction.commit();
                    } finally {
                        // TODO: _decent error handling
                        if (transaction.isActive()) {
                            transaction.rollback();
                        }
                    }
                } finally {
                    temporaryLocalEntityManager.close();
                }
            }

            firstResult += entities.size();
        } while (resultsFound);
    }
}
