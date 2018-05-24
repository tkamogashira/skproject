function denprodfl = set_denprodfl(this, denprodfl)
%SET_DENPRODFL   PreSet function for the 'DenProdFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if ~strcmpi(this.ProductMode, 'SpecifyPrecision')
    siguddutils('readonlyerror', 'DenProdFracLength', 'ProductMode', 'SpecifyPrecision');
end

try
    this.fimath2.ProductFractionLength = denprodfl;
catch 
    error(message('dsp:quantum:abstractfixediirfilterq:set_denprodfl:MustBeInteger'));
end

% Update any downstream automagic.
updateinternalsettings(this);

% Store nothing so we don't have duplicate storage.
denprodfl = [];

% [EOF]
