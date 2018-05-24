function statewl = set_statewl(q, statewl)
%SET_STATEWL   PreSet function for the 'statewl' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    q.privstatewl = statewl;
    % Quantizer changed, send a quantizestates event
    send_quantizestates(q);
catch
    error(message('dsp:quantum:fixedfirtdecimfilterq:set_statewl:MustBePosInteger'));
end

% [EOF]
