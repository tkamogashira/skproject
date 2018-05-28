package KQuest.GUI.dataTable.models.columns;

import java.util.Arrays;
import java.util.List;

/**
 * This class works for columns that hold Strings.
 * @author Ramses de Norre
 */
public class StringColumn extends AbstractColumn {

    public StringColumn(final String columnName) {
        super(columnName);
    }

    @Override
    public boolean isValid(String value) {
        return true;
    }

    @Override
    public Integer getIndexOf(String value) {
        return null;
    }

    @Override
    public List<String> getAllowedValues() {
        return Arrays.asList(new String[]{" unrestricted"});
    }

    /*
     * For String columns any value is allowed, so this method makes no sense.
     */
    @Override
    public void showError(String wrongValue) {
        throw new UnsupportedOperationException("Not supported.");
    }
}
