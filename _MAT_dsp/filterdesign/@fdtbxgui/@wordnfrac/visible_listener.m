function visible_listener(this, varargin)
%VISIBLE_LISTENER   Listener to the 'visible' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

vis = get(this, 'Visible');
h   = get(this, 'Handles');

on  = [1:length(this.FracLabels)];
off = [length(this.FracLabels)+1:this.Maximum];

set([h.wordlength h.wordlength_lbl], 'Visible', vis);
set([h.fraclength(on)  h.fraclength_lbl(on)],    'Visible', vis);
set([h.fraclength(off) h.fraclength_lbl(off)],   'Visible', 'Off');

if this.maxword == 2
    if isempty(this.WordLabel2)
        vis = 'Off';
    end

    set([h.wordlength2 h.wordlength2_lbl], 'Visible', vis);
end

vis = get(this, 'AutoScaleAvailable');
if strcmpi(this.Visible, 'Off')
    vis = 'Off';
end
set(h.autoscale, 'Visible', vis);


% [EOF]
