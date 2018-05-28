package KQuest.GUI.dataTable.models;

import KQuest.GUI.dataTable.models.columns.AbstractColumn;
import KQuest.GUI.dataTable.models.columns.ExposedColumn;
import KQuest.GUI.dataTable.models.columns.RecordingLocationColumn;
import KQuest.GUI.dataTable.models.columns.SideColumn;
import KQuest.GUI.dataTable.models.columns.SideNotBothColumn;
import KQuest.GUI.dataTable.models.columns.SpeciesColumn;
import KQuest.GUI.dataTable.models.columns.SpikeColumn;
import KQuest.GUI.dataTable.models.columns.StringColumn;
import KQuest.database.DataManagement;
import KQuest.database.LocalEntityCreationException;
import KQuest.database.entities.UserDataExp;
import static KQuest.util.KQuestUtil.*;
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

public class RootTableModel extends AbstractTableModel {
    // column titles
    final static String COLUMN_TITLE_FILE_NAME = "File name";
    final static String COLUMN_TITLE_AIM = "Aim";
    final static String COLUMN_TITLE_CHAN_1 = "Chan1";
    final static String COLUMN_TITLE_CHAN_2 = "Chan2";
    final static String COLUMN_TITLE_DSS_1 = "DSS1";
    final static String COLUMN_TITLE_DSS_2 = "DSS2";
    final static String COLUMN_TITLE_COMMENT = "Comment";
    final static String COLUMN_TITLE_EXPOSED = "ExposedStr";
    final static String COLUMN_TITLE_REC_LOCATION = "Rec Site";
    final static String COLUMN_TITLE_REC_SIDE = "RecLeRi";
    final static String COLUMN_TITLE_SPECIES = "Species";
    final static String COLUMN_TITLE_STIM_CHAN = "Stim Chan";
    // column titles order
    final static String[] COLUMN_TITLES = new String[]{
        COLUMN_TITLE_FILE_NAME,
        COLUMN_TITLE_AIM,
        COLUMN_TITLE_CHAN_1,
        COLUMN_TITLE_CHAN_2,
        COLUMN_TITLE_DSS_1,
        COLUMN_TITLE_DSS_2,
        COLUMN_TITLE_COMMENT,
        COLUMN_TITLE_EXPOSED,
        COLUMN_TITLE_REC_LOCATION,
        COLUMN_TITLE_REC_SIDE,
        COLUMN_TITLE_SPECIES,
        COLUMN_TITLE_STIM_CHAN
    };
    final static int[] EDITABLE_CULUMNS = new int[]{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11};
    private static final long serialVersionUID = 1L;

    public RootTableModel() throws LocalEntityCreationException {
        super();
        fillTableModel();
    }

    @Override
    protected final void fillTableModel() {
        final List<Map<String, Object>> newTableRows = new ArrayList<Map<String, Object>>();
        final Set<Integer> newEditedRows = new HashSet<Integer>();

        for (String filename : getFilenames()) {
            final Map<String, Object> map = getExperiment(filename);
            final UserDataExp experiment = (UserDataExp) map.get("UserDataExp");

            if ((Boolean) map.get("isChanged")) {
                newEditedRows.add(newTableRows.size());
            }
            
            newTableRows.add(getNewTableRows(filename, experiment));
        }
        fillTableModel(COLUMN_TITLES, EDITABLE_CULUMNS, newEditedRows, newTableRows);
    }

    private Map<String, Object> getNewTableRows(final String filename,
            final UserDataExp experiment) {
        final Map<String, Object> tableRow = new HashMap<String, Object>(COLUMN_TITLES.length);

        tableRow.put(COLUMN_TITLE_FILE_NAME, filename);
        if (experiment != null) {
            tableRow.put(COLUMN_TITLE_AIM, experiment.getAim());
            tableRow.put(COLUMN_TITLE_CHAN_1, experiment.getChan1());
            tableRow.put(COLUMN_TITLE_CHAN_2, experiment.getChan2());
            tableRow.put(COLUMN_TITLE_DSS_1, experiment.getDss1());
            tableRow.put(COLUMN_TITLE_DSS_2, experiment.getDss2());
            tableRow.put(COLUMN_TITLE_COMMENT, experiment.getEval());
            tableRow.put(COLUMN_TITLE_EXPOSED, experiment.getExposed());
            tableRow.put(COLUMN_TITLE_REC_LOCATION, experiment.getRecLoc());
            tableRow.put(COLUMN_TITLE_REC_SIDE, experiment.getRecSide());
            tableRow.put(COLUMN_TITLE_SPECIES, experiment.getSpecies());
            tableRow.put(COLUMN_TITLE_STIM_CHAN, experiment.getStimChan());
        } else {
            tableRow.putAll(getEmptyExperimentTable());
        }

        return tableRow;
    }

    private Map<String, Object> getEmptyExperimentTable() {
        final Map<String, Object> map = new HashMap<String, Object>(11);
        map.put(COLUMN_TITLE_AIM, null);
        map.put(COLUMN_TITLE_CHAN_1, null);
        map.put(COLUMN_TITLE_CHAN_2, null);
        map.put(COLUMN_TITLE_DSS_1, null);
        map.put(COLUMN_TITLE_DSS_2, null);
        map.put(COLUMN_TITLE_COMMENT, null);
        map.put(COLUMN_TITLE_EXPOSED, null);
        map.put(COLUMN_TITLE_REC_LOCATION, null);
        map.put(COLUMN_TITLE_REC_SIDE, null);
        map.put(COLUMN_TITLE_SPECIES, null);
        map.put(COLUMN_TITLE_STIM_CHAN, null);
        return map;
    }

    @Override
    public String getTableTitle() {
        return "Experiments";
    }

    @Override
    public void tableChanged(final TableModelEvent e) {
        final int changeRowNr = e.getFirstRow();
        final int changeColNr = e.getColumn();

        if (changeColNr == -1) {
            return;
        }

        final String changeColTitle = COLUMN_TITLES[changeColNr];
        final Object oldValue = getTableRows().get(changeRowNr).get(changeColTitle);
        final Object newValue = this.getValueAt(changeRowNr, changeColNr);

        // oldValue and newValue are different?
        // TODO equals from Object is useless here! We should properly compare the actual types
        if (e.getType() == TableModelEvent.UPDATE
                && ((oldValue == null && newValue != null)
                || oldValue != null && !oldValue.equals(newValue))) {
            // if certain types are expected, check it here
            if (!checkValue(newValue, changeColTitle)) {
                setValueAt(oldValue, changeRowNr, changeColNr); // revert changes
                return;
            }

            // Key value
            final String fileName = (String) getTableRows().get(changeRowNr)
                    .get(COLUMN_TITLE_FILE_NAME);

            UserDataExp oldUDExp;
            Query query;
            final String queryString = "SELECT udExp FROM UserDataExp udExp" +
                    " WHERE udExp.userDataExpPK.fileName=:filename";
            try {
                // First, check if this entry is already in the changes that need to be uploaded
                query = getChangesEntityManager().createQuery(queryString);
                query.setParameter("filename", fileName);
                oldUDExp = (UserDataExp) query.getSingleResult();
            } catch (NoResultException changesException) {
                try {
                    // The entry is not yet in the list of changes that need to be uploaded
                    // Check in the full database if the entry is already there
                    query = getLocalEntityManager().createQuery(queryString);
                    query.setParameter("filename", fileName);
                    oldUDExp = (UserDataExp) query.getSingleResult();
                } catch (NoResultException localException) {
                    // No entry exists for this file name. Create a new one.
                    oldUDExp = new UserDataExp(fileName);
                }
            }

            // Now copy this to a new entry (for the sake of clarity)
            final UserDataExp newUdExp =
                    getChangedUserDataExp(newValue, changeColTitle, oldUDExp);

            getChangesEntityManager().getTransaction().begin();
            getChangesEntityManager().merge(newUdExp);
            getTableRows().get(changeRowNr).put(changeColTitle, newValue);
            addToEditedRows(changeRowNr);
            getChangesEntityManager().getTransaction().commit();
        }
    }

    private UserDataExp getChangedUserDataExp(final Object newValue,
            final String changedColTitle, final UserDataExp originalUDE) {
        final UserDataExp newUdExp = new UserDataExp(originalUDE);

        if (changedColTitle.equals(COLUMN_TITLE_AIM)) {
            newUdExp.setAim(getStringValue(newValue.toString()));
        } else if (changedColTitle.equals(COLUMN_TITLE_CHAN_1)) {
            newUdExp.setChan1(getStringValue(newValue.toString()));
        } else if (changedColTitle.equals(COLUMN_TITLE_CHAN_2)) {
            newUdExp.setChan2(getStringValue(newValue.toString()));
        } else if (changedColTitle.equals(COLUMN_TITLE_DSS_1)) {
            newUdExp.setDss1(getStringValue(newValue.toString()));
        } else if (changedColTitle.equals(COLUMN_TITLE_DSS_2)) {
            newUdExp.setDss2(getStringValue(newValue.toString()));
        } else if (changedColTitle.equals(COLUMN_TITLE_COMMENT)) {
            newUdExp.setEval(getStringValue(newValue.toString()));
        } else if (changedColTitle.equals(COLUMN_TITLE_EXPOSED)) {
            newUdExp.setExposed(getStringValue(newValue.toString()));
        } else if (changedColTitle.equals(COLUMN_TITLE_REC_LOCATION)) {
            newUdExp.setRecLoc(getStringValue(newValue.toString()));
        } else if (changedColTitle.equals(COLUMN_TITLE_REC_SIDE)) {
            newUdExp.setRecSide(getStringValue(newValue.toString()));
        } else if (changedColTitle.equals(COLUMN_TITLE_SPECIES)) {
            newUdExp.setSpecies(getStringValue(newValue.toString()));
        } else if (changedColTitle.equals(COLUMN_TITLE_STIM_CHAN)) {
            newUdExp.setStimChan(getStringValue(newValue.toString()));
        }
        return newUdExp;
    }

    @Override
    protected void initColumns() {
        final Map<String, AbstractColumn> columns =
                new HashMap<String, AbstractColumn>(COLUMN_TITLES.length);

        columns.put(COLUMN_TITLE_REC_SIDE, new SideColumn(COLUMN_TITLE_REC_SIDE));
        columns.put(COLUMN_TITLE_STIM_CHAN, new SideColumn(COLUMN_TITLE_STIM_CHAN));

        columns.put(COLUMN_TITLE_CHAN_1, new SideNotBothColumn(COLUMN_TITLE_CHAN_1));
        columns.put(COLUMN_TITLE_CHAN_2, new SideNotBothColumn(COLUMN_TITLE_CHAN_2));
        columns.put(COLUMN_TITLE_DSS_1, new SideNotBothColumn(COLUMN_TITLE_DSS_1));
        columns.put(COLUMN_TITLE_DSS_2, new SideNotBothColumn(COLUMN_TITLE_DSS_2));

        columns.put(COLUMN_TITLE_EXPOSED, new ExposedColumn(COLUMN_TITLE_EXPOSED));

        columns.put(COLUMN_TITLE_SPECIES, new SpeciesColumn(COLUMN_TITLE_SPECIES));

        columns.put(COLUMN_TITLE_REC_LOCATION, new RecordingLocationColumn(COLUMN_TITLE_REC_LOCATION));

        columns.put(COLUMN_TITLE_FILE_NAME, new StringColumn(COLUMN_TITLE_FILE_NAME));
        columns.put(COLUMN_TITLE_AIM, new StringColumn(COLUMN_TITLE_AIM));
        columns.put(COLUMN_TITLE_COMMENT, new StringColumn(COLUMN_TITLE_COMMENT));

        setColumns(columns);
    }

    @Override
    protected String getRowString(int rowNumber) {
        return "experiment " + getTableRows().get(rowNumber).get(COLUMN_TITLE_FILE_NAME);
    }

    @Override
    protected void revertRow(int rowNumber) {
        DataManagement.revertRootChange(getFileName(rowNumber));
    }

    private String getFileName(int rowNumber) {
        return (String) getTableRows().get(rowNumber).get(COLUMN_TITLE_FILE_NAME);
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
