function SwingDataBrowse(Flag)
%SWINGDATABROWSE databrowse GUI using the JAVA Swing package
%   SWINGDATABROWSE(Flag)

%B. Van de Sande 25-09-2003

persistent MenuBarObj MenuObjs MenuItemObjs 
persistent ComboBoxObj UpdateButtonObj ButtonObjs
persistent TableObj

if nargin < 1, Flag = 'INIT'; 
elseif nargin > 1, error('Wrong number of input arguments.'); end
 
switch Flag %switchyard ...
case 'INIT'
    %--------------------------------------------MENUBAR------------------------------------------------
    MenuBarObj = javaObject('javax.swing.JMenuBar');
    
    MenuTxts = {'File'};
    NMenus   = length(MenuTxts);
    MenuObjs = javaArray('javax.swing.JMenu', NMenus);
    
    MenuObjs(1) = javaObject('javax.swing.JMenu', MenuTxts{1});
    MenuItemTxts          = {'Browse in current datadir', 'Choose folder for browsing data ...', '', 'Export current list to textfile ...'};
    MenuItemCallBackFlags = {'M_BROWSE', 'M_CHFOLDER', '', 'M_EXPORT' };
    NMenuItems = length(MenuItemTxts);
    MenuItemObjs = javaArray('javax.swing.JComponent', NMenuItems);
    for n = 1:NMenuItems,
        if isempty(MenuItemTxts{n}),
            MenuItemObjs(n) = javaObject('javax.swing.JSeparator');
        else,
            MenuItemObjs(n) = javaObject('javax.swing.JMenuItem', MenuItemTxts{n});
            set(MenuItemObjs(n), 'ActionPerformedCallBack', sprintf('SwingDataBrowse(''%s'');', MenuItemCallBackFlags{n}));
        end    
        MenuObjs(1).add(MenuItemObjs(n));
    end    
    MenuBarObj.add(MenuObjs(1));
    
    %-------------------------------EXPERIMENT-COMBOBOX AND VIEW-BUTTONS---------------------------------
    PanelObj  = javaArray('javax.swing.JPanel', 2);
    PanelTxts = {'Experiment', 'Views'};
    
    ComboList = {'Exp1', 'Exp2', 'Exp3'};
    ComboBoxObj = javaObject('javax.swing.JComboBox', ComboList);
    ComboBoxObj.setSelectedIndex(1);
    set(ComboBoxObj, 'ActionPerformedCallBack', 'SwingDataBrowse(''CB_SELECT'');');
    
    UpdateButtonObj = javaObject('javax.swing.JButton', 'Update');
    set(UpdateButtonObj, 'MouseClickedCallBack', 'SwingDataBrowse(''B_UPDATE'');');
    
    PanelObj(1) = javaObject('javax.swing.JPanel');
    PanelObj(1).add(ComboBoxObj); PanelObj(1).add(UpdateButtonObj);
    PanelObj(1).setBorder(javax.swing.BorderFactory.createTitledBorder(javax.swing.BorderFactory.createLineBorder(java.awt.Color.black), PanelTxts{1}, javax.swing.border.TitledBorder.CENTER, javax.swing.border.TitledBorder.TOP));
    PanelObj(1).setLayout(javaObject('java.awt.GridLayout', 2, 0));
    PanelObj(1).setVisible(1);
    
    ButtonTxts          = {'Raster', 'PST', 'LAT', 'ISI', 'CYC', 'Rate', 'VS/PH', 'Params'};
    ButtonCallBackFlags = {'B_RASTER', 'B_PST', 'B_LAT', 'B_ISI', 'B_CYC', 'B_RATE', 'B_VS_PH', 'B_PARAM' };
    NButtons            = length(ButtonTxts);
    ButtonObjs          = javaArray('javax.swing.JButton', NButtons);
    
    PanelObj(2) = javaObject('javax.swing.JPanel');
    for n = 1:NButtons, 
        ButtonObjs(n) = javaObject('javax.swing.JButton', ButtonTxts{n});
        set(ButtonObjs(n), 'MouseClickedCallBack', sprintf('SwingDataBrowse(''%s'');', ButtonCallBackFlags{n}));
        PanelObj(2).add(ButtonObjs(n));
    end
    PanelObj(2).setBorder(javax.swing.BorderFactory.createTitledBorder(javax.swing.BorderFactory.createLineBorder(java.awt.Color.black), PanelTxts{2}, javax.swing.border.TitledBorder.CENTER, javax.swing.border.TitledBorder.TOP));
    PanelObj(2).setLayout(javaObject('java.awt.GridLayout', NButtons, 0));
    PanelObj(2).setVisible(1);
    
    %----------------------------------------------TABLE-------------------------------------------------
    TableHeader = {'iSeq', 'SeqStr', 'IndepName', 'IndepRange', 'BurstDur', 'StimDur' };
    TableData   = repmat({'N/A',  'N/A',    'N/A',       'N/A',        'N/A',      'N/A' }, 60, 1);
    
    TableObj  = javaObject('javax.swing.JTable', TableData, TableHeader);
    HeaderObj = TableObj.getTableHeader; set(HeaderObj, 'ReorderingAllowed', 'off');
    TableObj.setCellEditor([]);
    TableObj.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
    TableObj.setShowHorizontalLines(0);
    TableObj.setAutoResizeMode(javax.swing.JTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
    
    SPaneObj = javaObject('javax.swing.JScrollPane', TableObj);
    SPaneObj.setVisible(1);
    
    %----------------------------------------------FRAME--------------------------------------------------
    FrameTitle   = 'DataBrowse';
    FrameHorLoc  = 0.125; %in procent ...
    FrameVerLoc  = 0.125; %in procent ...
    FrameHorSize = 0.75; %in procent ...
    FrameVerSize = 0.75; %in procent ...
    
    FrameObj = javaObject('javax.swing.JFrame', FrameTitle);
    ScrSz    = FrameObj.getToolkit.getScreenSize;

    FrameObj.setJMenuBar(MenuBarObj);
    
    Pane = FrameObj.getContentPane;
    GridBagObj = javaObject('java.awt.GridBagLayout');
    GridConstraintsObj = javaObject('java.awt.GridBagConstraints');
    Pane.setLayout(GridBagObj);
    
    GridConstraintsObj.fill = java.awt.GridBagConstraints.BOTH;
    GridConstraintsObj.anchor = java.awt.GridBagConstraints.NORTHWEST;
   
    GridConstraintsObj.weightx = 3;
    GridConstraintsObj.weighty = 1;
    GridConstraintsObj.gridheight = 2;
    GridConstraintsObj.gridx = 0;
    GridConstraintsObj.gridy = 0;
    GridBagObj.setConstraints(SPaneObj, GridConstraintsObj);
    Pane.add(SPaneObj); 
    
    GridConstraintsObj.weightx = 1;
    GridConstraintsObj.weighty = 1;
    GridConstraintsObj.gridheight = 1;
    GridConstraintsObj.gridx = 1;
    GridConstraintsObj.gridy = 0;
    GridBagObj.setConstraints(PanelObj(1), GridConstraintsObj);
    Pane.add(PanelObj(1)); 

    GridConstraintsObj.weightx = 1;
    GridConstraintsObj.weighty = 3;
    GridConstraintsObj.gridheight = 1;
    GridConstraintsObj.gridx = 1;
    GridConstraintsObj.gridy = 1;
    GridBagObj.setConstraints(PanelObj(2), GridConstraintsObj);
    Pane.add(PanelObj(2));
    
    FrameObj.addWindowListener(javaObject('com.mathworks.mwt.window.MWWindowActivater', FrameObj));
    FrameObj.setLocation(ScrSz.width*FrameHorLoc, ScrSz.height*FrameVerLoc);
    FrameObj.setSize(ScrSz.width*FrameHorSize, ScrSz.height*FrameVerSize);
    FrameObj.show;
otherwise, error(sprintf('%s is an unknown flag.', Flag)); end   