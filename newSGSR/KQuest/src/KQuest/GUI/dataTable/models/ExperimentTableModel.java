package KQuest.GUI.dataTable.models;

import KQuest.GUI.KQuestApplicationView;
import KQuest.GUI.dataTable.models.columns.AbstractColumn;
import KQuest.GUI.dataTable.models.columns.BooleanColumn;
import KQuest.GUI.dataTable.models.columns.CellColumn;
import KQuest.GUI.dataTable.models.columns.DoubleColumn;
import KQuest.GUI.dataTable.models.columns.ExposedColumn;
import KQuest.GUI.dataTable.models.columns.FysColumn;
import KQuest.GUI.dataTable.models.columns.IntegerColumn;
import KQuest.GUI.dataTable.models.columns.PSTHColumn;
import KQuest.GUI.dataTable.models.columns.RecordingLocationColumn;
import KQuest.GUI.dataTable.models.columns.SideColumn;
import KQuest.GUI.dataTable.models.columns.SideNotBothColumn;
import KQuest.GUI.dataTable.models.columns.StringColumn;
import KQuest.database.DataManagement;
import KQuest.database.LocalEntityCreationException;
import KQuest.database.entities.UserDataCell;
import KQuest.database.entities.UserDataCellCF;
import KQuest.database.entities.UserDataExp;
import KQuest.matlab.KQuestMatlabClient;
import static KQuest.util.KQuestUtil.*;
import com.jamal.client.MatlabClient;
import java.awt.EventQueue;
import java.awt.event.MouseEvent;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ExecutionException;
import javax.persistence.NoResultException;
import javax.persistence.Query;
import javax.swing.SwingWorker;
import javax.swing.event.TableModelEvent;

public class ExperimentTableModel extends AbstractTableModel {

    public static final long serialVersionUID = 0L;

    //column titles
    final static String COLUMN_TITLE_CELL_NR = "Cell nr";
    final static String COLUMN_TITLE_CHAN_1 = "Chan1";
    final static String COLUMN_TITLE_CHAN_2 = "Chan 2";
    final static String COLUMN_TITLE_DSS_1 = "DSS1";
    final static String COLUMN_TITLE_DSS_2 = "DSS2";
    final static String COLUMN_TITLE_COMMENT = "Comment";
    final static String COLUMN_TITLE_EXPOSED = "ExposedStr";
    final static String COLUMN_TITLE_HIST_DEPTH = "Depth";
    final static String COLUMN_TITLE_IGNORE_CELL = "Ignore Cell";
    final static String COLUMN_TITLE_RCNTHR = "RCNTHR";
    final static String COLUMN_TITLE_REC_LOCATION = "Rec Location";
    final static String COLUMN_TITLE_REC_SIDE = "RecLeRi";
    final static String COLUMN_TITLE_PASS = "Pass";
    final static String COLUMN_TITLE_PEN = "Pen";
    final static String COLUMN_TITLE_PSTH = "PSTH";
    final static String COLUMN_TITLE_CELL = "Cell";
    final static String COLUMN_TITLE_FYS = "Fys";
    final static String COLUMN_TITLE_HIST = "Hist";
    final static String COLUMN_TITLE_THR_SEQUENCE = "FTCseq";
    final static String COLUMN_TITLE_CF = "CF";
    final static String COLUMN_TITLE_SR = "SR";
    final static String COLUMN_TITLE_MIN_THR = "TH";
    final static String COLUMN_TITLE_Q10 = "Q10";

    //column titles order
    final static List<String> COLUMN_TITLES = Arrays.asList(new String[]{
                COLUMN_TITLE_CELL_NR,
                COLUMN_TITLE_CHAN_1,
                COLUMN_TITLE_CHAN_2,
                COLUMN_TITLE_DSS_1,
                COLUMN_TITLE_DSS_2,
                COLUMN_TITLE_COMMENT,
                COLUMN_TITLE_EXPOSED,
                COLUMN_TITLE_HIST_DEPTH,
                COLUMN_TITLE_IGNORE_CELL,
                COLUMN_TITLE_RCNTHR,
                COLUMN_TITLE_REC_LOCATION,
                COLUMN_TITLE_REC_SIDE,
                COLUMN_TITLE_PASS,
                COLUMN_TITLE_PEN,
                COLUMN_TITLE_PSTH,
                COLUMN_TITLE_CELL,
                COLUMN_TITLE_FYS,
                COLUMN_TITLE_HIST,
                COLUMN_TITLE_THR_SEQUENCE,
                COLUMN_TITLE_CF,
                COLUMN_TITLE_SR,
                COLUMN_TITLE_MIN_THR,
                COLUMN_TITLE_Q10
    });
    
    final static int[] EDITABLE_COLUMNS = new int[]
        {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18};

    private final String fileName;
    private final List<Boolean> adjustedThr;

    // The columns that belong to the UserDataCell entity
    private final static Set<String> USER_DATA_CELL_COLUMNS = new HashSet<String>(
            Arrays.asList(new String[] {
                COLUMN_TITLE_CELL_NR,
                COLUMN_TITLE_CHAN_1,
                COLUMN_TITLE_CHAN_2,
                COLUMN_TITLE_DSS_1,
                COLUMN_TITLE_DSS_2,
                COLUMN_TITLE_COMMENT,
                COLUMN_TITLE_EXPOSED,
                COLUMN_TITLE_HIST_DEPTH,
                COLUMN_TITLE_IGNORE_CELL,
                COLUMN_TITLE_RCNTHR,
                COLUMN_TITLE_REC_LOCATION,
                COLUMN_TITLE_REC_SIDE,
                COLUMN_TITLE_PASS,
                COLUMN_TITLE_PEN,
                COLUMN_TITLE_PSTH,
                COLUMN_TITLE_CELL,
                COLUMN_TITLE_FYS,
                COLUMN_TITLE_HIST
    }));

    // The columns that belong to the UserDataCellCF entity
    private final static Set<String> USER_DATA_CELL_CF_COLUMNS= new HashSet<String>(
            Arrays.asList(new String[] {
                COLUMN_TITLE_THR_SEQUENCE,
                COLUMN_TITLE_CF,
                COLUMN_TITLE_SR,
                COLUMN_TITLE_MIN_THR,
                COLUMN_TITLE_Q10
    }));

    public ExperimentTableModel(final String fileName)
            throws LocalEntityCreationException {
        super();
        this.fileName = fileName;
        adjustedThr = new ArrayList<Boolean>();
        EventQueue.invokeLater(new Runnable() {
            @Override
            public void run() {
                fillTableModel();
            }
        });
    }

    //TODO is this method still OK?
    @Override
    public boolean wasCellEdited(final int row, final int column) {
        if(COLUMN_TITLES.get(column).equals(COLUMN_TITLE_THR_SEQUENCE) ||
                COLUMN_TITLES.get(column).equals(COLUMN_TITLE_CF) ||
                COLUMN_TITLES.get(column).equals(COLUMN_TITLE_SR)) {
            return adjustedThr.get(row);
        }
        
        return super.wasCellEdited(row, column);
    }

    @Override
    protected final void fillTableModel() {
        final List<Map<String, Object>> newTableRows = new ArrayList<Map<String, Object>>();
        final Set<Integer> newEditedRows = new HashSet<Integer>();

        for (Integer cellNr : getCellNrsFor(fileName)) {
                Map<String, Object> map = getCell(fileName, cellNr);
            final UserDataCell cell = (UserDataCell) map.get("UserDataCell");
            final boolean cellChanged = (Boolean) map.get("isChanged");

            map = getCellCF(fileName, cellNr);
            UserDataCellCF cellcf = (UserDataCellCF) map.get("UserDataCellCF");

            if (cellChanged || (Boolean) map.get("isChanged")) {
                newEditedRows.add(newTableRows.size());
            }

            newTableRows.add(getNewTableRows(cellNr, cell, cellcf, newTableRows.size()));
            adjustedThr.add(cellcf == null ? false : cellcf.getManuallyAdjusted());
        }
        fillTableModel(COLUMN_TITLES.toArray(new String[COLUMN_TITLES.size()]),
                EDITABLE_COLUMNS, newEditedRows, newTableRows);
    }

    private Map<String, Object> getNewTableRows(final Integer cellNr,
            final UserDataCell cell, final UserDataCellCF cellcf, final  int row) {
        final boolean cellFound = cell != null;
        final boolean cfFound = cellcf != null;

        final UserDataExp experiment =
                ((UserDataExp) getExperiment(fileName).get("UserDataExp"));

        String chan1 = null, chan2 = null, dss1 = null, dss2 = null, recside = null;
        if (cellFound) {
            chan1 = cell.getChan1();
            chan2 = cell.getChan2();
            dss1 = cell.getDss1();
            dss2 = cell.getDss2();
            recside = cell.getRecSide();
        }

        if (experiment != null) {
            if (isNullOrEmpty(chan1) && !isNullOrEmpty(experiment.getChan1())) {
                chan1 = experiment.getChan1();
                addToInheritedCells(new TableCell(row, COLUMN_TITLES.indexOf(COLUMN_TITLE_CHAN_1)));
            }
            if (isNullOrEmpty(chan2) && !isNullOrEmpty(experiment.getChan2())) {
                chan2 = experiment.getChan2();
                addToInheritedCells(new TableCell(row, COLUMN_TITLES.indexOf(COLUMN_TITLE_CHAN_2)));
            }
            if (isNullOrEmpty(dss1) && !isNullOrEmpty(experiment.getDss1())) {
                dss1 = experiment.getDss1();
                addToInheritedCells(new TableCell(row, COLUMN_TITLES.indexOf(COLUMN_TITLE_DSS_1)));
            }
            if (isNullOrEmpty(dss2) && !isNullOrEmpty(experiment.getDss2())) {
                dss2 = experiment.getDss2();
                addToInheritedCells(new TableCell(row, COLUMN_TITLES.indexOf(COLUMN_TITLE_DSS_2)));
            }
            if (isNullOrEmpty(recside) && !isNullOrEmpty(experiment.getRecSide())) {
                recside = experiment.getRecSide();
                addToInheritedCells(new TableCell(row, COLUMN_TITLES.indexOf(COLUMN_TITLE_REC_SIDE)));
            }
        }

        final Map<String, Object> tableRow =
                new HashMap<String, Object>(COLUMN_TITLES.size());
        tableRow.put(COLUMN_TITLE_CELL_NR, cellNr);
        tableRow.put(COLUMN_TITLE_CHAN_1, chan1);
        tableRow.put(COLUMN_TITLE_CHAN_2, chan2);
        tableRow.put(COLUMN_TITLE_DSS_1, dss1);
        tableRow.put(COLUMN_TITLE_DSS_2, dss2);
        tableRow.put(COLUMN_TITLE_REC_SIDE, recside);
        if (cellFound) {
            tableRow.put(COLUMN_TITLE_COMMENT, cell.getEval());
            tableRow.put(COLUMN_TITLE_EXPOSED, cell.getExposed());
            tableRow.put(COLUMN_TITLE_HIST_DEPTH, cell.getHistDepth());
            tableRow.put(COLUMN_TITLE_IGNORE_CELL, cell.getIgnoreCell());
            tableRow.put(COLUMN_TITLE_RCNTHR, cell.getRcnThr());
            tableRow.put(COLUMN_TITLE_REC_LOCATION, cell.getRecLoc());
            tableRow.put(COLUMN_TITLE_PASS, cell.getIPass());
            tableRow.put(COLUMN_TITLE_PEN, cell.getIPen());
            tableRow.put(COLUMN_TITLE_PSTH, cell.getPsth());
            tableRow.put(COLUMN_TITLE_CELL, cell.getCell());
            tableRow.put(COLUMN_TITLE_FYS, cell.getFys());
            tableRow.put(COLUMN_TITLE_HIST, cell.getHist());
        } else {
            tableRow.putAll(getEmptyCellMap());
        }
        if (cfFound) {
            tableRow.put(COLUMN_TITLE_THR_SEQUENCE, cellcf.getTHRSeq());
            tableRow.put(COLUMN_TITLE_CF, cellcf.getCf());
            tableRow.put(COLUMN_TITLE_SR, cellcf.getSr());
            tableRow.put(COLUMN_TITLE_MIN_THR, cellcf.getMinTHR());
            tableRow.put(COLUMN_TITLE_Q10, cellcf.getQ10());
        } else {
            tableRow.putAll(getEmptyCellCFMap());
        }
        return tableRow;
    }

    private Map<String, Object> getEmptyCellMap() {
        final Map<String, Object> map = new HashMap<String, Object>(8);
        map.put(COLUMN_TITLE_COMMENT, null);
        map.put(COLUMN_TITLE_EXPOSED, null);
        map.put(COLUMN_TITLE_HIST_DEPTH, null);
        map.put(COLUMN_TITLE_IGNORE_CELL, null);
        map.put(COLUMN_TITLE_RCNTHR, null);
        map.put(COLUMN_TITLE_REC_LOCATION, null);
        map.put(COLUMN_TITLE_PASS, null);
        map.put(COLUMN_TITLE_PEN, null);
        map.put(COLUMN_TITLE_PSTH, null);
        map.put(COLUMN_TITLE_CELL, null);
        map.put(COLUMN_TITLE_FYS, null);
        map.put(COLUMN_TITLE_HIST, null);
        return map;
    }

    private Map<String, Object> getEmptyCellCFMap() {
        final Map<String, Object> map = new HashMap<String, Object>(5);
        map.put(COLUMN_TITLE_THR_SEQUENCE, null);
        map.put(COLUMN_TITLE_CF, null);
        map.put(COLUMN_TITLE_SR, null);
        map.put(COLUMN_TITLE_MIN_THR, null);
        map.put(COLUMN_TITLE_Q10, null);
        return map;
    }

    @Override
    public String getTableTitle() {
        return "Cells in experiment " + fileName;
    }

    @Override
    protected void initColumns() {
        final Map<String, AbstractColumn> columns =
                new HashMap<String, AbstractColumn>(COLUMN_TITLES.size());

        columns.put(COLUMN_TITLE_REC_SIDE, new SideColumn(COLUMN_TITLE_REC_SIDE));

        columns.put(COLUMN_TITLE_CHAN_1, new SideNotBothColumn(COLUMN_TITLE_CHAN_1));
        columns.put(COLUMN_TITLE_CHAN_2, new SideNotBothColumn(COLUMN_TITLE_CHAN_2));
        columns.put(COLUMN_TITLE_DSS_1, new SideNotBothColumn(COLUMN_TITLE_DSS_1));
        columns.put(COLUMN_TITLE_DSS_2, new SideNotBothColumn(COLUMN_TITLE_DSS_2));
        
        columns.put(COLUMN_TITLE_EXPOSED, new ExposedColumn(COLUMN_TITLE_EXPOSED));

        columns.put(COLUMN_TITLE_REC_LOCATION, new RecordingLocationColumn(COLUMN_TITLE_REC_LOCATION));

        columns.put(COLUMN_TITLE_CF, new DoubleColumn(COLUMN_TITLE_CF));
        columns.put(COLUMN_TITLE_SR, new DoubleColumn(COLUMN_TITLE_SR));
        columns.put(COLUMN_TITLE_Q10, new DoubleColumn(COLUMN_TITLE_Q10));

        columns.put(COLUMN_TITLE_CELL_NR, new IntegerColumn(COLUMN_TITLE_CELL_NR));
        columns.put(COLUMN_TITLE_RCNTHR, new IntegerColumn(COLUMN_TITLE_RCNTHR));
        columns.put(COLUMN_TITLE_HIST_DEPTH, new IntegerColumn(COLUMN_TITLE_HIST_DEPTH));
        columns.put(COLUMN_TITLE_PASS, new IntegerColumn(COLUMN_TITLE_PASS));
        columns.put(COLUMN_TITLE_PEN, new IntegerColumn(COLUMN_TITLE_PEN));
        columns.put(COLUMN_TITLE_THR_SEQUENCE, new IntegerColumn(COLUMN_TITLE_THR_SEQUENCE));
        columns.put(COLUMN_TITLE_MIN_THR, new IntegerColumn(COLUMN_TITLE_MIN_THR));

        columns.put(COLUMN_TITLE_IGNORE_CELL, new BooleanColumn(COLUMN_TITLE_IGNORE_CELL));
        columns.put(COLUMN_TITLE_HIST, new BooleanColumn(COLUMN_TITLE_HIST));

        columns.put(COLUMN_TITLE_PSTH, new PSTHColumn(COLUMN_TITLE_PSTH));

        columns.put(COLUMN_TITLE_CELL, new CellColumn(COLUMN_TITLE_CELL));

        columns.put(COLUMN_TITLE_FYS, new FysColumn(COLUMN_TITLE_FYS));

        columns.put(COLUMN_TITLE_COMMENT, new StringColumn(COLUMN_TITLE_COMMENT));

        setColumns(columns);
    }

    @Override
    public void tableChanged(TableModelEvent e) {
        final int changedRowNr = e.getFirstRow();
        final int changedColNr = e.getColumn();

        if (changedColNr < 0) {
            return;
        }

        final String changedColTitle = COLUMN_TITLES.get(changedColNr);
        final Object oldValue = getTableRows().get(changedRowNr).get(changedColTitle);
        final Object newValue = this.getValueAt(changedRowNr, changedColNr);

        // oldValue and newValue are different?
        // TODO equals on Objects sucks, it looks at the reference instead of at the value
        if (e.getType() == TableModelEvent.UPDATE &&
                ((oldValue == null && newValue != null) || oldValue != null &&
                !oldValue.equals(newValue))) {
            // if certain types are expected, check it here
            if (!checkValue(newValue, changedColTitle)) {
                setValueAt(oldValue, changedRowNr, changedColNr); // revert changes
                return;
            }

            // Key value
            Integer cellNr = (Integer) getTableRows().get(changedRowNr).get(COLUMN_TITLE_CELL_NR);

            if (USER_DATA_CELL_COLUMNS.contains(changedColTitle)) {
                UserDataCell newUDCell = getNewUDCell(cellNr, changedColTitle, newValue);
                getChangesEntityManager().getTransaction().begin();
                getChangesEntityManager().merge(newUDCell);
                getTableRows().get(changedRowNr).put(changedColTitle, newValue);
                addToEditedRows(changedRowNr);
                getChangesEntityManager().getTransaction().commit();

            } else {
                //THR seq was changed, we need to calculate CF, SR, minTHR and Q10

                assert(USER_DATA_CELL_CF_COLUMNS.contains(changedColTitle));

                if (changedColTitle.equals(COLUMN_TITLE_THR_SEQUENCE)) {
                    final Integer THRseq = newValue != null ?
                        getIntegerValue(newValue.toString()) : null;

                    // The rest of the process to change the THR is done in a
                    // SwingWorker to not block the EDT
                    getTHRSwingWorker(THRseq, cellNr, changedRowNr, newValue,
                            oldValue, changedColNr).execute();
                }
            }
            if (isCellInherited(changedRowNr, changedColNr)) {
                removeFromInheritedCells(new TableCell(changedRowNr, changedColNr));
            }
        }
    }

    private SwingWorker<Map<String, Double>, Void> getTHRSwingWorker(
            final Integer THRseq, final Integer cellNr,
            final Integer changedRowNr, final Object newValue,
            final Object oldValue, final Integer changedColNr) {

        return new SwingWorker<Map<String, Double>, Void>() {

            private final String statusText;
            private final KQuestApplicationView instance =
                    KQuestApplicationView.getInstance();
            {
                statusText = instance.getStatusText();
                instance.setStatusText("Calculating THR parameters...", true);
                // Disable some buttons to be sure that CF, SR,
                // minTHR and Q10 are updated.
                KQuestApplicationView.getInstance().setSaveMode(true);
                // Queue the old statustext to replace the new one when we leave
                // savemode.
                instance.setStatusText(statusText, false);
            }

            @Override
            protected Map<String, Double> doInBackground() throws Exception {
                final Map<String, Double> map = new HashMap<String, Double>();
                if (THRseq != null) {
                    try {
                        final MatlabClient client = KQuestMatlabClient.getMatlabClient();
                        client.executeMatlabFunction("qstart",
                                new Object[]{instance.getMatlabUser()}, 0);
                        final Object result = client.executeMatlabFunction(
                                "getTHRforSeq", new Object[]{fileName, THRseq}, 5);

                        // Pretty ugly type-casts!
                        final Object[] ResultArray = (Object[]) result;
                        map.put("CF", formatNumber(
                                ((double[]) ResultArray[0])[0],
                                0, BigDecimal.ROUND_HALF_EVEN));
                        map.put("SR", formatNumber(
                                ((double[]) ResultArray[1])[0],
                                1, BigDecimal.ROUND_HALF_EVEN));
                        map.put("minTHR", formatNumber(
                                ((double[]) ResultArray[2])[0],
                                0, BigDecimal.ROUND_DOWN));
                        map.put("Q10", formatNumber(
                                ((double[]) ResultArray[4])[0],
                                2, BigDecimal.ROUND_HALF_EVEN));
                        map.put("Succeeded", 1.0);
                    } catch (Exception exc) {
                        map.put("Succeeded", 0.0);
                    }
                } else {
                    map.put("CF", null);
                    map.put("SR", null);
                    map.put("minTHR", null);
                    map.put("Q10", null);
                    map.put("Succeeded", 1.0);
                }
                return map;
            }

            @Override
            protected void done() {
                try {
                    final Map<String, Double> THRmap = get();
                    if (THRmap.get("Succeeded") == 1.0) {

                        final Double CF = THRmap.get("CF");
                        final Double SR = THRmap.get("SR");
                        final Integer minTHR = THRmap.get("minTHR").intValue();
                        final Double Q10 = THRmap.get("Q10");

                        final String CFString = getStringIfNotNull(CF);
                        final String SRString = getStringIfNotNull(SR);
                        final String minTHRString = getStringIfNotNull(minTHR);
                        final String Q10String = getStringIfNotNull(Q10);

                        final UserDataCellCF newUDCellCF = getOldUDCellCF(cellNr);
                        newUDCellCF.setTHRSeq(THRseq);
                        newUDCellCF.setCf(CF);
                        newUDCellCF.setSr(SR);
                        newUDCellCF.setMinTHR(minTHR);
                        newUDCellCF.setQ10(Q10);

                        getChangesEntityManager().getTransaction().begin();
                        getChangesEntityManager().merge(newUDCellCF);

                        getTableRows().get(changedRowNr).put(COLUMN_TITLES.get(changedColNr), newValue);
                        getTableRows().get(changedRowNr).put(COLUMN_TITLE_CF, CFString);
                        getTableRows().get(changedRowNr).put(COLUMN_TITLE_SR, SRString);
                        getTableRows().get(changedRowNr).put(COLUMN_TITLE_MIN_THR, minTHRString);
                        getTableRows().get(changedRowNr).put(COLUMN_TITLE_Q10, Q10String);
                        addToEditedRows(changedRowNr);

                        getChangesEntityManager().getTransaction().commit();

                        setValueAt(CFString, changedRowNr,
                                COLUMN_TITLES.indexOf(COLUMN_TITLE_CF));
                        setValueAt(SRString, changedRowNr,
                                COLUMN_TITLES.indexOf(COLUMN_TITLE_SR));
                        setValueAt(minTHRString, changedRowNr,
                                COLUMN_TITLES.indexOf(COLUMN_TITLE_MIN_THR));
                        setValueAt(Q10String, changedRowNr,
                                COLUMN_TITLES.indexOf(COLUMN_TITLE_Q10));
                    } else {
                        // the calculation has failed...
                        instance.showErrorMessageDialog(
                                "Something went wrong while trying to calculate " +
                                "the CF and SR.\nTo avoid inconsistencies the " +
                                "THR Seq value gets reset. If this error persists, " +
                                "please contact a programmer.",
                                "Could not calculate CF and SR");
                        // revert changes
                        setValueAt(oldValue, changedRowNr, changedColNr);
                    }
                } catch (InterruptedException ex) {
                    ex.printStackTrace();
                } catch (ExecutionException ex) {
                    ex.printStackTrace();
                }
                instance.setSaveMode(false);
            }
        };
    }

    private UserDataCell getNewUDCell(Integer cellNr, final String changedColTitle,
            final Object newValue) {
        UserDataCell newUDCell = getOldUDCell(cellNr);

        final String stringValue = newValue == null ? "" : newValue.toString();

        if (changedColTitle.equals(COLUMN_TITLE_CHAN_1)) {
            newUDCell.setChan1(getStringValue(stringValue));
        } else if (changedColTitle.equals(COLUMN_TITLE_CHAN_2)) {
            newUDCell.setChan2(getStringValue(stringValue));
        } else if (changedColTitle.equals(COLUMN_TITLE_DSS_1)) {
            newUDCell.setDss1(getStringValue(stringValue));
        } else if (changedColTitle.equals(COLUMN_TITLE_DSS_2)) {
            newUDCell.setDss2(getStringValue(stringValue));
        } else if (changedColTitle.equals(COLUMN_TITLE_COMMENT)) {
            newUDCell.setEval(getStringValue(stringValue));
        } else if (changedColTitle.equals(COLUMN_TITLE_EXPOSED)) {
            newUDCell.setExposed(getStringValue(stringValue));
        } else if (changedColTitle.equals(COLUMN_TITLE_HIST_DEPTH)) {
            newUDCell.setHistDepth(getIntegerValue(stringValue));
        } else if (changedColTitle.equals(COLUMN_TITLE_IGNORE_CELL)) {
            newUDCell.setIgnoreCell(getBooleanValue(stringValue));
        } else if (changedColTitle.equals(COLUMN_TITLE_RCNTHR)) {
            newUDCell.setRcnthr(getIntegerValue(stringValue));
        } else if (changedColTitle.equals(COLUMN_TITLE_REC_LOCATION)) {
            newUDCell.setRecLoc(getStringValue(stringValue));
        } else if (changedColTitle.equals(COLUMN_TITLE_REC_SIDE)) {
            newUDCell.setRecSide(getStringValue(stringValue));
        } else if (changedColTitle.equals(COLUMN_TITLE_PASS)) {
            newUDCell.setIPass(getIntegerValue(stringValue));
        } else if (changedColTitle.equals(COLUMN_TITLE_PEN)) {
            newUDCell.setIPen(getIntegerValue(stringValue));
        } else if (changedColTitle.equals(COLUMN_TITLE_HIST)) {
            newUDCell.setHist(getBooleanValue(stringValue));
        } else if (changedColTitle.equals(COLUMN_TITLE_FYS)) {
            newUDCell.setFys(stringValue);
        } else if (changedColTitle.equals(COLUMN_TITLE_CELL)) {
            newUDCell.setCell(stringValue);
        } else if (changedColTitle.equals(COLUMN_TITLE_PSTH)) {
            newUDCell.setPsth(stringValue);
        }
        return newUDCell;
    }

    private Double formatNumber(Double value, int precision, int roundingMode) {
        if (! ( value == null || value.isNaN() || value.isInfinite())) {
            return (new BigDecimal(value)).setScale(precision, roundingMode).doubleValue();
        } else {
            // null is the value for an SQL NULL
            return null;
        }
    }

    private String getStringIfNotNull(Number number) {
        return number == null ? null : number.toString();
    }

    private UserDataCell getOldUDCell(Integer cellNr) {
        UserDataCell oldCell;
        String queryString = "SELECT udCell FROM UserDataCell udCell WHERE " +
                    "udCell.userDataCellPK.fileName=:filename AND " +
                    "udCell.userDataCellPK.nr=:cellnr";
        try {
            // First, check if this entry is already in the changes that need to be uploaded
            Query changesQuery = getChangesEntityManager().createQuery(queryString);
            changesQuery.setParameter("filename", fileName);
            changesQuery.setParameter("cellnr", cellNr);
            oldCell = (UserDataCell) changesQuery.getSingleResult();
        } catch (NoResultException changesException) {
            try {
                // The entry is not yet in the list of changes that need to be uploaded
                // Check in the full database if the entry is already there
                Query localQuery = getLocalEntityManager().createQuery(queryString);
                localQuery.setParameter("filename", fileName);
                localQuery.setParameter("cellnr", cellNr);
                oldCell = (UserDataCell) localQuery.getSingleResult();
            } catch (NoResultException localException) {
                // No entry exists for this file name. Create a new one.
                oldCell = new UserDataCell(fileName, cellNr);
            }
        }
        return new UserDataCell(oldCell);
    }

    private UserDataCellCF getOldUDCellCF(Integer cellNr) {
        UserDataCellCF oldCell;
        String queryString = "SELECT udCellCF FROM UserDataCellCF udCellCF WHERE " +
                    "udCellCF.userDataCellCFPK.fileName=:filename AND " +
                    "udCellCF.userDataCellCFPK.iCell=:cellnr";
        try {
            // First, check if this entry is already in the changes that need to be uploaded
            Query changesQuery = getChangesEntityManager().createQuery(queryString);
            changesQuery.setParameter("filename", fileName);
            changesQuery.setParameter("cellnr", cellNr);
            oldCell = (UserDataCellCF) changesQuery.getSingleResult();
        } catch (NoResultException changesException) {
            try {
                // The entry is not yet in the list of changes that need to be uploaded
                // Check in the full database if the entry is already there
                Query localQuery = getLocalEntityManager().createQuery(queryString);
                localQuery.setParameter("filename", fileName);
                localQuery.setParameter("cellnr", cellNr);
                oldCell = (UserDataCellCF) localQuery.getSingleResult();
            } catch (NoResultException localException) {
                // No entry exists for this file name. Create a new one.
                oldCell = new UserDataCellCF(fileName, cellNr);
            }
        }
        return new UserDataCellCF(oldCell);
    }

    @Override
    protected String getRowString(int rowNumber) {
        return "cell nr. " + getCellNr(rowNumber);
    }

    @Override
    protected void revertRow(int rowNumber) {
        DataManagement.revertExperimentChange(fileName, getCellNr(rowNumber));
        /*
         * In AbstractTableModel we call
         *   KQuestApplicationView.getInstance().updateTable();
         * which causes a new ExperimentTableModel to be made and thus makes
         * fillTabelModel() to be ran again. Inheritance of cell values and such
         * are thus taken care of automatically.
         */
    }

    private int getCellNr(int rowNumber) {
        return (Integer) getTableRows().get(rowNumber).get(COLUMN_TITLE_CELL_NR);
    }

    @Override
    public void mousePressed(MouseEvent e) {}

    @Override
    public void mouseReleased(MouseEvent e) {}

    @Override
    public void mouseEntered(MouseEvent e) {}

    @Override
    public void mouseExited(MouseEvent e) {}
}
