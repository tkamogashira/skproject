function updateinternalsettings(q)
%UPDATEINTERNALSETTINGS   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% Define TapSum format and update TapSumfimath
[tapsumWL, tapsumFL] = set_tapsumq(q,q.privinwl,q.privinfl);

% Define Product format and update fimath
[prodWL, prodFL] = set_prodq(q, q.privcoeffwl, q.privcoefffl, ...
    tapsumWL, ...
    tapsumFL);

% Define Accumulator format and update fimath
[accWL, accFL] = set_accq(q,prodWL,prodFL,ceil(q.ncoeffs/2));

% Define Output format
set_outq(q,accWL, accFL);

% [EOF]
