package KQuest.database.entities;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author u0050331
 */
@Entity
@Table(name = "KQuest_Seq", catalog = "ExpData", schema = "")
public class KQuestSeq implements Serializable, KQuestEntity<KQuestSeqPK> {
    private static final long serialVersionUID = 1L;
    @EmbeddedId
    protected KQuestSeqPK kQuestSeqPK;
    @Column(name = "idx")
    private Integer idx;
    @Column(name = "FileFormat", length = 40)
    private String fileFormat;
    @Column(name = "iCell")
    private Integer iCell;
    @Column(name = "SeqID", length = 40)
    private String seqID;
    @Column(name = "StimType", length = 40)
    private String stimType;
    @Column(name = "SchName", length = 40)
    private String schName;
    @Column(name = "Spike", length = 5)
    private String spike;
    @Column(name = "Time")
    @Temporal(TemporalType.TIMESTAMP)
    private Date time;
    @Column(name = "Place", length = 40)
    private String place;
    @Column(name = "Experimenter", length = 40)
    private String experimenter;
    @Basic(optional = false)
    @Column(name = "Nsub", nullable = false)
    private Short nsub;
    @Basic(optional = false)
    @Column(name = "Nrec", nullable = false)
    private Short nrec;
    @Basic(optional = false)
    @Column(name = "Nrep", nullable = false)
    private Short nrep;
    @Basic(optional = false)
    @Column(name = "Nchan", nullable = false)
    private Short nchan;

    public KQuestSeq() {
    }

    public KQuestSeq(KQuestSeqPK kQuestSeqPK) {
        this.kQuestSeqPK = kQuestSeqPK;
    }

    public KQuestSeq(final KQuestSeqPK kQuestSeqPK, final Short nsub,
            final Short nrec, final Short nrep, final Short nchan) {
        this.kQuestSeqPK = kQuestSeqPK;
        this.nsub = nsub;
        this.nrec = nrec;
        this.nrep = nrep;
        this.nchan = nchan;
    }

    public KQuestSeq(final KQuestSeq kQuestSeq) {
        this.kQuestSeqPK = kQuestSeq.kQuestSeqPK;
        this.idx = kQuestSeq.idx;
        this.fileFormat = kQuestSeq.fileFormat;
        this.iCell = kQuestSeq.iCell;
        this.seqID = kQuestSeq.seqID;
        this.stimType = kQuestSeq.stimType;
        this.schName = kQuestSeq.schName;
        this.spike = kQuestSeq.spike;
        this.time = kQuestSeq.time;
        this.place = kQuestSeq.place;
        this.experimenter = kQuestSeq.experimenter;
        this.nsub = kQuestSeq.nsub;
        this.nrec = kQuestSeq.nrec;
        this.nrep = kQuestSeq.nrep;
        this.nchan = kQuestSeq.nchan;
    }

    public KQuestSeq(final String fileName, final Integer iSeq) {
        this.kQuestSeqPK = new KQuestSeqPK(fileName, iSeq);
    }

    public KQuestSeqPK getKQuestSeqPK() {
        return kQuestSeqPK;
    }

    public void setKQuestSeqPK(final KQuestSeqPK kQuestSeqPK) {
        this.kQuestSeqPK = kQuestSeqPK;
    }

    public String getFileFormat() {
        return fileFormat;
    }

    public void setFileFormat(final String fileFormat) {
        this.fileFormat = fileFormat;
    }

    public Integer getICell() {
        return iCell;
    }

    public void setICell(final Integer iCell) {
        this.iCell = iCell;
    }

    public Integer getIdx() {
        return idx;
    }

    public void setIdx(final Integer idx) {
        this.idx = idx;
    }

    public String getSeqID() {
        return seqID;
    }

    public void setSeqID(final String seqID) {
        this.seqID = seqID;
    }

    public String getStimType() {
        return stimType;
    }

    public void setStimType(final String stimType) {
        this.stimType = stimType;
    }

    public String getSchName() {
        return schName;
    }

    public void setSchName(final String schName) {
        this.schName = schName;
    }

    public void setSpike(final String spike) {
        this.spike = spike;
    }

    public String getSpike() {
        return spike;
    }

    public Date getTime() {
        return time;
    }

    public void setTime(final Date time) {
        this.time = time;
    }

    public String getPlace() {
        return place;
    }

    public void setPlace(final String place) {
        this.place = place;
    }

    public String getExperimenter() {
        return experimenter;
    }

    public void setExperimenter(final String experimenter) {
        this.experimenter = experimenter;
    }

    public Short getNsub() {
        return nsub;
    }

    public void setNsub(final Short nsub) {
        this.nsub = nsub;
    }

    public Short getNrec() {
        return nrec;
    }

    public void setNrec(final Short nrec) {
        this.nrec = nrec;
    }

    public Short getNrep() {
        return nrep;
    }

    public void setNrep(final Short nrep) {
        this.nrep = nrep;
    }

    public Short getNchan() {
        return nchan;
    }

    public void setNchan(final Short nchan) {
        this.nchan = nchan;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (kQuestSeqPK != null ? kQuestSeqPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(final Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof KQuestSeq)) {
            return false;
        }
        KQuestSeq other = (KQuestSeq) object;
        if ((this.kQuestSeqPK == null && other.kQuestSeqPK != null) ||
                (this.kQuestSeqPK != null && !this.kQuestSeqPK.equals(other.kQuestSeqPK))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "KQuest.KQuestSeq[kQuestSeqPK=" + kQuestSeqPK + "]";
    }

    @Override
    public KQuestSeqPK getPrimaryKey() {
        return kQuestSeqPK;
    }
}
