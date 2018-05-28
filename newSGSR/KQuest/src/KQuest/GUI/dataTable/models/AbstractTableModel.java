package KQuest.GUI.dataTable.models;

import KQuest.GUI.KQuestApplicationView;
import KQuest.GUI.dataTable.models.columns.AbstractColumn;
import KQuest.database.DataManagement;
import KQuest.database.LocalEntityCreationException;
import KQuest.database.entities.KQuestIndep;
import KQuest.database.entities.KQuestSeq;
import KQuest.database.entities.KQuestSubSeq;
import KQuest.database.entities.UserDataBadSubSeq;
import KQuest.database.entities.UserDataCell;
import KQuest.database.entities.UserDataCellCF;
import KQuest.database.entities.UserDataDS;
import KQuest.database.entities.UserDataExp;
import java.awt.Point;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.Query;
import javax.swing.JMenuItem;
import javax.swing.JPopupMenu;
import javax.swing.SwingUtilities;
import javax.swing.event.TableModelEvent;
import javax.swing.event.TableModelListener;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableColumn;
import oracle.toplink.essentials.exceptions.DatabaseException;

@SuppressWarnings("unchecked")
public abstract class AbstractTableModel extends DefaultTableModel
        implements TableModelListener, MouseListener {

    private static final long serialVersionUID = 1L;

    private Set<Integer> editedRows;
    private List<Map<String, Object>> tableRows;
    private Set<TableCell> inheritedCells;

    private final EntityManager localEntityManager;
    private final EntityManager changesEntityManager;

    private Set<Integer> editableColumns;   // columns that can be edited

    /**
     * Map column titles to their column objects
     */
    private Map<String, AbstractColumn> columns;

    public AbstractTableModel() throws LocalEntityCreationException {
        super();
        editableColumns = new HashSet<Integer>();
        editedRows = new HashSet<Integer>();
        inheritedCells = new HashSet<TableCell>();
        init();
        localEntityManager = DataManagement.getLocalEntityManager();
        changesEntityManager = DataManagement.getChangesEntityManager();
    }

    private void init() throws LocalEntityCreationException {
        initColumns();
        addTableModelListener(this);
    }

    protected List<Map<String, Object>> getTableRows() {
        return this.tableRows;
    }

    protected boolean addToEditedRows(final int row) {
        return editedRows.add(row);
    }

    protected boolean addToEditedRows(final Collection<Integer> rows) {
        return editedRows.addAll(rows);
    }

    /*
     * The Netbeans warnings below are bogus, I am not exporting the TableCell
     * type publicly here as I only use it in protected methods.
     * It is true though that a subtype could override these methods and
     * make them public, but then the warning should be given there.
     */
    protected Set<TableCell> getInheritedCells() {
        return inheritedCells;
    }

    protected boolean addToInheritedCells(final TableCell inheritedCell) {
        return this.inheritedCells.add(inheritedCell);
    }

    protected boolean addToInheritedCells(final Collection<TableCell> inheritedCells) {
        return this.inheritedCells.addAll(inheritedCells);
    }

    protected boolean removeFromInheritedCells(final TableCell inheritedCell) {
        return this.inheritedCells.remove(inheritedCell);
    }

    protected boolean removeFromInheritedCells(final Collection<TableCell> inheritedCells) {
        return this.inheritedCells.removeAll(inheritedCells);
    }

    protected void setEditableColumns(final int[] columns) {
        editableColumns = new HashSet<Integer>(columns.length);
        for (int column : columns) {
            editableColumns.add(new Integer(column));
        }
    }

    public boolean isColumnEditable(final int column) {
        return editableColumns.contains(column);
    }

    public boolean isRowEdited(final int row) {
        return editedRows.contains(row);
    }

    public boolean isCellInherited(final int row, final int column) {
        return getInheritedCells().contains(new TableCell(row, column));
    }

    /*
     * TODO: how is this relevant??
     */
    public boolean wasCellEdited(final int row, final int column) {
        if (!isColumnEditable(column)) {
            return false;
        }

        final String columnName = getColumnName(column);

        final Object value = tableRows.get(row).get(columnName);

        if (value == null) {
            return false;
        }
        if (value.getClass() == String.class) {
            if (((String) value).trim().length() == 0) {
                return false;
            }
        }
        if (value.getClass() == Boolean.class) {
            if (((Boolean) value) == false) {
                return false;
            }
        }
        return true;
    }

    @Override
    public boolean isCellEditable(final int row, final int column) {
        return isColumnEditable(column);
    }

    protected void fillTableModel(final String[] columnTitles, final int[] editableColumns,
            final Set<Integer> editedRows, final List<Map<String, Object>> tableRows) {
        setColumnIdentifiers(columnTitles);
        setEditableColumns(editableColumns);
        setRowCount(0);

        this.tableRows = tableRows;
        this.editedRows = editedRows;

        for (Map<String, Object> tableRow : tableRows) {
            final int nCols = tableRow.size();
            if (nCols != columnTitles.length) {
                try {
                    throw new IllegalArgumentException(
                            "Row length does not equal amount of columns!");
                } catch (IllegalArgumentException ex) {
                    Logger.getLogger(AbstractTableModel.class.getName()).
                            log(Level.SEVERE, null, ex);
                }
            }
            final Object[] rowElements = new Object[nCols];
            for (int cCol = 0; cCol < columnTitles.length; cCol++) {
                rowElements[cCol] = tableRow.get(columnTitles[cCol]);
            }
            this.addRow(rowElements);
        }
    }

    @Override
    public abstract void tableChanged(final TableModelEvent ev);

        protected List<String> getFilenames() {
        final Query localQuery = getLocalEntityManager().createQuery(
                "SELECT DISTINCT seq.kQuestSeqPK.fileName"
                + " FROM KQuestSeq seq ORDER BY seq.kQuestSeqPK.fileName");
        List<String> filenames = null;
        try {
            filenames = localQuery.getResultList();
        } catch (DatabaseException e) {
            DataManagement.removeAllCachesAndExit();
        }
        return filenames == null ? new ArrayList<String>(0) : filenames;
    }

    @Override
    public Class<?> getColumnClass(final int column) {
        return columns.get(getColumnName(column)).getColumnClass();
    }

    public static Iterable<Class<?>> getColumnClasses() {
        return new Iterable<Class<?>>() {

            @Override
            public Iterator<Class<?>> iterator() {
                return new Iterator<Class<?>>() {

                    //TODO make this dynamic based on the columns map
                    private final Class<?>[] classes = new Class<?>[] {
                        Double.class,
                        Integer.class,
                        Boolean.class,
                        Date.class,
                        Object.class
                    };
                    private int counter = 0;

                    @Override
                    public boolean hasNext() {
                        return counter < classes.length;
                    }

                    @Override
                    public Class<?> next() {
                        if (hasNext()) {
                            return classes[counter++];
                        }
                        throw new NoSuchElementException();
                    }

                    @Override
                    public void remove() {
                        throw new UnsupportedOperationException("Not supported.");
                    }
                };
            }
        };
    }

    protected boolean checkValue(final Object newValue, final String colTitle) {
        if (newValue == null) {
            return true;
        }
        final String trimmedString = newValue.toString().trim().isEmpty() ?
                "" : newValue.toString().trim();

        AbstractColumn column = columns.get(colTitle);

        final boolean result = column.isValid(trimmedString);
        if (! result) {
            column.showError(trimmedString);
        }
        return result;
    }

    public String getTooltipFor(final TableColumn column) {
        return getAllowedValuesFor(column);
    }

    private String getAllowedValuesFor(final TableColumn column) {
        final String columnTitle = getColumnName(column.getModelIndex());
        final StringBuilder builder =
                new StringBuilder("The allowed values for this column are: ");

        builder.append(columns.get(columnTitle).getAllowedValuesString())
                .append(".");

        return builder.toString();
    }

    protected Map<String, AbstractColumn> getColumns() {
        return columns;
    }

    protected void setColumns(final Map<String, AbstractColumn> columns) {
        this.columns = columns;
    }

    protected EntityManager getLocalEntityManager() {
        return localEntityManager;
    }

    protected EntityManager getChangesEntityManager() {
        return changesEntityManager;
    }

    @Override
    public void mouseClicked(final MouseEvent e) {
        if (SwingUtilities.isRightMouseButton(e)) {
            final Point p = e.getPoint();
            final int rowNumber = KQuestApplicationView.getInstance().
                    getRowAtDataTablePoint(p);

            final JPopupMenu menu = new JPopupMenu();
            final JMenuItem item = new JMenuItem("Revert change...");
            item.setEnabled(isRowEdited(rowNumber));
            item.addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(final ActionEvent evt) {
                    final Boolean doRevert = KQuestApplicationView.getInstance().
                            showDangerousConfirmDialog("Are you sure you want to"
                            + " revert all changes to " + getRowString(rowNumber) +
                            "? This can not be undone.", "REVERT ROW?");
                    if(doRevert) {
                        revertRow(rowNumber);
                    }
                }
            });
            menu.add(item);
            menu.show(e.getComponent(), e.getX(), e.getY());
        }
    }

    @Override
    public abstract void mousePressed(MouseEvent e);

    @Override
    public abstract void mouseReleased(MouseEvent e);

    @Override
    public abstract void mouseEntered(MouseEvent e);

    @Override
    public abstract void mouseExited(MouseEvent e);

    protected abstract String getRowString(int rowNumber);

    protected abstract void revertRow(int rowNumber);

    protected abstract void fillTableModel();

    protected abstract void initColumns();

    public abstract String getTableTitle();

    private Map<String, Object> genericQueryExecute(final Query changesQuery,
            final Query localQuery) {
        final Map<String, Object> map = new HashMap<String, Object>(2);
        Object result = null;
        boolean isChanged = false;

        // first see if the row is already in the database with local changes
        try {
            if (changesQuery == null) {
                throw new NoResultException();
            }
            result = changesQuery.getSingleResult();
            isChanged = true;
        } catch (NoResultException changesError) {
            // if not, see if any user data exists for this row in the local copy of the database
            try {
                result = localQuery.getSingleResult();
            } catch (NoResultException localError) {
                // Nothing found...
                result = null;
            } catch (DatabaseException dbe) {
                DataManagement.removeAllCachesAndExit();
            }
        } catch (DatabaseException dbe) {
            DataManagement.removeAllCachesAndExit();
        }
        map.put("result", result);
        map.put("isChanged", isChanged);
        return map;
    }

    /*
     * Below are a lot of generally useful queries.
     */

    protected List<Integer> getCellNrsFor(final String filename) {
        final Query query = getLocalEntityManager().createQuery(
                "SELECT DISTINCT seq.iCell FROM KQuestSeq seq"
                + " WHERE seq.kQuestSeqPK.fileName=:filename"
                + " ORDER BY seq.iCell")
                .setParameter("filename", filename);
        List<Integer> cellNrs = null;
        try {
            cellNrs = query.getResultList();
        } catch (DatabaseException dbe) {
            DataManagement.removeAllCachesAndExit();
        }
        return cellNrs == null ? new ArrayList<Integer>(0) : cellNrs;
    }

    protected List<KQuestSubSeq> getSubSeqsFor(final String filename, final int iSeq) {
        final List<KQuestSubSeq> subseqs = new ArrayList<KQuestSubSeq>();
        for (int isubseq : getISubSeqsFor(filename, iSeq)) {
            subseqs.add(getSubSeqFor(filename, iSeq, isubseq));
        }
        return subseqs;
    }

    protected KQuestSubSeq getSubSeqFor(final String filename, final int iSeq,
            final int isubseq) {
        String queryString = "SELECT subseq FROM KQuestSubSeq subseq"
                + " WHERE subseq.kQuestSubSeqPK.fileName = :filename"
                + " AND subseq.kQuestSubSeqPK.iSeq=:iseq"
                + " AND subseq.kQuestSubSeqPK.subSeqNr=:isubseq";

        final Query changesQuery = getChangesEntityManager().createQuery(queryString)
                .setParameter("filename", filename).setParameter("iseq", iSeq)
                .setParameter("isubseq", isubseq);

        final Query localQuery = getLocalEntityManager().createQuery(queryString)
                .setParameter("filename", filename).setParameter("iseq", iSeq)
                .setParameter("isubseq", isubseq);

        final Map<String, Object> map = genericQueryExecute(changesQuery, localQuery);
        return (KQuestSubSeq) map.remove("result");
    }

    protected List<Integer> getISubSeqsFor(final String filename, final int iSeq) {
        Query query = getLocalEntityManager().createQuery(
                "SELECT subseq.kQuestSubSeqPK.subSeqNr FROM KQuestSubSeq subseq"
                + " WHERE subseq.kQuestSubSeqPK.fileName = :filename"
                + " AND subseq.kQuestSubSeqPK.iSeq=:iseq"
                + " ORDER BY subseq.kQuestSubSeqPK.subSeqNr")
                .setParameter("filename", filename).setParameter("iseq", iSeq);
        List<Integer> iSubSeqs = null;
        try {
            iSubSeqs = query.getResultList();
        } catch (DatabaseException dbe) {
            DataManagement.removeAllCachesAndExit();
        }
        return iSubSeqs;
    }

    protected List<KQuestSeq> getSeqsFor(final String filename, final int cellNr) {
        final List<KQuestSeq> seqs = new ArrayList<KQuestSeq>();
        for (int iSeq : getISeqsFor(filename, cellNr)) {
            seqs.add(getSeqFor(filename, iSeq));
        }
        return seqs;
    }

    protected KQuestSeq getSeqFor(final String filename, final int iSeq) {
        String queryString = "SELECT seq FROM KQuestSeq seq"
                + " WHERE seq.kQuestSeqPK.fileName = :filename"
                + " AND seq.kQuestSeqPK.iSeq=:iseq";

        final Query changesQuery = getChangesEntityManager().createQuery(queryString)
                .setParameter("filename", filename).setParameter("iseq", iSeq);

        final Query localQuery = getLocalEntityManager().createQuery(queryString)
                .setParameter("filename", filename).setParameter("iseq", iSeq);

        final Map<String, Object> map = genericQueryExecute(changesQuery, localQuery);
        return (KQuestSeq) map.remove("result");
    }

    protected List<Integer> getISeqsFor(final String filename, final int cellNr) {
        Query query = getLocalEntityManager().createQuery(
                "SELECT seq.kQuestSeqPK.iSeq FROM KQuestSeq seq"
                + " WHERE seq.kQuestSeqPK.fileName = :filename"
                + " AND seq.iCell=:cellnr ORDER BY seq.kQuestSeqPK.iSeq")
                .setParameter("filename", filename).setParameter("cellnr", cellNr);
        List<Integer> iSeqs = null;
        try {
            iSeqs = query.getResultList();
        } catch (DatabaseException dbe) {
            DataManagement.removeAllCachesAndExit();
        }
        return iSeqs;
    }

    protected Map<String, Object> getExperiment(final String filename) {
        final String queryString = "SELECT exp FROM UserDataExp exp"
                + " WHERE exp.userDataExpPK.fileName=:filename";

        final Query changesQuery = getChangesEntityManager().createQuery(queryString)
                .setParameter("filename", filename);

        final Query localQuery = getLocalEntityManager().createQuery(queryString)
                .setParameter("filename", filename);

        final Map<String, Object> map = genericQueryExecute(changesQuery, localQuery);
        map.put("UserDataExp", (UserDataExp) map.remove("result"));
        return map;
    }

    protected Map<String, Object> getCellCF(final String filename, final Integer cellNr) {
        final String queryString = "SELECT cf FROM UserDataCellCF cf"
                + " WHERE cf.userDataCellCFPK.iCell=:cellnr"
                + " AND cf.userDataCellCFPK.fileName=:filename";

        final Query changesQuery = getChangesEntityManager().createQuery(queryString)
                .setParameter("cellnr", cellNr)
                .setParameter("filename", filename);

        final Query localQuery = getLocalEntityManager().createQuery(queryString)
                .setParameter("cellnr", cellNr)
                .setParameter("filename", filename);

        final Map<String, Object> map = genericQueryExecute(changesQuery, localQuery);
        map.put("UserDataCellCF", (UserDataCellCF) map.remove("result"));
        return map;
    }

    protected Map<String, Object> getCell(final String filename, final Integer cellNr) {
        final String queryString = "SELECT cell FROM UserDataCell cell"
                + " WHERE cell.userDataCellPK.nr=:cellnr"
                + " AND cell.userDataCellPK.fileName=:filename";

        final Query changesQuery = getChangesEntityManager().createQuery(queryString)
                .setParameter("cellnr", cellNr)
                .setParameter("filename", filename);

        final Query localQuery = getLocalEntityManager().createQuery(queryString)
                .setParameter("cellnr", cellNr)
                .setParameter("filename", filename);

        final Map<String, Object> map = genericQueryExecute(changesQuery, localQuery);
        map.put("UserDataCell", (UserDataCell) map.remove("result"));
        return map;
    }

    protected Map<String, Object> getBadSubseq(final String filename,
            final int iSeq, final int subSeqNr) {
        final String queryString = "SELECT udSubSeq FROM UserDataBadSubSeq udSubSeq"
                + " WHERE udSubSeq.userDataBadSubSeqPK.fileName = :filename"
                + " AND udSubSeq.userDataBadSubSeqPK.iSeq = :iseq"
                + " AND udSubSeq.userDataBadSubSeqPK.subSeqNr = :subseqnr";

        final Query changesQuery = getChangesEntityManager().createQuery(queryString)
                .setParameter("filename", filename)
                .setParameter("iseq", iSeq)
                .setParameter("subseqnr", subSeqNr);

        final Query localQuery = getLocalEntityManager().createQuery(queryString)
                .setParameter("filename", filename)
                .setParameter("iseq", iSeq)
                .setParameter("subseqnr", subSeqNr);

        final Map<String, Object> map = genericQueryExecute(changesQuery, localQuery);
        map.put("UserDataBadSubSeq", (UserDataBadSubSeq) map.remove("result"));
        return map;
    }

    protected Map<String, Object> getUserDataDS(final String filename, final int iSeq) {
        final String queryString = "SELECT udDs FROM UserDataDS udDs"
                    + " WHERE udDs.userDataDSPK.fileName = :filename"
                    + " AND udDs.userDataDSPK.iSeq = :iseq";

        final Query changesQuery = getChangesEntityManager().createQuery(queryString)
                .setParameter("filename", filename)
                .setParameter("iseq", iSeq);

        final Query localQuery = getLocalEntityManager().createQuery(queryString)
                .setParameter("filename", filename)
                .setParameter("iseq", iSeq);

        final Map<String, Object> map = genericQueryExecute(changesQuery, localQuery);
        map.put("UserDataDS", (UserDataDS) map.remove("result"));
        return map;
    }

    protected KQuestIndep[] getKQuestIndepFrom(final String filename,
            final int iSeq) {
        final String queryString = "SELECT indep FROM KQuestIndep indep"
                    + " WHERE indep.kQuestIndepPK.fileName = :filename"
                    + " AND indep.kQuestIndepPK.iSeq = :iseq"
                    + " AND indep.kQuestIndepPK.indepNr = :number";

        // Indep is immutable
        final Query changesQuery = null;

        Query localQuery = getLocalEntityManager().createQuery(queryString)
                .setParameter("filename", filename)
                .setParameter("iseq", iSeq)
                .setParameter("number", 1);
        Map<String, Object> map = genericQueryExecute(changesQuery, localQuery);
        KQuestIndep indep1 = (KQuestIndep) map.remove("result");

        localQuery = getLocalEntityManager().createQuery(queryString)
                .setParameter("filename", filename)
                .setParameter("iseq", iSeq)
                .setParameter("number", 2);
        map = genericQueryExecute(changesQuery, localQuery);
        KQuestIndep indep2 = (KQuestIndep) map.remove("result");

        return new KQuestIndep[]{indep1, indep2};
    }
}
