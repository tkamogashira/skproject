function [stageoutWL, stageoutFL] = set_stageoutq(q,numAccWL, numAccFL)
%SET_STAGEOUTQ Specify Stage output word and fraction length for the mexfunction.

% This should be a private method.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

stageoutWL = q.privstageoutwl;
if q.privSectionOutputAutoScale,
    bits2add = 2;
    ideal_numaccWL = q.privstatewl + q.privcoeffwl + bits2add;
    ideal_numaccFL = q.privstatefl + q.privcoefffl;
    stageoutFL = stageoutWL - (min(numAccWL-numAccFL,ideal_numaccWL-ideal_numaccFL));
else
    stageoutFL = q.privstageoutfl;
end
if ~isempty(stageoutFL),
    q.privstageoutfl = stageoutFL;
end


% [EOF]
