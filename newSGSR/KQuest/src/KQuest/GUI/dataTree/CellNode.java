package KQuest.GUI.dataTree;

public class CellNode extends Node {
    protected Integer cellNr;

    public CellNode(String fileName, Integer cellNr) {
        super(fileName);
        this.cellNr = cellNr;
    }

    @Override
    public String toString() {
        return cellNr.toString();
    }

    public Integer getCellNr() {
        return cellNr;
    }

    public void setCellNr(Integer cellNr) {
        this.cellNr = cellNr;
    }
}
