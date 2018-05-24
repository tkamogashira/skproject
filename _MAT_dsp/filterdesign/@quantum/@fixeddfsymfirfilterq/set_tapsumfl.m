function tapsumfl = set_tapsumfl(q, tapsumfl)
%SET_TAPSUMFL   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    q.TapSumfimath.SumFractionlength = tapsumfl;
    updateinternalsettings(q);
catch
    error(message('dsp:quantum:fixeddfsymfirfilterq:set_tapsumfl:MustBeInteger'));
end

tapsumfl = [];



% [EOF]
