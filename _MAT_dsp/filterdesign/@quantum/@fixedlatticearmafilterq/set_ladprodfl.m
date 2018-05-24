function ladprodfl = set_ladprodfl(this, ladprodfl)
%SET_LADPRODFL   PreSet function for the 'LadderProdFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if ~strcmpi(this.ProductMode, 'SpecifyPrecision')
    siguddutils('readonlyerror', 'LadderProdFracLength', 'ProductMode', 'SpecifyPrecision');
end

try
    this.fimath2.ProductFractionLength = ladprodfl;
catch 
    error(message('dsp:quantum:fixedlatticearmafilterq:set_ladprodfl:MustBeInteger'));
end

% Update downstream automagic.
updateinternalsettings(this);

% Store nothing to avoid duplication.
ladprodfl = [];

% [EOF]
