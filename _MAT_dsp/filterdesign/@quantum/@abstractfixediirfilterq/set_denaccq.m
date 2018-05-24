function [accWL, accFL] = set_denaccq(q, inWL, inFL, ncoeffs)
%SET_DENACCQ Specify word and fraction length of the accum passed to the mexfunction.

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

bits2add = 0;
if ncoeffs>=1,
    bits2add = nguardbits(ncoeffs-1);
end

if strcmpi(q.privAccumMode, 'FullPrecision'),
    [accWL, accFL] = fullprecisionaccum(q, inWL, inFL, bits2add);
elseif strcmpi(q.privAccumMode, 'SpecifyPrecision'),
    accWL = q.fimath2.SumWordLength;
    accFL = q.fimath2.SumFractionLength;
elseif strcmpi(q.privAccumMode, 'KeepLSB'),
    accWL = q.fimath2.SumWordLength;
    accFL = inFL; % No underflow
elseif strcmpi(q.privAccumMode, 'KeepMSB'),
    accWL = q.fimath2.SumWordLength;
    accFL = keepmsbaccum(q, inWL, inFL, bits2add, accWL);
end

if ~isempty(accWL),
    q.fimath2.SumMode = 'SpecifyPrecision';
    q.fimath2.SumWordLength = accWL;
    q.fimath2.SumFractionLength = accFL;
end

% [EOF]
