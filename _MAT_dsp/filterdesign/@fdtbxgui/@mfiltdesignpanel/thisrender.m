function thisrender(this, varargin)
%THISRENDER   Render the designer.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

pos  = parserenderinputs(this, varargin{:});
sz   = gui_sizes(this);
hFig = get(this, 'FigureHandle');

if isempty(pos),
    pos = [10 10 732 248]*sz.pixf;
end

totalw = 200*sz.pixf;

poppos = [pos(1) pos(2)+pos(4)-sz.uh-sz.vfus*3 totalw sz.uh];

rendercontrols(this, poppos, 'type');

h = get(this, 'Handles');

w = 116*sz.pixf; %largestuiwidth({'Interpolation Factor', 'Decimation Factor'});

lblpos = [poppos(1)+sz.hfus poppos(2)-sz.uh-sz.uuvs*2 w sz.uh];

x = lblpos(1)+lblpos(3)+sz.uuhs/2;

editpos = [x lblpos(2)+sz.lblTweak totalw-lblpos(3)-sz.hfus*2.5 sz.uh+4*sz.pixf];

h.interpolationfactor_lbl = uicontrol(hFig, ...
    'Position', lblpos, ...
    'HorizontalAlignment', 'Left', ...
    'Visible', 'Off', ...
    'Style', 'Text', ...
    'String', [getString(message('signal:sigtools:siggui:InterpolationFactor')) ':']);

cshelpcontextmenu(h.interpolationfactor_lbl, fullfile('fdatool_mfilt_interp', ...
    'dsp'), 'fdatool');

[temp h.java.controller.interpolation] = javacomponent(this.JavaHandles.interpolation, editpos, hFig);
set(h.java.controller.interpolation, 'Visible', 'Off');
set(temp, 'StateChangedCallback', @(hcbo, ev) interpStateChanged(this));

lblpos(2)  = lblpos(2)  - sz.uh-sz.uuvs-4*sz.pixf;
editpos(2) = editpos(2) - sz.uh-sz.uuvs-4*sz.pixf;

h.decimationfactor_lbl = uicontrol(hFig, ...
    'Position', lblpos, ...
    'HorizontalAlignment', 'Left', ...
    'Visible', 'Off', ...
    'Style', 'Text', ...
    'String', [getString(message('signal:sigtools:siggui:DecimationFactor')) ':']);

cshelpcontextmenu(h.decimationfactor_lbl, fullfile('fdatool_mfilt_decim', ...
    'dsp'), 'fdatool');

[temp h.java.controller.decimation] = javacomponent(this.JavaHandles.decimation, editpos, hFig);
set(h.java.controller.decimation, 'Visible', 'Off');
set(temp, 'StateChangedCallback', @(hcbo, ev) decimStateChanged(this));

divpos = [poppos(1)+poppos(3)+sz.hfus pos(2)+40*sz.pixf 1 pos(4)-50*sz.pixf];

h.divider = uicontrol(hFig, ...
    'Style', 'frame', ...
    'Visible', 'Off', ...
    'Position', divpos);

ht = sz.uh*5+sz.vfus*6;
imppos = [divpos(1)+sz.hfus pos(2)+pos(4)-ht-sz.vfus*2 220*sz.pixf ht];
hs = getcomponent(this, 'tag', 'implementation');
render(hs, hFig, [], imppos);

divpos(1) = imppos(1)+imppos(3)+sz.hfus;

h.divider(2) = uicontrol(hFig, ...
    'Style', 'frame', ...
    'Visible', 'Off', ...
    'Position', divpos);

set(this, 'Handles', h);

hfs = getcomponent(this, 'tag', 'fs');

fspos = [pos(1)+sz.hfus pos(2)+sz.bh+sz.uuvs totalw sz.uh*4+sz.vfus*4];
render(hfs, hFig, fspos);
h_hfs = get(hfs, 'Handles');
cshelpcontextmenu(h_hfs.fstitle, fullfile('fdatool_mfilt_fs', 'dsp'), 'fdatool');
cshelpcontextmenu([h_hfs.units h_hfs.units_lbl], fullfile('fdatool_mfilt_units', 'dsp'), 'fdatool');
cshelpcontextmenu([h_hfs.value h_hfs.value_lbl], fullfile('fdatool_mfilt_samplerate', 'dsp'), 'fdatool');

ht = sz.uh*2+sz.vfus*3;
x  = divpos(1)+divpos(3)+sz.hfus;
cicpos = [x pos(2)+pos(4)-ht-sz.vfus*2 pos(1)+pos(3)-x ht];
rendercontrols(this, cicpos, {'differentialdelay', 'numberofsections'});

pos(3) = pos(3)-10;
renderactionbtn(this, pos, 'Create Multirate Filter', @design);

l = [ ...
        this.WhenRenderedListeners(:); ...
        handle.listener(this, this.findprop('Type'), 'PropertyPostSet', ...
        @selection_listener); ...
        handle.listener(hs, 'NewSelection', @selection_listener); ...
        handle.listener([this hfs], 'UserModifiedSpecs', @ums_listener); ...
    ];

set(l, 'CallbackTarget', this);
set(this, 'WhenRenderedListeners', l);

setupenablelink(this, 'isdesigned', false, 'design');

selection_listener(this);

% -------------------------------------------------------------------------
function ums_listener(this, ~)

set(this, 'isDesigned', false);

% -------------------------------------------------------------------------
function selection_listener(this, ~)

visible_listener(this);
set(this, 'isDesigned', false);

% -------------------------------------------------------------------------
function interpStateChanged(this)

if ~isa(this, 'siggui.siggui')
    return
end

value = awtinvoke(this.JavaHandles.interpolation, 'getValue');
this.InterpolationFactor = value;

% -------------------------------------------------------------------------
function decimStateChanged(this)

if ~isa(this, 'siggui.siggui')
    return
end

value = awtinvoke(this.JavaHandles.decimation, 'getValue');
this.DecimationFactor = value;

% [EOF]
