package KQuest.database.entities;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
public class KQuestIndepPK implements Serializable {
    private static final long serialVersionUID = 1L;

    @Basic(optional = false)
    @Column(name = "FileName")
    private String fileName;

    @Basic(optional = false)
    @Column(name = "iSeq")
    private Integer iSeq;

    @Basic(optional = false)
    @Column(name = "Indep_Nr")
    private Integer indepNr;

    public KQuestIndepPK() {
    }

    public KQuestIndepPK(final String fileName, final Integer iSeq,
            final Integer indepNr) {
        this.fileName = fileName;
        this.iSeq = iSeq;
        this.indepNr = indepNr;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(final String fileName) {
        this.fileName = fileName;
    }

    public Integer getISeq() {
        return iSeq;
    }

    public void setISeq(final Integer iSeq) {
        this.iSeq = iSeq;
    }

    public Integer getIndepNr() {
        return indepNr;
    }

    public void setIndepNr(final Integer indepNr) {
        this.indepNr = indepNr;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (fileName != null ? fileName.hashCode() : 0);
        hash += iSeq;
        hash += indepNr;
        return hash;
    }

    @Override
    public boolean equals(final Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof KQuestIndepPK)) {
            return false;
        }
        KQuestIndepPK other = (KQuestIndepPK) object;
        if ((this.fileName == null && other.fileName != null) ||
                (this.fileName != null && !this.fileName.equals(other.fileName))) {
            return false;
        }
        if (this.iSeq != other.iSeq) {
            return false;
        }
        if (this.indepNr != other.indepNr) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "KQuest.KQuestIndepPK[fileName=" + fileName + ", iSeq=" + iSeq + ", indepNr=" + indepNr + "]";
    }
}
