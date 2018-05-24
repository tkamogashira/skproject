function thisrender(this, varargin)
%   Copyright 1999-2010 The MathWorks, Inc.
% Renders a line of quantizer properties.


% Uicontrol sizes and spaces.
sz = gui_sizes(this);

% PARSERENDERINPUTS adds the FigureHandle, Handles fields, etc. to THIS. 
pos = parserenderinputs(this,varargin{:});
if isempty(pos)
  pos = [10 10 0 0]*sz.pixf;
end
pos(4) = sz.uh;
skip = sz.uuvs;

hFig = this.FigureHandle;

% Cache figure background color.
bgc = get(hFig,'Color');

x = pos(1);  % X-position of the last uicontrol rendered.
y = pos(2);  % Constant Y-position
w = 0;       % Width of the last uicontrol rendered.
h = pos(4);  % Constant height of the text.

hndls = this.Handles;
hndls.label = [];
hndls.quantizertool = [];
hndls.quantizerclass = [];
hndls.mode = [];
hndls.roundmode = [];
hndls.overflowmode = [];
hndls.format = [];

w = sz.popwTweak;
hndl = uicontrol(hFig, ...
                 'Style','checkbox', ...
                 'String','', ...
                 'Value', this.checkbox, ...
                 'Units', 'pixels', ...
                 'Position', [x y w h], ...
                 'Enable', 'off', ...
                 'Visible', 'off', ...
                 'Callback', {@setquantizercheckbox,this,'Set quantizer on/off.'});
hndls.quantizertool(end+1:end+length(hndl)) = hndl;
hndls.checkbox = hndl(1);
csmenu(hndl, 'quantizer_checkbox');

if isunix, w = w-sz.uuhs; end

if ~isempty(this.label)
  str = this.label;
  [hndl,x,w] = textlabel(this,str,x,y,w,h,skip,bgc,'right',this.LabelWidth);
  hndls.quantizertool(end+1:end+length(hndl)) = hndl;
  hndls.label = hndl(1);
end

if this.ShowQuantizerClass
  labels = {'quantizer','unitquantizer'};
  default = strmatch(this.quantizerclass,labels);
  heading = 'Quantizer type';
  [hndl,x,w] = popupmenu(this,labels,default,...
                         x,y,w,h,skip,bgc,...
                         {@setquantizerclass,this,'Set quantizer/unitquantizer',labels},...
                         heading,sz);
  hndls.quantizertool(end+1:end+length(hndl)) = hndl;
  hndls.quantizerclass = hndl(1);
  csmenu(hndl, 'quantype_popupmenus');
end

labels = {'fixed','ufixed','float','double','single'};
default = strmatch(this.mode, labels);
heading = 'Mode';
[hndl,x,w] = popupmenu(this,labels,default,...
                       x,y,w,h,skip,bgc,...
                       {@setquantizerproperty,this,labels,'mode'},...
                       heading,sz);
hndls.quantizertool(end+1:end+length(hndl)) = hndl;
hndls.mode = hndl(1);
csmenu(hndl, 'mode_popupmenus');

labels = {'ceil','convergent','fix','floor','round'};
default = strmatch(this.roundmode, labels);
heading = 'Round mode';
[hndl,x,w] = popupmenu(this,labels,default,...
                       x,y,w,h,skip,bgc,...
                       {@setquantizerproperty,this,labels,'roundmode'},...
                       heading,sz);
hndls.quantizertool(end+1:end+length(hndl)) = hndl;
hndls.roundmode = hndl(1);
csmenu(hndl, 'rmode_popupmenus');

labels = {'saturate','wrap'};
default = strmatch(this.overflowmode, labels);
heading = 'Overflow mode';
[hndl,x,w] = popupmenu(this,labels,default,...
                       x,y,w,h,skip,bgc,...
                       {@setquantizerproperty,this,labels,'overflowmode'},...
                       heading,sz);
hndls.quantizertool(end+1:end+length(hndl)) = hndl;
hndls.overflowmode = hndl(1);
csmenu(hndl, 'ofmode_popupmenus');

str = [ '[',num2str(getformat(this)),']' ];
heading = 'Format';
[hndl,x,w] = editbox(this,str,...
                       x,y,w,h,skip,bgc,...
                       {@setquantizerformat,this,'format'},...
                     heading);
hndls.quantizertool(end+1:end+length(hndl)) = hndl;
hndls.format = hndl(1);
csmenu(hndl, 'format_editboxes');

% Store the handles
this.Handles = hndls;

% Attach a listener to the mode and checkbox so that the displays of the other
% parameters can change when these change.

% Attach a listener to the all the properties.
modelistener = handle.listener(this, [this.findprop('quantizerclass'), ...
                    this.findprop('mode'), ...
                    this.findprop('checkbox'), ...
                    this.findprop('roundmode'), ...
                    this.findprop('overflowmode')], ...
                               'PropertyPostSet',@mode_listener);
% Set this object to be the input argument to this listener
modelistener.CallbackTarget = this;

% $$$ % Attach a listener to the checkbox.
% $$$ checkboxproperty = this.findprop('checkbox');
% $$$ % Create the listener
% $$$ checkboxlistener = handle.listener(this, checkboxproperty,'PropertyPostSet',@mode_listener);
% $$$ % Set this object to be the input argument to this listener
% $$$ checkboxlistener.CallbackTarget = this;


% Attach a listener to the format.
formatlistener = handle.listener(this, [this.findprop('fixedformat'), ...
                    this.findprop('floatformat')],...
                                 'PropertyPostSet',@format_listener);
formatlistener.CallbackTarget = this;

% Save the listeners
% $$$ this.WhenRenderedListeners = [modelistener, ...  
% $$$                     checkboxlistener, ...
% $$$                     formatlistener];
this.WhenRenderedListeners = [modelistener, ...  
                    formatlistener];

% Start disabled.
this.enable = 'off';

% -----------------------------------------------------------------------
function  [hndl,x,w] = textlabel(this,str,xold,y,wold,h,skip,bgc,horzal,labelwidth);

if nargin<10, labelwidth = []; end

x = xold + wold + skip;
if ~isempty(labelwidth)
  w = labelwidth;
else
  w = largestuiwidth({str},'text');
end

hndl = uicontrol(this.FigureHandle, ...
                 'Style', 'text', ...
                 'String', getTranslatedString('dsp:fdtbxgui:fdtbxgui',str), ...
                 'HorizontalAlignment', horzal, ...
                 'Enable', 'off', ...
                 'Visible', 'off', ...
                 'BackgroundColor', bgc, ...
                 'ForegroundColor', 'k', ...
                 'Position', [x, y, w h]);

% -----------------------------------------------------------------------
function [hndl,x,w] = popupmenu(this,labels,default,...
                                xold,y,wold,h,skip,bgc,fun,...
                                heading,sz)
x = xold + wold + skip;
w = max(largestuiwidth(labels,'popup'),largestuiwidth({heading},'text'));
w = w + 2*sz.lblTweak;

hndl = uicontrol(this.FigureHandle, ...
                 'Style','popupmenu', ...
                 'String',getTranslatedString('dsp:fdtbxgui:fdtbxgui',labels), ...
                 'Value',default, ...
                 'Units', 'pixels', ...
                 'Position', [x y w h], ...
                 'BackgroundColor', 'w', ...
                 'ForegroundColor', 'k', ...
                 'Enable', 'off', ...
                 'Visible', 'off', ...
                 'Callback', fun);

if this.ShowHeadings
    sz = gui_sizes(this);
  hndl(2) = showheading(this,heading,x,y,w,h,sz.uuvs,bgc);
end


% -----------------------------------------------------------------------
function [hndl,x,w] = editbox(this,str,...
                              xold,y,wold,h,skip,bgc,fun,...
                              heading)
x = xold + wold + skip;
w = max(largestuiwidth({str},'popup'),largestuiwidth({heading},'text'));

hndl = uicontrol(this.FigureHandle, ...
                 'Style','edit', ...
                 'String',str, ...
                 'Units', 'pixels', ...
                 'Position', [x y w h], ...
                 'BackgroundColor', 'w', ...
                 'ForegroundColor', 'k', ...
                 'Enable', 'off', ...
                 'Visible', 'off', ...
                 'Callback', fun);

if this.ShowHeadings
    sz = gui_sizes(this);
  hndl(2) = showheading(this,heading,x,y,w,h,sz.uuvs,bgc);
end

% -----------------------------------------------------------------------
function hndl = showheading(this,heading,x,y,w,h,skip,bgc);
hndl = uicontrol(this.FigureHandle, ...
                 'Style', 'text', ...
                 'String', getTranslatedString('dsp:fdtbxgui:fdtbxgui',heading), ...
                 'HorizontalAlignment', 'center', ...
                 'Enable', 'off', ...
                 'Visible', 'off', ...
                 'BackgroundColor', bgc, ...
                 'ForegroundColor', 'k', ...
                 'Position', [x, y+h+skip/2, w h]);

% -----------------------------------------------------------------------
function setquantizercheckbox(hcbo, eventstruct, this, str)
% This callback sets the Checkbox property of the object to true or false.
startrecording(this, str);
val = get(hcbo,'Value');
this.checkbox = val~=0;
stoprecording(this);

% -----------------------------------------------------------------------
function setquantizerclass(hcbo, eventstruct, this, str, labels)
% This callback sets the QuantizerClass property of the object to quantizer
% or unitquantizer.
startrecording(this, str);
val = get(hcbo,'Value');
% Replace the current quantizer class with a quantizer or unitquantizer.
this.quantizerclass = labels{val};
stoprecording(this);

% -----------------------------------------------------------------------
function setquantizerproperty(hcbo, eventstruct, this, labels, property)
% This callback sets an enumerated property.
str = ['Set quantizer ',property];
startrecording(this, str);
val = get(hcbo,'Value');
this.(property) = labels{val};
stoprecording(this);

% -----------------------------------------------------------------------
function setquantizerformat(hcbo, eventstruct, this, property)
% This callback sets the format of the quantizer.
str = ['Set quantizer ',property];
startrecording(this, str);
val = get(hcbo,'String');
try
  setformat(this,evaluatevars(val));
catch ME
  senderror(this, ME.identifier, ME.message);
end
stoprecording(this);

% -----------------------------------------------------------------------
function csmenu(h, tag)
hFig = get(h, 'Parent'); if iscell(hFig), hFig = hFig{1}; end
cshelpcontextmenu(hFig, h, ['fdatool_' tag filesep 'dsp'], 'fdatool');

