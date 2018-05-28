package KQuest.GUI.dataTable.models.columns;

import java.util.List;
import javax.persistence.NoResultException;
import javax.persistence.Query;

/**
 * @author Ramses de Norre
 */
public class ExposedColumn extends AbstractColumn {

    public ExposedColumn(final String columnName) {
        super(columnName);
    }

    @Override
    public Integer getIndexOf(final String value) throws NoResultException {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        final Query localQuery = getLocalEntityManager().createQuery(
                "SELECT udExposed.idx FROM UserDataExposed udExposed"
                + " WHERE udExposed.exposed=:exposed");
        localQuery.setParameter("exposed", value.trim().toUpperCase());
        return ((Short) localQuery.getSingleResult()).intValue();
    }

    @Override
    public List<String> getAllowedValues() {
        final Query localQuery = getLocalEntityManager().createQuery(
                "SELECT udExposed.exposed FROM UserDataExposed udExposed");
        return localQuery.getResultList();
    }
}
