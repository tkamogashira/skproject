package KQuest.GUI.dataTable.models.columns;

import java.util.List;
import javax.persistence.Query;
import javax.persistence.NoResultException;
import static KQuest.util.KQuestUtil.*;

/**
 * @author Ramses de Norre
 */
public class SideColumn extends AbstractColumn {

    public SideColumn(final String columnName) {
        super(columnName);
    }

    @Override
    public Integer getIndexOf(final String value) throws NoResultException {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        final Query localQuery = getLocalEntityManager().createQuery(
                "SELECT udLR.idx FROM UserDataLeftRight udLR WHERE udLR.side=:side");
        localQuery.setParameter("side", capitalizeFirstLetter(value.trim()));
        return (Integer) localQuery.getSingleResult();
    }

    @Override
    public List<String> getAllowedValues() {
        final Query localQuery = getLocalEntityManager().createQuery(
                "SELECT udLR.side FROM UserDataLeftRight udLR");
        return localQuery.getResultList();
    }
}
