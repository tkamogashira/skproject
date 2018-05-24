function visible_listener(this, varargin)
%VISIBLE_LISTENER   Listener to 'visible'.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

siggui_visible_listener(this, varargin{:});

vis = get(this, 'Visible');

set([getcomponent(this, '-class', 'siggui.fsspecifier') ...
    getcomponent(this, '-class', 'siggui.selector')], 'Visible', vis);

h = get(this, 'Handles');
set(h.java.controller.interpolation, 'Visible', vis);
set(h.java.controller.decimation,    'Visible', vis);

if ~strcmpi(this.Implementation, 'cic')
    vis = 'Off';
end
set([h.numberofsections h.numberofsections_lbl h.differentialdelay_lbl ...
    h.differentialdelay], 'Visible', vis);

% [EOF]
