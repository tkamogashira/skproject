package KQuest.GUI.dataTable;

import KQuest.GUI.dataTable.models.AbstractTableModel;
import java.awt.Component;
import java.awt.Font;
import javax.swing.JTable;

public class DefaultTableCellRenderer extends AbstractTableCellRenderer {
    private static final long serialVersionUID = 1L;

    public DefaultTableCellRenderer() {
        super();
    }

    @Override
    public Component getComponent(final JTable table, final Object value,
            final boolean isSelected, final boolean hasFocus, final int viewRow,
            final int viewColumn) {

        final Component cell = super.getSuperComponent(table, value,
                isSelected, hasFocus, viewRow, viewColumn);

        // Get the model
        final AbstractTableModel tableModel = (AbstractTableModel) table.getModel();

        // Convert the view indices viewRow and viewColumn to model indices
        final int row = table.convertRowIndexToModel(viewRow);
        final int column = table.convertColumnIndexToModel(viewColumn);

        cell.setBackground(getBackground(table, viewRow, viewColumn));
        cell.setForeground(getForeground(table, viewRow, viewColumn));

        if (tableModel.wasCellEdited(row, column)) {
            cell.setFont(getFont().deriveFont(Font.BOLD));
        }

        return cell;
    }
}
