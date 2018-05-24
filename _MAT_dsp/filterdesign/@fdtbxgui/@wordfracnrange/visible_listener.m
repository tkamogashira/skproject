function visible_listener(this, varargin)
%VISIBLE_LISTENER   Listener to the 'visible' property.

%   Author(s): J. Schickler
%   Copyright 1999-2010 The MathWorks, Inc.

siggui_visible_listener(this, varargin{:});

hs = getcomponent(this, '-class', 'siggui.selectorwvalues');
set(hs(1:length(this.FracLabels)), 'Visible', this.Visible);
set(hs(length(this.FracLabels)+1:this.Maximum), 'Visible', 'Off');

h = get(this, 'Handles');
if isfield(h, 'autoscale')
    if strcmpi(this.AutoScaleAvailable, 'Off') || ...
            strcmpi(this.EnableFracLengths, 'Off')
        vis = 'Off';
    else
        vis = this.Visible;
    end
    set(h.autoscale, 'Visible', vis);
end

% [EOF]
