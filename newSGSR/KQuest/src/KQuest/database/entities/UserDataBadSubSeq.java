package KQuest.database.entities;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "UserData_BadSubSeq", catalog = "ExpData", schema = "")
public class UserDataBadSubSeq implements Serializable,
        KQuestEntity<UserDataBadSubSeqPK>, UserDataEntity {
    private static final long serialVersionUID = 1L;

    @EmbeddedId
    protected UserDataBadSubSeqPK userDataBadSubSeqPK;

    @Column(name = "Bad")
    private Boolean bad;

    @Column(name = "Eval", length = 100)
    private String eval;

    public UserDataBadSubSeq() {
    }

    public UserDataBadSubSeq(final UserDataBadSubSeq udBadSubSeq) {
        userDataBadSubSeqPK = udBadSubSeq.userDataBadSubSeqPK;
        bad = udBadSubSeq.bad;
    }

    public UserDataBadSubSeq(final UserDataBadSubSeqPK userDataBadSubSeqPK) {
        this.userDataBadSubSeqPK = userDataBadSubSeqPK;
    }

    public UserDataBadSubSeq(final String fileName, final Integer iSeq,
            final Integer subSeqNr) {
        this.userDataBadSubSeqPK = new UserDataBadSubSeqPK(fileName, iSeq, subSeqNr);
    }

    public UserDataBadSubSeqPK getUserDataBadSubSeqPK() {
        return userDataBadSubSeqPK;
    }

    public void setUserDataBadSubSeqPK(final UserDataBadSubSeqPK userDataBadSubSeqPK) {
        this.userDataBadSubSeqPK = userDataBadSubSeqPK;
    }

    public Boolean getBad() {
        return bad;
    }

    public void setBad(final Boolean bad) {
        this.bad = bad;
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
        hash += (userDataBadSubSeqPK != null ? userDataBadSubSeqPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(final Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof UserDataBadSubSeq)) {
            return false;
        }
        UserDataBadSubSeq other = (UserDataBadSubSeq) object;
        if ((this.userDataBadSubSeqPK == null && other.userDataBadSubSeqPK != null)
                || (this.userDataBadSubSeqPK != null
                && !this.userDataBadSubSeqPK.equals(other.userDataBadSubSeqPK))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "KQuest.UserDataBadSubSeq[userDataBadSubSeqPK=" + userDataBadSubSeqPK + "]";
    }

    @Override
    public UserDataBadSubSeqPK getPrimaryKey() {
        return userDataBadSubSeqPK;
    }
}
