function thisrender(this, varargin)
%THISRENDER   Render the word and fractional length object.

%   Author(s): J. Schickler
%   Copyright 1999-2011 The MathWorks, Inc.
%     

pos  = parserenderinputs(this, varargin{:});
hFig = get(this, 'FigureHandle');
sz   = gui_sizes(this);
cbs  = siggui_cbs(this);

if isempty(pos), pos = [10 10 200 200]*sz.pixf; end

edit_width = 28*sz.pixf;

if sz.fontsize > 8   
  sz.uh = 18*sz.pixf;
  sz.lh = sz.uh;
end

tag        = get(this, 'Tag');
if ~isempty(tag), tag = [tag '_']; end

lblpos = [pos(1)+sz.hfus/2 pos(2)+pos(4)-sz.uh-sz.vfus pos(3)-sz.hfus-edit_width sz.uh];

h.wordlength_lbl = uicontrol(hFig, ...
    'Style', 'Text', ...
    'Tag', sprintf('%sword_lbl', tag), ...
    'Visible', 'Off', ...
    'HorizontalAlignment', 'Left', ...
    'Position', lblpos);

editpos = [lblpos(1)+lblpos(3) lblpos(2)+sz.lblTweak edit_width sz.uh];

h.wordlength = uicontrol(hFig, ...
    'Style', 'Edit', ...
    'Tag', sprintf('%sword', tag), ...
    'String', this.WordLength, ...
    'HorizontalAlignment', 'Left', ...
    'Callback', {cbs.property, this, 'WordLength', 'change word length'}, ...
    'Visible', 'Off', ...
    'BackgroundColor', 'w', ...
    'Position', editpos);

if this.maxword == 2,

    lblpos(2) = lblpos(2)-lblpos(4)-sz.uuvs;
    
    h.wordlength2_lbl = uicontrol(hFig, ...
        'Style', 'Text', ...
        'Tag', sprintf('%sword2_lbl', tag), ...
        'Visible', 'Off', ...
        'HorizontalAlignment', 'Left', ...
        'Position', lblpos);

    editpos(2) = editpos(2)-lblpos(4)-sz.uuvs;
    
    h.wordlength2 = uicontrol(hFig, ...
        'Style', 'Edit', ...
        'Tag', sprintf('%sword2', tag), ...
        'String', this.WordLength, ...
        'HorizontalAlignment', 'Left', ...
        'Callback', {cbs.property, this, 'WordLength2', 'change word length'}, ...
        'Visible', 'Off', ...
        'BackgroundColor', 'w', ...
        'Position', editpos);
end

checkpos = [lblpos(1) lblpos(2)-sz.uh-sz.uuvs+sz.lblTweak pos(3)-2*sz.hfus sz.uh];

h.autoscale = uicontrol(hFig, ...
    'String', getTranslatedString('dsp:fdtbxgui:fdtbxgui',this.AutoScaleDescription), ...
    'Style', 'check', ...
    'Tag', sprintf('%sautoscale', tag), ...
    'Callback', {cbs.property, this, 'AutoScale'}, ...
    'HorizontalAlignment', 'Left', ...
    'Visible', 'Off', ...
    'Position', checkpos);

lblpos(2) = lblpos(2)-2*sz.uh-2*sz.uuvs;
editpos(2) = lblpos(2)+sz.lblTweak;

strs = get(this, 'FracLengths');

strs = [strs; repmat({''}, this.Maximum-length(strs), 1)];

for indx = 1:this.Maximum
    h.fraclength_lbl(indx) = uicontrol(hFig, ...
        'Style', 'text', ...
        'HorizontalAlignment', 'Left', ...
        'Tag', sprintf('%sfraclbl%d', tag, indx), ...
        'Visible', 'Off', ...
        'Position', lblpos);

    h.fraclength(indx) = uicontrol(hFig, ...
        'Style', 'edit', ...
        'String', strs{indx}, ...
        'HorizontalAlignment', 'Left', ...
        'Callback', {@fraclength_cb, this, indx}, ...
        'Tag', sprintf('%sfrac%d', tag, indx), ...
        'Visible', 'Off', ...
        'BackgroundColor', 'w', ...
        'Position', editpos);

    lblpos(2)  = lblpos(2)-sz.uh-sz.uuvs;
    editpos(2) = lblpos(2)+sz.lblTweak;
end

set(this, 'Handles', h);

l = [ ...
    handle.listener(this, this.findprop('Name'), ...
    'PropertyPostSet', @name_listener); ...
    handle.listener(this, [this.findprop('AutoScale') this.findprop('WordLength')], ...
    'PropertyPostSet', @prop_listener); ...
    handle.listener(this, [this.findprop('FracLabels') ...
    this.findprop('Abbreviate')], 'PropertyPostSet', @fraclabels_listener); ...
    handle.listener(this, this.findprop('FracLength'), ...
    'PropertyPostSet', @fraclengths_listener); ...
    handle.listener(this, this.findprop('AutoScaleAvailable'), ...
    'PropertyPostSet', @autoscaleavailable_listener); ...
    handle.listener(this, this.findprop('WordLabel2'), ...
    'PropertyPostSet', @wordlabel2_listener); ...
    ];
set(l, 'CallbackTarget', this);
set(this, 'WhenRenderedListeners', l);

setupenablelink(this, 'autoscale', 'off', 'fraclength');

prop_listener(this, 'autoscale');
prop_listener(this, 'wordlength');
name_listener(this);
fraclabels_listener(this);
autoscaleavailable_listener(this);

if this.maxword == 2
    wordlabel2_listener(this);
end

updatecsh(this);

% -------------------------------------------------------------------------
function fraclength_cb(hcbo, ~, this, indx)

vals = get(this, 'FracLengths');
vals{indx} = get(hcbo, 'String');

set(this, 'FracLengths', vals);
send(this, 'UserModifiedSpecs');


% -------------------------------------------------------------------------
function autoscaleavailable_listener(this, ~)

enable_listener(this);
visible_listener(this);

% -------------------------------------------------------------------------
function wordlabel2_listener(this, ~)

h = get(this, 'Handles');

set(h.wordlength2_lbl, 'String', sprintf('%s %s:',...
    getTranslatedString('dsp:fdtbxgui:fdtbxgui',get(this, 'WordLabel2')),...
    getTranslatedString('dsp:fdtbxgui:fdtbxgui','word length')));

visible_listener(this);

% -------------------------------------------------------------------------
function name_listener(this, ~)

h = get(this, 'Handles');

set(h.wordlength_lbl, 'String', sprintf('%s %s:',...
    getTranslatedString('dsp:fdtbxgui:fdtbxgui',get(this, 'Name')),...
    getTranslatedString('dsp:fdtbxgui:fdtbxgui','word length')));

% -------------------------------------------------------------------------
function fraclabels_listener(this, ~)

h = get(this, 'Handles');

str = getfracstr(this);

for indx = 1:length(this.FracLabels)
    set(h.fraclength_lbl(indx), 'String', sprintf('%s %s:', ...
        getTranslatedString('dsp:fdtbxgui:fdtbxgui',this.FracLabels{indx}),...
        getTranslatedString('dsp:fdtbxgui:fdtbxgui',sprintf('%slength',str))));
end

fraclengths_listener(this);
% visible_listener(this);

% -------------------------------------------------------------------------
function fraclengths_listener(this, ~)

h = get(this, 'Handles');

for indx = 1:length(this.FracLengths)
    set(h.fraclength(indx), 'String', this.FracLengths{indx});
end

visible_listener(this, []);

% [EOF]