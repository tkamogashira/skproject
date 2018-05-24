function updateinternalsettings(q)
%UPDATEINTERNALSETTINGS   

%   Author(s): V. Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.


% Full Precision Tap Sum
tapsumwl = q.privinwl + 1;
tapsumfl = q.privinfl;
q.fdfimath.SumWordLength = tapsumwl;
q.fdfimath.SumFractionLength = tapsumfl;

if strcmpi(q.privFilterInternals,'FullPrecision'),

    input_range = 2^(q.privinwl-q.privinfl-1);
    
    % Full Precision product
    prodfl = tapsumfl + q.privfdfl;
    prodwl = tapsumwl + q.privfdwl;
    q.fimath.ProductWordLength = prodwl;
    q.fimath.ProductFractionLength = prodfl;

    % Full Precision Accum
    q.fimath.SumWordLength = prodwl+1;
    q.fimath.SumFractionLength = prodfl;

    % No loss of precision at the output
    q.privoutwl = q.fimath.SumWordLength;
    q.privoutfl = q.fimath.SumFractionLength;

end


% [EOF]
