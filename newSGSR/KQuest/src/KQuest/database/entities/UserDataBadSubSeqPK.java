package KQuest.database.entities;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
public class UserDataBadSubSeqPK implements Serializable {
    private static final long serialVersionUID = 1L;

    @Basic(optional = false)
    @Column(name = "FileName", nullable = false, length = 40)
    private String fileName;

    @Basic(optional = false)
    @Column(name = "iSeq", nullable = false)
    private Integer iSeq;

    @Basic(optional = false)
    @Column(name = "SubSeq_Nr", nullable = false)
    private Integer subSeqNr;

    public UserDataBadSubSeqPK() {
    }

    public UserDataBadSubSeqPK(final String fileName, final Integer iSeq,
            final Integer subSeqNr) {
        this.fileName = fileName;
        this.iSeq = iSeq;
        this.subSeqNr = subSeqNr;
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

    public Integer getSubSeqNr() {
        return subSeqNr;
    }

    public void setSubSeqNr(final Integer subSeqNr) {
        this.subSeqNr = subSeqNr;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (fileName != null ? fileName.hashCode() : 0);
        hash += iSeq;
        hash += subSeqNr;
        return hash;
    }

    @Override
    public boolean equals(final Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof UserDataBadSubSeqPK)) {
            return false;
        }
        UserDataBadSubSeqPK other = (UserDataBadSubSeqPK) object;
        if ((this.fileName == null && other.fileName != null) ||
                (this.fileName != null && !this.fileName.equals(other.fileName))) {
            return false;
        }
        if (this.iSeq != other.iSeq) {
            return false;
        }
        if (this.subSeqNr != other.subSeqNr) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "KQuest.UserDataBadSubSeqPK[fileName=" + fileName +
                ", iSeq=" + iSeq + ", subSeqNr=" + subSeqNr + "]";
    }
}
