function sdspwwvdisp(block)
%SDSPWWVDISP Time display GUI for Simulink demo "dspwwv".
%   This file implements a Level-2 MATLAB file S-function.

% Copyright 1995-2010 The MathWorks, Inc.

% Block parameters
%  1) FigPos
%      4-element vector of doubles indicating position of GUI
%
% Inputs to block
%
%  Input 1: 7x1 vector of doubles representing time code,
% [ UTC ;
%   UT1 ;
%   Year ;
%   DayOfYear ;
%   DaylightSavings1 ;
%   DaylightSavings2 ;
%   LeapSeconds ]
%
%  Input 2: boolean Detect signal
%  Input 3: boolean Lock signal
%
% Stored in Figure window userdata:
%   struct with the fields:
%       .gui: struct with handles to GUI elements
%       .block: copy of block name
%       .hfig: handle to figure
%
% Stored in block userdata:
%    struct with the fields
%    .hfig: handle to figure
%
% The S-function block has callbacks set for DeleteFcn and NameChangeFcn

if ischar(block)
    switch block
        case 'BlockDelete'
            BlockDelete;
        case 'NameChange'
            NameChange;
    end
else
    setup(block);
end


%%
function setup(block)

% Register number of ports
block.NumInputPorts  = 3;
block.NumOutputPorts = 0;

% Setup functional port properties
block.SetPreCompInpPortInfoToDynamic;

% UTC
block.InputPort(1).DatatypeID   = 1; %doubles 3=uint8
block.InputPort(1).Complexity   = 'Real';
block.InputPort(1).SamplingMode = 'Sample';
block.InputPort(1).Dimensions   = [7 1];

% Detect
block.InputPort(2).DatatypeID   = 8; %boolean
block.InputPort(2).Complexity   = 'Real';
block.InputPort(2).SamplingMode = 'Inherited';
block.InputPort(2).Dimensions   = [1 1];

% Lock
block.InputPort(3).DatatypeID   = 8; %boolean
block.InputPort(3).Complexity   = 'Real';
block.InputPort(3).SamplingMode = 'Inherited';
block.InputPort(3).Dimensions   = [1 1];

% Register dialog parameters
block.NumDialogPrms = 1;
block.DialogPrmsTunable = {'Tunable'};

% This is a scope
SetSimViewingDevice(block,true);

% Register block methods
block.RegBlockMethod('SetInputPortDimensions',  @SetInpPortDims);
block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
block.RegBlockMethod('Start',                   @Start);
block.RegBlockMethod('Outputs',                 @Output);


%%
function DoPostPropSetup(block)

block.NumDworks = 3;

% Dwork1: last data input (inport 1)
block.Dwork(1).Name         = 'inport1';
block.Dwork(1).Dimensions   = 7;
block.Dwork(1).DatatypeID   = 1; % double
block.Dwork(1).Complexity   = 'Real';

% Dwork2: last data input (inport 2)
block.Dwork(2).Name         = 'inport2';
block.Dwork(2).Dimensions   = 1;
block.Dwork(2).DatatypeID   = 8; % boolean
block.Dwork(2).Complexity   = 'Real';

% Dwork3: last data input (inport 3)
block.Dwork(3).Name         = 'inport3';
block.Dwork(3).Dimensions   = 1;
block.Dwork(3).DatatypeID   = 8; % boolean
block.Dwork(3).Complexity   = 'Real';

%%
function Start(block)

% See if we can find the figure
% If it exists, use it
% Otherwise, create a new one

blk = getfullname(block.BlockHandle);
h = findobj('type','figure','name',blk);
if isempty(h)
    % Create new figure
    h = create_display(block);
else
    % Re-use existing figure
    reset_display(h);
    figure(h); % bring window forward
end

% Record handle in block data, so it can be accessed
% when, say, the block is being deleted
block_data.hfig = h;
set_param(blk,'UserData',block_data);


%%
function Output(block)
% Update the WWV display

% Get figure handle - could have closed without us knowing
block_data = get_param(block.BlockHandle, 'UserData');
h = block_data.hfig;
if isempty(h) || ~ishandle(h)
    return
end

%  Input 1: 7x1 vector of doubles representing time code,
% [ UTC ;
%   UT1 ;
%   Year ;
%   DayOfYear ;
%   DaylightSavings1 ;
%   DaylightSavings2 ;
%   LeapSeconds ]
%
%  Input 2: boolean Detect signal
%  Input 3: boolean Lock signal

% Get last input1 data from dwork
% This is the basic UTC time code data
%
last_u = block.Dwork(1).Data;
this_u = block.InputPort(1).Data;

if ~isequal(last_u,this_u)
    % Something changed
    if any( last_u(1) ~= this_u(1) )
        wwvgui_utc(h, this_u(1));
    end
    if any( last_u(3:4) ~= this_u(3:4) )
        wwvgui_date(h, this_u(3:4));
    end
    if last_u(2) ~= this_u(2)
        wwvgui_ut1(h, this_u(2));
    end
    if any( last_u(5:6) ~= this_u(5:6) )
        wwvgui_ds(h, this_u(5:6));
    end
    if last_u(7) ~= this_u(7)
        wwvgui_leap(h, this_u(7));
    end

    % Update cache
    block.Dwork(1).Data = this_u;
end

% Get last input2 data from dwork
%
last_u = block.Dwork(2).Data;
this_u = block.InputPort(2).Data;
if last_u ~= this_u
   wwvgui_detect(h, this_u);
   
    % Update cache
    block.Dwork(2).Data = this_u;
end

% Get last input3 data from dwork
%
last_u = block.Dwork(3).Data;
this_u = block.InputPort(3).Data;
if last_u ~= this_u
   wwvgui_lock(h, this_u);
end


%%
function wwvgui_date(h, u)
% Update date info
%     u: [yy doy]
%    yy: year
%   doy: day of year

if any(u==0)
    return
end
yy = u(1);
doy = u(2);

if yy<2000,
    yy=yy+100;
end
sjan1 = datenum(double(yy),01,01);  % Serial date for Jan 1 of this year
s = sjan1 + doy-1;          % Serial date for today
dow = datestr(double(s), 8);        % Day of week, ex: 'Wed'
[yyyy mm dom] = datevec(double(s)); % year, month, day of month
months={'Jan','Feb','Mar','Apr','May','Jun', ...
      'Jul','Aug','Sep','Oct','Nov','Dec'};
q = [dow '., ' months{mm} '. ' num2str(dom) ', ' num2str(yyyy) ];

% new tooltip string:
t = sprintf('Day %d of %d',doy,yyyy);

fig_data = get(h,'userdata');
set(fig_data.gui.date, 'string',q, 'tooltip',t);


%%
function wwvgui_utc(h,utc)
% Update UTC info
% utc=hh.mm

hh=floor(utc/100);
mm=utc-hh*100;
hms=sprintf('%02d:%02d UTC',hh,mm);

fig_data = get(h,'userdata');
set(fig_data.gui.utc,'string',hms);


%%
function wwvgui_ut1(h,ut1)
% Update UT1 info
% ut1= +/- 0.7 secs

sut1=sprintf('%+01.1f sec UT1',ut1);

fig_data = get(h,'userdata');
set(fig_data.gui.ut1,'string',sut1);


%%
function wwvgui_ds(h, ds)
% Update daylight savings info
% ds=[ds1 ds1], each may be 0=no or 1=yes

clrs = {[0 .3 0], [0 1 0]};  % colors: {off, on}
fig_data = get(h,'userdata');
set(fig_data.gui.ds1,'backgr',clrs{ds(1)+1});
set(fig_data.gui.ds2,'backgr',clrs{ds(2)+1});


%%
function wwvgui_leap(h, leap)
% Update leap-second info
% leap: 0=no, 1=yes

clrs = {[0 .3 0], [0 1 0]};  % colors: {off, on}
fig_data = get(h,'userdata');
set(fig_data.gui.leap,'backgr',clrs{leap+1});


%%
function wwvgui_detect(h, detect)
% Update signal-detection info
% detect: 0=no, 1=yes

clrs = {[.4 0 0], [1 0 0]};  % colors: {off, on}
fig_data = get(h,'userdata');
set(fig_data.gui.detect,'backgr',clrs{detect+1});


%%
function wwvgui_lock(h, lock)
% Update receiver-lock info
% lock: 0=no, 1=yes

clrs = {[.4 0 0], [1 0 0]};  % colors: {off, on}
if lock,
   t = 'Synchronized to WWV broadcast';
else
   t = 'Cannot synchronize to WWV broadcast';
end
fig_data = get(h,'userdata');
set(fig_data.gui.lock(1),'backgr',clrs{lock+1});
set(fig_data.gui.lock, 'tooltip',t);


%%
function reset_display(h)

fig_data = get(h,'userdata');
gui = fig_data.gui;

set(gui.date, ...
   'tooltip','Day 1 of 1900', ...
   'string','Mon., Jan. 1, 1900');
set(gui.utc, ...
   'tooltip','Coordinated Universal Time', ...
   'string','00:00 UTC');
set(gui.ut1, ...
   'tooltip','Compensation for rotation of Earth', ...
   'string','+0.0 sec UT1');
set(gui.ds1, ...
   'backgr',[0 .5 0], ...
   'tooltip','Daylight savings indicator #1');
set(gui.ds2, ...
   'backgr',[0 .5 0], ...
   'tooltip','Daylight savings indicator #2');
set(gui.leap, ...
   'backgr',[0 .5 0], ...
   'tooltip','Compensation for rotation of Earth');
set(gui.detect, ...
   'backgr',[.5 0 0], ...
   'tooltip','Detecting 100 Hz data signal');
set(gui.lock(1), ...
   'backgr',[.5 0 0]);


%%
function h = wwvgui(hfig)
% Create WWV GUI

lg=18;
sm=10;  % size of font used for labels
bg=get(hfig,'color');
set(hfig,'units','points');
y=7.5;

% Day/Date:
h.date = uicontrol('parent',hfig, ...
   'backgroundcolor',bg, ...
   'style','text', ...
   'horiz','left', ...
   'units','points', ...
   'fontsize',lg, ...
   'pos',[0.4 y 10 1.5]*lg);

% UTC:
h.utc = uicontrol('parent',hfig, ...
   'backgroundcolor',bg, ...
   'style','text', ...
   'horiz','left', ...
   'units','points', ...
   'fontsize',lg, ...
   'pos',[0.4 y-1.5 10 1.5]*lg);

% UT1:
h.ut1 = uicontrol('parent',hfig, ...
   'backgroundcolor',bg, ...
   'style','text', ...
   'horiz','left', ...
   'units','points', ...
   'fontsize',lg, ...
   'pos',[0.4 y-3 10 1.5]*lg);

% Daylight savings indicators
h.ds1=uicontrol('parent',hfig, ...
   'style','frame', ...
   'backgr',[0 .5 0], ...
   'foregr','k', ...
   'units','points', ...
   'pos',[1.1 y-4 1.1/2 .5]*lg);
h.ds2=uicontrol('parent',hfig, ...
   'style','frame', ...
   'backgr',[0 .5 0], ...
   'foregr','k', ...
   'units','points', ...
   'pos',[1.6 y-4 1.1/2 .5]*lg);
uicontrol('parent',hfig, ...
   'backgroundcolor',bg, ...
   'style','text', ...
   'units','points', ...
   'fontsize', sm, ...
   'horiz','left', ...
   'pos',[2.4*lg (y-4.1)*lg 10*sm sm+2], ...  % y-4.1
   'string','Daylight savings', ...
   'tooltip', 'Daylight savings is in effect');

% Leap second:
s = 'Compensation for rotation of Earth';
h.leap=uicontrol('parent',hfig, ...
   'style','frame', ...
   'backgr',[0 .5 0], ...
   'foregr','k', ...
   'units','points', ...
   'pos',[1.1 y-4.75 1.1 .5]*lg, ...
   'tooltip',s);
uicontrol('parent',hfig, ...
   'backgroundcolor',bg, ...
   'style','text', ...
   'units','points', ...
   'fontsize', sm, ...
   'horiz','left', ...
   'pos',[2.4*lg (y-4.85)*lg 10*sm sm+2], ...
   'string','Leap second', ...
   'tooltip',s);

% Signal detection:
s = 'Detecting 100 Hz data signal';
h.detect=uicontrol('parent',hfig, ...
   'style','frame', ...
   'backgr',[1 0 0], ...
   'foregr','k', ...
   'units','points', ...
   'pos',[1.1 y-6 1.1 .5]*lg, ...
   'tooltip',s);
uicontrol('parent',hfig, ...
   'backgroundcolor',bg, ...
   'style','text', ...
   'units','points', ...
   'fontsize', sm, ...
   'horiz','left', ...
   'pos',[2.4*lg (y-6.1)*lg 10*sm sm+2], ...
   'string','Receiving WWV', ...
   'tooltip',s);

% Receiver lock:
s = 'Currently decoding WWV broadcast';
h.lock=uicontrol('parent',hfig, ...
   'style','frame', ...
   'backgr',[1 0 0], ...
   'foregr','k', ...
   'units','points', ...
   'pos',[1.1 y-6.7 1.1 .5]*lg, ...
   'tooltip',s);
h.lock(2) = uicontrol('parent',hfig, ...
   'backgroundcolor',bg, ...
   'style','text', ...
   'units','points', ...
   'fontsize', sm, ...
   'horiz','left', ...
   'pos',[2.4*lg (y-6.8)*lg 10*sm sm+2], ...
   'string','Locked-in', ...
   'tooltip',s);


%%
function hfig = create_display(block)
% CREATE_DISPLAY Create new scope GUI

% sz = block.InputPort(1).Dimensions;
% block.Dwork(1).Data = h;

block_name = getfullname(block.BlockHandle);
FigPos = block.DialogPrm(1).Data;

hfig = figure(...
   'numbertitle', 'off', ...
   'name',         block_name, ...
   'menubar',     'none', ...
   'position',     FigPos, ...
   'nextplot',     'add', ...
   'integerhandle','off');

% Don't change visibility, since we'll search for the open
% figure each time we restart the model
%   'HandleVisibility','callback'

% Create main display
fig_data.gui = wwvgui(hfig);

% Establish settings for all structure fields:
fig_data.block  = block_name;
fig_data.hfig   = hfig;

% Record figure data:
set(hfig, 'UserData',fig_data);

reset_display(hfig);


%%
function NameChange

% In response to the name change, we must do the following:
%
% (1) find the old figure window, only if the block had a GUI 
%     associated with it.
%     NOTE: Current block is parent of the S-function block
block_name = gcb;
block_data = get_param(block_name, 'UserData');

% System might never have been run since loading.
% Therefore, block_data might be empty
% Also, a figure may not currently be open, either
if ~isempty(block_data)
   hfig = block_data.hfig;
   if ~isempty(hfig) && ishandle(hfig)
       % change name of figure window (cosmetic)
       set(hfig,'name',block_name);

       % update figure's userdata so that the new blockname
       %     can be used if the figure gets deleted
       fig_data = get(hfig,'UserData');
       fig_data.block = block_name;
       set(hfig,'UserData',fig_data);
   end
end


%%
function BlockDelete
% Block is being deleted from the model

% clear out figure's close function
% delete figure manually
blk = gcbh;
block_data = get_param(blk,'UserData');
if isstruct(block_data) && ishandle(block_data.hfig)
    set(block_data.hfig, 'DeleteFcn','');
    delete(block_data.hfig);
    block_data.hfig = [];
    set_param(blk,'UserData',block_data);
end

% [EOF]

% LocalWords:  UTC userdata hfig DWork WWV yy doy utc hh ut ds backgr
% LocalWords:  backgroundcolor horiz fontsize foregr sz numbertitle nextplot
% LocalWords:  integerhandle blockname
