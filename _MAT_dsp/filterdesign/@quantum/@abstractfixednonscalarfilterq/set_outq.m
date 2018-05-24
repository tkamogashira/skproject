function set_outq(q, accWL, accFL)
%SET_OUTQ Specify output word and fraction length for the mexfunction.

% This should be a private method.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

outWL = q.privoutwl;
if strcmpi(q.privOutputMode, 'AvoidOverflow') || strcmpi(q.privOutputMode, 'BestPrecision'),
    % Best precision output fraction length will be ignored
    bits2add = nguardbits(q.ncoeffs-1);
    ideal_accWL = q.privinwl + q.privcoeffwl + bits2add;
    ideal_accFL = q.privinfl + q.privcoefffl;
    outFL = outWL - (min(accWL-accFL,ideal_accWL-ideal_accFL));
else
    outFL = q.privoutfl;
end
if ~isempty(outFL),
    q.privoutfl = outFL;
end

% [EOF]
