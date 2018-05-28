package KQuest.GUI.dataTable.models.columns;

import java.util.Iterator;
import java.util.List;
import javax.persistence.NoResultException;

/**
 * @author Ramses de Norre
 */
public class SideNotBothColumn extends SideColumn {

    private static final String BOTHSTRING = "both";
    
    public SideNotBothColumn(final String columnName) {
        super(columnName);
    }

    @Override
    public boolean isValid(final String value) {
        if (BOTHSTRING.equalsIgnoreCase(value)) {
            return false;
        }
        return super.isValid(value);
    }

    @Override
    public Integer getIndexOf(final String value) throws NoResultException {
        if (value.equalsIgnoreCase(BOTHSTRING)) {
            return null;
        }
        return super.getIndexOf(value);
    }

    @Override
    public List<String> getAllowedValues() {
        final List<String> sides = super.getAllowedValues();
        final Iterator<String> iterator = sides.iterator();
        while (iterator.hasNext()) {
            if (iterator.next().equalsIgnoreCase(BOTHSTRING)) {
                iterator.remove();
            }
        }
        return sides;
    }
}
