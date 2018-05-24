function updateinternalsettings(q)
%UPDATEINTERNALSETTINGS   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% Define Num Product format and update fimath
[prodWL, prodFL] = set_prodq(q, q.privcoeffwl, q.privcoefffl, ...
    max(q.privnstatewl,q.privdstatewl), ...
    q.privnstatefl);

% Define Num Accumulator format and update fimath
[accWL, accFL] = set_accq(q,prodWL,prodFL,3);

% Define Den Product format and update fimath
[prodWL, prodFL] = set_denprodq(q, q.privcoeffwl, q.privcoefffl2, ...
    max(q.privnstatewl,q.privdstatewl), ...
    q.privdstatefl);

% Define Den Accumulator format and update fimath2
[accWL, accFL] = set_denaccq(q,prodWL,prodFL,3);

% Define Output format
set_outq(q,accWL, accFL);


% [EOF]
