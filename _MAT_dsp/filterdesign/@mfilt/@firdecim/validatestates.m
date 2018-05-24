function validatestates(this)
%VALIDATESTATES   Validate the states.

%   Author(s): V. Pellissier
%   Copyright 1988-2004 The MathWorks, Inc.

if isempty(this.HiddenStates)
    return;
end

w = warning('off');
[wid, wstr] = lastwarn;

try
    S = validatestates(this.filterquantizer,this.States);
    this.States = []; % Assigned as empty to fire set function
    this.States = S;
catch
    % NO OP
end

warning(w);
lastwarn(wid, wstr);

% [EOF]
