package KQuest.database.entities;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
public class UserDataExpPK implements Serializable {
    private static final long serialVersionUID = 1L;

    @Basic(optional = false)
    @Column(name = "FileName", nullable = false, length = 40)
    private String fileName;

    public UserDataExpPK() {
    }

    public UserDataExpPK(final String fileName) {
        this.fileName = fileName;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(final String fileName) {
        this.fileName = fileName;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (fileName != null ? fileName.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(final Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof UserDataExpPK)) {
            return false;
        }
        UserDataExpPK other = (UserDataExpPK) object;
        if ((this.fileName == null && other.fileName != null) ||
                (this.fileName != null && !this.fileName.equals(other.fileName))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "KQuest.UserDataExpPK[fileName=" + fileName + "]";
    }

}
