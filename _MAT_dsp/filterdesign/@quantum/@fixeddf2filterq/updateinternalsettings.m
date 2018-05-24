function updateinternalsettings(q)
%UPDATEINTERNALSETTINGS   Update the internal settings.

%   Author(s): P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

% Define denominator product format & update fimath (q.fimath2) object
[prodWL, prodFL] = set_denprodq(q, q.privcoeffwl, q.privcoefffl2, ...
    q.privstatewl, ...
    q.privstatefl);
 
if length(q.ncoeffs) == 1
    q.ncoeffs = [1 1];
end
    
% Define denominator accumulator format & update fimath
set_denaccq(q,prodWL,prodFL,q.ncoeffs(2));
 
% Define numerator product format & update fimath (q.fimath) object
[prodWL, prodFL] = set_prodq(q, q.privcoeffwl, q.privcoefffl, ...
    q.privstatewl, ...
    q.privstatefl);

% Define numerator accumulator format & update fimath (q.fimath) object
[numAccWL, numAccFL] = set_accq(q,prodWL,prodFL,q.ncoeffs(1));

% Define Output format
set_outq(q,numAccWL, numAccFL);

% [EOF]
