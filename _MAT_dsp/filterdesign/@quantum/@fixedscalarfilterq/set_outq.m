function set_outq(q, accWL, accFL)
%SET_OUTQ Specify output word and fraction length for the mexfunction.

% This should be a private method.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

ideal_prodWL = q.privinwl + q.privcoeffwl;
ideal_prodFL = q.privinfl + q.privcoefffl;
outWL = q.privoutwl;
if strcmpi(q.privOutputMode, 'AvoidOverflow') || strcmpi(q.privOutputMode, 'BestPrecision'),
    outFL = outWL - (ideal_prodWL-ideal_prodFL);
else
    outFL = q.privoutfl;
end
if ~isempty(outFL),
    q.privoutfl = outFL;
end

% [EOF]
