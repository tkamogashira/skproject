package KQuest.util;

public class KQuestUtil {

    // do not instantiate
    private KQuestUtil() {}

    public static Double getDoubleValue(final String doubleString) {
        if (doubleString == null || doubleString.trim().length() == 0) {
            return null;
        }
        return Double.valueOf(doubleString);
    }

    public static Integer getIntegerValue(final String intString) {
        if (intString == null || intString.trim().length() == 0) {
            return null;
        }
        return Integer.valueOf(intString);
    }

    public static Boolean getBooleanValue(final String boolString) {
        if (boolString == null || boolString.trim().length() == 0) {
            return false;
        }
        return Boolean.valueOf(boolString);
    }

    public static String getStringValue(final String stringString) {
        if(stringString.length() == 0) {
            return null;
        }
        return stringString;
    }

    public static boolean isNullOrEmpty(final String string) {
        return string == null || string.isEmpty();
    }

    public static String capitalizeFirstLetter(final String string) {
        if (string == null) {
            return string;
        }
        return string.substring(0, 1).toUpperCase() + string.substring(1);
    }
}
