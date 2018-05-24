function updateinternalsettings(q)
%UPDATEINTERNALSETTINGS   

%   Author(s): V. Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.

% Full Precision Tap Sum
tapsumwl = q.privinwl + 1;
tapsumfl = q.privinfl;
q.TapSumfimath.SumWordLength = tapsumwl;
q.TapSumfimath.SumFractionLength = tapsumfl;

if strcmpi(q.privFilterInternals,'FullPrecision'),

    input_range = 2^(tapsumwl-tapsumfl-1);
    
    % Full Precision product
    prodfl = tapsumfl + q.privcoefffl;
    prodwl = tapsumwl + q.privcoeffwl;
    if ~isempty(q.maxprod),
        aux = fi(input_range*q.maxprod);
        aux = prodfl + aux.WordLength - aux.FractionLength;
        if aux>0, prodwl = aux; end
    end
    q.fimath.ProductWordLength = prodwl;
    q.fimath.ProductFractionLength = prodfl;

    % Full Precision Accum
    accumfl = prodfl;
    accumwl = prodwl;
    if ~isempty(q.ncoeffs),
        accumwl = accumwl + nguardbits(q.ncoeffs);
    end
    if ~isempty(q.maxsum),
        aux = fi(input_range*q.maxsum);
        aux = accumfl + aux.WordLength - aux.FractionLength;
        if aux>0, accumwl = aux; end
    end
    q.fimath.SumWordLength = accumwl;
    q.fimath.SumFractionLength = accumfl;

    % No loss of precision at the output
    q.privoutwl = accumwl;
    q.privoutfl = accumfl;

end
% [EOF]
