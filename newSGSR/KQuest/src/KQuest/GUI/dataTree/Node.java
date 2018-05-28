package KQuest.GUI.dataTree;

public abstract class Node {
    protected String fileName;

    public Node(String fileName) {
        this.fileName = fileName;
    }

    @Override
    abstract public String toString();

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }
}
