package KQuest.GUI.dataTable.models.columns;

import KQuest.GUI.KQuestApplicationView;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.persistence.NoResultException;

/**
 * @author Ramses de Norre
 */
public class RangeColumn extends AbstractColumn  {

    /*
     * Construct the regex to match range expressions, used to check the values
     * in range columns.
     */
    private static final Pattern RANGE_PATTERN;
    static {
        /*
         * Any digit, e.g. 4 or 23.
         */
        final String dig = "(\\d+)";

        /*
         * Any amount of white space
         */
        final String s = "([ \t]*)";

        /*
         * Number or range, so e.g. "7" or "3:11".
         */
        final String nor = "("+s+dig+"("+s+":"+s+dig+")?)";

        /*
         * Allow multiples, each ends on a ",", so allowed are:
         *   ""
         *   "7,"
         *   "3:11,"
         * and any concatenation of those.
         */
        final String multNor = "("+nor+s+",)*";

        /*
         * Start with a "[" then a number of (numbers or ranges) ending with ","
         * then a final (number or range) and to conclude a "]".
         */
        String regex = "\\[" + multNor + nor + s + "\\]";
        RANGE_PATTERN = Pattern.compile(regex,
                Pattern.CASE_INSENSITIVE & Pattern.UNIX_LINES);
    }

    public RangeColumn(final String columnName) {
        super(columnName);
    }

    @Override
    public boolean isValid(String value) {
        if (value == null) {
            return false;
        }
        final Matcher matcher = RANGE_PATTERN.matcher(value);
        return matcher.matches();
    }

    @Override
    public Integer getIndexOf(String value) throws NoResultException {
        throw new UnsupportedOperationException("Not applicable.");
    }

    @Override
    public List<String> getAllowedValues() {
        return Arrays.asList(new String[]{
            " any list of ranges, e.g. [7] or [3:7] or [4,7,9:11]"});
    }

    @Override
    public void showError(String wrongValue) {
        KQuestApplicationView.getInstance().showErrorMessageDialog("The value \""
                + wrongValue + "\" is not valid for " + getColumnName() + ". "
                + "Please give a valid range like [3], [5:6] or [7, 1:5].",
                "Invalid value");
    }
}
