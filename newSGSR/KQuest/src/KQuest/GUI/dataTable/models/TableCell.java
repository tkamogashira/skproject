package KQuest.GUI.dataTable.models;

/**
 * Class to represent cells in a table;
 * @author u0063666
 */
class TableCell {
    private final int row;
    private final int column;

    TableCell(final int row, final int column) {
        if (row < 0 || column < 0) {
            throw new IllegalArgumentException("Both the row and the column "
                    + "must be positive!");
        }
        this.row = row;
        this.column = column;
    }

    int getColumn() {
        return column;
    }

    int getRow() {
        return row;
    }

    @Override
    public boolean equals(final Object other) {
        if (other.getClass().equals(this.getClass())) {
            TableCell otherCell = (TableCell) other;
            return this.row == otherCell.row && this.column == otherCell.column;
        }
        return false;
    }

    @Override
    public int hashCode() {
        return (row^column) + ((row^column) << (Integer.SIZE/2));
    }
}
