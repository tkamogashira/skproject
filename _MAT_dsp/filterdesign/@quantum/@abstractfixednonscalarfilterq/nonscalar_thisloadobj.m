function nonscalar_thisloadobj(this, s)
%NONSCALAR_THISLOADOBJ   

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

out_thisloadobj(this, s);

set(this, ...
    'ProductMode', s.ProductMode, ...
    'AccumMode',   s.AccumMode);

if ~strcmpi(this.ProductMode, 'fullprecision')
    this.ProductWordLength = s.ProductWordLength;
end

if ~strcmpi(this.AccumMode, 'fullprecision')
    set(this, ...
        'AccumWordLength', s.AccumWordLength, ...
        'CastBeforeSum',   s.CastBeforeSum);
end

% [EOF]
