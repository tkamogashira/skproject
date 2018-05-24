function fir_thisloadobj(this, s)
%FIR_THISLOADOBJ   Load this object

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

nonscalar_thisloadobj(this, s);

if strcmpi(lower(this.ProductMode), 'specifyprecision')
    this.ProductFracLength = s.ProductFracLength;
end

if strcmpi(lower(this.AccumMode), 'specifyprecision')
    this.AccumFracLength = s.AccumFracLength;
end

if ~this.CoeffAutoScale
    set(this, 'NumFracLength', s.NumFracLength);
end

% [EOF]
