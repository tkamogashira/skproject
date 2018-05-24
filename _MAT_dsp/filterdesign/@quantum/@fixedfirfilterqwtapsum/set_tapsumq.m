function [tsWL tsFL] = set_tapsumq(q, inWL, inFL)
%SET_TAPSUMQ  Specify word and fraction length of the tapsum passed to the mexfunxtion.

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

bits2add = 1;
if strcmpi(q.privTapSumMode, 'FullPrecision'),
    [tsWL tsFL] = fullprecisionaccum(q, inWL, inFL, bits2add);
elseif strcmpi(q.privTapSumMode, 'SpecifyPrecision'),
    tsWL = q.TapSumfimath.SumWordLength;
    tsFL = q.TapSumfimath.SumFractionLength;
elseif strcmpi(q.privTapSumMode, 'KeepLSB'),
    tsWL = q.TapSumfimath.SumWordLength;
    tsFL = inFL;
elseif strcmpi(q.privTapSumMode, 'KeepMSB'),
    tsWL = q.TapSumfimath.SumWordLength;
    tsFL = keepmsbaccum(q, inWL, inFL, bits2add, tsWL);
end

if ~isempty(q.TapSumfimath),
    q.TapSumfimath.SumMode = 'SpecifyPrecision';
    q.TapSumfimath.SumWordLength = tsWL;
    q.TapSumfimath.SumFractionLength = tsFL;
end

% [EOF]
