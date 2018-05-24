function [hhelpmenu, hhelpmenuitems] = render_sqhelpmenu(hfig, position)
%RENDER_SQHELPMENU Render a SQ DESIGN TOOL specific "Help" menu.
% 
%   Inputs:
%     hfig     - Handle to the figure
%     position - Position of new menu.
%
%   Output:
%     hhelpmenu      - Handle to the "Help" menu on the menubar. 
%     hhelpmenuitems - Vector containing handles to all the help menu items.

%    Copyright 1988-2012 The MathWorks, Inc.

% List menu item strings
strs = {xlate('&Help'),...
        xlate('SQ Design Block Help'),...
        xlate('SQ Encoder Block Help'),...
        xlate('SQ Decoder Block Help'),...
        getString(message('dsp:demo:DSPSystemToolboxExamples')),...
        xlate('&About DSP System Toolbox')};

tags = {'help',...
        'sqdblockhelp',...
        'sqencblockhelp',...
        'sqdecblockhelp',...
        'demos',...
        'about'};

% Separators
sep = {'Off','Off','Off','Off','On','On'};

% CallBacks
cbs = {'',...
        @sqdblockhelp_cb,...
        @sqencblockhelp_cb,...
        @sqdecblockhelp_cb,...
        @demos_cb,...
        @about_cb};

% Render the Help menu 
hhelpmenus     = addmenu(hfig,position,strs,cbs,tags,sep);
hhelpmenu      = hhelpmenus(1);
hhelpmenuitems = hhelpmenus(2:end);

% --------------------------------------------------------------
function sqdblockhelp_cb(hco,eventStruct)

helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'dspscalarquantizerdesign');

% --------------------------------------------------------------
function sqencblockhelp_cb(hco,eventStruct)

helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'dspscalarquantizerencoder');

% --------------------------------------------------------------
function sqdecblockhelp_cb(hco,eventStruct)

helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'dspscalarquantizerdecoder');

% --------------------------------------------------------------
function demos_cb(hco,eventStruct)

demo toolbox 'dsp'
%--------------------------------------------------------------
function about_cb(hco,eventStruct)

aboutdspsystbx

% [EOF]
