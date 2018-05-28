package KQuest.database.entities;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
public class UserDataCellPK implements Serializable {
    private static final long serialVersionUID = 1L;

    @Basic(optional = false)
    @Column(name = "FileName", nullable = false, length = 40)
    private String fileName;

    @Basic(optional = false)
    @Column(name = "Nr", nullable = false)
    private Integer nr;

    public UserDataCellPK() {
    }

    public UserDataCellPK(final String fileName, final Integer nr) {
        this.fileName = fileName;
        this.nr = nr;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(final String fileName) {
        this.fileName = fileName;
    }

    public Integer getNr() {
        return nr;
    }

    public void setNr(final Integer nr) {
        this.nr = nr;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (fileName != null ? fileName.hashCode() : 0);
        hash += nr;
        return hash;
    }

    @Override
    public boolean equals(final Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof UserDataCellPK)) {
            return false;
        }
        UserDataCellPK other = (UserDataCellPK) object;
        if ((this.fileName == null && other.fileName != null) ||
                (this.fileName != null && !this.fileName.equals(other.fileName))) {
            return false;
        }
        if (this.nr != other.nr) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "KQuest.UserDataCellPK[fileName=" + fileName + ", nr=" + nr + "]";
    }

}
