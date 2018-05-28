package KQuest.GUI.dataTable;

import KQuest.GUI.dataTable.models.AbstractTableModel;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionAdapter;
import javax.swing.JTable;
import javax.swing.ToolTipManager;
import javax.swing.table.JTableHeader;
import javax.swing.table.TableColumn;
import javax.swing.table.TableColumnModel;

/**
 * @author Ramses de Norre
 */
public class ColumnHeaderTooltipsAdapter extends MouseMotionAdapter {
    // Current column whose tooltip is being displayed.
    // This variable is used to minimize the calls to setToolTipText().
    private TableColumn curCol;

    public ColumnHeaderTooltipsAdapter() {
        super();
        ToolTipManager manager = ToolTipManager.sharedInstance();
        manager.setDismissDelay(60000);
        manager.setInitialDelay(0);
        manager.setReshowDelay(0);
        manager.setLightWeightPopupEnabled(true);
    }

    @Override
    public void mouseMoved(final MouseEvent evt) {
        TableColumn col = null;
        JTableHeader header = (JTableHeader) evt.getSource();
        JTable table = header.getTable();
        TableColumnModel colModel = table.getColumnModel();
        int vColIndex = colModel.getColumnIndexAtX(evt.getX());

        if (vColIndex >= 0) {
            col = colModel.getColumn(vColIndex);
        } else {
            // Return if not clicked on any column header
            return;
        }

        if (col != curCol) {
            header.setToolTipText(
                    ((AbstractTableModel) table.getModel()).getTooltipFor(col));
            curCol = col;
        }
    }
}
