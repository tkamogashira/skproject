function wl = set_polyaccwl(q, wl)
%SET_POLYACCWL   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    q.PolyAccfimath.SumWordLength = wl;
    send_quantizeacc(q);
catch
    error(message('dsp:quantum:fixedfirtdecimfilterq:set_polyaccwl:MustBePosInteger'));
end

wl = [];


% [EOF]
