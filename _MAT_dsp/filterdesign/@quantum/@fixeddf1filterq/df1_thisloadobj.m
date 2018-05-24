function df1_thisloadobj(this, s)
%DF1_THISLOADOBJ   

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

this.OutputWordLength = s.OutputWordLength;
this.OutputFracLength = s.OutputFracLength;

this.ProductMode = s.ProductMode;
switch lower(this.ProductMode)
    case 'specifyprecision'
        set(this, ...
            'ProductWordLength', s.ProductWordLength, ...
            'NumProdFracLength', s.NumProdFracLength, ...
            'DenProdFracLength', s.DenProdFracLength);
    case {'keeplsb', 'keepmsb'}
        this.ProductWordLength = s.ProductWordLength;
end

this.AccumMode = s.AccumMode;
switch lower(this.AccumMode)
    case 'specifyprecision'
        set(this, ...
            'AccumWordLength',    s.AccumWordLength, ...
            'NumAccumFracLength', s.NumAccumFracLength, ...
            'DenAccumFracLength', s.DenAccumFracLength, ...
            'CastBeforeSum',      s.CastBeforeSum);
    case {'keeplsb', 'keepmsb'}
        set(this, ...
            'AccumWordLength', s.AccumWordLength, ...
            'CastBeforeSum',   s.CastBeforeSum);
end

if ~this.CoeffAutoScale
    set(this, ...
        'NumFracLength', s.NumFracLength, ...
        'DenFracLength', s.DenFracLength);
end

% [EOF]
