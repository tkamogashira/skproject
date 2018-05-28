package KQuest.GUI.dataTree;

public class ExperimentNode extends Node {

    public ExperimentNode(String fileName) {
        super(fileName);
    }

    @Override public String toString() {
        return this.fileName;
    }
    
}
