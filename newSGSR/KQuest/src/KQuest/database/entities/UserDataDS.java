package KQuest.database.entities;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "UserData_DS", catalog = "ExpData", schema = "")
public class UserDataDS implements Serializable, KQuestEntity<UserDataDSPK>, UserDataEntity {
    private static final long serialVersionUID = 1L;

    @EmbeddedId
    protected UserDataDSPK userDataDSPK;

    @Column(name = "Ignore_DS")
    private Boolean ignoreDS;

    @Column(name = "Eval", length = 100)
    private String eval;

    public UserDataDS() {
    }

    public UserDataDS(UserDataDSPK userDataDSPK) {
        this.userDataDSPK = userDataDSPK;
    }

    public UserDataDS(final String fileName, final Integer iSeq) {
        this.userDataDSPK = new UserDataDSPK(fileName, iSeq);
    }

    public UserDataDS(final UserDataDS oldUDDS) {
        this.userDataDSPK = oldUDDS.userDataDSPK;
        this.eval = oldUDDS.eval;
        this.ignoreDS = oldUDDS.ignoreDS;
    }

    public UserDataDSPK getUserDataDSPK() {
        return userDataDSPK;
    }

    public void setUserDataDSPK(final UserDataDSPK userDataDSPK) {
        this.userDataDSPK = userDataDSPK;
    }

    public Boolean getIgnoreDS() {
        return ignoreDS;
    }

    public void setIgnoreDS(final Boolean ignoreDS) {
        this.ignoreDS = ignoreDS;
    }

    public String getEval() {
        return eval;
    }

    public void setEval(final String eval) {
        this.eval = eval;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (userDataDSPK != null ? userDataDSPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(final Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof UserDataDS)) {
            return false;
        }
        UserDataDS other = (UserDataDS) object;
        if ((this.userDataDSPK == null && other.userDataDSPK != null) ||
                (this.userDataDSPK != null && !this.userDataDSPK.equals(other.userDataDSPK))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "KQuest.UserDataDS[userDataDSPK=" + userDataDSPK + "]";
    }

    @Override
    public UserDataDSPK getPrimaryKey() {
        return userDataDSPK;
    }

}
