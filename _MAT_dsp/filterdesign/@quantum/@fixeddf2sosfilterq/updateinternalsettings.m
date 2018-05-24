function updateinternalsettings(q)
%UPDATEINTERNALSETTINGS   

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

% Define Den Product format and update fimath
[prodWL, prodFL] = set_denprodq(q, q.privcoeffwl, q.privcoefffl2, ...
    q.privstatewl, ...
    q.privstatefl);

% Define Den Accumulator format and update fimath2
[accWL, accFL] = set_denaccq(q,prodWL,prodFL,3);

% Define Num Product format and update fimath
[prodWL, prodFL] = set_prodq(q, q.privcoeffwl, q.privcoefffl, ...
    q.privstatewl, ...
    q.privstatefl);

% Define Num Accumulator format and update fimath
[numaccWL, numaccFL] = set_accq(q,prodWL,prodFL,3);

% Define StageOutput format
[stageoutWL stageoutFL] = set_stageoutq(q,numaccWL,numaccFL);

% Define StageOutput format
set_stageinq(q,q.privcoeffwl,q.privcoefffl3,stageoutWL,stageoutFL);

% Define Output format
set_outq(q,numaccWL, numaccFL);


% [EOF]
