function setstate(this, state)
%SETSTATE   Set the state.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

% Make sure we set the type first.
set(this, 'Type', state.Type);

state = rmfield(state, {'Tag', 'Version', 'Type'});
if isfield(state, 'InputWordLength')
    state = rmfield(state, {'InputWordLength', 'OutputWordLength', ...
        'BitsPerSection'});
end

imp = state.Implementation;

state = rmfield(state, 'Implementation');

set(this, state);

try
    set(this, 'Implementation', imp);
catch
    
    hs = getcomponent(this, 'tag', 'implementation');
    
    hs.enableselection('current');
    
    set(this, 'Implementation', imp);
end

% [EOF]
