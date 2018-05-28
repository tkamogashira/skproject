package KQuest.database.entities;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "UserData_Exposed", catalog = "ExpData", schema = "")
public class UserDataExposed implements Serializable, UserDataEntity {
    private static final long serialVersionUID = 1L;

    @Id
    @Basic(optional = false)
    @Column(name = "idx", nullable = false)
    private Short idx;

    @Basic(optional = false)
    @Column(name = "Exposed", nullable = false, length = 3)
    private String exposed;

    public UserDataExposed() {
    }

    public UserDataExposed(final Short idx) {
        this.idx = idx;
    }

    public UserDataExposed(final Short idx, final String exposed) {
        this.idx = idx;
        this.exposed = exposed;
    }

    public Short getIdx() {
        return idx;
    }

    public void setIdx(final Short idx) {
        this.idx = idx;
    }

    public String getExposed() {
        return exposed;
    }

    public void setExposed(final String exposed) {
        this.exposed = exposed;
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
        if (!(object instanceof UserDataExposed)) {
            return false;
        }
        UserDataExposed other = (UserDataExposed) object;
        if ((this.idx == null && other.idx != null) ||
                (this.idx != null && !this.idx.equals(other.idx))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "KQuest.UserDataExposed[idx=" + idx + "]";
    }
}
