package KQuest.GUI.dataTable.models.columns;

import KQuest.GUI.KQuestApplicationView;
import java.util.Arrays;
import java.util.List;
import javax.persistence.NoResultException;

/**
 * @author Ramses de Norre
 */
public class IntegerColumn extends AbstractColumn {

    public IntegerColumn(final String columnName) {
        super(columnName);
    }

    @Override
    public boolean isValid(String value) {
        try {
            Integer.parseInt(value);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    @Override
    public Integer getIndexOf(String value) throws NoResultException {
        throw new UnsupportedOperationException("Not applicable.");
    }

    @Override
    public List<String> getAllowedValues() {
        return Arrays.asList(new String[]{" all numbers"});
    }

    @Override
    public void showError(String wrongValue) {
        KQuestApplicationView.getInstance().showErrorMessageDialog("The value \""
                + wrongValue + "\" is not valid for " + getColumnName()
                + ". An integer value should be given. The change was cancelled.",
                "Invalid value");
    }

    @Override
    public Class<?> getColumnClass() {
        return Integer.class;
    }
}
