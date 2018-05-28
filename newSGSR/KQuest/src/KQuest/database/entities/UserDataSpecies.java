package KQuest.database.entities;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "UserData_Species", catalog = "ExpData", schema = "")
public class UserDataSpecies implements Serializable, UserDataEntity {
    private static final long serialVersionUID = 1L;

    @Id
    @Basic(optional = false)
    @Column(name = "idx", nullable = false)
    private Integer idx;
    
    @Column(name = "species", length = 20)
    private String species;

    public UserDataSpecies() {
    }

    public UserDataSpecies(final Integer idx) {
        this.idx = idx;
    }

    public UserDataSpecies(final Integer idx, final String species) {
        this.idx = idx;
        this.species = species;
    }

    public Integer getIdx() {
        return idx;
    }

    public void setIdx(final Integer idx) {
        this.idx = idx;
    }

    public String getSpecies() {
        return species;
    }

    public void setSpecies(final String species) {
        this.species = species;
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
        if (!(object instanceof UserDataSpecies)) {
            return false;
        }
        UserDataSpecies other = (UserDataSpecies) object;
        if ((this.idx == null && other.idx != null) || (this.idx != null && !this.idx.equals(other.idx))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "KQuest.UserDataSpecies[idx=" + idx + "]";
    }

}
