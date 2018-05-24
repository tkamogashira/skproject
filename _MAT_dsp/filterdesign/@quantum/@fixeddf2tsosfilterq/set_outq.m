function set_outq(q, accWL, accFL)
%SET_OUTQ Specify output word and fraction length for the mexfunction.

% This should be a private method.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

outWL = q.privoutwl;
if strcmpi(q.privOutputMode, 'AvoidOverflow') || strcmpi(q.privOutputMode, 'BestPrecision'),
    bits2add = 2;
    ideal_accWL = q.privstageinwl + q.privcoeffwl + bits2add;
    ideal_numaccFL = q.privstageinfl + q.privcoefffl;
    ideal_denaccFL = q.privstageoutfl + q.privcoefffl2;
    outFL = outWL - (min([accWL-accFL, ...
        max(ideal_accWL-ideal_numaccFL,ideal_accWL-ideal_denaccFL)]));
else
    outFL = q.privoutfl;
end
if ~isempty(outFL),
    q.privoutfl = outFL;
end

% [EOF]
