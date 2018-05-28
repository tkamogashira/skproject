package KQuest.database.entities;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "UserData_Exp", catalog = "ExpData", schema = "")
public class UserDataExp implements Serializable, KQuestEntity<UserDataExpPK>, UserDataEntity {
    private static final long serialVersionUID = 1L;

    @EmbeddedId
    protected UserDataExpPK userDataExpPK;
    
    @Column(name = "Aim", length = 40)
    private String aim;

    @Column(name = "Eval", length = 100)
    private String eval;

    @Column(name = "RecLoc", length = 40)
    private String recLoc;

    @Column(name = "StimChan", length = 40)
    private String stimChan;

    @Column(name = "Species", length = 20)
    private String species;

    @Column(name = "RecSide", length = 40)
    private String recSide;

    @Column(name = "ExposedStr", length = 40)
    private String exposed;

    @Column(name = "DSS2", length = 40)
    private String dss2;

    @Column(name = "DSS1", length = 40)
    private String dss1;

    @Column(name = "Chan2", length = 40)
    private String chan2;

    @Column(name = "Chan1", length = 40)
    private String chan1;

    public UserDataExp() {
    }

    public UserDataExp(final UserDataExp udExp) {
        this.userDataExpPK = udExp.userDataExpPK;
        this.aim = udExp.aim;
        this.eval = udExp.eval;
        this.recLoc = udExp.recLoc;
        this.stimChan = udExp.stimChan;
        this.species = udExp.species;
        this.recSide = udExp.recSide;
        this.exposed = udExp.exposed;
        this.dss1 = udExp.dss1;
        this.dss2 = udExp.dss2;
        this.chan1 = udExp.chan1;
        this.chan2 = udExp.chan2;
    }

    public UserDataExp(final UserDataExpPK userDataExpPK) {
        this.userDataExpPK = userDataExpPK;
    }

    public UserDataExp(final String fileName) {
        this.userDataExpPK = new UserDataExpPK(fileName);
    }

    public UserDataExpPK getUserDataExpPK() {
        return userDataExpPK;
    }

    public void setUserDataDSPK(final UserDataExpPK userDataExpPK) {
        this.userDataExpPK = userDataExpPK;
    }

    public String getAim() {
        return aim;
    }

    public void setAim(final String aim) {
        this.aim = aim;
    }

    public String getEval() {
        return eval;
    }

    public void setEval(final String eval) {
        this.eval = eval;
    }

    public String getRecLoc() {
        return recLoc;
    }

    public void setRecLoc(final String recLoc) {
        this.recLoc = recLoc;
    }

    public String getStimChan() {
        return stimChan;
    }

    public void setStimChan(final String stimChan) {
        this.stimChan = stimChan;
    }

    public String getSpecies() {
        return species;
    }

    public void setSpecies(final String species) {
        this.species = species;
    }

    public String getRecSide() {
        return recSide;
    }

    public void setRecSide(final String recSide) {
        this.recSide = recSide;
    }

    public String getExposed() {
        return exposed;
    }

    public void setExposed(final String exposed) {
        this.exposed = exposed;
    }

    public String getDss2() {
        return dss2;
    }

    public void setDss2(final String dss2) {
        this.dss2 = dss2;
    }

    public String getDss1() {
        return dss1;
    }

    public void setDss1(final String dss1) {
        this.dss1 = dss1;
    }

    public String getChan2() {
        return chan2;
    }

    public void setChan2(final String chan2) {
        this.chan2 = chan2;
    }

    public String getChan1() {
        return chan1;
    }

    public void setChan1(final String chan1) {
        this.chan1 = chan1;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (userDataExpPK != null ? userDataExpPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(final Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof UserDataExp)) {
            return false;
        }
        UserDataExp other = (UserDataExp) object;
        if ((this.userDataExpPK == null && other.userDataExpPK != null) ||
                (this.userDataExpPK != null && !this.userDataExpPK.equals(other.userDataExpPK))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "KQuest.UserDataExp[userDataExpPK=" + userDataExpPK + "]";
    }

    @Override
    public UserDataExpPK getPrimaryKey() {
        return userDataExpPK;
    }

}
