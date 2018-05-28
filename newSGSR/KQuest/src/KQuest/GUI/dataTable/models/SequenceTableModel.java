package KQuest.GUI.dataTable.models;

import KQuest.GUI.dataTable.models.columns.AbstractColumn;
import KQuest.GUI.dataTable.models.columns.BooleanColumn;
import KQuest.GUI.dataTable.models.columns.IntegerColumn;
import KQuest.GUI.dataTable.models.columns.RangeColumn;
import KQuest.GUI.dataTable.models.columns.StringColumn;
import KQuest.database.DataManagement;
import KQuest.database.LocalEntityCreationException;
import KQuest.database.entities.KQuestSubSeq;
import KQuest.database.entities.UserDataBadSubSeq;
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

public class SequenceTableModel extends AbstractTableModel {
    // column titles

    final static String COLUMN_TITLE_SUB_SEQUENCE_NR = "Subseq Nr";
    final static String COLUMN_TITLE_REP_ACCEPT = "RepAccept";
    final static String COLUMN_TITLE_SPL_L = "SPL L";
    final static String COLUMN_TITLE_SPL_R = "SPL R";
    final static String COLUMN_TITLE_ITD = "ITD";
    final static String COLUMN_TITLE_NOISE_LOW_FREQ_L = "Noise LowFreq L";
    final static String COLUMN_TITLE_NOISE_LOW_FREQ_R = "Noise LowFreq R";
    final static String COLUMN_TITLE_NOISE_HIGH_FREQ_L = "Noise HighFreq L";
    final static String COLUMN_TITLE_NOISE_HIGH_FREQ_R = "Noise HighFreq R";
    final static String COLUMN_TITLE_NOISE_BW_L = "Noise BW L";
    final static String COLUMN_TITLE_NOISE_BW_R = "Noise BW R";
    final static String COLUMN_TITLE_NOISE_RHO_L = "Noise Rho L";
    final static String COLUMN_TITLE_NOISE_RHO_R = "Noise Rho R";
    final static String COLUMN_TITLE_NOISE_POLARITY = "Noise Polarity";
    final static String COLUMN_TITLE_NOISE_RSEED_L = "Noise RSeed L";
    final static String COLUMN_TITLE_NOISE_RSEED_R = "Noise RSeed R";
    final static String COLUMN_TITLE_NOISE_FILE_NAME_L = "Noise FileName L";
    final static String COLUMN_TITLE_NOISE_FILE_NAME_R = "Noise FileName R";
    final static String COLUMN_TITLE_NOISE_SEQ_ID_L = "Noise SeqID L";
    final static String COLUMN_TITLE_NOISE_SEQ_ID_R = "Noise SeqID R";
    final static String COLUMN_TITLE_TONE_CAR_FREQ_L = "Tone CarFreq L";
    final static String COLUMN_TITLE_TONE_CAR_FREQ_R = "Tone CarFreq R";
    final static String COLUMN_TITLE_TONE_MOD_FREQ_L = "Tone ModFreq L";
    final static String COLUMN_TITLE_TONE_MOD_FREQ_R = "Tone ModFreq R";
    final static String COLUMN_TITLE_TONE_BEAT_FREQ = "Tone BeatFreq";
    final static String COLUMN_TITLE_TONE_MOD_DEPTH_L = "Tone ModDepth L";
    final static String COLUMN_TITLE_TONE_MOD_DEPTH_R = "Tone ModDepth R";
    final static String COLUMN_TITLE_BURST_DUR_L = "BurstDur L";
    final static String COLUMN_TITLE_BURST_DUR_R = "BurstDur R";
    final static String COLUMN_TITLE_REP_DUR_L = "RepDur L";
    final static String COLUMN_TITLE_REP_DUR_R = "RepDur R";
    final static String COLUMN_TITLE_RISE_DUR_L = "RiseDur L";
    final static String COLUMN_TITLE_RISE_DUR_R = "RiseDur R";
    final static String COLUMN_TITLE_FALL_DUR_L = "FallDur L";
    final static String COLUMN_TITLE_FALL_DUR_R = "FallDur R";
    final static String COLUMN_TITLE_BAD_SUB_SEQ = "Bad?";
    final static String COLUMN_TITLE_COMMENT = "Comment";
    // column titles order
    final static String[] COLUMN_TITLES = new String[]{
        COLUMN_TITLE_SUB_SEQUENCE_NR,
        COLUMN_TITLE_REP_ACCEPT,
        COLUMN_TITLE_SPL_L,
        COLUMN_TITLE_SPL_R,
        COLUMN_TITLE_ITD,
        COLUMN_TITLE_NOISE_LOW_FREQ_L,
        COLUMN_TITLE_NOISE_LOW_FREQ_R,
        COLUMN_TITLE_NOISE_HIGH_FREQ_L,
        COLUMN_TITLE_NOISE_HIGH_FREQ_R,
        COLUMN_TITLE_NOISE_BW_L,
        COLUMN_TITLE_NOISE_BW_R,
        COLUMN_TITLE_NOISE_RHO_L,
        COLUMN_TITLE_NOISE_RHO_R,
        COLUMN_TITLE_NOISE_POLARITY,
        COLUMN_TITLE_NOISE_RSEED_L,
        COLUMN_TITLE_NOISE_RSEED_R,
        COLUMN_TITLE_NOISE_FILE_NAME_L,
        COLUMN_TITLE_NOISE_FILE_NAME_R,
        COLUMN_TITLE_NOISE_SEQ_ID_L,
        COLUMN_TITLE_NOISE_SEQ_ID_R,
        COLUMN_TITLE_TONE_CAR_FREQ_L,
        COLUMN_TITLE_TONE_CAR_FREQ_R,
        COLUMN_TITLE_TONE_MOD_FREQ_L,
        COLUMN_TITLE_TONE_MOD_FREQ_R,
        COLUMN_TITLE_TONE_BEAT_FREQ,
        COLUMN_TITLE_TONE_MOD_DEPTH_L,
        COLUMN_TITLE_TONE_MOD_DEPTH_R,
        COLUMN_TITLE_BURST_DUR_L,
        COLUMN_TITLE_BURST_DUR_R,
        COLUMN_TITLE_REP_DUR_L,
        COLUMN_TITLE_REP_DUR_R,
        COLUMN_TITLE_RISE_DUR_L,
        COLUMN_TITLE_RISE_DUR_R,
        COLUMN_TITLE_FALL_DUR_L,
        COLUMN_TITLE_FALL_DUR_R,
        COLUMN_TITLE_BAD_SUB_SEQ,
        COLUMN_TITLE_COMMENT
    };
    final static int[] EDITABLE_CULUMNS = new int[]{1, 35, 36};
    private static final long serialVersionUID = 1L;
    private final String fileName;
    private final int iSeq;
    private final  int cellNr;
    private final String seqId;

    public SequenceTableModel(String fileName, Integer cellNr, String seqId,
            Integer iSeq) throws LocalEntityCreationException {
        super();
        this.fileName = fileName;
        this.iSeq = iSeq;
        this.cellNr = cellNr;
        this.seqId = seqId;
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

        for (KQuestSubSeq subSeq : getSubSeqsFor(fileName, iSeq)) {
            final int subSeqNr = subSeq.getKQuestSubSeqPK().getSubSeqNr();
            final Map<String, Object> map = getBadSubseq(fileName, iSeq, subSeqNr);
            UserDataBadSubSeq udSubSeq = (UserDataBadSubSeq) map.get("UserDataBadSubSeq");

            if ((Boolean) map.get("isChanged")) {
                newEditedRows.add(newTableRows.size());
            }

            final Boolean badSubSeq = (udSubSeq == null) ? null : udSubSeq.getBad();
            final String comment = (udSubSeq == null) ? null : udSubSeq.getEval();
            newTableRows.add(getNewTableRows(subSeq, badSubSeq, comment));
        }
        fillTableModel(COLUMN_TITLES, EDITABLE_CULUMNS, newEditedRows, newTableRows);
    }

    private Map<String, Object> getNewTableRows(KQuestSubSeq subSeq,
            final Boolean badSubSeq, final String comment) {
        final Map<String, Object> tableRow = new HashMap<String, Object>(COLUMN_TITLES.length);
        if (subSeq != null) {
            tableRow.put(COLUMN_TITLE_SUB_SEQUENCE_NR, subSeq.getKQuestSubSeqPK().getSubSeqNr());
            tableRow.put(COLUMN_TITLE_REP_ACCEPT, subSeq.getRepAccept());
            tableRow.put(COLUMN_TITLE_SPL_L, subSeq.getSplL());
            tableRow.put(COLUMN_TITLE_SPL_R, subSeq.getSplR());
            tableRow.put(COLUMN_TITLE_ITD, subSeq.getItd());
            tableRow.put(COLUMN_TITLE_NOISE_LOW_FREQ_L, subSeq.getNoiseLowFreqL());
            tableRow.put(COLUMN_TITLE_NOISE_LOW_FREQ_R, subSeq.getNoiseLowFreqR());
            tableRow.put(COLUMN_TITLE_NOISE_HIGH_FREQ_L, subSeq.getNoiseHighFreqL());
            tableRow.put(COLUMN_TITLE_NOISE_HIGH_FREQ_R, subSeq.getNoiseHighFreqR());
            tableRow.put(COLUMN_TITLE_NOISE_BW_L, subSeq.getNoiseBWL());
            tableRow.put(COLUMN_TITLE_NOISE_BW_R, subSeq.getNoiseBWR());
            tableRow.put(COLUMN_TITLE_NOISE_RHO_L, subSeq.getNoiseRhoL());
            tableRow.put(COLUMN_TITLE_NOISE_RHO_R, subSeq.getNoiseRhoR());
            tableRow.put(COLUMN_TITLE_NOISE_POLARITY, subSeq.getNoisePolarity());
            tableRow.put(COLUMN_TITLE_NOISE_RSEED_L, subSeq.getNoiseRSeedL());
            tableRow.put(COLUMN_TITLE_NOISE_RSEED_R, subSeq.getNoiseRSeedR());
            tableRow.put(COLUMN_TITLE_NOISE_FILE_NAME_L, subSeq.getNoiseFileNameL());
            tableRow.put(COLUMN_TITLE_NOISE_FILE_NAME_R, subSeq.getNoiseFileNameR());
            tableRow.put(COLUMN_TITLE_NOISE_SEQ_ID_L, subSeq.getNoiseSeqIDL());
            tableRow.put(COLUMN_TITLE_NOISE_SEQ_ID_R, subSeq.getNoiseSeqIDR());
            tableRow.put(COLUMN_TITLE_TONE_CAR_FREQ_L, subSeq.getToneCarFreqL());
            tableRow.put(COLUMN_TITLE_TONE_CAR_FREQ_R, subSeq.getToneCarFreqR());
            tableRow.put(COLUMN_TITLE_TONE_MOD_FREQ_L, subSeq.getToneModFreqL());
            tableRow.put(COLUMN_TITLE_TONE_MOD_FREQ_R, subSeq.getToneModFreqR());
            tableRow.put(COLUMN_TITLE_TONE_BEAT_FREQ, subSeq.getToneBeatFreq());
            tableRow.put(COLUMN_TITLE_TONE_MOD_DEPTH_L, subSeq.getToneModDepthL());
            tableRow.put(COLUMN_TITLE_TONE_MOD_DEPTH_R, subSeq.getToneModDepthR());
            tableRow.put(COLUMN_TITLE_BURST_DUR_L, subSeq.getBurstDurL());
            tableRow.put(COLUMN_TITLE_BURST_DUR_R, subSeq.getBurstDurR());
            tableRow.put(COLUMN_TITLE_REP_DUR_L, subSeq.getRepDurL());
            tableRow.put(COLUMN_TITLE_REP_DUR_R, subSeq.getRepDurR());
            tableRow.put(COLUMN_TITLE_RISE_DUR_L, subSeq.getRiseDurL());
            tableRow.put(COLUMN_TITLE_RISE_DUR_R, subSeq.getRiseDurR());
            tableRow.put(COLUMN_TITLE_FALL_DUR_L, subSeq.getFallDurL());
            tableRow.put(COLUMN_TITLE_FALL_DUR_R, subSeq.getFallDurR());
        } else {
            tableRow.putAll(getEmptySubSeqMap());
        }
        tableRow.put(COLUMN_TITLE_BAD_SUB_SEQ, badSubSeq);
        tableRow.put(COLUMN_TITLE_COMMENT, comment);
        return tableRow;
    }

    private Map<String, Object> getEmptySubSeqMap() {
        final Map<String, Object> map = new HashMap<String, Object>(34);
        map.put(COLUMN_TITLE_SUB_SEQUENCE_NR, null);
        map.put(COLUMN_TITLE_REP_ACCEPT, null);
        map.put(COLUMN_TITLE_SPL_L, null);
        map.put(COLUMN_TITLE_SPL_R, null);
        map.put(COLUMN_TITLE_ITD, null);
        map.put(COLUMN_TITLE_NOISE_LOW_FREQ_L, null);
        map.put(COLUMN_TITLE_NOISE_LOW_FREQ_R, null);
        map.put(COLUMN_TITLE_NOISE_HIGH_FREQ_L, null);
        map.put(COLUMN_TITLE_NOISE_HIGH_FREQ_R, null);
        map.put(COLUMN_TITLE_NOISE_BW_L, null);
        map.put(COLUMN_TITLE_NOISE_BW_R, null);
        map.put(COLUMN_TITLE_NOISE_RHO_L, null);
        map.put(COLUMN_TITLE_NOISE_RHO_R, null);
        map.put(COLUMN_TITLE_NOISE_POLARITY, null);
        map.put(COLUMN_TITLE_NOISE_RSEED_L, null);
        map.put(COLUMN_TITLE_NOISE_RSEED_R, null);
        map.put(COLUMN_TITLE_NOISE_FILE_NAME_L, null);
        map.put(COLUMN_TITLE_NOISE_FILE_NAME_R, null);
        map.put(COLUMN_TITLE_NOISE_SEQ_ID_L, null);
        map.put(COLUMN_TITLE_NOISE_SEQ_ID_R, null);
        map.put(COLUMN_TITLE_TONE_CAR_FREQ_L, null);
        map.put(COLUMN_TITLE_TONE_CAR_FREQ_R, null);
        map.put(COLUMN_TITLE_TONE_MOD_FREQ_L, null);
        map.put(COLUMN_TITLE_TONE_MOD_FREQ_R, null);
        map.put(COLUMN_TITLE_TONE_BEAT_FREQ, null);
        map.put(COLUMN_TITLE_TONE_MOD_DEPTH_L, null);
        map.put(COLUMN_TITLE_TONE_MOD_DEPTH_R, null);
        map.put(COLUMN_TITLE_BURST_DUR_L, null);
        map.put(COLUMN_TITLE_BURST_DUR_R, null);
        map.put(COLUMN_TITLE_REP_DUR_L, null);
        map.put(COLUMN_TITLE_REP_DUR_R, null);
        map.put(COLUMN_TITLE_RISE_DUR_L, null);
        map.put(COLUMN_TITLE_RISE_DUR_R, null);
        map.put(COLUMN_TITLE_FALL_DUR_L, null);
        map.put(COLUMN_TITLE_FALL_DUR_R, null);
        return map;
    }

    @Override
    public String getTableTitle() {
        return "Subsequences in experiment: " + fileName + ", cell nr: "
                + cellNr + ", seq Id: " + seqId;
    }

    @Override
    protected void initColumns() {
        final Map<String, AbstractColumn> columns =
                new HashMap<String, AbstractColumn>(COLUMN_TITLES.length);
        columns.put(COLUMN_TITLE_SUB_SEQUENCE_NR, new IntegerColumn(COLUMN_TITLE_SUB_SEQUENCE_NR));
        columns.put(COLUMN_TITLE_SPL_L, new IntegerColumn(COLUMN_TITLE_SPL_L));
        columns.put(COLUMN_TITLE_SPL_R, new IntegerColumn(COLUMN_TITLE_SPL_R));
        columns.put(COLUMN_TITLE_ITD, new IntegerColumn(COLUMN_TITLE_ITD));
        columns.put(COLUMN_TITLE_BURST_DUR_L, new IntegerColumn(COLUMN_TITLE_BURST_DUR_L));
        columns.put(COLUMN_TITLE_BURST_DUR_R, new IntegerColumn(COLUMN_TITLE_BURST_DUR_R));
        columns.put(COLUMN_TITLE_FALL_DUR_L, new IntegerColumn(COLUMN_TITLE_FALL_DUR_L));
        columns.put(COLUMN_TITLE_FALL_DUR_R, new IntegerColumn(COLUMN_TITLE_FALL_DUR_R));
        columns.put(COLUMN_TITLE_REP_DUR_L, new IntegerColumn(COLUMN_TITLE_REP_DUR_L));
        columns.put(COLUMN_TITLE_REP_DUR_R, new IntegerColumn(COLUMN_TITLE_REP_DUR_R));
        columns.put(COLUMN_TITLE_RISE_DUR_L, new IntegerColumn(COLUMN_TITLE_RISE_DUR_L));
        columns.put(COLUMN_TITLE_RISE_DUR_R, new IntegerColumn(COLUMN_TITLE_RISE_DUR_R));

        columns.put(COLUMN_TITLE_TONE_BEAT_FREQ, new IntegerColumn(COLUMN_TITLE_TONE_BEAT_FREQ));
        columns.put(COLUMN_TITLE_TONE_CAR_FREQ_L, new IntegerColumn(COLUMN_TITLE_TONE_CAR_FREQ_L));
        columns.put(COLUMN_TITLE_TONE_CAR_FREQ_R, new IntegerColumn(COLUMN_TITLE_TONE_CAR_FREQ_R));
        columns.put(COLUMN_TITLE_TONE_MOD_DEPTH_L, new IntegerColumn(COLUMN_TITLE_TONE_MOD_DEPTH_L));
        columns.put(COLUMN_TITLE_TONE_MOD_DEPTH_R, new IntegerColumn(COLUMN_TITLE_TONE_MOD_DEPTH_R));
        columns.put(COLUMN_TITLE_TONE_MOD_FREQ_L, new IntegerColumn(COLUMN_TITLE_TONE_MOD_FREQ_L));
        columns.put(COLUMN_TITLE_TONE_MOD_FREQ_R, new IntegerColumn(COLUMN_TITLE_TONE_MOD_FREQ_R));

        columns.put(COLUMN_TITLE_NOISE_BW_L, new IntegerColumn(COLUMN_TITLE_NOISE_BW_L));
        columns.put(COLUMN_TITLE_NOISE_BW_R, new IntegerColumn(COLUMN_TITLE_NOISE_BW_R));
        columns.put(COLUMN_TITLE_NOISE_HIGH_FREQ_L, new IntegerColumn(COLUMN_TITLE_NOISE_HIGH_FREQ_L));
        columns.put(COLUMN_TITLE_NOISE_HIGH_FREQ_R, new IntegerColumn(COLUMN_TITLE_NOISE_HIGH_FREQ_R));
        columns.put(COLUMN_TITLE_NOISE_LOW_FREQ_L, new IntegerColumn(COLUMN_TITLE_NOISE_LOW_FREQ_L));
        columns.put(COLUMN_TITLE_NOISE_LOW_FREQ_R, new IntegerColumn(COLUMN_TITLE_NOISE_LOW_FREQ_R));
        columns.put(COLUMN_TITLE_NOISE_POLARITY, new IntegerColumn(COLUMN_TITLE_NOISE_POLARITY));
        columns.put(COLUMN_TITLE_NOISE_RHO_L, new IntegerColumn(COLUMN_TITLE_NOISE_RHO_L));
        columns.put(COLUMN_TITLE_NOISE_RHO_R, new IntegerColumn(COLUMN_TITLE_NOISE_RHO_R));
        columns.put(COLUMN_TITLE_NOISE_RSEED_L, new IntegerColumn(COLUMN_TITLE_NOISE_RSEED_L));
        columns.put(COLUMN_TITLE_NOISE_RSEED_R, new IntegerColumn(COLUMN_TITLE_NOISE_RSEED_R));
        
        columns.put(COLUMN_TITLE_REP_ACCEPT, new RangeColumn(COLUMN_TITLE_REP_ACCEPT));
        
        columns.put(COLUMN_TITLE_BAD_SUB_SEQ, new BooleanColumn(COLUMN_TITLE_BAD_SUB_SEQ));
        
        columns.put(COLUMN_TITLE_NOISE_FILE_NAME_L, new StringColumn(COLUMN_TITLE_NOISE_FILE_NAME_L));
        columns.put(COLUMN_TITLE_NOISE_FILE_NAME_R, new StringColumn(COLUMN_TITLE_NOISE_FILE_NAME_R));
        columns.put(COLUMN_TITLE_NOISE_SEQ_ID_L, new StringColumn(COLUMN_TITLE_NOISE_SEQ_ID_L));
        columns.put(COLUMN_TITLE_NOISE_SEQ_ID_R, new StringColumn(COLUMN_TITLE_NOISE_SEQ_ID_R));
        columns.put(COLUMN_TITLE_COMMENT, new StringColumn(COLUMN_TITLE_COMMENT));

        setColumns(columns);
    }

    @Override
    public void tableChanged(TableModelEvent e) {
        final int changeRowNr = e.getFirstRow();
        final int changeColNr = e.getColumn();

        if (changeColNr == -1) {
            return;
        }

        final String changeColTitle = COLUMN_TITLES[changeColNr];

        final Object oldValue = getTableRows().get(changeRowNr).get(changeColTitle);
        final Object newValue = this.getValueAt(changeRowNr, changeColNr);

        // oldValue and newValue are different?
        if (e.getType() == TableModelEvent.UPDATE
                && ((oldValue == null && newValue != null)
                || oldValue != null && !oldValue.equals(newValue))) {
            // if certain types are expected, check it here
            if (!checkValue(newValue, changeColTitle)) {
                setValueAt(oldValue, changeRowNr, changeColNr); // revert changes
                return;
            }

            // Key value
            final Integer iSubSeq = (Integer) getTableRows().get(changeRowNr)
                    .get(COLUMN_TITLE_SUB_SEQUENCE_NR);

            UserDataBadSubSeq newUDBadSubSeq = getNewUDBadSubSeq(iSubSeq);
            KQuestSubSeq newKQuestSubSeq = getNewKQuestSubSeq(iSubSeq);

            if (changeColTitle.equals(COLUMN_TITLE_BAD_SUB_SEQ)) {
                newUDBadSubSeq.setBad(getBooleanValue(newValue.toString()));
            } else if (changeColTitle.equals(COLUMN_TITLE_REP_ACCEPT)) {
                newKQuestSubSeq.setRepAccept(newValue.toString());
            }

            getChangesEntityManager().getTransaction().begin();
            getChangesEntityManager().merge(newUDBadSubSeq);
            getChangesEntityManager().merge(newKQuestSubSeq);
            getTableRows().get(changeRowNr).put(changeColTitle, newValue);
            addToEditedRows(changeRowNr);
            getChangesEntityManager().getTransaction().commit();
        }
    }

    private UserDataBadSubSeq getNewUDBadSubSeq(final int iSubSeq) {
        UserDataBadSubSeq oldUDBadSubSeq;
        final String queryString = "SELECT udBadSubSeq"
                + " FROM UserDataBadSubSeq udBadSubSeq"
                + " WHERE udBadSubSeq.userDataBadSubSeqPK.fileName=:filename"
                + " AND udBadSubSeq.userDataBadSubSeqPK.iSeq=:iseq AND"
                + " udBadSubSeq.userDataBadSubSeqPK.subSeqNr=:subseqnr";
        try {
            // First, check if this entry is already in the changes that need to be uploaded
            final Query changesQuery = getChangesEntityManager().createQuery(queryString);
            changesQuery.setParameter("filename", fileName);
            changesQuery.setParameter("iseq", iSeq);
            changesQuery.setParameter("subseqnr", iSubSeq);
            oldUDBadSubSeq = (UserDataBadSubSeq) changesQuery.getSingleResult();
        } catch (NoResultException changesException) {
            try {
                // The entry is not yet in the list of changes that need to be uploaded
                // Check in the full database if the entry is already there
                final Query localQuery = getLocalEntityManager().createQuery(queryString);
                localQuery.setParameter("filename", fileName);
                localQuery.setParameter("iseq", iSeq);
                localQuery.setParameter("subseqnr", iSubSeq);
                oldUDBadSubSeq = (UserDataBadSubSeq) localQuery.getSingleResult();
            } catch (NoResultException localException) {
                // No entry exists for this file name. Create a new one.
                oldUDBadSubSeq = new UserDataBadSubSeq(fileName, iSeq, iSubSeq);
            }
        }
        return new UserDataBadSubSeq(oldUDBadSubSeq);
    }

    private KQuestSubSeq getNewKQuestSubSeq(final int iSubSeq) {
        KQuestSubSeq oldKQuestSubSeq;
        final String queryString = "SELECT kquestSubSeq"
                + " FROM KQuestSubSeq kquestSubSeq"
                + " WHERE kquestSubSeq.kQuestSubSeqPK.fileName=:filename"
                + " AND kquestSubSeq.kQuestSubSeqPK.iSeq=:iseq AND"
                + " kquestSubSeq.kQuestSubSeqPK.subSeqNr=:subseqnr";
        try {
            // First, check if this entry is already in the changes that need to be uploaded
            final Query changesQuery = getChangesEntityManager().createQuery(queryString);
            changesQuery.setParameter("filename", fileName);
            changesQuery.setParameter("iseq", iSeq);
            changesQuery.setParameter("subseqnr", iSubSeq);
            oldKQuestSubSeq = (KQuestSubSeq) changesQuery.getSingleResult();
        } catch (NoResultException changesException) {
            try {
                // The entry is not yet in the list of changes that need to be uploaded
                // Check in the full database if the entry is already there
                final Query localQuery = getLocalEntityManager().createQuery(queryString);
                localQuery.setParameter("filename", fileName);
                localQuery.setParameter("iseq", iSeq);
                localQuery.setParameter("subseqnr", iSubSeq);
                oldKQuestSubSeq = (KQuestSubSeq) localQuery.getSingleResult();
            } catch (NoResultException localException) {
                // No entry exists for this file name. Create a new one.
                oldKQuestSubSeq = new KQuestSubSeq(fileName, iSeq, iSubSeq);
            }
        }
        return new KQuestSubSeq(oldKQuestSubSeq);
    }

    @Override
    protected String getRowString(int rowNumber) {
        return "subsequence nr. " + getTableRows().get(rowNumber)
                .get(COLUMN_TITLE_SUB_SEQUENCE_NR);
    }

    @Override
    protected void revertRow(int rowNumber) {
        DataManagement.revertSequenceChange(fileName, iSeq, getSubSeqNr(rowNumber));
    }

    private int getSubSeqNr(int rowNumber) {
        return (Integer) getTableRows().get(rowNumber).get(COLUMN_TITLE_SUB_SEQUENCE_NR);
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
