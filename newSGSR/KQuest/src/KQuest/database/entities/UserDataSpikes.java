package KQuest.database.entities;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * @author Ramses de Norre
 */
@Entity
@Table(name = "UserData_Spikes", catalog = "ExpData", schema = "")
public class UserDataSpikes implements Serializable, UserDataEntity {
    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "Spike", length = 5)
    private String spike;

    public Integer getId() {
        return id;
    }

    public void setId(final Integer id) {
        this.id = id;
    }

    public String getSpike() {
        return spike;
    }

    public void setSpike(final String spike) {
        this.spike = spike;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += id;
        return hash;
    }

    @Override
    public boolean equals(final Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof UserDataSpikes)) {
            return false;
        }
        UserDataSpikes other = (UserDataSpikes) object;
        if (this.id != other.id) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "KQuest.database.entities.UserDataSpikes[id=" + id + "]";
    }
}
