function tapsumwl = set_tapsumwl(q, tapsumwl)
%SET_TAPSUMWL   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    q.TapSumfimath.SumWordLength = tapsumwl;
    updateinternalsettings(q);
catch
    error(message('dsp:quantum:fixeddfsymfirfilterq:set_tapsumwl:MustBePosInteger'));
end

tapsumwl = [];


% [EOF]
