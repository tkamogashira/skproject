function [val exists] = dspmodelvar(model,var)
% [val exists] = dspmodelvar(model,var)
% Determines if variable exists in the model workspace and, if so, returns
% the value of the variable.
% exists is true if the value exists. In that case, val contains it's
% value.
% If exists is false, val will contain the empty string and should be
% ignored.

% Copyright 2006 The MathWorks, Inc.

mws = get_param(model,'modelworkspace');
mwsdata = data(mws);
sz = size(mwsdata);
exists = 0;
for i=1:sz(2)
    if strcmp(mwsdata(i).Name, var)
        val = mwsdata(i).Value;
        exists = 1;
        break;
    end
end
if exists==0
    val = '';
end
