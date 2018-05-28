package KQuest.GUI.dataTable.models.columns;

import KQuest.GUI.KQuestApplicationView;
import java.text.DateFormat;
import java.text.ParseException;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import javax.persistence.NoResultException;

/**
 * @author Ramses de Norre
 */
public class DateColumn extends AbstractColumn {

    public DateColumn(final String columnName) {
        super(columnName);
    }

    @Override
    public boolean isValid(String value) {
        try {
            DateFormat.getInstance().parse(value);
            return true;
        } catch (ParseException excp) {
            return false;
        }
    }

    @Override
    public Integer getIndexOf(String value) throws NoResultException {
        throw new UnsupportedOperationException("Not applicable.");
    }

    @Override
    public List<String> getAllowedValues() {
        return Arrays.asList(new String[]{" dates."});
    }

    @Override
    public void showError(String wrongValue) {
        KQuestApplicationView.getInstance().showErrorMessageDialog("The value \""
                + wrongValue + "\" is not valid for " + getColumnName()
                + ". A Date should be given. Most conventional date formats are accepted",
                "Invalid value");
    }

    @Override
    public Class<?> getColumnClass() {
        return Date.class;
    }
}
