function visible_listener(this, eventData)
%VISIBLE_LISTENER   Listener to 'visible'.

%   Author(s): J. Schickler
%   Copyright 2004 The MathWorks, Inc.

vis = get(this, 'Visible');

set(this.allchild, 'Visible', vis);

if strcmpi(vis, 'on')
    vis = get(this, 'ModeAvailable');
end

set(handles2vector(this), 'Visible', vis);

% [EOF]
