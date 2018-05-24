function [accWL, accFL] = set_denaccq(q, inWL, inFL, ncoeffs)
%SET_DENACCQ Specify word and fraction length of the accum passed to the mexfunction.

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

bits2add = 0;
if ncoeffs>=1,
    bits2add = nguardbits(ncoeffs-1);
end

if strcmpi(q.AccumMode, 'FullPrecision'),
    % denProdWL + GuardBits 
    [accWL, accFL] = fullprecisionaccum(q, inWL, inFL, bits2add);
elseif strcmpi(q.AccumMode, 'SpecifyPrecision'),
    accWL = q.AccumWordLength;
    accFL = q.DenAccumFracLength;
elseif strcmpi(q.AccumMode, 'KeepLSB'),
    accWL = q.AccumWordLength;
    accFL = inFL;
elseif strcmpi(q.AccumMode, 'KeepMSB'),
    accWL = q.AccumWordLength;
    accFL = keepmsbaccum(q, inWL, inFL, bits2add, accWL);
end

if ~isempty(accWL),
    q.fimath2.SumMode = 'SpecifyPrecision';
    q.fimath2.SumWordLength = accWL;
    q.fimath2.SumFractionLength = accFL;
end

% [EOF]
