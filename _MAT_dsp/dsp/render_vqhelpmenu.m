function [hhelpmenu, hhelpmenuitems] = render_vqhelpmenu(hfig, position)
%RENDER_VQHELPMENU Render a VQ DESIGN TOOL specific "Help" menu.
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
        xlate('VQ Design Block Help'),...
        xlate('VQ Encoder Block Help'),...
        xlate('VQ Decoder Block Help'),...
        getString(message('dsp:demo:DSPSystemToolboxExamples')),...
        xlate('&About DSP System Toolbox')};

tags = {'help',...
        'vqdblockhelp',...
        'vqencblockhelp',...
        'vqdecblockhelp',...
        'demos',...
        'about'};

% Separators
sep = {'Off','Off','Off','Off','On','On'};

% CallBacks
cbs = {'',...
        @vqdblockhelp_cb,...
        @vqencblockhelp_cb,...
        @vqdecblockhelp_cb,...
        @demos_cb,...
        @about_cb};

% Render the Help menu 
hhelpmenus     = addmenu(hfig,position,strs,cbs,tags,sep);
hhelpmenu      = hhelpmenus(1);
hhelpmenuitems = hhelpmenus(2:end);

% --------------------------------------------------------------
function vqdblockhelp_cb(hco,eventStruct)

helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'dspvectorquantizerdesign');

% --------------------------------------------------------------
function vqencblockhelp_cb(hco,eventStruct)

helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'dspvectorquantizerencoder');

% --------------------------------------------------------------
function vqdecblockhelp_cb(hco,eventStruct)

helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'dspvectorquantizerdecoder');

% --------------------------------------------------------------
function demos_cb(hco,eventStruct)

demo toolbox 'dsp'

%--------------------------------------------------------------
function about_cb(hco,eventStruct)

aboutdspsystbx

% [EOF]
