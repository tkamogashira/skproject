function set_outq(q, accWL, accFL)
%SET_OUTQ Specify output word and fraction length for the mexfunction.

% This should be a private method.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

outWL = q.privoutwl;
if strcmpi(q.privOutputMode, 'AvoidOverflow') || strcmpi(q.privOutputMode, 'BestPrecision'),
    bits2add = 2;
    ideal_intbits = max(q.privdstatewl + q.privcoeffwl + bits2add - q.privdstatefl - q.privcoefffl2, ...
        q.privnstatewl + q.privcoeffwl + bits2add - q.privnstatefl - q.privcoefffl);
    outFL = outWL - (min(accWL-accFL,ideal_intbits));
else
    outFL = q.privoutfl;
end
if ~isempty(outFL),
    q.privoutfl = outFL;
end

% [EOF]
