package KQuest.database.entities;

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;
import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Transient;

@Entity
@Table(name = "KQuest_Indep", catalog = "ExpData", schema = "")
public class KQuestIndep implements Serializable, KQuestEntity<KQuestIndepPK>  {
    @Transient
    private PropertyChangeSupport changeSupport = new PropertyChangeSupport(this);

    private static final long serialVersionUID = 1L;

    @EmbeddedId
    protected KQuestIndepPK kQuestIndepPK;

    @Column(name = "idx")
    private Integer idx;

    @Basic(optional = false)
    @Column(name = "IndepName")
    private String indepName;

    @Basic(optional = false)
    @Column(name = "IndepUnit")
    private String indepUnit;

    public KQuestIndep() {
    }

    public KQuestIndep(final KQuestIndepPK kQuestIndepPK) {
        this.kQuestIndepPK = kQuestIndepPK;
    }

    public KQuestIndep(final KQuestIndepPK kQuestIndepPK, final String indepName,
            final String indepUnit) {
        this.kQuestIndepPK = kQuestIndepPK;
        this.indepName = indepName;
        this.indepUnit = indepUnit;
    }

    public KQuestIndep(final String fileName, final Integer iSeq, final Integer indepNr) {
        this.kQuestIndepPK = new KQuestIndepPK(fileName, iSeq, indepNr);
    }

    public KQuestIndepPK getKQuestIndepPK() {
        return kQuestIndepPK;
    }

    public void setKQuestIndepPK(final KQuestIndepPK kQuestIndepPK) {
        this.kQuestIndepPK = kQuestIndepPK;
    }

    public String getIndepName() {
        return indepName;
    }

    public void setIndepName(final String indepName) {
        String oldIndepName = this.indepName;
        this.indepName = indepName;
        changeSupport.firePropertyChange("indepName", oldIndepName, indepName);
    }

    public String getIndepUnit() {
        return indepUnit;
    }

    public void setIndepUnit(final String indepUnit) {
        String oldIndepUnit = this.indepUnit;
        this.indepUnit = indepUnit;
        changeSupport.firePropertyChange("indepUnit", oldIndepUnit, indepUnit);
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (kQuestIndepPK != null ? kQuestIndepPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(final Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof KQuestIndep)) {
            return false;
        }
        KQuestIndep other = (KQuestIndep) object;
        if ((this.kQuestIndepPK == null && other.kQuestIndepPK != null) ||
                (this.kQuestIndepPK != null && !this.kQuestIndepPK.equals(other.kQuestIndepPK))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "KQuest.KQuestIndep[kQuestIndepPK=" + kQuestIndepPK + "]";
    }

    public void addPropertyChangeListener(final PropertyChangeListener listener) {
        changeSupport.addPropertyChangeListener(listener);
    }

    public void removePropertyChangeListener(final PropertyChangeListener listener) {
        changeSupport.removePropertyChangeListener(listener);
    }

    @Override
    public KQuestIndepPK getPrimaryKey() {
        return kQuestIndepPK;
    }
}
