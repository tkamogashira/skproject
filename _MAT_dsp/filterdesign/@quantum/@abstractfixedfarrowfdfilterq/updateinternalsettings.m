function updateinternalsettings(q)
%UPDATEINTERNALSETTINGS   

%   Author(s): V. Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.


if strcmpi(q.privFilterInternals,'FullPrecision'),

    input_range = 2^(q.privinwl-q.privinfl-1);
    
    % Full Precision product
    prodfl = q.privinfl + q.privcoefffl;
    prodwl = q.privinwl + q.privcoeffwl;
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
        accumwl = accumwl + nguardbits(q.ncoeffs(1));
    end
    if ~isempty(q.maxsum),
        aux = fi(input_range*q.maxsum);
        aux = accumfl + aux.WordLength - aux.FractionLength;
        if aux>0, accumwl = aux; end
    end
    q.fimath.SumWordLength = accumwl;
    q.fimath.SumFractionLength = accumfl;

    % Full Precision Multiplicand
    nphases = 1;
    if length(q.ncoeffs)>1,
        nphases = q.ncoeffs(2);
    end
    multfl = accumfl;
    multwl = accumwl;
    for ii=3:nphases,
        multfl = max(multfl+q.privfdfl,accumfl);
        intbits = max(multwl+q.privfdwl-multfl,accumwl-accumfl);
        multwl = multfl + intbits;
    end
    q.privmultfl = multfl;
    q.privmultwl = multwl + nguardbits(max(nphases-1,0));
    q.fdfimath.SumWordLength = q.privmultwl;
    q.fdfimath.SumFractionLength = q.privmultfl;

    % Full Precision FD product
    q.fdfimath.ProductWordLength = q.privfdwl+q.privmultwl;
    q.fdfimath.ProductFractionLength = q.privfdfl+q.privmultfl;
  
    % No loss of precision at the output
    q.privoutfl = max(accumfl,q.fdfimath.ProductFractionLength);
    q.privoutwl = q.OutputFracLength + max(accumwl-accumfl,...
        q.fdfimath.ProductWordLength-q.fdfimath.ProductFractionLength)+1;

end




% [EOF]
