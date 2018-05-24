function state = getstate(this)
%GETSTATE   Get the state.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

state = rmfield(get(this), 'CurrentFilter');

if isrendered(this)
    state = rmfield(state, {'Visible', 'Enable', 'Parent'});
end

% [EOF]
