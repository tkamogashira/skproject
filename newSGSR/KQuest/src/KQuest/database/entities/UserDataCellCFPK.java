package KQuest.database.entities;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
public class UserDataCellCFPK implements Serializable {
    private static final long serialVersionUID = 1L;

    @Basic(optional = false)
    @Column(name = "FileName", nullable = false, length = 40)
    private String fileName;

    @Basic(optional = false)
    @Column(name = "iCell", nullable = false)
    private Integer iCell;

    public UserDataCellCFPK() {
    }

    public UserDataCellCFPK(final String fileName, final Integer iCell) {
        this.fileName = fileName;
        this.iCell = iCell;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(final String fileName) {
        this.fileName = fileName;
    }

    public Integer getICell() {
        return iCell;
    }

    public void setICell(final Integer iCell) {
        this.iCell = iCell;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (fileName != null ? fileName.hashCode() : 0);
        hash += iCell;
        return hash;
    }

    @Override
    public boolean equals(final Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof UserDataCellCFPK)) {
            return false;
        }
        UserDataCellCFPK other = (UserDataCellCFPK) object;
        if ((this.fileName == null && other.fileName != null) ||
                (this.fileName != null && !this.fileName.equals(other.fileName))) {
            return false;
        }
        if (this.iCell != other.iCell) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "KQuest.UserDataCellCFPK[fileName=" + fileName + ", iCell=" + iCell + "]";
    }
}
