function updateinternalsettings(q)
%UPDATEINTERNALSETTINGS   

%   Author(s): V. Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.

input_range = 2^(q.privinwl-q.privinfl-1);

if strcmpi(q.privFilterInternals,'FullPrecision'),

    % Full Precision product
    prodfl = q.privinfl + q.privcoefffl;
    prodwl = q.privinwl + q.privcoeffwl;
    if ~isempty(q.maxprod),
        aux = fi(input_range*q.maxprod);
        aux = prodfl + aux.WordLength - aux.FractionLength;
        if aux>0, prodwl = aux; end
    end
    q.fimath.ProductWordLength = prodwl;
    q.PolyAccfimath.ProductWordLength = prodwl;
    q.fimath.ProductFractionLength = prodfl;
    q.PolyAccfimath.ProductFractionLength = prodfl;
    
    % Full Precision Accum
    accumfl = prodfl;
    accumwl = prodwl;
    if ~isempty(q.ncoeffs),
        accumwl = accumwl + nguardbits(q.ncoeffs);
    end
    if ~isempty(q.maxsum),
        aux = fi(input_range*q.maxsum(2));
        aux = accumfl + aux.WordLength - aux.FractionLength;
        if aux>0, accumwl = aux; end
    end
    q.fimath.SumWordLength = accumwl;
    q.fimath.SumFractionLength = accumfl;
    
    q.StateWordLength = accumwl;
    q.StateFracLength = accumfl;

    % No loss of precision at the ouptput
    q.privoutwl = accumwl;
    q.privoutfl = accumfl;

end

% Full Precision polyphase accum
polyaccumfl = q.ProductFracLength;
polyaccumwl = q.ProductWordLength;
if ~isempty(q.nphases),
    polyaccumwl = polyaccumwl + nguardbits(q.nphases);
end
if ~isempty(q.maxsum),
    aux = polyaccumfl + nextpow2(input_range*q.maxsum(1)) + 1;
    if aux>0, polyaccumwl = aux; end
end
q.PolyAccWordLength = polyaccumwl;
q.PolyAccFracLength = polyaccumfl;

% [EOF]
