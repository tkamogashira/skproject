package KQuest.database.entities;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "UserData_Cell", catalog = "ExpData", schema = "")
public class UserDataCell implements Serializable, KQuestEntity<UserDataCellPK>,
        UserDataEntity {
    private static final long serialVersionUID = 1L;

    @EmbeddedId
    protected UserDataCellPK userDataCellPK;

    @Basic(optional = false)
    @Column(name = "Chan1", length = 40)
    private String chan1;

    @Basic(optional = false)
    @Column(name = "Chan2", length = 40)
    private String chan2;

    @Basic(optional = false)
    @Column(name = "DSS1", length = 40)
    private String dss1;

    @Basic(optional = false)
    @Column(name = "DSS2", length = 40)
    private String dss2;

    @Basic(optional = false)
    @Column(name = "Eval", length = 200)
    private String eval;

    @Basic(optional = false)
    @Column(name = "ExposedStr", length = 40)
    private String exposed;

    //@Column(name = "FTCTHR")
    //private Integer ftcthr;

    @Column(name = "HistDepth")
    private Integer histDepth;

    @Column(name = "Ignore_Cell")
    private Boolean ignoreCell;

    @Column(name = "RCNTHR")
    private Integer rcnthr;

    @Basic(optional = false)
    @Column(name = "RecLoc", length = 40)
    private String recLoc;

    @Basic(optional = false)
    @Column(name = "RecSide", length = 40)
    private String recSide;

    @Column(name = "iPass")
    private Integer iPass;
    
    @Column(name = "iPen")
    private Integer iPen;

    @Column(name = "PSTH", length = 6)
    private String psth;

    @Column(name = "Cell", length = 7)
    private String cell;

    @Column(name = "Fys", length = 30)
    private String fys;

    @Column(name = "Hist")
    private Boolean hist;

    public UserDataCell() {}

    public UserDataCell(final UserDataCell udDataCell) {
        this.userDataCellPK = udDataCell.userDataCellPK;
        this.chan1 = udDataCell.chan1;
        this.chan2 = udDataCell.chan2;
        this.dss1 = udDataCell.dss1;
        this.dss2 = udDataCell.dss2;
        this.eval = udDataCell.eval;
        this.exposed = udDataCell.exposed;
        //this.ftcthr = udDataCell.ftcthr;
        this.histDepth = udDataCell.histDepth;
        this.iPass = udDataCell.iPass;
        this.iPen = udDataCell.iPen;
        this.ignoreCell = udDataCell.ignoreCell;
        this.rcnthr = udDataCell.rcnthr;
        this.recLoc = udDataCell.recLoc;
        this.recSide = udDataCell.recSide;
        this.psth = udDataCell.psth;
        this.cell = udDataCell.cell;
        this.fys = udDataCell.fys;
        this.hist = udDataCell.hist;
    }

    public UserDataCell(final UserDataCellPK userDataCellPK) {
        this.userDataCellPK = userDataCellPK;
    }

    public UserDataCell(final UserDataCellPK userDataCellPK, String eval) {
        this.userDataCellPK = userDataCellPK;
        this.eval = eval;
    }

    public UserDataCell(final String fileName, final Integer nr) {
        this.userDataCellPK = new UserDataCellPK(fileName, nr);
    }

    public UserDataCellPK getUserDataCellPK() {
        return userDataCellPK;
    }

    public void setUserDataCellPK(final UserDataCellPK userDataCellPK) {
        this.userDataCellPK = userDataCellPK;
    }

    public String getChan1() {
        return chan1;
    }

    public void setChan1(final String chan1) {
        this.chan1 = chan1;
    }

    public String getChan2() {
        return chan2;
    }

    public void setChan2(final String chan2) {
        this.chan2 = chan2;
    }

    public String getDss1() {
        return dss1;
    }

    public void setDss1(final String dss1) {
        this.dss1 = dss1;
    }

    public String getDss2() {
        return dss2;
    }

    public void setDss2(final String dss2) {
        this.dss2 = dss2;
    }

    public String getEval() {
        return eval;
    }

    public void setEval(final String eval) {
        this.eval = eval;
    }

    public String getExposed() {
        return exposed;
    }

    public void setExposed(final String exposed) {
        this.exposed = exposed;
    }

    public Integer getHistDepth() {
        return histDepth;
    }

    public void setHistDepth(final Integer histDepth) {
        this.histDepth = histDepth;
    }

    public Boolean getIgnoreCell() {
        return ignoreCell;
    }

    public void setIgnoreCell(final Boolean ignoreCell) {
        this.ignoreCell = ignoreCell;
    }

    public Integer getRcnThr() {
        return rcnthr;
    }

    public void setRcnthr(final Integer rcnthr) {
        this.rcnthr = rcnthr;
    }

    public String getRecLoc() {
        return recLoc;
    }

    public void setRecLoc(final String recLoc) {
        this.recLoc = recLoc;
    }

    public String getRecSide() {
        return recSide;
    }

    public void setRecSide(final String recSide) {
        this.recSide = recSide;
    }

    public Integer getIPass() {
        return iPass;
    }

    public void setIPass(final Integer iPass) {
        this.iPass = iPass;
    }

    public Integer getIPen() {
        return iPen;
    }

    public void setIPen(final Integer iPen) {
        this.iPen = iPen;
    }

    public String getCell() {
        return cell;
    }

    public void setCell(final String cell) {
        this.cell = cell;
    }

    public String getFys() {
        return fys;
    }

    public void setFys(final String fys) {
        this.fys = fys;
    }

    public Boolean getHist() {
        return hist;
    }

    public void setHist(final Boolean hist) {
        this.hist = hist;
    }

    public String getPsth() {
        return psth;
    }

    public void setPsth(final String psth) {
        this.psth = psth;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (userDataCellPK != null ? userDataCellPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(final Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof UserDataCell)) {
            return false;
        }
        UserDataCell other = (UserDataCell) object;
        if ((this.userDataCellPK == null && other.userDataCellPK != null) ||
                (this.userDataCellPK != null && !this.userDataCellPK.equals(other.userDataCellPK))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "KQuest.UserDataCell[userDataCellPK=" + userDataCellPK + "]";
    }

    @Override
    public UserDataCellPK getPrimaryKey() {
        return userDataCellPK;
    }
}
