function [accWL, accFL] = set_denaccq(q, inWL, inFL, ncoeffs)
%SET_DENACCQ Specify word and fraction length of the accum passed to the mexfunction.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

bits2add = 0;
if ncoeffs>=1,
    bits2add = nguardbits(ncoeffs-1);
end

if q.privStateAutoScale,
    if strcmpi(q.privAccumMode, 'FullPrecision'),
        nintbits = inWL-inFL;
        dintbits = inWL-q.fimath2.ProductFractionLength;
        inFL = max(inFL,q.fimath2.ProductFractionLength);
        inWL = inFL + max(nintbits,dintbits);
        [accWL, accFL] = fullprecisionaccum(q, inWL, inFL, bits2add);
    elseif strcmpi(q.privAccumMode, 'SpecifyPrecision'),
        accWL = q.fimath2.SumWordLength;
        accFL = q.fimath2.SumFractionLength;
    elseif strcmpi(q.privAccumMode, 'KeepLSB'),
        accWL = q.fimath2.SumWordLength;
        accFL = max(inFL,q.fimath2.ProductFractionLength);
    elseif strcmpi(q.privAccumMode, 'KeepMSB'),
        accWL = q.fimath2.SumWordLength;
        nintbits = inWL-inFL;
        dintbits = inWL-q.fimath2.ProductFractionLength;
        inFL = max(inFL,q.fimath2.ProductFractionLength);
        inWL = inFL + max(nintbits,dintbits);
        accFL = keepmsbaccum(q, inWL, inFL, bits2add, accWL);
    end
else
    if strcmpi(q.privAccumMode, 'FullPrecision'),
        intnacc = q.fimath.SumWordLength - q.fimath.SumFractionLength;
        accFL = max(q.fimath.SumFractionLength,inFL);
        accWL = max(intnacc,inWL-inFL)+1+accFL;
    elseif strcmpi(q.privAccumMode, 'SpecifyPrecision'),
        accWL = q.fimath2.SumWordLength;
        accFL = q.fimath2.SumFractionLength;
    elseif strcmpi(q.privAccumMode, 'KeepLSB'),
        accWL = q.fimath2.SumWordLength;
        accFL = max(inFL,q.fimath.SumFractionLength); % No underflow
    elseif strcmpi(q.privAccumMode, 'KeepMSB'),
        accWL = q.fimath2.SumWordLength;
        intnacc = max(q.fimath.ProductWordLength - q.fimath.ProductFractionLength, ...
            q.privstatewl-q.privstatefl)+1;
        ideal_accFL = max(q.fimath.SumFractionLength,inFL);
        ideal_accWL = max(intnacc,inWL-inFL)+1+ideal_accFL;
        accFL = ideal_accFL - max(ideal_accWL-accWL,0);
    end
end

if ~isempty(accWL),
    q.fimath2.SumMode = 'SpecifyPrecision';
    q.fimath2.SumWordLength = accWL;
    q.fimath2.SumFractionLength = accFL;
end

% [EOF]
