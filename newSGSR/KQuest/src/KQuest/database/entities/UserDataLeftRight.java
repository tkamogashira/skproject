package KQuest.database.entities;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

@Entity
@Table(name = "UserData_LeftRight", catalog = "ExpData", schema = "",
    uniqueConstraints = {@UniqueConstraint(columnNames = {"Side"})})
public class UserDataLeftRight implements Serializable, UserDataEntity {
    private static final long serialVersionUID = 1L;

    @Id
    @Basic(optional = false)
    @Column(name = "idx", nullable = false)
    private Integer idx;
    
    @Basic(optional = false)
    @Column(name = "Side", nullable = false, length = 5)
    private String side;

    public UserDataLeftRight() {
    }

    public UserDataLeftRight(final Integer idx) {
        this.idx = idx;
    }

    public UserDataLeftRight(final Integer idx, final String side) {
        this.idx = idx;
        this.side = side;
    }

    public Integer getIdx() {
        return idx;
    }

    public void setIdx(final Integer idx) {
        this.idx = idx;
    }

    public String getSide() {
        return side;
    }

    public void setSide(final String side) {
        this.side = side;
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
        if (!(object instanceof UserDataLeftRight)) {
            return false;
        }
        UserDataLeftRight other = (UserDataLeftRight) object;
        if ((this.idx == null && other.idx != null) ||
                (this.idx != null && !this.idx.equals(other.idx))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "KQuest.UserDataLeftRight[idx=" + idx + "]";
    }

}
