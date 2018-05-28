package KQuest.GUI.dataTable.models.columns;

import java.util.List;
import javax.persistence.NoResultException;
import javax.persistence.Query;

/**
 * @author Ramses de Norre
 */
public class RecordingLocationColumn extends AbstractColumn {

    public RecordingLocationColumn(final String columnName) {
        super(columnName);
    }

    @Override
    public Integer getIndexOf(String value) throws NoResultException {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        final Query localQuery = getLocalEntityManager().createQuery(
                "SELECT udRecLoc.idx FROM UserDataRecLoc udRecLoc"
                + " WHERE udRecLoc.recLoc=:recloc");
        localQuery.setParameter("recloc", value.toUpperCase());
        return ((Short) localQuery.getSingleResult()).intValue();
    }

    @Override
    public List<String> getAllowedValues() {
        final Query localQuery = getLocalEntityManager().createQuery(
                "SELECT udRecLoc.recLoc FROM UserDataRecLoc udRecLoc");
        return localQuery.getResultList();
    }
}
