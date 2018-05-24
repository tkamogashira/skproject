function thisrender(this, varargin)
%THISRENDER   Render the wordfracnrange

%   Author(s): J. Schickler
%   Copyright 1999-2010 The MathWorks, Inc.

if nargin > 1 && islogical(varargin{end})
    twocols = varargin{end};
    varargin(end) = [];
else
    twocols = false;
end

pos  = parserenderinputs(this, varargin{:});
hFig = get(this, 'FigureHandle');
sz   = gui_sizes(this);
cbs  = siggui_cbs(this);

if isempty(pos), pos = [10 10 240 this.Maximum*60+80]*sz.pixf; end

edit_width = 23*sz.pixf;
tag        = get(this, 'Tag');
if ~isempty(tag), tag = [tag '_']; end

if twocols
    lblpos = [pos(1)+sz.hfus/2 pos(2)+pos(4)-sz.uh-sz.vfus pos(3)/2-sz.hfus-edit_width sz.uh];
else
    lblpos = [pos(1)+sz.hfus/2 pos(2)+pos(4)-sz.uh-sz.vfus pos(3)-sz.hfus-edit_width sz.uh];
end

h.wordlength_lbl = uicontrol(hFig, ...
    'Style', 'Text', ...
    'Tag', sprintf('%sword_lbl', tag), ...
    'Visible', 'Off', ...
    'HorizontalAlignment', 'Left', ...
    'Position', lblpos);

editpos = [lblpos(1)+lblpos(3) lblpos(2)+sz.lblTweak edit_width sz.uh];

wlEditPos = [editpos(1)-5*sz.pixf editpos(2) editpos(3)+5*sz.pixf editpos(4)];
h.wordlength = uicontrol(hFig, ...
    'Style', 'Edit', ...
    'Tag', sprintf('%sword', tag), ...
    'String', this.WordLength, ...
    'HorizontalAlignment', 'Left', ...
    'Callback', {cbs.property, this, 'WordLength', 'change word length'}, ...
    'Visible', 'Off', ...
    'BackgroundColor', 'w', ...
    'Position', wlEditPos);

if strcmpi(this.AutoScaleAvailable, 'on'),
    
    l = handle.listener(this, this.findprop('AutoScale'), 'PropertyPostSet', ...
        @autoscale_listener);
    
    if twocols
        w = pos(3)/2-2*sz.hfus;
        checkpos = [lblpos(1)+w+2*sz.hfus lblpos(2)+sz.lblTweak w sz.uh];
    else
        checkpos = [lblpos(1) lblpos(2)-sz.uh-sz.uuvs+sz.lblTweak pos(3)-2*sz.hfus sz.uh];
    end
        
    h.autoscale = uicontrol(hFig, ...
        'String', getTranslatedString('dsp:fdtbxgui:fdtbxgui',this.AutoscaleDescription), ...
        'Style', 'check', ...
        'Tag', sprintf('%sautoscale', tag), ...
        'Callback', {cbs.property, this, 'AutoScale'}, ...
        'HorizontalAlignment', 'Left', ...
        'Visible', 'Off', ...
        'Position', checkpos);
    
    if twocols
        checkpos(1) = checkpos(1)-w-2*sz.hfus;
    end

    lblpos(2) = lblpos(2)-2*sz.uh-2*sz.uuvs;
    editpos(2) = lblpos(2)+sz.lblTweak;
    p = [this.findprop('AutoScale') this.findprop('WordLength')];
else
    
    l = [];
    
    % Setup the position so that the selectors are rendered correctly.
    checkpos = lblpos;
    checkpos(2) = checkpos(2)+4*sz.pixf;
    p = this.findprop('WordLength');
end

set(this, 'Handles', h);

hs = getcomponent(this, '-class', 'siggui.selectorwvalues');

ht = 2*sz.uh+3*sz.uuvs;
spos = [checkpos(1)-sz.hfus checkpos(2)-ht lblpos(3)+editpos(3)+2*sz.hfus ht];

if twocols
    
    spos(2) = spos(2)-sz.uuvs+2*sz.pixf;
    
    for indx = 1:ceil(this.Maximum/2)
    
        render(hs(indx), hFig, [], spos, edit_width);
        spos(2) = spos(2)-ht;
    end
    
    spos = [pos(1)+pos(3)/2-sz.hfus/2 checkpos(2)-ht-sz.uuvs+2*sz.pixf pos(3)/2 ht];
    for indx = ceil(this.Maximum/2)+1:this.Maximum
        render(hs(indx), hFig, [], spos, edit_width);
        spos(2) = spos(2)-ht;
    end
    
else
    for indx = 1:this.Maximum
        render(hs(indx), hFig, [], spos, edit_width);
        spos(2) = spos(2)-ht;
    end
end

l = [ l(:); ...
        handle.listener(this, this.findprop('Name'), ...
        'PropertyPostSet', @name_listener); ...
        handle.listener(this, p, 'PropertyPostSet', @prop_listener); ...
        handle.listener(this, this.findprop('FracLabels'), ...
        'PropertyPostSet', @fraclabels_listener); ...
        handle.listener(this, this.findprop('AutoScaleAvailable'), ...
        'PropertyPostSet', @autoscaleavailable_listener); ...
        handle.listener(this, this.findprop('EnableFracLengths'), ...
        'PropertyPostSet', @enablefraclengths_listener); ...
    ];

set(l, 'CallbackTarget', this);
set(this, 'WhenRenderedListeners', l);

if strcmpi(this.AutoScaleAvailable, 'On')
    prop_listener(this, 'autoscale');
    autoscale_listener(this);
end
prop_listener(this, 'wordlength');
name_listener(this);
enable_listener(this);

updatecsh(this);

% -------------------------------------------------------------------------
function autoscaleavailable_listener(this, eventData)

visible_listener(this);
enable_listener(this);

% -------------------------------------------------------------------------
function enablefraclengths_listener(this, eventData)

enable_listener(this);

% -------------------------------------------------------------------------
function autoscale_listener(this, eventData)

enable_listener(this);


% -------------------------------------------------------------------------
function fraclabels_listener(this, eventData)

visible_listener(this);

% -------------------------------------------------------------------------
function name_listener(this, eventData)

h = get(this, 'Handles');

set(h.wordlength_lbl, 'String', sprintf('%s %s:',...
    getTranslatedString('dsp:fdtbxgui:fdtbxgui',get(this, 'Name')),...
    getTranslatedString('dsp:fdtbxgui:fdtbxgui','word length')));

% [EOF]
