package KQuest.GUI.dataTable.models.columns;

import java.util.List;
import javax.persistence.NoResultException;
import javax.persistence.Query;

/**
 * @author Ramses de Norre
 */
public class CellColumn extends AbstractColumn  {

    public CellColumn(final String columnName) {
        super(columnName);
    }

    @Override
    public Integer getIndexOf(String value) throws NoResultException {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        final Query localQuery = getLocalEntityManager().createQuery(
                "SELECT udCellV.id FROM UserDataCellValues udCellV"
                + " WHERE udCellV.cell=:cell");
        localQuery.setParameter("cell", value.trim().toUpperCase());
        return (Integer) localQuery.getSingleResult();
    }

    @Override
    public List<String> getAllowedValues() {
        final Query localQuery = getLocalEntityManager().createQuery(
                "SELECT udCellV.cell FROM UserDataCellValues udCellV");
        return localQuery.getResultList();
    }
}
