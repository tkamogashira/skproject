package KQuest.GUI.dataTable;

import javax.swing.JCheckBox;
import javax.swing.JTable;

public class BooleanTableCellRenderer extends AbstractTableCellRenderer {
    private static final long serialVersionUID = 1L;

    public BooleanTableCellRenderer() {
        super();
    }

    @Override
    public JCheckBox getComponent(final JTable table, final Object value,
            final boolean isSelected, final boolean hasFocus, final int viewRow,
            final int viewColumn) {
        
        final JCheckBox box = new JCheckBox();
        box.setHorizontalAlignment(JCheckBox.CENTER);
        
        box.setForeground(super.getForeground(table, viewRow, viewColumn));
        box.setBackground(super.getBackground(table, viewRow, viewColumn));
        
        box.setSelected((value != null && ((Boolean) value).booleanValue()));

        return box;
    }
}
