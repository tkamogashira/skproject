package KQuest.database.entities;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

@Entity
@Table(name = "UserData_RecLoc", catalog = "ExpData", schema = "", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"RecLoc"})})
public class UserDataRecLoc implements Serializable, UserDataEntity {
    private static final long serialVersionUID = 1L;

    @Id
    @Basic(optional = false)
    @Column(name = "idx", nullable = false)
    private Short idx;

    @Basic(optional = false)
    @Column(name = "RecLoc", nullable = false, length = 4)
    private String recLoc;

    public UserDataRecLoc() {
    }

    public UserDataRecLoc(final Short idx) {
        this.idx = idx;
    }

    public UserDataRecLoc(final Short idx, String recLoc) {
        this.idx = idx;
        this.recLoc = recLoc;
    }

    public Short getIdx() {
        return idx;
    }

    public void setIdx(final Short idx) {
        this.idx = idx;
    }

    public String getRecLoc() {
        return recLoc;
    }

    public void setRecLoc(final String recLoc) {
        this.recLoc = recLoc;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idx != null ? idx.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(final Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof UserDataRecLoc)) {
            return false;
        }
        UserDataRecLoc other = (UserDataRecLoc) object;
        if ((this.idx == null && other.idx != null) || (this.idx != null && !this.idx.equals(other.idx))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "KQuest.UserDataRecLoc[idx=" + idx + "]";
    }

}
