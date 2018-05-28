package KQuest.GUI.dataTable.models.columns;

import java.util.List;
import javax.persistence.NoResultException;
import javax.persistence.Query;

/**
 * @author Ramses de Norre
 */
public class FysColumn extends AbstractColumn  {

    public FysColumn(final String columnName) {
        super(columnName);
    }

    @Override
    public Integer getIndexOf(String value) throws NoResultException {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        final Query localQuery = getLocalEntityManager().createQuery(
                "SELECT udFys.id FROM UserDataFys udFys"
                + " WHERE udFys.fys=:fys");
        localQuery.setParameter("fys", value.trim().toUpperCase());
        return (Integer) localQuery.getSingleResult();
    }

    @Override
    public List<String> getAllowedValues() {
        final Query localQuery = getLocalEntityManager().createQuery(
                "SELECT udFys.fys FROM UserDataFys udFys");
        return localQuery.getResultList();
    }

    @Override
    public String getAllowedValuesString() {
        return super.getAllowedValuesString()
                + " Or multiple values seperated by a comma";
    }
}
