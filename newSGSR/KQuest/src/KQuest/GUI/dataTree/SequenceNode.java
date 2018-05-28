package KQuest.GUI.dataTree;

/**
 * Sequence nodes in the data tree
 */
public class SequenceNode extends Node {
    protected Integer cellNr;
    protected String seqId;
    private Integer iSeq;

    public SequenceNode(String fileName, int cellNr, String seqId,
            int iSeq) {
        super(fileName);
        this.cellNr = cellNr;
        this.seqId = seqId;
        this.iSeq = iSeq;
    }

    @Override public String toString() {
        return seqId;
    }

    public Integer getCellNr() {
        return cellNr;
    }

    void setCellNr(Integer cellNr) {
        this.cellNr = cellNr;
    }

    public String getSeqId() {
        return seqId;
    }

    void setSeqId(String seqId) {
        this.seqId = seqId;
    }

    /**
     * @return the iSeq
     */
    public Integer getiSeq() {
        return iSeq;
    }

    /**
     * @param iSeq the iSeq to set
     */
    public void setiSeq(int iSeq) {
        this.iSeq = iSeq;
    }
}
