package KQuest.GUI.dataTable.models.columns;

import java.util.List;
import javax.persistence.NoResultException;
import javax.persistence.Query;
import static KQuest.util.KQuestUtil.*;

/**
 * @author Ramses de Norre
 */
public class SpeciesColumn extends AbstractColumn {

    public SpeciesColumn(final String columnName) {
        super(columnName);
    }

    @Override
    public Integer getIndexOf(String value) throws NoResultException {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        final Query localQuery = getLocalEntityManager().createQuery(
                "SELECT udSpecies.idx FROM UserDataSpecies udSpecies"
                + " WHERE udSpecies.species=:species");
        localQuery.setParameter("species",
                capitalizeFirstLetter(value.trim()));
        return (Integer) localQuery.getSingleResult();
    }

    @Override
    public List<String> getAllowedValues() {
        final Query localQuery = getLocalEntityManager().createQuery(
                "SELECT udSpecies.species FROM UserDataSpecies udSpecies");
        return localQuery.getResultList();
    }
}
