package KQuest.GUI.dataTable.models.columns;

import java.util.List;
import javax.persistence.NoResultException;
import javax.persistence.Query;

/**
 * @author Ramses de Norre
 */
public class PSTHColumn extends AbstractColumn  {

    public PSTHColumn(final String columnName) {
        super(columnName);
    }

    @Override
    public Integer getIndexOf(String value) throws NoResultException {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        final Query localQuery = getLocalEntityManager().createQuery(
                "SELECT udPSTH.id FROM UserDataPSTH udPSTH"
                + " WHERE udPSTH.psth=:psth");
        localQuery.setParameter("psth", value.trim().toUpperCase());
        return (Integer) localQuery.getSingleResult();
    }

    @Override
    public List<String> getAllowedValues() {
        final Query localQuery = getLocalEntityManager().createQuery(
                "SELECT udPSTH.psth FROM UserDataPSTH udPSTH");
        return localQuery.getResultList();
    }
}
