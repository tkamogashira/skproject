function prodfl = set_numprodfl(this, prodfl)
%SET_NUMPRODFL   PreSet function for the 'NumProdFracLength'.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if ~strcmpi(this.ProductMode, 'SpecifyPrecision')
    siguddutils('readonlyerror', 'NumProdFracLength', 'ProductMode', 'SpecifyPrecision');
end

try
    this.fimath.ProductFractionLength = prodfl;
catch
    error(message('dsp:quantum:fixeddf1filterq:set_numprodfl:MustBeInteger'));
end

% Update any downstream automagic.
updateinternalsettings(this);

% Store nothing to avoid duplication.
prodfl = [];

% [EOF]
