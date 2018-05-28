package KQuest.GUI.dataTable.models;

import KQuest.GUI.dataTable.models.columns.AbstractColumn;
import KQuest.GUI.dataTable.models.columns.BooleanColumn;
import KQuest.GUI.dataTable.models.columns.DateColumn;
import KQuest.GUI.dataTable.models.columns.IntegerColumn;
import KQuest.GUI.dataTable.models.columns.SpikeColumn;
import KQuest.GUI.dataTable.models.columns.StringColumn;
import KQuest.database.DataManagement;
import KQuest.database.LocalEntityCreationException;
import KQuest.database.entities.KQuestIndep;
import KQuest.database.entities.KQuestSeq;
import KQuest.database.entities.UserDataDS;
import static KQuest.util.KQuestUtil.*;
import java.awt.EventQueue;
import java.awt.event.MouseEvent;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.persistence.NoResultException;
import javax.persistence.Query;
import javax.swing.event.TableModelEvent;

public class CellTableModel extends AbstractTableModel {

    //column titles
    final static String COLUMN_TITLE_SEQ_ID = "Seq id";
    final static String COLUMN_TITLE_SEQ_NR = "Seq nr";
    final static String COLUMN_TITLE_FILE_FORMAT = "File Format";
    final static String COLUMN_TITLE_STIM_TYPE = "Stim Type";
    final static String COLUMN_TITLE_SCH_NAME = "Sch Name";
    final static String COLUMN_TITLE_SPIKE = "Spike";
    final static String COLUMN_TITLE_TIME = "Time";
    final static String COLUMN_TITLE_PLACE = "Place";
    final static String COLUMN_TITLE_EXPERIMENTER = "Who";
    final static String COLUMN_TITLE_NSUB = "Nsub";
    final static String COLUMN_TITLE_NREC = "Nrec";
    final static String COLUMN_TITLE_NREP = "Nrep";
    final static String COLUMN_TITLE_NCHAN = "Nchan";
    final static String COLUMN_TITLE_IGNORE = "Ignore";
    final static String COLUMN_TITLE_COMMENT = "Comment";
    final static String COLUMN_TITLE_INDEP_VAR_1 = "Indep var 1";
    final static String COLUMN_TITLE_INDEP_UNIT_1 = "Indep unit 1";
    final static String COLUMN_TITLE_INDEP_VAR_2 = "Indep var 2";
    final static String COLUMN_TITLE_INDEP_UNIT_2 = "Indep unit 2";

    //column titles order
    final static String[] COLUMN_TITLES = new String[]{
        COLUMN_TITLE_SEQ_ID,
        COLUMN_TITLE_SEQ_NR,
        COLUMN_TITLE_FILE_FORMAT,
        COLUMN_TITLE_STIM_TYPE,
        COLUMN_TITLE_SCH_NAME,
        COLUMN_TITLE_SPIKE,
        COLUMN_TITLE_TIME,
        COLUMN_TITLE_PLACE,
        COLUMN_TITLE_EXPERIMENTER,
        COLUMN_TITLE_NSUB,
        COLUMN_TITLE_NREC,
        COLUMN_TITLE_NREP,
        COLUMN_TITLE_NCHAN,
        COLUMN_TITLE_IGNORE,
        COLUMN_TITLE_COMMENT,
        COLUMN_TITLE_INDEP_VAR_1,
        COLUMN_TITLE_INDEP_UNIT_1,
        COLUMN_TITLE_INDEP_VAR_2,
        COLUMN_TITLE_INDEP_UNIT_2
    };
    final static int[] EDITABLE_COLUMNS = new int[]{5,13,14};
    private static final long serialVersionUID = 1L;
    private final String fileName;
    private final Integer cellNr;

    public CellTableModel(String fileName, Integer cellNr)
            throws LocalEntityCreationException {
        super();
        this.fileName = fileName;
        this.cellNr = cellNr;
        EventQueue.invokeLater(new Runnable() {
            @Override
            public void run() {
                fillTableModel();
            }
        });
    }

    @Override
    protected final void fillTableModel() {
        final List<Map<String, Object>> newTableRows = new ArrayList<Map<String, Object>>();
        final Set<Integer> newEditedRows = new HashSet<Integer>();

        for (KQuestSeq sequence : getSeqsFor(fileName, cellNr)) {
            final Map<String, Object> map =
                    getUserDataDS(fileName, sequence.getKQuestSeqPK().getISeq());
            UserDataDS udDs = (UserDataDS) map.get("UserDataDS");

            if ((Boolean) map.get("isChanged")) {
                newEditedRows.add(newTableRows.size());
            }

            KQuestIndep[] indeps = getKQuestIndepFrom(fileName, cellNr);
            newTableRows.add(getNewTableRows(sequence, udDs, indeps));
        }
        fillTableModel(COLUMN_TITLES, EDITABLE_COLUMNS, newEditedRows, newTableRows);
    }

    private Map<String, Object> getNewTableRows(final KQuestSeq sequence,
            final UserDataDS udDs, final KQuestIndep[] indeps) {
        final boolean seqFound = sequence != null;
        final boolean udDsFound = udDs != null;

        final Map<String, Object> tableRow = new HashMap<String, Object>(COLUMN_TITLES.length);
        if (seqFound) {
            tableRow.put(COLUMN_TITLE_SEQ_ID, sequence.getSeqID());
            tableRow.put(COLUMN_TITLE_SEQ_NR, sequence.getKQuestSeqPK().getISeq());
            tableRow.put(COLUMN_TITLE_FILE_FORMAT, sequence.getFileFormat());
            tableRow.put(COLUMN_TITLE_STIM_TYPE, sequence.getStimType());
            tableRow.put(COLUMN_TITLE_SCH_NAME, sequence.getSchName());
            tableRow.put(COLUMN_TITLE_SPIKE, sequence.getSpike());
            tableRow.put(COLUMN_TITLE_TIME, sequence.getTime());
            tableRow.put(COLUMN_TITLE_PLACE, sequence.getPlace());
            tableRow.put(COLUMN_TITLE_EXPERIMENTER, sequence.getExperimenter());
            tableRow.put(COLUMN_TITLE_NSUB, sequence.getNsub());
            tableRow.put(COLUMN_TITLE_NREC, sequence.getNrec());
            tableRow.put(COLUMN_TITLE_NREP, sequence.getNrep());
            tableRow.put(COLUMN_TITLE_NCHAN, sequence.getNchan());
        } else {
            tableRow.putAll(getEmptySequenceMap());
        }
        if (udDsFound) {
            tableRow.put(COLUMN_TITLE_IGNORE, udDs.getIgnoreDS());
            tableRow.put(COLUMN_TITLE_COMMENT, udDs.getEval());
        } else {
            tableRow.putAll(getEmptyUdDsMap());
        }
        tableRow.put(COLUMN_TITLE_INDEP_VAR_1,
                indeps[0] == null ? null : indeps[0].getIndepName());
        tableRow.put(COLUMN_TITLE_INDEP_UNIT_1,
                indeps[0] == null ? null : indeps[0].getIndepUnit());
        tableRow.put(COLUMN_TITLE_INDEP_VAR_2,
                indeps[1] == null ? null : indeps[1].getIndepName());
        tableRow.put(COLUMN_TITLE_INDEP_UNIT_2,
                indeps[1] == null ? null : indeps[1].getIndepUnit());
        return tableRow;
    }

    private Map<String, Object> getEmptySequenceMap() {
        final Map<String, Object> map = new HashMap<String, Object>(12);
        map.put(COLUMN_TITLE_SEQ_ID, null);
        map.put(COLUMN_TITLE_SEQ_NR, null);
        map.put(COLUMN_TITLE_FILE_FORMAT, null);
        map.put(COLUMN_TITLE_STIM_TYPE, null);
        map.put(COLUMN_TITLE_SCH_NAME, null);
        map.put(COLUMN_TITLE_TIME, null);
        map.put(COLUMN_TITLE_PLACE, null);
        map.put(COLUMN_TITLE_EXPERIMENTER, null);
        map.put(COLUMN_TITLE_NSUB, null);
        map.put(COLUMN_TITLE_NREC, null);
        map.put(COLUMN_TITLE_NREP, null);
        map.put(COLUMN_TITLE_NCHAN, null);
        return map;
    }

    private Map<String, Object> getEmptyUdDsMap() {
        final Map<String, Object> map = new HashMap<String, Object>(2);
        map.put(COLUMN_TITLE_IGNORE, null);
        map.put(COLUMN_TITLE_COMMENT, null);
        return map;
    }

    @Override
    public String getTableTitle() {
        return "Datasets in experiment: " + fileName + ", cell nr: " + cellNr;
    }

    @Override
    protected void initColumns() {
        final Map<String, AbstractColumn> columns =
                new HashMap<String, AbstractColumn>(COLUMN_TITLES.length);

        columns.put(COLUMN_TITLE_SPIKE, new SpikeColumn(COLUMN_TITLE_SPIKE));

        columns.put(COLUMN_TITLE_SEQ_NR, new IntegerColumn(COLUMN_TITLE_SEQ_NR));
        columns.put(COLUMN_TITLE_NSUB, new IntegerColumn(COLUMN_TITLE_NSUB));
        columns.put(COLUMN_TITLE_NREC, new IntegerColumn(COLUMN_TITLE_NREC));
        columns.put(COLUMN_TITLE_NREP, new IntegerColumn(COLUMN_TITLE_NREP));
        columns.put(COLUMN_TITLE_NCHAN, new IntegerColumn(COLUMN_TITLE_NCHAN));

        columns.put(COLUMN_TITLE_IGNORE, new BooleanColumn(COLUMN_TITLE_IGNORE));

        columns.put(COLUMN_TITLE_TIME, new DateColumn(COLUMN_TITLE_TIME));

        columns.put(COLUMN_TITLE_SEQ_ID, new StringColumn(COLUMN_TITLE_SEQ_ID));
        columns.put(COLUMN_TITLE_FILE_FORMAT, new StringColumn(COLUMN_TITLE_FILE_FORMAT));
        columns.put(COLUMN_TITLE_STIM_TYPE, new StringColumn(COLUMN_TITLE_STIM_TYPE));
        columns.put(COLUMN_TITLE_SCH_NAME, new StringColumn(COLUMN_TITLE_SCH_NAME));
        columns.put(COLUMN_TITLE_PLACE, new StringColumn(COLUMN_TITLE_PLACE));
        columns.put(COLUMN_TITLE_EXPERIMENTER, new StringColumn(COLUMN_TITLE_EXPERIMENTER));
        columns.put(COLUMN_TITLE_COMMENT, new StringColumn(COLUMN_TITLE_COMMENT));
        columns.put(COLUMN_TITLE_INDEP_VAR_1, new StringColumn(COLUMN_TITLE_INDEP_VAR_1));
        columns.put(COLUMN_TITLE_INDEP_UNIT_1, new StringColumn(COLUMN_TITLE_INDEP_UNIT_1));
        columns.put(COLUMN_TITLE_INDEP_VAR_2, new StringColumn(COLUMN_TITLE_INDEP_VAR_2));
        columns.put(COLUMN_TITLE_INDEP_UNIT_2, new StringColumn(COLUMN_TITLE_INDEP_UNIT_2));

        setColumns(columns);
    }

    @Override
    public void tableChanged(TableModelEvent e) {
        final int changeRowNr = e.getFirstRow();
        final int changeColNr = e.getColumn();

        if (changeColNr == -1) {
            return;
        }

        String changeColTitle = COLUMN_TITLES[changeColNr];

        Object oldValue = getTableRows().get(changeRowNr).get(changeColTitle);
        Object newValue = this.getValueAt(changeRowNr, changeColNr);

        // oldValue and newValue are different?
        if (e.getType() == TableModelEvent.UPDATE
                && ((oldValue == null && newValue != null)
                || oldValue != null && !oldValue.equals(newValue))) {
            // if a certain types are expected, check it here
            if (!checkValue(newValue, changeColTitle)) {
                setValueAt(oldValue, changeRowNr, changeColNr); // revert changes
                return;
            }

            final UserDataDS newUDDS = getNewUserDataDS(changeRowNr,
                    changeColTitle, newValue);
            final KQuestSeq newSeq = getNewKQuestSeq(fileName, changeRowNr,
                    changeColTitle, newValue);

            getChangesEntityManager().getTransaction().begin();
            getChangesEntityManager().merge(newUDDS);
            getChangesEntityManager().merge(newSeq);
            getTableRows().get(changeRowNr).put(changeColTitle, newValue);
            addToEditedRows(changeRowNr);
            getChangesEntityManager().getTransaction().commit();
        }
    }

    private UserDataDS getNewUserDataDS(final int changeRowNr,
            final String changeColTitle, final Object newValue) {
        // Key value
        int iSeq = (Integer) getTableRows().get(changeRowNr).get(COLUMN_TITLE_SEQ_NR);

        UserDataDS oldUDDS = null;
        final String queryString = "SELECT udDs FROM UserDataDS udDs"
                + " WHERE udDs.userDataDSPK.fileName=:filename"
                + " AND udDs.userDataDSPK.iSeq=:iseq";
        try {
            // First, check if this entry is already in the changes that need to be uploaded
            Query changesQuery = getChangesEntityManager().createQuery(queryString)
                    .setParameter("filename", fileName)
                    .setParameter("iseq", iSeq);
            oldUDDS = (UserDataDS) changesQuery.getSingleResult();
        } catch (NoResultException changesException) {
            try {
                // The entry is not yet in the list of changes that need to be uploaded
                // Check in the full database if the entry is already there
                Query localQuery = getLocalEntityManager().createQuery(queryString)
                        .setParameter("filename", fileName)
                        .setParameter("iseq", iSeq);
                oldUDDS = (UserDataDS) localQuery.getSingleResult();
            } catch (NoResultException localException) {
                // No entry exists for this file name. Create a new one.
                oldUDDS = new UserDataDS(fileName, iSeq);
            }
        }

        // Now copy this to a new entry (for the sake of clarity)
        final UserDataDS newUDDS = new UserDataDS(oldUDDS);

        if (changeColTitle.equals(COLUMN_TITLE_COMMENT)) {
            newUDDS.setEval(getStringValue(newValue.toString()));
        } else if (changeColTitle.equals(COLUMN_TITLE_IGNORE)) {
            newUDDS.setIgnoreDS(getBooleanValue(newValue.toString()));
        }
        return newUDDS;
    }

    private KQuestSeq getNewKQuestSeq(final String filename, final int changeRowNr,
            final String changeColTitle, final Object newValue) {
        int iSeq = (Integer) getTableRows().get(changeRowNr).get(COLUMN_TITLE_SEQ_NR);

        KQuestSeq oldSeq = null;
        final String queryString = "SELECT KQseq FROM KQuestSeq KQseq"
                + " WHERE KQseq.kQuestSeqPK.fileName=:filename"
                + " AND KQseq.kQuestSeqPK.iSeq=:iseq";
        try {
            // First, check if this entry is already in the changes that need to be uploaded
            Query changesQuery = getChangesEntityManager().createQuery(queryString)
                    .setParameter("filename", fileName)
                    .setParameter("iseq", iSeq);
            oldSeq = (KQuestSeq) changesQuery.getSingleResult();
        } catch (NoResultException changesException) {
            try {
                // The entry is not yet in the list of changes that need to be uploaded
                // Check in the full database if the entry is already there
                Query localQuery = getLocalEntityManager().createQuery(queryString)
                        .setParameter("filename", fileName)
                        .setParameter("iseq", iSeq);
                oldSeq = (KQuestSeq) localQuery.getSingleResult();
            } catch (NoResultException localException) {
                // No entry exists for this file name. Create a new one.
                oldSeq = new KQuestSeq(fileName, iSeq);
            }
        }

        final KQuestSeq newSeq = new KQuestSeq(oldSeq);

        if (changeColTitle.equals(COLUMN_TITLE_SPIKE)) {
            newSeq.setSpike(getStringValue(newValue.toString()));
        }

        return newSeq;
    }

    @Override
    protected String getRowString(int rowNumber) {
        return "sequence " + getTableRows().get(rowNumber).get(COLUMN_TITLE_SEQ_ID);
    }

    @Override
    protected void revertRow(int rowNumber) {
        DataManagement.revertCellChange(fileName, getSeqNr(rowNumber));
    }

    private int getSeqNr(int rowNumber) {
        return (Integer) getTableRows().get(rowNumber).get(COLUMN_TITLE_SEQ_NR);
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
