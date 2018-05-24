function iir_thisloadobj(this, s)
%IIR_THISLOADOBJ   

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

nonscalar_thisloadobj(this, s);

if ~this.CoeffAutoScale
    this.NumFracLength = s.NumFracLength;
    this.DenFracLength = s.DenFracLength;
end

if strcmpi(this.ProductMode, 'specifyprecision')
    this.NumProdFracLength = s.NumProdFracLength;
    this.DenProdFracLength = s.DenProdFracLength;
end

if strcmpi(this.AccumMode, 'specifyprecision')
    this.NumAccumFracLength = s.NumAccumFracLength;
    this.DenAccumFracLength = s.DenAccumFracLength;
end

% [EOF]
