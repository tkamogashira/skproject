function updateinternalsettings(q)
%UPDATEINTERNALSETTINGS   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% Define Den Product format and update fimath
if ~isempty(q.privmultwl),
    [denprodWL, denprodFL] = set_denprodq(q, q.privcoeffwl, q.privcoefffl2, ...
        q.privmultwl, ...
        q.privmultfl);

    % Define Den Accumulator format and update fimath2
    [denaccWL, denaccFL] = set_denaccq(q,denprodWL,denprodFL,3);

    % Define Num Product format and update fimath
    [numprodWL, numprodFL] = set_prodq(q, q.privcoeffwl, q.privcoefffl, ...
        q.privmultwl, ...
        q.privmultfl);

    % Define Num Accumulator format and update fimath
    [numaccWL numaccFL] = set_accq(q,numprodWL,numprodFL,3);

    % Define StageOutput format
    [stageoutWL stageoutFL] = set_stageoutq(q,numaccWL,numaccFL);

    % Define StageOutput format
    set_stageinq(q,q.privcoeffwl,q.privcoefffl3,stageoutWL,stageoutFL);

    % Define State format
    set_denstateq(q, denaccWL, denaccFL);

    % Define State format
    set_numstateq(q, numaccWL, numaccFL);

    % Define Output format
    set_outq(q,numaccWL, numaccFL);

    % Send a quantizestates event
    send_quantizestates(q);

end

%[EOF]
