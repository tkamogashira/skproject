function [stageinWL, stageinFL] = set_stageinq(q,scalevalueWL,scalevalueFL,stageoutWL, stageoutFL)
%SET_STAGEINQ Specify Stage input word and fraction length for the mexfunction.

% This should be a private method.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

stageinWL = q.privstageinwl;
if q.privSectionInputAutoScale,
    idealprod_range = (scalevalueWL+stageoutWL)-(scalevalueFL+stageoutFL);
    stageinFL = stageinWL - idealprod_range;
else
    stageinFL = q.privstageinfl;
end
if ~isempty(stageinFL),
    q.privstageinfl = stageinFL;
end

% [EOF]
