package KQuest.database.entities;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "UserData_CellCF", catalog = "ExpData", schema = "")
public class UserDataCellCF implements Serializable, KQuestEntity<UserDataCellCFPK>,
        UserDataEntity {
    private static final long serialVersionUID = 1L;

    @EmbeddedId
    protected UserDataCellCFPK userDataCellCFPK;

    @Column(name = "THRSeq")
    private Integer tHRSeq;

    @Column(name = "CF", precision = 22)
    private Double cf;

    @Column(name = "SR", precision = 22)
    private Double sr;

    @Column(name = "minTHR")
    private Integer minTHR;

    @Column(name = "Q10", precision = 22)
    private Double Q10;

    @Basic(optional = false)
    @Column(name = "manuallyAdjusted", nullable = false)
    private boolean manuallyAdjusted;

    public UserDataCellCF() {
    }

    public UserDataCellCF(final UserDataCellCFPK userDataCellCFPK) {
        this.userDataCellCFPK = userDataCellCFPK;
    }

    public UserDataCellCF(final UserDataCellCFPK userDataCellCFPK,
            final Boolean manuallyAdjusted) {
        this.userDataCellCFPK = userDataCellCFPK;
        this.manuallyAdjusted = manuallyAdjusted;
    }

    public UserDataCellCF(final String fileName, final Integer iCell) {
        this.userDataCellCFPK = new UserDataCellCFPK(fileName, iCell);
    }

    public UserDataCellCF(final UserDataCellCF cell) {
        this.userDataCellCFPK = cell.userDataCellCFPK;
        this.tHRSeq = cell.tHRSeq;
        this.cf = cell.cf;
        this.sr = cell.sr;
        this.minTHR = cell.minTHR;
        this.Q10 = cell.Q10;
        this.manuallyAdjusted = cell.manuallyAdjusted;
    }

    public UserDataCellCFPK getUserDataCellCFPK() {
        return userDataCellCFPK;
    }

    public void setUserDataCellCFPK(final UserDataCellCFPK userDataCellCFPK) {
        this.userDataCellCFPK = userDataCellCFPK;
    }

    public Integer getTHRSeq() {
        return tHRSeq;
    }

    public void setTHRSeq(final Integer tHRSeq) {
        this.tHRSeq = tHRSeq;
    }

    public Double getCf() {
        return cf;
    }

    public void setCf(final Double cf) {
        this.cf = cf;
    }

    public Double getSr() {
        return sr;
    }

    public void setSr(final Double sr) {
        this.sr = sr;
    }

    public Integer getMinTHR() {
        return this.minTHR;
    }

    public void setMinTHR(final Integer minTHR) {
        this.minTHR = minTHR;
    }

    public Double getQ10() {
        return this.Q10;
    }

    public void setQ10(final Double Q10) {
        this.Q10 = Q10;
    }

    public boolean getManuallyAdjusted() {
        return manuallyAdjusted;
    }

    public void setManuallyAdjusted(final Boolean manuallyAdjusted) {
        this.manuallyAdjusted = manuallyAdjusted;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (userDataCellCFPK != null ? userDataCellCFPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(final Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof UserDataCellCF)) {
            return false;
        }
        UserDataCellCF other = (UserDataCellCF) object;
        if ((this.userDataCellCFPK == null && other.userDataCellCFPK != null) ||
                (this.userDataCellCFPK != null && !this.userDataCellCFPK.equals(other.userDataCellCFPK))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "KQuest.UserDataCellCF[userDataCellCFPK=" + userDataCellCFPK + "]";
    }

    @Override
    public UserDataCellCFPK getPrimaryKey() {
        return userDataCellCFPK;
    }

}
