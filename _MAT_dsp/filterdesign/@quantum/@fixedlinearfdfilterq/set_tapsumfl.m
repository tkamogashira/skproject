function tapsumfl = set_tapsumfl(q, tapsumfl)
%SET_TAPSUMFL   

%   Author(s): V. Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.

try
    q.fdfimath.SumFractionlength = tapsumfl;
    updateinternalsettings(q);
catch
    error(message('dsp:quantum:fixedlinearfdfilterq:set_tapsumfl:MustBeInteger'));
end

tapsumfl = [];



% [EOF]
