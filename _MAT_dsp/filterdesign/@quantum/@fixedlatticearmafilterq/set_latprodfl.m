function latprodfl = set_latprodfl(this, latprodfl)
%SET_LATPRODFL   PreSet function for the 'LatticeProdFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if ~strcmpi(this.ProductMode, 'SpecifyPrecision')
    siguddutils('readonlyerror', 'LatticeProdFracLength', 'ProductMode', 'SpecifyPrecision');
end

try
    this.fimath.ProductFractionLength = latprodfl;
catch 
    error(message('dsp:quantum:fixedlatticearmafilterq:set_latprodfl:MustBeInteger'));
end

% Update downstream automagic.
updateinternalsettings(this);

% Store nothing to avoid duplication.
latprodfl = [];

% [EOF]
