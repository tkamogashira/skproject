function updateinternalsettings(q)
%UPDATEINTERNALSETTINGS   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% Define NumProduct format and update fimath
[prodWL, nprodFL] = set_prodq(q, q.privcoeffwl, q.privcoefffl, ...
    q.privstageinwl, ...
    q.privstageinfl);

% Define Den Product format and update fimath
[prodWL, dprodFL] = set_denprodq(q, q.privcoeffwl, q.privcoefffl2, ...
    q.privstageoutwl, ...
    q.privstageoutfl);

% Define NumAccumulator format and update fimath
[accWL, accFL] = set_accq(q,prodWL,nprodFL,3);

% Define Den Accumulator format and update fimath2
[denaccWL, denaccFL] = set_denaccq(q,prodWL,dprodFL,3);

% Define State format
[stWL stFL] = set_stateq(q, denaccWL, denaccFL);

% Send a quantizestates event
send_quantizestates(q);

% Define Output format
set_outq(q,accWL, accFL);

% [EOF]
