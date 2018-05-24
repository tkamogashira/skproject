function visible_listener(this, varargin)
%VISIBLE_LISTENER   Listener to 'visible' property.

%   Author(s): J. Schickler
%   Copyright 1999-2010 The MathWorks, Inc.

visState = get(this, 'Visible');

vis3 = 'Off';
if strcmpi(this.Arithmetic, 'fixed-point')
    isfixed = true;
    vis1 = this.Visible;
    vis2 = 'Off';
    if isfilterinternals(this)
        vis3 = this.Visible;
    end
else
    isfixed = false;
    vis1 = 'Off';
    vis2 = this.Visible;
end

if this.DSPMode
    vis1 = 'Off';
end

h  = get(this, 'TabHandles');

set([h.tabbuttons h.tabpanel], 'Visible', vis1);
hon = h.tabcovers(this.CurrentTab);
set(hon, 'Visible', vis1);
set(setdiff(h.tabcovers, hon), 'Visible', 'Off');
lbls = gettablabels(this);

[b, str] = issupported(this);
if b
    str  = getString(message('dsp:fdtbxgui:fdtbxgui:NoAdditionalSetting',this.Arithmetic));
end

h = get(this, 'Handles');
set(h.description, 'Visible', vis2, ...
    'String', str);

set(h.apply, 'Visible', vis1);
set([h.arithmetic h.arithmetic_lbl], 'Visible', this.Visible);
set([h.filterinternals h.filterinternals_lbl], 'Visible', vis3);

if isfixed
    ontab = this.CurrentTab;
    showtab(this, ontab);
    hidetab(this, setdiff(1:length(lbls), ontab))
else
    hidetab(this, 1:length(lbls));
end

updatecastbeforesum(this);

% [EOF]
