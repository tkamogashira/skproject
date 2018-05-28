package KQuest.GUI.dataTable.models.columns;

import KQuest.GUI.KQuestApplicationView;
import java.util.Arrays;
import java.util.List;
import javax.persistence.NoResultException;

/**
 * @author Ramses de Norre
 */
public class BooleanColumn extends AbstractColumn {

    public BooleanColumn(final String columnName) {
        super(columnName);
    }

    @Override
    public boolean isValid(String value) {
        if (value.toLowerCase().equals("true")
                || value.toLowerCase().equals("false")) {
            return true;
        }
        return false;
    }

    @Override
    public Integer getIndexOf(String value) throws NoResultException {
        throw new UnsupportedOperationException("Not applicable.");
    }

    @Override
    public List<String> getAllowedValues() {
        return Arrays.asList(new String[]{" \"true\" and \"false\""});
    }

    @Override
    public void showError(String wrongValue) {
        KQuestApplicationView.getInstance().showErrorMessageDialog("The value \""
                + wrongValue + "\" is not valid for " + getColumnName()
                + ". A boolean should be given. Possible values are: [true, false]. "
                + "The change was cancelled.", "Invalid value");
    }

    @Override
    public Class<?> getColumnClass() {
        return Boolean.class;
    }
}
