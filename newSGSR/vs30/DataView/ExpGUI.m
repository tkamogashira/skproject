function y = ExpGUI(Flag, varargin)
% ExpGUI - databrowse GUI using the JAVA Swing package
%   ExpGUI(Flag, varargin)

% Adapted from code by B. Van de Sande 25-09-2003

persistent Clist

if nargin < 1, Flag = 'init'; end
Flag = lower(Flag);

switch Flag %switchyard ...
case 'getobj', % return java objects in struct
   y = Clist;
case 'init',
   Clist = localInitGUI(varargin{:});
case 'filltable',
   Clist = localFillTable(Clist, varargin{1});
otherwise, error(sprintf('%s is an unknown flag.', Flag)); 
end   

%===========LOCALS=======================================
function Clist = localFillTable(Clist, ExpDataList);
% fill or refill Jtable with experiment list
if nargin<2, 
   ExpDataList = repmat({'1N/A', '2N/A', '3N/A', '4N/A', '5N/A', '6N/A' }, 60, 1);
end
TableHeader = {'iSeq', 'SeqStr', 'IndepName', 'IndepRange', 'BurstDur', 'StimDur' };
TableObj  = javaObject('javax.swing.JTable', ExpDataList, TableHeader);
HeaderObj = TableObj.getTableHeader; set(HeaderObj, 'ReorderingAllowed', 'off');
TableObj.setCellEditor([]);
TableObj.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
TableObj.setShowHorizontalLines(0);
TableObj.setAutoResizeMode(javax.swing.JTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
set(TableObj, 'Editing', 'off');
% if scroll panel is already there, remove it
if isfield(Clist, 'SPaneObj'),
   Clist.FakePanel.remove(Clist.SPaneObj);
end
Clist.TableObj = TableObj;
% put table in scroll pane
Clist.SPaneObj = javax.swing.JScrollPane(TableObj);
% fake panel must exist - empty it and refill it
Clist.FakePanel.add(Clist.SPaneObj);
if isfield(Clist, 'Frame'), % make it visible
   Clist.Frame.show;
end

function Clist = localInitGUI(varargin);
% initializes a new databrowse GUI
import javax.swing.*
Clist = []; % initialize list of all components to be added
%---------------------MENUBAR------------------------------------------------
MenuBarObj = javax.swing.JMenuBar;
% MenuBarObj = java.awt.MenuBar;
% set(MenuBarObj, 'MouseClickedCallBack', 'jget(gcbo)'); % ---TEST-----
% ---File menu-------------
Clist = AddJmenu(MenuBarObj, '&File', 'File', '', Clist);
ItemLabels = { ...
      'Browse in current datadir', ...
      'Choose folder for browsing data', ...
      '-Export current list to textfile'};
ItemTags = {'DataDirBrowse', 'ChooseFolder', 'ExportDataList'};
Clist = AddJmenu(Clist.FileMenu, ItemLabels, ItemTags, 'jget(gcbo)', Clist);
% ---Exp menu-------------
Clist = AddJmenu(MenuBarObj, '&Experiment', 'ExpSelect', '', Clist);
ItemLabels = {'Exp1', 'Exp2', 'Exp3'};
ItemTags = {'Exp1', 'Exp2', 'Exp3'};
Clist = AddJmenu(Clist.ExpSelectMenu, ItemLabels, ItemTags, 'jget(gcbo)', Clist);
%---------------EXPERIMENT-COMBOBOX AND VIEW-BUTTONS---------------------
% main panels: ExperimentPanel (top) and ViewPanel (bottom)
ExperimentPanel = javaObject('javax.swing.JPanel');
PanelTxts = {'Synchronize', 'Views'};
ExperimentPanel.setBorder(...
   BorderFactory.createTitledBorder(BorderFactory.createLineBorder(java.awt.Color.black), ...
   PanelTxts{1}, ...
   border.TitledBorder.CENTER, ...
   border.TitledBorder.TOP));
ViewPanel = javaObject('javax.swing.JPanel');
ViewPanel.setBorder(...
   BorderFactory.createTitledBorder(BorderFactory.createLineBorder(java.awt.Color.black), ...
   PanelTxts{2}, ...
   border.TitledBorder.CENTER, ...
   border.TitledBorder.TOP));
%%% ComboBox for selecting the experiment
%%ComboList = {'Exp1', 'Exp2', 'Exp3'};
%%Clist = AddJcombobox(ExperimentPanel, ComboList ,'ExpSelect', 'jget(gcbo)', Clist);
% Update Button to synchronize with ongoing data collection
Clist = addJbutton(ExperimentPanel, 'Update', 'Update', 'jget(gcbo)', Clist);
ExperimentPanel.setLayout(javaObject('java.awt.GridLayout', 2, 0));
% View buttons  
ButtonTxts = {'Raster', 'PST', 'LAT', 'ISI', 'CYC', 'Rate', 'VS/PH', 'Params'};
ButtonTags = {'Raster', 'PST', 'LAT', 'ISI', 'CYC', 'Rate', 'Vphase', 'Params'};
NButtons = length(ButtonTxts);
Clist = addJbutton(ViewPanel, ButtonTxts, ButtonTags, 'jget(gcbo)', Clist);
ViewPanel.setLayout(javaObject('java.awt.GridLayout', NButtons, 0)); % vertical ordering

FrameTitle   = 'DataBrowse';
FrameHorLoc  = 0.125; %in procent ...
FrameVerLoc  = 0.125; %in procent ...
FrameHorSize = 0.75; %in procent ...
FrameVerSize = 0.75; %in procent ...

FrameObj = javaObject('javax.swing.JFrame', FrameTitle);
% FrameObj = javaObject('com.mathworks.mwt.MWFrame', FrameTitle);
% Fobj.addWindowListener(com.mathworks.mwt.window.MWWindowActivater(Fobj));
ScrSz    = FrameObj.getToolkit.getScreenSize;
FrameObj.setJMenuBar(MenuBarObj);
% FrameObj.setMenuBar(MenuBarObj);
Clist.FakePanel = javaObject('javax.swing.JPanel');
Clist.FakePanel.setBackground(java.awt.Color(0.7, 0.7, 0.7));
Clist.FakePanel.setLayout(java.awt.GridLayout(1,1));

Pane = FrameObj.getContentPane;
% Pane = FrameObj.add(javax.swing.JPanel); % MWT hack
GridBagObj = javaObject('java.awt.GridBagLayout');
Pane.setLayout(GridBagObj);
GridConstraintsObj = javaObject('java.awt.GridBagConstraints');

GridConstraintsObj.fill = java.awt.GridBagConstraints.BOTH;
GridConstraintsObj.anchor = java.awt.GridBagConstraints.NORTHWEST;

GridConstraintsObj.weightx = 1;
GridConstraintsObj.weighty = 1;
GridConstraintsObj.gridwidth = 1;
GridConstraintsObj.gridheight = 1;
GridConstraintsObj.gridx = 1;
GridConstraintsObj.gridy = 0;
GridBagObj.setConstraints(ExperimentPanel, GridConstraintsObj);
Pane.add(ExperimentPanel); 

GridConstraintsObj.weightx = 1;
GridConstraintsObj.weighty = 3;
GridConstraintsObj.gridheight = 1;
GridConstraintsObj.gridx = 1;
GridConstraintsObj.gridy = 1;
GridBagObj.setConstraints(ViewPanel, GridConstraintsObj);
Pane.add(ViewPanel);

GridConstraintsObj.weightx = 20;
GridConstraintsObj.weighty = 1;
GridConstraintsObj.gridheight = 2;
GridConstraintsObj.gridx = 0;
GridConstraintsObj.gridy = 0;
GridBagObj.setConstraints(Clist.FakePanel, GridConstraintsObj);
Pane.add(Clist.FakePanel); 

FrameObj.addWindowListener(javaObject('com.mathworks.mwt.window.MWWindowActivater', FrameObj));
FrameObj.setLocation(ScrSz.width*FrameHorLoc, ScrSz.height*FrameVerLoc);
FrameObj.setSize(ScrSz.width*FrameHorSize, ScrSz.height*FrameVerSize);

%---------------------------------TABLE-------------------------------------------------
Clist = localFillTable(Clist, varargin{:});
%----------------------------------------------FRAME--------------------------------------------------

FrameObj.show;

Clist.Pane = Pane;
Clist.Frame = FrameObj;



