package KQuest.GUI.dataTable.models.columns;

import KQuest.GUI.KQuestApplicationView;
import KQuest.database.DataManagement;
import KQuest.database.LocalEntityCreationException;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;

/**
 * @author Ramses de Norre
 */
public abstract class AbstractColumn {

    private final String columnName;

    private EntityManager localEntityManager;

    protected AbstractColumn(final String columnName) {
        this.columnName = columnName;
    }

    public String getColumnName() {
        return columnName;
    }

    protected EntityManager getLocalEntityManager() {
        if (localEntityManager == null) {
            try {
                localEntityManager = DataManagement.getLocalEntityManager();
            } catch (LocalEntityCreationException e) {
                e.printStackTrace();
                KQuestApplicationView.getInstance().reportLocalDatabaseErrorAndExit();
                return null;
            }
        }
        return localEntityManager;
    }

    /*
     * Object.class works for most types.
     */
    public Class<?> getColumnClass() {
        return Object.class;
    }

    public boolean isValid(final String value) {
        try {
            getIndexOf(value);
            return true;
        } catch (NoResultException exposedNotExist) {
            return false;
        }
    }

    /*
     * Return an Integer to allow for null
     */
    public abstract Integer getIndexOf(final String value) throws NoResultException;

    public abstract List<String> getAllowedValues();
    
    public String getAllowedValuesString() {
        return listToString(getAllowedValues());
    }

    private <T> String listToString(final List<T> list) {
        if (list == null || list.isEmpty()) {
            return "";
        }
        final StringBuilder builder = new StringBuilder(list.get(0).toString());
        for (T element : list.subList(1, list.size())) {
            builder.append(", ").append(element);
        }
        return builder.toString();
    }

    public void showError(final String wrongValue) {
        final List<String> values = getAllowedValues();
        KQuestApplicationView.getInstance().showErrorMessageDialog("The value \""
                + wrongValue
                + "\" is not valid for " + getColumnName() + ". Possible values are: "
                + values + " or empty. The change was cancelled.", "Invalid value");
    }
}
