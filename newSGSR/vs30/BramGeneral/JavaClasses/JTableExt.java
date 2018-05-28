import java.lang.*;
import javax.swing.*;

class JTableExt {
    static public void updateTable(JTable tableObj, Object[][] rowData, Object[] columnNames) {
        int r, c, NRow, NCol;
        
        NRow = rowData.length; NCol = columnNames.length;
        
        for (r = 0;  r < NRow; r++) {
                for (c = 0; c < NCol; c++) {
                    tableObj.getColumnModel().getColumn(c).setHeaderValue(columnNames[c]); 
                    tableObj.setValueAt(rowData[r][c], r, c);
                }
        }
        tableObj.getTableHeader().resizeAndRepaint();
    }
}