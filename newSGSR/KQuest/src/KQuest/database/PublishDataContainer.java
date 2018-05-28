package KQuest.database;

/**
 * @author Ramses de Norre
 */
public class PublishDataContainer {

    private final long progress;
    private final long total;
    private final String dataTable;
    private final int tableCount;
    private final int numberOfTables;

    PublishDataContainer(final long progress, final long total,
            final String dataTable, final int tableCount,
            final int numberOfTables) {
        this.progress = progress;
        this.total = total;
        this.dataTable = dataTable;
        this.tableCount = tableCount;
        this.numberOfTables = numberOfTables;
    }

    String getDataTable() {
        return dataTable;
    }

    long getProgress() {
        return progress;
    }

    long getTotal() {
        return total;
    }

    int getNumberOfTables() {
        return numberOfTables;
    }

    int getTableCount() {
        return tableCount;
    }

    int getPercentage() {
        return getTotal() == 0 ?
            0 : (int) ((double) getProgress() / getTotal() * 100);
    }
}
