package KQuest.GUI.dataTable.models.columns;

import java.util.List;
import javax.persistence.NoResultException;
import javax.persistence.Query;

/**
 * @author Ramses de Norre
 */
public class SpikeColumn extends AbstractColumn {

    public SpikeColumn(final String columnName) {
        super(columnName);
    }

    @Override
    public Integer getIndexOf(String value) throws NoResultException {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        final Query localQuery = getLocalEntityManager().createQuery(
                "SELECT udSpikes.id FROM UserDataSpikes udSpikes"
                + " WHERE udSpikes.spike=:spike");
        localQuery.setParameter("spike", value.trim().toUpperCase());
        return (Integer) localQuery.getSingleResult();
    }

    @Override
    public List<String> getAllowedValues() {
        final Query localQuery = getLocalEntityManager().createQuery(
                "SELECT udSpikes.spike FROM UserDataSpikes udSpikes");
        return localQuery.getResultList();
    }
}
