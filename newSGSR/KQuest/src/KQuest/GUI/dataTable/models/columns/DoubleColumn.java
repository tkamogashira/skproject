package KQuest.GUI.dataTable.models.columns;

import KQuest.GUI.KQuestApplicationView;
import java.util.Arrays;
import java.util.List;
import javax.persistence.NoResultException;

/**
 * @author Ramses de Norre
 */
public class DoubleColumn extends AbstractColumn  {

    public DoubleColumn(final String columnName) {
        super(columnName);
    }

    @Override
    public boolean isValid(String value) {
        try {
            Double.parseDouble(value);
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
                + ". A numeric value should be given. The change was cancelled.",
                "Invalid value");
    }

    @Override
    public Class<?> getColumnClass() {
        return Double.class;
    }
}
