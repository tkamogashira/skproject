package KQuest.GUI;

import KQuest.GUI.dataTable.AbstractTableCellRenderer;
import KQuest.GUI.dataTable.BooleanTableCellRenderer;
import KQuest.GUI.dataTable.ColumnHeaderTooltipsAdapter;
import KQuest.GUI.dataTable.DefaultTableCellRenderer;
import KQuest.GUI.dataTable.models.AbstractTableModel;
import KQuest.GUI.dataTable.models.CellTableModel;
import KQuest.GUI.dataTable.models.ExperimentTableModel;
import KQuest.GUI.dataTable.models.RootTableModel;
import KQuest.GUI.dataTable.models.SequenceTableModel;
import KQuest.GUI.dataTree.CellNode;
import KQuest.GUI.dataTree.ExperimentNode;
import KQuest.GUI.dataTree.SequenceNode;
import KQuest.GUI.dataTree.TreeUpdater;
import KQuest.clients.KQuestGUIApplication;
import KQuest.database.DataManagement;
import KQuest.database.DatabaseUpdater;
import KQuest.database.LocalEntityCreationException;
import KQuest.matlab.KQuestMatlabClient;
import com.jamal.JamalException;
import java.awt.Color;
import java.awt.Font;
import java.awt.Point;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.EventObject;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JOptionPane;
import javax.swing.JTable;
import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import javax.swing.tree.DefaultMutableTreeNode;
import org.jdesktop.application.SingleFrameApplication;
import org.jdesktop.application.FrameView;
import javax.swing.tree.TreeSelectionModel;
import org.jdesktop.application.Application;
import org.jdesktop.application.Application.ExitListener;
import org.jdesktop.application.ResourceMap;

/**
 * The application's main frame.
 */
public final class KQuestApplicationView extends FrameView
        implements TreeSelectionListener {

    // singleton
    private static KQuestApplicationView instance;

    private static final Color CONN_OFFLINE_FOREGROUND_COLOR = new Color(0, 0, 0);
    private static final Color CONN_OFFLINE_BACKGROUND_COLOR = Color.RED;
    private static final Color CONN_ONLINE_FOREGROUND_COLOR = new Color(0, 0, 0);
    private static final Color CONN_ONLINE_BACKGROUND_COLOR = new Color(0, 128, 0);
    private static final Color CONN_CONNECTING_FOREGROUND_COLOR = new Color(0, 0, 0);
    private static final Color CONN_CONNECTING_BACKGROUND_COLOR = new Color(240, 240, 240);
    private static final String CONN_OFFLINE_STRING = "Offline";
    private static final String CONN_ONLINE_STRING = "Online";
    private static final String CONN_CONNECTING_STRING = "Connecting...";

    // my own declarations
    private ConnectionType connType;
    private String matlabUser;
    private boolean canBeClosed;
    private boolean allowStatusChanges;
    private String lastStatusUpdate;
    private boolean lastStatusBold;

    final private String rootString;

    private KQuestApplicationView(final SingleFrameApplication app) {
        super(app);

        this.getFrame().setTitle("Userdata GUI");

        final ResourceMap resourceMap =
                Application.getInstance(KQuest.clients.KQuestGUIApplication.class).
                getContext().getResourceMap(KQuestApplicationView.class);
        rootString = resourceMap.getString("treeRoot.text");

        allowStatusChanges = true;
        lastStatusUpdate = "";
        lastStatusBold = false;
        canBeClosed = true;

        initComponents();
        addExitListener();
        addWindowClosingListener();
        fixArrowsWhileEditing();
        addDefaultRenderers();
        setConnType(connType.CONNECTION_OFFLINE);
        updateGUI();
        downloadDatabase();
    }

    private void addDefaultRenderers() {
        for (Class<?> clazz : AbstractTableModel.getColumnClasses()) {
            if (Boolean.class.equals(clazz)) {
                dataTable.setDefaultRenderer(clazz, new BooleanTableCellRenderer());
            } else {
                dataTable.setDefaultRenderer(clazz, new DefaultTableCellRenderer());
            }
        }
    }

    private void addExitListener() {
        this.getApplication().addExitListener(new ExitListener() {

            @Override
            public boolean canExit(final EventObject e) {
                return canBeClosed;
            }

            @Override
            public void willExit(final EventObject e) {
                // Clean-up is already handled in the frame's WindowListener
            }
        });
    }

    private void addWindowClosingListener() {
        // Close any existing matlab session on shutdown
        this.getFrame().addWindowListener(new WindowAdapter() {

            @Override
            public void windowClosing(final WindowEvent e) {
                try {
                    KQuestMatlabClient.getMatlabClient().shutDownServer();
                } catch (JamalException ex) {
                    // Nothing we can do then...
                }
                KQuestApplicationView.this.getApplication().exit(e);
            }
        });
    }

    private void fixArrowsWhileEditing() {
        dataTable.addKeyListener(new KeyAdapter() {
            @Override
            public void keyPressed(final KeyEvent e) {
                if (e.getKeyCode() == KeyEvent.VK_UP
                        || e.getKeyCode() == KeyEvent.VK_DOWN) {
                    if (dataTable.isEditing()) {
                        dataTable.getCellEditor().stopCellEditing();
                    }
                }
            }
        });
    }

    public static synchronized KQuestApplicationView initInstance(final SingleFrameApplication app) {
        instance = new KQuestApplicationView(app);
        return instance;
    }

    public static synchronized KQuestApplicationView getInstance() {
        if (instance == null) {
            try {
                throw new Exception("Object KQuestApplicationView not initialized!");
            } catch (Exception ex) {
                Logger.getLogger(KQuestApplicationView.class.getName())
                        .log(Level.SEVERE, null, ex);
            }
        }
        return instance;
    }

    public int getRowAtDataTablePoint(final Point point) {
        return dataTable.convertRowIndexToModel(dataTable.rowAtPoint(point));
    }

    public int getColumnAtDataTablePoint(final Point point) {
        return dataTable.convertColumnIndexToModel(dataTable.columnAtPoint(point));
    }

    private void downloadDatabase() {
        (new DatabaseUpdater()).execute();
    }

    private void updateTree() {
        (new TreeUpdater(dataTree)).execute();

        //define listeners
        dataTree.getSelectionModel().
                setSelectionMode(TreeSelectionModel.SINGLE_TREE_SELECTION);
        dataTree.addTreeSelectionListener(this);
    }

    public void updateTable() {
        // what node is selected in the tree?
        final DefaultMutableTreeNode selectedNode =
                (DefaultMutableTreeNode) dataTree.getLastSelectedPathComponent();
        if (selectedNode != null) {
            final Object nodeObject = selectedNode.getUserObject();
            AbstractTableModel newModel = null;
            try {
                if (nodeObject instanceof String
                        && ((String) nodeObject).equals(rootString)) {
                    newModel = new RootTableModel();
                } else if (nodeObject.getClass() == ExperimentNode.class) {
                    final String fileName = ((ExperimentNode) nodeObject).getFileName();
                    newModel = new ExperimentTableModel(fileName);
                } else if (nodeObject.getClass() == CellNode.class) {
                    final String fileName = ((CellNode) nodeObject).getFileName();
                    final int cellNr = ((CellNode) nodeObject).getCellNr();
                    newModel = new CellTableModel(fileName, cellNr);
                } else if (nodeObject.getClass() == SequenceNode.class) {
                    final String fileName = ((SequenceNode) nodeObject).getFileName();
                    final int cellNr = ((SequenceNode) nodeObject).getCellNr();
                    final String seqId = ((SequenceNode) nodeObject).getSeqId();
                    final int iSeq = ((SequenceNode) nodeObject).getiSeq();
                    newModel = new SequenceTableModel(fileName, cellNr, seqId, iSeq);
                } else {
                    // We should never get here!
                    throw new RuntimeException("An error occured while trying to"
                            + " determine the appropriate table model."
                            + " Please contact a developer.");
                }
            } catch (LocalEntityCreationException ex) {
                reportLocalDatabaseErrorAndExit();
            }
            tableTitle.setText(newModel.getTableTitle());
            dataTable.setModel(newModel);
            dataTable.addMouseListener(newModel);
            addHeaderTooltipAdapters(dataTable);
        }
    }

    private void addHeaderTooltipAdapters(final JTable table) {
        table.getTableHeader().addMouseMotionListener(new ColumnHeaderTooltipsAdapter());
    }

    public void updateGUI() {
        updateTree();
        updateTable();
    }

    public void setStatusText(final String statusText) {
        setStatusText(statusText, false);
    }

    public void setStatusText(final String statusText, final boolean bold) {
        if (allowStatusChanges) {
            statusLabel.setText(statusText);
            setStatusTextBold(bold);
        } else {
            lastStatusBold = bold;
            lastStatusUpdate = statusText;
        }
    }

    private void setStatusTextBold(final boolean bold) {
        Font font = statusLabel.getFont();
        if (bold) {
            font = font.deriveFont(Font.BOLD);
        } else {
            font = font.deriveFont(Font.PLAIN);
        }
        statusLabel.setFont(font);
    }

    public String getStatusText() {
        return statusLabel.getText();
    }

    public void showMessageDialog(final String message, final String title) {
        JOptionPane.showMessageDialog(mainPanel, message, title,
                JOptionPane.PLAIN_MESSAGE);
    }

    public void showErrorMessageDialog(final String message, final String title) {
        JOptionPane.showMessageDialog(mainPanel, message, title,
                JOptionPane.ERROR_MESSAGE);
    }

    public Boolean showConfirmDialog(final String message, final String title) {
        final int answer = JOptionPane.showConfirmDialog(mainPanel, message, title,
                JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE);
        return (answer == JOptionPane.YES_OPTION);
    }

    public Boolean showDangerousConfirmDialog(final String message, final String title) {
        final int answer = JOptionPane.showConfirmDialog(mainPanel, message, title,
                JOptionPane.YES_NO_OPTION, JOptionPane.WARNING_MESSAGE);
        return (answer == JOptionPane.YES_OPTION);
    }

    public void reportLocalDatabaseErrorAndExit() {
        showErrorMessageDialog("There is a problem with your local database! "
                + "Close all programs that could be using the local database "
                + "(e.g. another instance of Userdata or Matlab),"
                + " and restart Userdata."
                + " If the problem persists, contact a programmer.",
                "Problem with local database");
        System.exit(1);
    }

    public String getMatlabUser() {
        if (this.matlabUser == null) {
            final ResourceMap resourceMap = org.jdesktop.application.Application.
                    getInstance(KQuest.clients.KQuestGUIApplication.class).getContext().
                    getResourceMap(KQuestGUIApplication.class);
            final File file = new File(resourceMap.getString("matlab.userFile"));
            try {
                final Scanner scanner = new Scanner(file);
                matlabUser = scanner.nextLine();
                scanner.close();
            } catch (FileNotFoundException exc) {
                final String message = "Enter the username to use with Matlab,"
                        + " this should be the username you use to run qstart";
                final String title = "Matlab username";
                String username = null;
                while (username == null) {
                    username =
                            JOptionPane.showInputDialog(mainPanel, message, title,
                            JOptionPane.DEFAULT_OPTION);
                }
                matlabUser = username;
                try {
                    file.createNewFile();
                    final FileWriter writer = new FileWriter(file);
                    writer.write(matlabUser);
                    writer.close();
                } catch (IOException exc2) {
                    showErrorMessageDialog("Something went wrong...", "Problem");
                    System.exit(-1);
                }
            }
        }
        return this.matlabUser;
    }

    @Override
    public void valueChanged(final TreeSelectionEvent e) {
        updateTable();
    }

    private void disableUploadButton() {
        this.buttonUploadLocalChanges.setEnabled(false);
    }

    private void disableRemoveButton() {
        this.buttonRemoveLocalChanges.setEnabled(false);
    }

    private void enableUploadButton() {
        this.buttonUploadLocalChanges.setEnabled(true);
    }

    private void enableRemoveButton() {
        this.buttonRemoveLocalChanges.setEnabled(true);
    }

    private void disableClosing() {
        this.canBeClosed = false;
    }

    private void enableClosing() {
        this.canBeClosed = true;
    }

    private void disableStatusTextUpdates() {
        this.allowStatusChanges = false;
    }

    private void enableStatusChanges() {
        this.allowStatusChanges = true;
        if (!lastStatusUpdate.isEmpty()) {
            setStatusText(lastStatusUpdate, lastStatusBold);
            lastStatusUpdate = "";
            lastStatusBold = false;
        }
    }

    private void enableMainPanel(final boolean enable) {
        mainPanel.setEnabled(enable);
    }

    public void setSaveMode(final boolean saveMode) {
        if (saveMode) {
            disableStatusTextUpdates();
            disableClosing();
            disableRemoveButton();
            disableUploadButton();
            enableMainPanel(false);

        } else {
            enableClosing();
            enableRemoveButton();
            enableUploadButton();
            enableMainPanel(true);
            enableStatusChanges();
        }
    }

    /** This method is called from within the constructor to
     * initialise the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        mainPanel = new javax.swing.JPanel();
        dataSplitPane = new javax.swing.JSplitPane();
        treeScrollPane = new javax.swing.JScrollPane();
        dataTree = new javax.swing.JTree();
        tablePane = new javax.swing.JPanel();
        tableScrollPane = new javax.swing.JScrollPane();
        dataTable = new javax.swing.JTable();
        tableTitle = new javax.swing.JLabel();
        buttonRemoveLocalChanges = new javax.swing.JButton();
        buttonUploadLocalChanges = new javax.swing.JButton();
        legendPanel = new javax.swing.JPanel();
        unEditableColor = new javax.swing.JPanel();
        editedColor = new javax.swing.JPanel();
        inheritedColor = new javax.swing.JPanel();
        uneditableLabel = new javax.swing.JLabel();
        editedLabel = new javax.swing.JLabel();
        inheritedLabel = new javax.swing.JLabel();
        legendTitle = new javax.swing.JLabel();
        statusPanel = new javax.swing.JPanel();
        statusLabel = new javax.swing.JLabel();
        connectionButton = new javax.swing.JToggleButton();

        mainPanel.setName("mainPanel"); // NOI18N

        dataSplitPane.setName("dataSplitPane"); // NOI18N

        treeScrollPane.setMinimumSize(new java.awt.Dimension(70, 24));
        treeScrollPane.setName("treeScrollPane"); // NOI18N
        treeScrollPane.setPreferredSize(new java.awt.Dimension(100, 324));

        javax.swing.tree.DefaultMutableTreeNode treeNode1 = new javax.swing.tree.DefaultMutableTreeNode("Loading...");
        dataTree.setModel(new javax.swing.tree.DefaultTreeModel(treeNode1));
        dataTree.setDoubleBuffered(true);
        dataTree.setMinimumSize(new java.awt.Dimension(70, 0));
        dataTree.setName("dataTree"); // NOI18N
        treeScrollPane.setViewportView(dataTree);

        dataSplitPane.setLeftComponent(treeScrollPane);

        tablePane.setName("tablePane"); // NOI18N

        tableScrollPane.setName("tableScrollPane"); // NOI18N

        dataTable.setAutoCreateRowSorter(true);
        dataTable.setAutoResizeMode(javax.swing.JTable.AUTO_RESIZE_OFF);
        dataTable.setDoubleBuffered(true);
        dataTable.setName("dataTable"); // NOI18N
        tableScrollPane.setViewportView(dataTable);

        org.jdesktop.application.ResourceMap resourceMap = org.jdesktop.application.Application.getInstance(KQuest.clients.KQuestGUIApplication.class).getContext().getResourceMap(KQuestApplicationView.class);
        tableTitle.setFont(resourceMap.getFont("tableTitle.font")); // NOI18N
        tableTitle.setName("tableTitle"); // NOI18N

        buttonRemoveLocalChanges.setText(resourceMap.getString("buttonRemoveLocalChanges.text")); // NOI18N
        buttonRemoveLocalChanges.setName("buttonRemoveLocalChanges"); // NOI18N
        buttonRemoveLocalChanges.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                buttonRemoveLocalChangesActionPerformed(evt);
            }
        });

        buttonUploadLocalChanges.setText(resourceMap.getString("buttonUploadLocalChanges.text")); // NOI18N
        buttonUploadLocalChanges.setName("buttonUploadLocalChanges"); // NOI18N
        buttonUploadLocalChanges.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                buttonUploadLocalChangesActionPerformed(evt);
            }
        });

        legendPanel.setBorder(javax.swing.BorderFactory.createBevelBorder(javax.swing.border.BevelBorder.RAISED));
        legendPanel.setName("legendPanel"); // NOI18N

        unEditableColor.setBackground(AbstractTableCellRenderer.BG_UNSELECTED_UNEDITABLE);
        unEditableColor.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));
        unEditableColor.setName("unEditableColor"); // NOI18N
        unEditableColor.setPreferredSize(new java.awt.Dimension(55, 16));

        javax.swing.GroupLayout unEditableColorLayout = new javax.swing.GroupLayout(unEditableColor);
        unEditableColor.setLayout(unEditableColorLayout);
        unEditableColorLayout.setHorizontalGroup(
            unEditableColorLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 69, Short.MAX_VALUE)
        );
        unEditableColorLayout.setVerticalGroup(
            unEditableColorLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 14, Short.MAX_VALUE)
        );

        editedColor.setBackground(AbstractTableCellRenderer.BG_UNSELECTED_EDITABLE_EDITED);
        editedColor.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));
        editedColor.setName("editedColor"); // NOI18N
        editedColor.setPreferredSize(new java.awt.Dimension(100, 16));

        javax.swing.GroupLayout editedColorLayout = new javax.swing.GroupLayout(editedColor);
        editedColor.setLayout(editedColorLayout);
        editedColorLayout.setHorizontalGroup(
            editedColorLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 69, Short.MAX_VALUE)
        );
        editedColorLayout.setVerticalGroup(
            editedColorLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 14, Short.MAX_VALUE)
        );

        inheritedColor.setBackground(AbstractTableCellRenderer.BG_UNSELECTED_INHERITED);
        inheritedColor.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));
        inheritedColor.setName("inheritedColor"); // NOI18N
        inheritedColor.setPreferredSize(new java.awt.Dimension(100, 16));

        javax.swing.GroupLayout inheritedColorLayout = new javax.swing.GroupLayout(inheritedColor);
        inheritedColor.setLayout(inheritedColorLayout);
        inheritedColorLayout.setHorizontalGroup(
            inheritedColorLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 69, Short.MAX_VALUE)
        );
        inheritedColorLayout.setVerticalGroup(
            inheritedColorLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 14, Short.MAX_VALUE)
        );

        uneditableLabel.setLabelFor(unEditableColor);
        uneditableLabel.setText(resourceMap.getString("uneditableLabel.text")); // NOI18N
        uneditableLabel.setName("uneditableLabel"); // NOI18N

        editedLabel.setLabelFor(editedColor);
        editedLabel.setText(resourceMap.getString("editedLabel.text")); // NOI18N
        editedLabel.setName("editedLabel"); // NOI18N

        inheritedLabel.setLabelFor(inheritedColor);
        inheritedLabel.setText(resourceMap.getString("inheritedLabel.text")); // NOI18N
        inheritedLabel.setName("inheritedLabel"); // NOI18N

        legendTitle.setFont(resourceMap.getFont("legendTitle.font")); // NOI18N
        legendTitle.setLabelFor(legendPanel);
        legendTitle.setText(resourceMap.getString("legendTitle.text")); // NOI18N
        legendTitle.setName("legendTitle"); // NOI18N

        javax.swing.GroupLayout legendPanelLayout = new javax.swing.GroupLayout(legendPanel);
        legendPanel.setLayout(legendPanelLayout);
        legendPanelLayout.setHorizontalGroup(
            legendPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(legendPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(legendPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(legendPanelLayout.createSequentialGroup()
                        .addGroup(legendPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(inheritedColor, javax.swing.GroupLayout.PREFERRED_SIZE, 71, Short.MAX_VALUE)
                            .addComponent(editedColor, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 71, Short.MAX_VALUE)
                            .addComponent(unEditableColor, javax.swing.GroupLayout.PREFERRED_SIZE, 71, Short.MAX_VALUE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(legendPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, legendPanelLayout.createSequentialGroup()
                                .addGroup(legendPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(editedLabel)
                                    .addComponent(uneditableLabel))
                                .addGap(22, 22, 22))
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, legendPanelLayout.createSequentialGroup()
                                .addComponent(inheritedLabel)
                                .addContainerGap())))
                    .addGroup(legendPanelLayout.createSequentialGroup()
                        .addComponent(legendTitle)
                        .addContainerGap(200, Short.MAX_VALUE))))
        );
        legendPanelLayout.setVerticalGroup(
            legendPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, legendPanelLayout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(legendTitle)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(legendPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(unEditableColor, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(uneditableLabel))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(legendPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(editedLabel)
                    .addComponent(editedColor, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(legendPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(inheritedLabel)
                    .addComponent(inheritedColor, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap())
        );

        javax.swing.GroupLayout tablePaneLayout = new javax.swing.GroupLayout(tablePane);
        tablePane.setLayout(tablePaneLayout);
        tablePaneLayout.setHorizontalGroup(
            tablePaneLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(tablePaneLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(tablePaneLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(tableScrollPane, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 786, Short.MAX_VALUE)
                    .addComponent(tableTitle, javax.swing.GroupLayout.DEFAULT_SIZE, 786, Short.MAX_VALUE)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, tablePaneLayout.createSequentialGroup()
                        .addComponent(legendPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 374, Short.MAX_VALUE)
                        .addGroup(tablePaneLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(buttonUploadLocalChanges, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(buttonRemoveLocalChanges, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
                .addContainerGap())
        );
        tablePaneLayout.setVerticalGroup(
            tablePaneLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, tablePaneLayout.createSequentialGroup()
                .addComponent(tableTitle, javax.swing.GroupLayout.DEFAULT_SIZE, 20, Short.MAX_VALUE)
                .addGap(18, 18, 18)
                .addComponent(tableScrollPane, javax.swing.GroupLayout.PREFERRED_SIZE, 605, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(tablePaneLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(tablePaneLayout.createSequentialGroup()
                        .addComponent(buttonUploadLocalChanges)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(buttonRemoveLocalChanges))
                    .addComponent(legendPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap())
        );

        dataSplitPane.setRightComponent(tablePane);

        statusPanel.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        statusPanel.setName("statusPanel"); // NOI18N

        statusLabel.setName("statusLabel"); // NOI18N

        connectionButton.setText(resourceMap.getString("connectionButton.text")); // NOI18N
        connectionButton.setActionCommand(resourceMap.getString("connectionButton.actionCommand")); // NOI18N
        connectionButton.setFocusable(false);
        connectionButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                connectionButtonActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout statusPanelLayout = new javax.swing.GroupLayout(statusPanel);
        statusPanel.setLayout(statusPanelLayout);
        statusPanelLayout.setHorizontalGroup(
            statusPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(statusPanelLayout.createSequentialGroup()
                .addComponent(connectionButton, javax.swing.GroupLayout.PREFERRED_SIZE, 108, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(statusLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 550, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(211, Short.MAX_VALUE))
        );
        statusPanelLayout.setVerticalGroup(
            statusPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(statusPanelLayout.createSequentialGroup()
                .addGroup(statusPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(connectionButton, javax.swing.GroupLayout.PREFERRED_SIZE, 17, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(statusLabel, javax.swing.GroupLayout.DEFAULT_SIZE, 17, Short.MAX_VALUE))
                .addContainerGap())
        );

        javax.swing.GroupLayout mainPanelLayout = new javax.swing.GroupLayout(mainPanel);
        mainPanel.setLayout(mainPanelLayout);
        mainPanelLayout.setHorizontalGroup(
            mainPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(statusPanel, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(dataSplitPane, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 883, Short.MAX_VALUE)
        );
        mainPanelLayout.setVerticalGroup(
            mainPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, mainPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(dataSplitPane, javax.swing.GroupLayout.DEFAULT_SIZE, 779, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(statusPanel, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        setComponent(mainPanel);
    }// </editor-fold>//GEN-END:initComponents

    private void buttonRemoveLocalChangesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_buttonRemoveLocalChangesActionPerformed
        if (showDangerousConfirmDialog("Are you sure you want to cancel all your "
                + "local changes? \nIf you choose yes, all of your work since "
                + "your last upload will be cancelled!", "DELETE ALL CHANGES?")) {
            try {
                DataManagement.purgeChangesTables();
            } catch (Exception ex) {
                reportLocalDatabaseErrorAndExit();
            }
        }
    }//GEN-LAST:event_buttonRemoveLocalChangesActionPerformed

    private void buttonUploadLocalChangesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_buttonUploadLocalChangesActionPerformed
        if (showConfirmDialog("Do you want to send your changes to the central "
                + "server? \nIf you choose yes, all changes, including possible "
                + "mistakes, will be shared with other users.", "Upload all changes?")) {
            DataManagement.uploadChangesTables();
        }
    }//GEN-LAST:event_buttonUploadLocalChangesActionPerformed

    private void connectionButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_connectionButtonActionPerformed
        connectionButton.setSelected(false);
        if (connType.equals(connType.CONNECTION_OFFLINE)) {
            downloadDatabase();
        }
    }//GEN-LAST:event_connectionButtonActionPerformed
;

    public ConnectionType getConnType() {
        return connType;
    }

    public void setConnType(final ConnectionType connType) {
        this.connType = connType;
        switch (connType) {
            case CONNECTION_OFFLINE:
                connectionButton.setText(CONN_OFFLINE_STRING);
                connectionButton.setFont(connectionButton.getFont()
                        .deriveFont(Font.BOLD));
                connectionButton.setForeground(CONN_OFFLINE_FOREGROUND_COLOR);
                connectionButton.setBackground(CONN_OFFLINE_BACKGROUND_COLOR);
                connectionButton.setSelected(false);
                break;
            case CONNECTION_ONLINE:
                connectionButton.setText(CONN_ONLINE_STRING);
                connectionButton.setFont(connectionButton.getFont()
                        .deriveFont(Font.BOLD));
                connectionButton.setForeground(CONN_ONLINE_FOREGROUND_COLOR);
                connectionButton.setBackground(CONN_ONLINE_BACKGROUND_COLOR);
                connectionButton.setSelected(false);
                break;
            case CONNECTION_CONNECTING:
                connectionButton.setText(CONN_CONNECTING_STRING);
                connectionButton.setFont(connectionButton.getFont()
                        .deriveFont(Font.BOLD));
                connectionButton.setForeground(CONN_CONNECTING_FOREGROUND_COLOR);
                connectionButton.setBackground(CONN_CONNECTING_BACKGROUND_COLOR);
                connectionButton.setSelected(false);
                break;
        }
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton buttonRemoveLocalChanges;
    private javax.swing.JButton buttonUploadLocalChanges;
    private javax.swing.JToggleButton connectionButton;
    private javax.swing.JSplitPane dataSplitPane;
    private javax.swing.JTable dataTable;
    private javax.swing.JTree dataTree;
    private javax.swing.JPanel editedColor;
    private javax.swing.JLabel editedLabel;
    private javax.swing.JPanel inheritedColor;
    private javax.swing.JLabel inheritedLabel;
    private javax.swing.JPanel legendPanel;
    private javax.swing.JLabel legendTitle;
    private javax.swing.JPanel mainPanel;
    private javax.swing.JLabel statusLabel;
    private javax.swing.JPanel statusPanel;
    private javax.swing.JPanel tablePane;
    private javax.swing.JScrollPane tableScrollPane;
    private javax.swing.JLabel tableTitle;
    private javax.swing.JScrollPane treeScrollPane;
    private javax.swing.JPanel unEditableColor;
    private javax.swing.JLabel uneditableLabel;
    // End of variables declaration//GEN-END:variables

}
