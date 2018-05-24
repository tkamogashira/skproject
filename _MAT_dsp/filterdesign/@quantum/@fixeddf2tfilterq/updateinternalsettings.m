function updateinternalsettings(q)
%UPDATEINTERNALSETTINGS   

%   Author(s): P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

% Define numerator product format & update fimath (q.fimath) object
[prodWL, prodFL] = set_numprodq(q, q.privcoeffwl, q.privcoefffl, ...
    q.inputwordlength, ...
    q.inputfraclength);
 
% Define denominator product format & update fimath (q.fimath2) object
[denProdWL, denProdFL] = set_denprodq(q, q.privcoeffwl, q.privcoefffl2, ...
    q.outputwordlength, ...
    q.outputfraclength);

% Define the accumulator format & update fimath (q.fimath) object
set_numaccq(q,prodWL,prodFL,sum(q.ncoeffs)-1);

[denAccWL, denAccFL] = set_denaccq(q,denProdWL,denProdFL,sum(q.ncoeffs)-1);

% Define State format
set_stateq(q, denAccWL, denAccFL);

% Send a quantizestates event
send_quantizestates(q);


% [EOF]
