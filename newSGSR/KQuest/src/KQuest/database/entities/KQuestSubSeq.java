package KQuest.database.entities;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "KQuest_SubSeq", catalog = "ExpData", schema = "")
public class KQuestSubSeq implements Serializable, KQuestEntity<KQuestSubSeqPK> {
    private static final long serialVersionUID = 1L;

    @EmbeddedId
    protected KQuestSubSeqPK kQuestSubSeqPK;
    @Column(name = "idx")
    private Integer idx;

    @Column(name = "RepAccept", length = 50)
    private String repAccept;

    @Column(name = "SPL_L", precision = 22)
    private Double splL;

    @Column(name = "SPL_R", precision = 22)
    private Double splR;

    @Column(name = "ITD", precision = 22)
    private Double itd;

    @Column(name = "Noise_LowFreq_L", precision = 22)
    private Double noiseLowFreqL;

    @Column(name = "Noise_LowFreq_R", precision = 22)
    private Double noiseLowFreqR;

    @Column(name = "Noise_HighFreq_L", precision = 22)
    private Double noiseHighFreqL;

    @Column(name = "Noise_HighFreq_R", precision = 22)
    private Double noiseHighFreqR;

    @Column(name = "Noise_BW_L", precision = 22)
    private Double noiseBWL;

    @Column(name = "Noise_BW_R", precision = 22)
    private Double noiseBWR;

    @Column(name = "Noise_Rho_L", precision = 22)
    private Double noiseRhoL;

    @Column(name = "Noise_Rho_R", precision = 22)
    private Double noiseRhoR;

    @Column(name = "Noise_Polarity", precision = 22)
    private Double noisePolarity;

    @Column(name = "Noise_RSeed_L", precision = 22)
    private Double noiseRSeedL;

    @Column(name = "Noise_RSeed_R", precision = 22)
    private Double noiseRSeedR;

    @Column(name = "Noise_FileName_L", length = 40)
    private String noiseFileNameL;

    @Column(name = "Noise_FileName_R", length = 40)
    private String noiseFileNameR;

    @Column(name = "Noise_SeqID_L", length = 40)
    private String noiseSeqIDL;

    @Column(name = "Noise_SeqID_R", length = 40)
    private String noiseSeqIDR;

    @Column(name = "Tone_CarFreq_L", precision = 22)
    private Double toneCarFreqL;

    @Column(name = "Tone_CarFreq_R", precision = 22)
    private Double toneCarFreqR;

    @Column(name = "Tone_ModFreq_L", precision = 22)
    private Double toneModFreqL;

    @Column(name = "Tone_ModFreq_R", precision = 22)
    private Double toneModFreqR;

    @Column(name = "Tone_BeatFreq", precision = 22)
    private Double toneBeatFreq;

    @Column(name = "Tone_BeatModFreq", precision = 22)
    private Double toneBeatModFreq;

    @Column(name = "Tone_ModDepth_L", precision = 22)
    private Double toneModDepthL;

    @Column(name = "Tone_ModDepth_R", precision = 22)
    private Double toneModDepthR;

    @Column(name = "BurstDur_L", precision = 22)
    private Double burstDurL;

    @Column(name = "BurstDur_R", precision = 22)
    private Double burstDurR;

    @Column(name = "RepDur_L", precision = 22)
    private Double repDurL;

    @Column(name = "RepDur_R", precision = 22)
    private Double repDurR;

    @Column(name = "RiseDur_L", precision = 22)
    private Double riseDurL;

    @Column(name = "RiseDur_R", precision = 22)
    private Double riseDurR;

    @Column(name = "FallDur_L", precision = 22)
    private Double fallDurL;

    @Column(name = "FallDur_R", precision = 22)
    private Double fallDurR;

    public KQuestSubSeq() {
    }

    public KQuestSubSeq(final KQuestSubSeqPK kQuestSubSeqPK) {
        this.kQuestSubSeqPK = kQuestSubSeqPK;
    }

    public KQuestSubSeq(final String fileName, final Integer iSeq,
            final Integer subSeqNr) {
        this.kQuestSubSeqPK = new KQuestSubSeqPK(fileName, iSeq, subSeqNr);
    }

    public KQuestSubSeq(final KQuestSubSeq kquestSubSeq) {
        this.kQuestSubSeqPK = kquestSubSeq.kQuestSubSeqPK;
        this.repAccept = kquestSubSeq.repAccept;
        this.splL = kquestSubSeq.splL;
        this.splR = kquestSubSeq.splR;
        this.idx = kquestSubSeq.idx;
        this.itd = kquestSubSeq.itd;
        this.noiseBWL = kquestSubSeq.noiseBWL;
        this.noiseBWR = kquestSubSeq.noiseBWR;
        this.noiseFileNameL = kquestSubSeq.noiseFileNameL;
        this.noiseFileNameR = kquestSubSeq.noiseFileNameR;
        this.noiseHighFreqL = kquestSubSeq.noiseHighFreqL;
        this.noiseHighFreqR = kquestSubSeq.noiseHighFreqR;
        this.noiseLowFreqL = kquestSubSeq.noiseLowFreqL;
        this.noiseLowFreqR = kquestSubSeq.noiseLowFreqR;
        this.noisePolarity = kquestSubSeq.noisePolarity;
        this.noiseRSeedL = kquestSubSeq.noiseRSeedL;
        this.noiseRSeedR = kquestSubSeq.noiseRSeedR;
        this.noiseFileNameL = kquestSubSeq.noiseFileNameL;
        this.noiseFileNameR = kquestSubSeq.noiseFileNameR;
        this.noiseSeqIDL = kquestSubSeq.noiseSeqIDL;
        this.noiseSeqIDR = kquestSubSeq.noiseSeqIDR;
        this.toneCarFreqL = kquestSubSeq.toneCarFreqL;
        this.toneCarFreqR = kquestSubSeq.toneCarFreqR;
        this.toneModFreqL = kquestSubSeq.toneModFreqL;
        this.toneModFreqR = kquestSubSeq.toneModFreqR;
        this.toneBeatFreq = kquestSubSeq.toneBeatFreq;
        this.toneBeatModFreq = kquestSubSeq.toneBeatModFreq;
        this.toneModDepthL = kquestSubSeq.toneModDepthL;
        this.toneModDepthR = kquestSubSeq.toneModDepthR;
        this.burstDurL = kquestSubSeq.burstDurL;
        this.burstDurR = kquestSubSeq.burstDurR;
        this.repDurL = kquestSubSeq.repDurL;
        this.repDurR = kquestSubSeq.repDurR;
        this.riseDurL = kquestSubSeq.riseDurL;
        this.riseDurR = kquestSubSeq.riseDurR;
        this.fallDurL = kquestSubSeq.fallDurL;
        this.fallDurR = kquestSubSeq.fallDurR;
    }

    public KQuestSubSeqPK getKQuestSubSeqPK() {
        return kQuestSubSeqPK;
    }

    public void setKQuestSubSeqPK(final KQuestSubSeqPK kQuestSubSeqPK) {
        this.kQuestSubSeqPK = kQuestSubSeqPK;
    }

    public String getRepAccept() {
        return repAccept;
    }

    public void setRepAccept(final String repAccept) {
        this.repAccept = repAccept;
    }

    public Double getSplL() {
        return splL;
    }

    public void setSplL(final Double splL) {
        this.splL = splL;
    }

    public Double getSplR() {
        return splR;
    }

    public void setSplR(final Double splR) {
        this.splR = splR;
    }

    public Double getItd() {
        return itd;
    }

    public void setItd(final Double itd) {
        this.itd = itd;
    }

    public Double getNoiseLowFreqL() {
        return noiseLowFreqL;
    }

    public void setNoiseLowFreqL(final Double noiseLowFreqL) {
        this.noiseLowFreqL = noiseLowFreqL;
    }

    public Double getNoiseLowFreqR() {
        return noiseLowFreqR;
    }

    public void setNoiseLowFreqR(final Double noiseLowFreqR) {
        this.noiseLowFreqR = noiseLowFreqR;
    }

    public Double getNoiseHighFreqL() {
        return noiseHighFreqL;
    }

    public void setNoiseHighFreqL(final Double noiseHighFreqL) {
        this.noiseHighFreqL = noiseHighFreqL;
    }

    public Double getNoiseHighFreqR() {
        return noiseHighFreqR;
    }

    public void setNoiseHighFreqR(final Double noiseHighFreqR) {
        this.noiseHighFreqR = noiseHighFreqR;
    }

    public Double getNoiseBWL() {
        return noiseBWL;
    }

    public void setNoiseBWL(final Double noiseBWL) {
        this.noiseBWL = noiseBWL;
    }

    public Double getNoiseBWR() {
        return noiseBWR;
    }

    public void setNoiseBWR(final Double noiseBWR) {
        this.noiseBWR = noiseBWR;
    }

    public Double getNoiseRhoL() {
        return noiseRhoL;
    }

    public void setNoiseRhoL(final Double noiseRhoL) {
        this.noiseRhoL = noiseRhoL;
    }

    public Double getNoiseRhoR() {
        return noiseRhoR;
    }

    public void setNoiseRhoR(final Double noiseRhoR) {
        this.noiseRhoR = noiseRhoR;
    }

    public Double getNoisePolarity() {
        return noisePolarity;
    }

    public void setNoisePolarity(final Double noisePolarity) {
        this.noisePolarity = noisePolarity;
    }

    public Double getNoiseRSeedL() {
        return noiseRSeedL;
    }

    public void setNoiseRSeedL(final Double noiseRSeedL) {
        this.noiseRSeedL = noiseRSeedL;
    }

    public Double getNoiseRSeedR() {
        return noiseRSeedR;
    }

    public void setNoiseRSeedR(final Double noiseRSeedR) {
        this.noiseRSeedR = noiseRSeedR;
    }

    public String getNoiseFileNameL() {
        return noiseFileNameL;
    }

    public void setNoiseFileNameL(final String noiseFileNameL) {
        this.noiseFileNameL = noiseFileNameL;
    }

    public String getNoiseFileNameR() {
        return noiseFileNameR;
    }

    public void setNoiseFileNameR(final String noiseFileNameR) {
        this.noiseFileNameR = noiseFileNameR;
    }

    public String getNoiseSeqIDL() {
        return noiseSeqIDL;
    }

    public void setNoiseSeqIDL(final String noiseSeqIDL) {
        this.noiseSeqIDL = noiseSeqIDL;
    }

    public String getNoiseSeqIDR() {
        return noiseSeqIDR;
    }

    public void setNoiseSeqIDR(final String noiseSeqIDR) {
        this.noiseSeqIDR = noiseSeqIDR;
    }

    public Double getToneCarFreqL() {
        return toneCarFreqL;
    }

    public void setToneCarFreqL(final Double toneCarFreqL) {
        this.toneCarFreqL = toneCarFreqL;
    }

    public Double getToneCarFreqR() {
        return toneCarFreqR;
    }

    public void setToneCarFreqR(final Double toneCarFreqR) {
        this.toneCarFreqR = toneCarFreqR;
    }

    public Double getToneModFreqL() {
        return toneModFreqL;
    }

    public void setToneModFreqL(final Double toneModFreqL) {
        this.toneModFreqL = toneModFreqL;
    }

    public Double getToneModFreqR() {
        return toneModFreqR;
    }

    public void setToneModFreqR(final Double toneModFreqR) {
        this.toneModFreqR = toneModFreqR;
    }

    public Double getToneBeatFreq() {
        return toneBeatFreq;
    }

    public void setToneBeatFreq(final Double toneBeatFreq) {
        this.toneBeatFreq = toneBeatFreq;
    }

    public Double getToneBeatModFreq() {
        return toneBeatModFreq;
    }

    public void setToneBeatModFreq(final Double toneBeatModFreq) {
        this.toneBeatModFreq = toneBeatModFreq;
    }

    public Double getToneModDepthL() {
        return toneModDepthL;
    }

    public void setToneModDepthL(final Double toneModDepthL) {
        this.toneModDepthL = toneModDepthL;
    }

    public Double getToneModDepthR() {
        return toneModDepthR;
    }

    public void setToneModDepthR(final Double toneModDepthR) {
        this.toneModDepthR = toneModDepthR;
    }

    public Double getBurstDurL() {
        return burstDurL;
    }

    public void setBurstDurL(final Double burstDurL) {
        this.burstDurL = burstDurL;
    }

    public Double getBurstDurR() {
        return burstDurR;
    }

    public void setBurstDurR(final Double burstDurR) {
        this.burstDurR = burstDurR;
    }

    public Double getRepDurL() {
        return repDurL;
    }

    public void setRepDurL(final Double repDurL) {
        this.repDurL = repDurL;
    }

    public Double getRepDurR() {
        return repDurR;
    }

    public void setRepDurR(final Double repDurR) {
        this.repDurR = repDurR;
    }

    public Double getRiseDurL() {
        return riseDurL;
    }

    public void setRiseDurL(final Double riseDurL) {
        this.riseDurL = riseDurL;
    }

    public Double getRiseDurR() {
        return riseDurR;
    }

    public void setRiseDurR(final Double riseDurR) {
        this.riseDurR = riseDurR;
    }

    public Double getFallDurL() {
        return fallDurL;
    }

    public void setFallDurL(final Double fallDurL) {
        this.fallDurL = fallDurL;
    }

    public Double getFallDurR() {
        return fallDurR;
    }

    public void setFallDurR(final Double fallDurR) {
        this.fallDurR = fallDurR;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (kQuestSubSeqPK != null ? kQuestSubSeqPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(final Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof KQuestSubSeq)) {
            return false;
        }
        KQuestSubSeq other = (KQuestSubSeq) object;
        if ((this.kQuestSubSeqPK == null && other.kQuestSubSeqPK != null) ||
                (this.kQuestSubSeqPK != null && !this.kQuestSubSeqPK.equals(other.kQuestSubSeqPK))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "KQuest.KQuestSubSeq[kQuestSubSeqPK=" + kQuestSubSeqPK + "]";
    }

    @Override
    public KQuestSubSeqPK getPrimaryKey() {
        return kQuestSubSeqPK;
    }

}
