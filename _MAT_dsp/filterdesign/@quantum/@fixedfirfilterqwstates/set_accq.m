function [accWL, accFL] = set_accq(q, inWL, inFL, ncoeffs)
%SET_ACCQ Specify word and fraction length of the accum passed to the mexfunction.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

bits2add = 0;
if ncoeffs>=1,
    bits2add = nguardbits(ncoeffs-1);
end

if q.privStateAutoScale,
    if strcmpi(q.privAccumMode, 'FullPrecision'),
        [accWL, accFL] = fullprecisionaccum(q, inWL, inFL, bits2add);
    elseif strcmpi(q.privAccumMode, 'SpecifyPrecision'),
        accWL = q.fimath.SumWordLength;
        accFL = q.fimath.SumFractionLength;
    elseif strcmpi(q.privAccumMode, 'KeepLSB'),
        accWL = q.fimath.SumWordLength;
        accFL = inFL; % No underflow
    elseif strcmpi(q.privAccumMode, 'KeepMSB'),
        accWL = q.fimath.SumWordLength;
        accFL = keepmsbaccum(q, inWL, inFL, bits2add, accWL);
    end
else
    if strcmpi(q.privAccumMode, 'FullPrecision'),
        intStates = q.privstatewl - q.privstatefl;
        accFL = max(q.privstatefl,inFL);
        accWL = max(intStates,inWL-inFL)+1+accFL;
    elseif strcmpi(q.privAccumMode, 'SpecifyPrecision'),
        accWL = q.fimath.SumWordLength;
        accFL = q.fimath.SumFractionLength;
    elseif strcmpi(q.privAccumMode, 'KeepLSB'),
        accWL = q.fimath.SumWordLength;
        accFL = max(q.privstatefl,inFL); % No underflow
    elseif strcmpi(q.privAccumMode, 'KeepMSB'),
        accWL = q.fimath.SumWordLength;
        intStates = q.privstatewl - q.privstatefl;
        ideal_accFL = max(q.privstatefl,inFL);
        ideal_accWL = max(intStates,inWL-inFL)+1+ideal_accFL;
        accFL = accWL - max(ideal_accWL,accWL) + ideal_accFL;
    end
end

if ~isempty(accWL),
    q.fimath.SumMode = 'SpecifyPrecision';
    q.fimath.SumWordLength = accWL;
    q.fimath.SumFractionLength = accFL;
end

% [EOF]
