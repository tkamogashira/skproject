package KQuest.GUI.dataTable;

import KQuest.GUI.dataTable.models.AbstractTableModel;
import java.awt.Color;
import java.awt.Component;
import javax.swing.JTable;
import javax.swing.table.TableCellRenderer;

public abstract class AbstractTableCellRenderer
        extends javax.swing.table.DefaultTableCellRenderer
        implements TableCellRenderer {
    
    private static final long serialVersionUID = 1L;

    // Foreground colors
    public final static Color FG_DEFAULT                      = Color.BLACK;
    public final static Color FG_UNEDITABLE_DEFAULT           = Color.WHITE;
    // Background colors
    public final static Color BG_SELECTED_EDITABLE            = new Color(185, 185, 185);
    public final static Color BG_SELECTED_EDITABLE_EDITED     = new Color(0, 192, 0);
    public final static Color BG_SELECTED_UNEDITABLE          = new Color(144, 144, 144);
    public final static Color BG_SELECTED_UNEDITABLE_EDITED   = new Color(0, 96, 0);
    public final static Color BG_UNSELECTED_EDITABLE          = Color.WHITE;
    public final static Color BG_UNSELECTED_EDITABLE_EDITED   = new Color(0, 255, 0);
    public final static Color BG_UNSELECTED_UNEDITABLE        = new Color(192, 192, 192);
    public final static Color BG_UNSELECTED_UNEDITABLE_EDITED = new Color(0, 128, 0);
    // Inheritance is only useful when a cell is unedited but editable
    public final static Color BG_UNSELECTED_INHERITED         = new Color(245, 245, 220);
    public final static Color BG_SELECTED_INHERITED           = new Color(200, 200, 175);

    protected AbstractTableCellRenderer() {}

    @Override
    public final Component getTableCellRendererComponent(final JTable table,
            final Object value, final boolean isSelected, final boolean hasFocus,
            final int viewRow, final int viewColumn){
        final Component cell = getComponent(table, value, isSelected, hasFocus,
                viewRow, viewColumn);
        
        final AbstractTableModel tableModel = (AbstractTableModel) table.getModel();
        tableModel.fireTableRowsUpdated(0,
                tableModel.getRowCount() > 0 ? tableModel.getRowCount() - 1 : 0);
        
        return cell;
    }

    protected abstract Component getComponent(final JTable table, final Object value,
            final boolean isSelected, final boolean hasFocus, final int viewRow,
            final int viewColumn);

    /*
     * Allow subclasses to access the getTableCellRendererComponent() method
     * in javax.swing.table.DefaultTableCellRenderer
     */
    protected Component getSuperComponent(final JTable table, final Object value,
            final boolean isSelected, final boolean hasFocus, final int viewRow,
            final int viewColumn) {
        return super.getTableCellRendererComponent(table, value, isSelected,
                hasFocus, viewRow, viewColumn);
    }

    protected Color getBackground(final JTable table, final int viewRow,
            final int viewColumn) {
        
        final AbstractTableModel tableModel = (AbstractTableModel) table.getModel();
        final int row = table.convertRowIndexToModel(viewRow);
        final int column = table.convertColumnIndexToModel(viewColumn);

        if (table.getSelectedRow() == row) {
            // current row is selected
            if (tableModel.isColumnEditable(column)) {
                if (tableModel.isRowEdited(row)) {
                    return BG_SELECTED_EDITABLE_EDITED;
                } else if (tableModel.isCellInherited(row, column)) {
                    return BG_SELECTED_INHERITED;
                } else {
                    return BG_SELECTED_EDITABLE;
                }
            } else {
                if(tableModel.isRowEdited(row)) {
                    return BG_SELECTED_UNEDITABLE_EDITED;
                } else {
                    return BG_SELECTED_UNEDITABLE;
                }
            }
        } else {
            if (tableModel.isColumnEditable(column)) {
                if (tableModel.isRowEdited(row)) {
                    return BG_UNSELECTED_EDITABLE_EDITED;
                } else {
                    if (tableModel.isCellInherited(row, column)) {
                        return BG_UNSELECTED_INHERITED;
                    }
                    return BG_UNSELECTED_EDITABLE;
                }
            } else {
                if (tableModel.isRowEdited(row)) {
                    return BG_UNSELECTED_UNEDITABLE_EDITED;
                } else {
                    return BG_UNSELECTED_UNEDITABLE;
                }
            }
        }
    }

    protected Color getForeground(final JTable table, final int viewRow,
            final int viewColumn) {

        final AbstractTableModel tableModel = (AbstractTableModel) table.getModel();
        final int row = table.convertRowIndexToModel(viewRow);
        final int column = table.convertColumnIndexToModel(viewColumn);

        if (!tableModel.isCellEditable(row, column) && tableModel.isRowEdited(row)) {
            return FG_UNEDITABLE_DEFAULT;
        }
        return FG_DEFAULT;
    }

   // The following methods override the defaults for performance reasons
    @Override
    public void validate() {
        return;
    }

    @Override
    public void revalidate() {
        return;
    }

    @Override
    protected void firePropertyChange(final String propertyName, final Object oldValue,
            final Object newValue) {
        return;
    }

    @Override
    public void firePropertyChange(final String propertyName, final boolean oldValue,
            final boolean newValue) {
        return;
    }
}
