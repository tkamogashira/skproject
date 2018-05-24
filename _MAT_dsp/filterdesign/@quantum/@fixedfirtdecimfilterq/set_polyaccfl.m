function fl = set_polyaccfl(q, fl)
%SET_POLYACCFL   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    q.PolyAccfimath.SumFractionLength = fl;
    send_quantizeacc(q);
catch
    error(message('dsp:quantum:fixedfirtdecimfilterq:set_polyaccfl:MustBeInteger'));
end

fl = [];



% [EOF]
