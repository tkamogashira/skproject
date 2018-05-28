package KQuest.GUI.dataTree;

import KQuest.GUI.KQuestApplicationView;
import KQuest.database.DataManagement;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.Query;

import javax.swing.JTree;
import javax.swing.SwingWorker;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeModel;
import org.jdesktop.application.Application;
import org.jdesktop.application.ResourceMap;

public class TreeUpdater extends SwingWorker<Void, Void> {
    // dummy constants, containing nonsensical values
    // those values indicate that no previous entries exist yet
    // (because we just started looking for entries)
    private final String STR_NOTHING_YET = "NOTHING_YET";
    private final int INT_NOTHING_YET = -1;

    private final JTree dataTree;
    protected DefaultMutableTreeNode treeRoot;

    // constructor
    public TreeUpdater(final JTree dataTree) {
        this.dataTree = dataTree;
    }

    @Override
    protected Void doInBackground() throws Exception {
        // prepare a connection to the local database
        final EntityManager localEntityManager =
                DataManagement.getLocalEntityManager();
        
        //prepare the root of the tree
        final ResourceMap resourceMap =
                Application.getInstance(KQuest.clients.KQuestGUIApplication.class).
                getContext().getResourceMap(KQuestApplicationView.class);
        final String rootString = resourceMap.getString("treeRoot.text");
        treeRoot = new DefaultMutableTreeNode(rootString);

        //get sequence information from the local database
        final Query query = localEntityManager.createQuery(
                "SELECT seq.kQuestSeqPK.fileName, seq.iCell, seq.seqID, " +
                "seq.kQuestSeqPK.iSeq FROM KQuestSeq seq " +
                "ORDER BY seq.kQuestSeqPK.fileName, seq.iCell, seq.seqID");
        List<Object[]> sequences = query.getResultList();

        String previousFileName = STR_NOTHING_YET;
        Integer previousICell = INT_NOTHING_YET;

        DefaultMutableTreeNode expNode = new DefaultMutableTreeNode();
        DefaultMutableTreeNode cellNode = new DefaultMutableTreeNode();
        DefaultMutableTreeNode seqNode = new DefaultMutableTreeNode();
        // loop through all sequences
        for (Object[] resultElement : sequences) {
            // each result contains 4 columns: fileName, iCell, seqID and iSeq

            // first look at the file name
            // if the file name is not equal to that of the previous result, a
            // new file (experiment) node should be started in the tree
            String fileName = (String)resultElement[0];
            if( !fileName.equals(previousFileName) ) {
                expNode = new DefaultMutableTreeNode(new ExperimentNode(fileName));
                treeRoot.add(expNode);
                previousFileName = fileName;
                previousICell = -1;
            }

            // get remaining results
            Integer iCell = (Integer)resultElement[1];
            String seqID = (String)resultElement[2];
            Integer iSeq = (Integer)resultElement[3];

            // if no cell number is indicated, there is nothing we can do with
            // this result
            if (iCell != null) {
                // if the cell number is different from the previous, a new cell
                // node should be started in the tree
                if (!iCell.equals(previousICell)) {
                    cellNode = new DefaultMutableTreeNode(new CellNode(fileName,
                            iCell));
                    expNode.add(cellNode);
                    previousICell = iCell;
                }

                // now add a sequence node the cell node for this result
                seqNode = new DefaultMutableTreeNode(new SequenceNode(fileName,
                        iCell, seqID, iSeq));
                cellNode.add(seqNode);
            }
        }
        return null;
    }

    @Override
    protected void done() {
        //apply the model and expand the tree
        dataTree.setModel(new DefaultTreeModel(treeRoot));
        //dataTree.expandRow(0);
    }
}
