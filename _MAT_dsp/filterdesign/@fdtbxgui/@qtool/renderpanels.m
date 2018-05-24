function renderpanels(this, panelpos)
%RENDERPANELS   Render the three panels.

%   Author(s): J. Schickler
%   Copyright 1999-2011 The MathWorks, Inc.
%     

hFig = get(this, 'FigureHandle');
sz   = gui_sizes(this);

divy = panelpos(2)+3*sz.vfus;
divh = panelpos(4)-6*sz.vfus;

pos = [panelpos(1)-5*sz.pixf panelpos(2)+panelpos(4)+4*sz.pixf 280*sz.pixf sz.uh];

rendercontrols(this, pos, 'arithmetic');

h = get(this, 'Handles');

h.description = uicontrol(hFig, ...
    'Style', 'Text', ...
    'String', 'test', ...
    'Visible', 'Off', ...
    'Position', [pos(1)+sz.hfus pos(2)-5*sz.uh-2*sz.uuvs panelpos(3)-2*sz.hfus 4*sz.uh], ...
    'HorizontalAlignment', 'Left');

set(this, 'Handles', h);

pos = getpixelpos(this, 'arithmetic');
pos(1) = pos(1)-5*sz.pixf;
setpixelpos(this, 'arithmetic', pos);

pos(1) = pos(1)+pos(3);
th = get(this, 'TabHandles');
tabpos = get(th.tabbuttons(1), 'Position');
pos(3) = tabpos(1)-pos(1)+5*sz.pixf;

rendercontrols(this, pos, 'filterinternals');

pos = getpixelpos(this, 'filterinternals');
pos(1) = pos(1)-5*sz.pixf;
setpixelpos(this, 'filterinternals', pos);

%
% Render the first panel
%

% Render the Coefficients
hc = getcomponent(this, 'tag', 'coeff');
w = 450*sz.pixf;
pos = [panelpos(1)+sz.hfus panelpos(2)+3*sz.vfus w panelpos(4)-6*sz.vfus];
render(hc, hFig, pos, true);

pos = [pos(1)+pos(3) divy 1 divh];

hcoeffdivider = uicontrol(hFig, ...
    'Style', 'frame', ...
    'Visible', 'Off', ...
    'Position', pos);

w = 78*sz.pixf; % largestuiwidth({'Signed', 'Normalize'})+sz.rbwTweak+5*sz.pixf;
ht = 2*sz.uh+3*sz.uuvs;

pos = [pos(1) pos(2)+pos(4)-ht w ht];
rendercontrols(this, pos, {'unsigned', 'normalize'});

checkpos = getpixelpos(this, 'normalize');
checkpos(3) = panelpos(3)+panelpos(1)-pos(1)-sz.hfus-sz.uuhs;
setpixelpos(this, 'normalize', checkpos);

% Render the checkboxs.
h = get(this, 'Handles');
h.normalize_extra = uicontrol(hFig, ...
    'Style', 'Text', ...
    'HorizontalAlignment', 'Left', ...
    'Visible','Off', ...
    'String', '', ...
    'Position', checkpos+[sz.rbwTweak -sz.uh -sz.rbwTweak 0]);

set(this, 'Handles', h);

%
% Render the second panel
%

pos = [panelpos(1)+sz.hfus panelpos(2)+panelpos(4)-ht-2.5*sz.vfus panelpos(3)*.3 ht];
hi = getcomponent(this, 'tag', 'input');
render(hi, hFig, pos);

pos = [pos(1)+pos(3)+sz.hfus/2 divy 1 divh];

hinputdivider = uicontrol(hFig, ...
    'Style', 'frame', ...
    'Visible', 'Off', ...
    'Position', pos);

ht = 3*sz.uh+4*sz.uuvs;

% @siggui.gui_sizes() will inflate the size of control height if the font is
% greater than 8.  We do not have enough area to use the default behavior.
if sz.fontsize > 8
  ht = ht - 8*sz.pixf;
end

pos = [pos(1)+sz.hfus/2 panelpos(2)+panelpos(4)-ht-2.75*sz.vfus panelpos(3)*.3 ht];

ho = getcomponent(this, 'tag', 'output');
asa = get(ho, 'AutoScaleAvailable'); set(ho, 'AutoScaleAvailable', 'on');
render(ho, hFig, pos); set(ho, 'AutoScaleAvailable', asa);

pos = [pos(1)+pos(3)+sz.hfus/2 divy 1 divh];

houtputdivider = uicontrol(hFig, ...
    'Style','frame', ...
    'Visible', 'off', ...
    'Position', pos);

pos = [pos(1)+sz.hfus/2 panelpos(2)+panelpos(4)-ht-2.5*sz.vfus panelpos(3)-pos(1) ht];
hsi = getcomponent(this, 'tag', 'sectioninput');
render(hsi, hFig, pos);

pos(2) = pos(2)-pos(4)+6*sz.pixf;
hso = getcomponent(this, 'tag', 'sectionoutput');
render(hso, hFig, pos);

pos = [pos(1)+sz.hfus pos(2)+pos(4)+3*sz.pixf pos(3)-2*sz.hfus 1];

hsectiondivider = uicontrol(hFig, ...
    'Style','frame', ...
    'Visible', 'off', ...
    'Position', pos);

% Render the third panel.

% Can't hard code because of Unix.
w1 = largestuiwidth({[getString(message('dsp:fdtbxgui:fdtbxgui:Roundtowards')) ': ']}) +  ...
    largestuiwidth(set(this, 'RoundMode')) + sz.uuhs + 2*sz.hfus + sz.rbwTweak;
w2 = largestuiwidth({[getString(message('dsp:fdtbxgui:fdtbxgui:Overflowmode')) ':']}) +  ...
    largestuiwidth(set(this, 'OverflowMode')) + sz.uuhs + 2*sz.hfus + sz.rbwTweak;

spacing = (panelpos(3)-w1-w2)/3;

pos = [panelpos(1)+spacing panelpos(2)+panelpos(4)-2*sz.vfus-sz.uh w1 sz.uh];

rendercontrols(this, pos, 'roundmode');

pos = [pos(1)+w1+spacing pos(2) w2 sz.uh];

% Adding pixels to width to accomodate wordlength. g921151
rendercontrols(this, [pos(1:2) pos(3)+45 pos(4)], 'overflowmode');

pos = [panelpos(1)+sz.hfus pos(2)-sz.uuvs panelpos(3)-2*sz.hfus 1];

hmodedivider = uicontrol(hFig, ...
    'Style','frame', ...
    'Visible', 'off', ...
    'Position', pos);

w  = panelpos(3)/4;
ht = panelpos(4)-2*sz.uh-5*sz.uuvs;

pos = [panelpos(1) panelpos(2)+sz.uh+2*sz.uuvs+6*sz.pixf w ht];
hp = getcomponent(this, 'tag', 'product');
render(hp, hFig, pos);

labels = {[getString(message('dsp:fdtbxgui:fdtbxgui:Sectionwordlength')) ': '], [getString(message('dsp:fdtbxgui:fdtbxgui:Sectionfractionlength')) ': ']};

width = largestuiwidth(labels);

lblpos = [pos(1)+sz.hfus*2 pos(2)+pos(4)-sz.uh-sz.vfus-sz.lblTweak width sz.uh];
hsecword_lbl = uicontrol(hFig, ...
    'Visible',  'Off', ...
    'HorizontalAlignment', 'left', ...
    'Position', lblpos, ...
    'String',   labels{1}, ...
    'Style',    'text');

editpos = [lblpos(1)+width+sz.uuhs lblpos(2)+sz.lblTweak 200*sz.pixf sz.uh];
hsecword = uicontrol(hFig, ...
    'HorizontalAlignment', 'left', ...
    'Visible', 'Off', ...
    'Position', editpos, ...
    'Callback', {@secword_cb, this}, ...
    'String', 'test', ...
    'Style', 'edit');

lblpos(2) = lblpos(2)-lblpos(4)-sz.uuvs;
hfracword_lbl = uicontrol(hFig, ...
    'HorizontalAlignment', 'left', ...
    'Visible',  'Off', ...
    'Position', lblpos, ...
    'String',   labels{2}, ...
    'Style',    'text');

editpos(2) = editpos(2)-editpos(4)-sz.uuvs;
hfracword = uicontrol(hFig, ...
    'HorizontalAlignment', 'left', ...
    'Visible', 'Off', ...
    'Position', editpos, ...
    'Callback', {@secfrac_cb, this}, ...
    'String', 'test', ...
    'Style', 'edit');

divh = divh-sz.uh-sz.uuvs;
pos = [pos(1)+pos(3) divy 1 divh];

hproddivider = uicontrol(hFig, ...
    'Style','frame', ...
    'Visible', 'off', ...
    'Position', pos);

pos = [pos(1) panelpos(2)+sz.uh+2*sz.uuvs+6*sz.pixf w ht];
ha = getcomponent(this, 'tag', 'accum');
render(ha, hFig, pos);

pos = [pos(1) panelpos(2)+sz.uuvs w sz.uh];
rendercontrols(this, pos, 'castbeforesum');

%make sure checkbox doesn't overrun bounds (in Japanese)
hcheck = findall(hFig,'tag','castbeforesum');
extent = get(hcheck,'extent');
if extent(3) + 40*sz.pixf > w
  set(hcheck,'FontSize',8);
end

pos = [pos(1)+pos(3) divy 1 divh];

haccumdivider = uicontrol(hFig, ...
    'Style','frame', ...
    'Visible', 'off', ...
    'Position', pos);

pos = [pos(1) panelpos(2)+sz.uh+2*sz.uuvs+6*sz.pixf w ht];
hts = getcomponent(this, 'tag', 'tapsum');
render(hts, hFig, pos);

% ht = 3*sz.uh+4*sz.uuvs;
y  = panelpos(2)+panelpos(4)-ht-sz.uh-3*sz.uuvs+6*sz.pixf;

pos = [pos(1) y w ht];
hs = getcomponent(this, 'tag', 'state');
render(hs, hFig, pos);

pos = [pos(1)+pos(3) divy 1 divh];

hstatedivider = uicontrol(hFig, ...
    'Style','frame', ...
    'Visible', 'off', ...
    'Position', pos);

pos = [pos(1) y w ht];
hm = getcomponent(this, 'tag', 'multiplicand');
render(hm, hFig, pos);

renderactionbtn(this, panelpos - [0 30*sz.pixf 0 0], 'Apply', 'apply');

h = get(this, 'Handles');
h.coeffdivider  = hcoeffdivider;
h.inputdivider  = hinputdivider;
h.outputdivider = houtputdivider;
h.sectiondivider = hsectiondivider;
h.modedivider   = hmodedivider;
h.proddivider   = hproddivider;
h.accumdivider  = haccumdivider;
h.statedivider  = hstatedivider;
h.sectionwordlengths_lbl = hsecword_lbl;
h.sectionwordlengths     = hsecword;
h.sectionfraclengths_lbl = hfracword_lbl;
h.sectionfraclengths     = hfracword;
set(this, 'Handles', h);

setupenablelink(this, 'isapplied', false, 'apply');

l = [ ...
        this.WhenRenderedListeners(:); ...
        handle.listener(this, [this.findprop('arithmetic'), ...
        this.findprop('filter')], 'PropertyPostSet', @filter_listener); ...
        handle.listener(this, this.findprop('filter'), ...
        'PropertyPreSet', @filter_preset_listener); ...
        handle.listener(ha, ha.findprop('Mode'), 'PropertyPostSet', ...
        @accum_listener); ...
        handle.listener(this, this.findprop('SectionWordLengths'), ...
        'PropertyPostSet', @sectionwordlengths_listener); ...
        handle.listener(this, this.findprop('SectionFracLengths'), ...
        'PropertyPostSet', @sectionwordlengths_listener); ...
        handle.listener(this, this.findprop('FilterInternals'), ...
        'PropertyPostSet', @filterinternals_listener); ...
    ];
set(l, 'CallbackTarget', this);
set(this, 'WhenRenderedListeners', l);

filter_preset_listener(this);
filter_listener(this);
accum_listener(this);
sectionwordlengths_listener(this);
sectionfraclengths_listener(this);

% -------------------------------------------------------------------------
function filterinternals_listener(this, ~)

switch lower(this.FilterInternals)
    case 'full'
        outenab = 'off';
        accmode = 'Full';
        swlenab = 'off';
        sflenab = 'off';
    case 'specify all'
        outenab = this.Enable;
        accmode = 'Spec';
        swlenab = this.Enable;
        sflenab = this.Enable;
    case 'specify word lengths'
        outenab = this.Enable;
        accmode = 'Spec';
        swlenab = this.Enable;
        sflenab = 'off';
    case 'minimum section word lengths'
        outenab = this.Enable;
        accmode = 'Spec';
        swlenab = 'off';
        sflenab = 'off';
end
if isfilterinternals(this)
    set([getcomponent(this, 'accum') ...
        getcomponent(this, 'product')], 'Mode', accmode);
else
    outenab = this.Enable;
end
set([getcomponent(this, 'output') ...
    getcomponent(this, 'accum') ...
    getcomponent(this, 'product')], 'Enable', outenab);

h = get(this, 'Handles');
setenableprop([h.sectionwordlengths h.sectionwordlengths_lbl], swlenab);
setenableprop([h.sectionfraclengths h.sectionfraclengths_lbl], sflenab);

updateinputoutput(this);
updatemodes(this);
if isa(this.Filter, 'mfilt.abstractcic')
    updatecicinfo(this);
end

% -------------------------------------------------------------------------
function sectionwordlengths_listener(this, ~)

set(this.Handles.sectionwordlengths, 'String', this.SectionWordLengths);

% -------------------------------------------------------------------------
function sectionfraclengths_listener(this, ~)

set(this.Handles.sectionfraclengths, 'String', this.SectionFracLengths);

% -------------------------------------------------------------------------
function accum_listener(this, ~)

updatecastbeforesum(this);

% -------------------------------------------------------------------------
function filter_preset_listener(this, eventData)

objectStrings = set(this, 'Arithmetic');

if nargin > 1
    filtobj = get(eventData, 'NewValue');
else
    filtobj = get(this, 'Filter');
end

if isa(filtobj, 'mfilt.abstractcic')
    
    objectStrings(1:2) = [];
end

% Use setPopupStrings to update the strings property properly.
setPopupStrings(this, 'arithmetic', objectStrings, getTranslatedStringcell('dsp:fdtbxgui:fdtbxgui',objectStrings));

str = set(this, 'FilterInternals');
if ~isa(filtobj, 'mfilt.abstractcic')
    str(2:3) = [];
    if ~any(strcmpi(this.FilterInternals, str))
        this.FilterInternals = 'Full';
    end
end

% Use setPopupStrings to update the strings property properly.
setPopupStrings(this, 'filterinternals', str, getTranslatedStringcell('dsp:fdtbxgui:fdtbxgui',str));

% -------------------------------------------------------------------------
function filter_listener(this, ~)

prop_listener(this, 'arithmetic');

enable_listener(this, []);
visible_listener(this, []);

filterinternals_listener(this, []);
prop_listener(this, 'normalize');
prop_listener(this, 'roundmode');
prop_listener(this, 'overflowmode');
updateinputoutput(this);

% Update the CSH because the filter may have changed the labels.
h = allchild(this);
for indx = 1:length(h)
    updatecsh(h(indx));
end

% -------------------------------------------------------------------------
function secword_cb(hcbo, ~, this)

set(this, 'SectionWordLengths', get(hcbo, 'String'));

% -------------------------------------------------------------------------
function secfrac_cb(hcbo, ~, this)

set(this, 'SectionFracLengths', get(hcbo, 'String'));

% [EOF]
