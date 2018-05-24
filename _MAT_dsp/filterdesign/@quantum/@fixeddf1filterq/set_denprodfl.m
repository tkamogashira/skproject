function prodfl = set_denprodfl(this, prodfl)
%SET_DENPRODFL   PreSet function for the 'DenProdFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if ~strcmpi(this.ProductMode, 'SpecifyPrecision')
    siguddutils('readonlyerror', 'DenProdFracLength', 'ProductMode', 'SpecifyPrecision');
end

try
    this.fimath2.ProductFractionLength = prodfl;
catch
    error(message('dsp:quantum:fixeddf1filterq:set_denprodfl:MustBeInteger'));
end

% Update any downstream automagic.
updateinternalsettings(this);

% Store nothing here to avoid duplicate storage.
prodfl = [];

% [EOF]
