function validatestates(h)
%VALIDATESTATES   

%   Author(s): V. Pellissier
%   Copyright 1988-2004 The MathWorks, Inc.

w = warning('off');
[wid, wstr] = lastwarn;

try
    S = validatestates(h.filterquantizer,h.States);
    h.States = []; % Assigned as empty to fire set function
    h.States = S;
catch
    % NO OP
end

warning(w);
lastwarn(wid, wstr);

% [EOF]
