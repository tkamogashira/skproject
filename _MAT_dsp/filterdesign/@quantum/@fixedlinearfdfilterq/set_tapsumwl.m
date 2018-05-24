function tapsumwl = set_tapsumwl(q, tapsumwl)
%SET_TAPSUMWL   

%   Author(s): V. Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.

try
    q.fdfimath.SumWordLength = tapsumwl;
    updateinternalsettings(q);
catch
    error(message('dsp:quantum:fixedlinearfdfilterq:set_tapsumwl:MustBePosInteger'));
end

tapsumwl = [];


% [EOF]
