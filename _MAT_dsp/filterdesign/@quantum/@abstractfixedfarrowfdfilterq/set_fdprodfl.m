function fdprodfl = set_fdprodfl(this, fdprodfl)
%SET_FDPRODFL   

%   Author(s): V. Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.

if strcmpi(this.FilterInternals,'FullPrecision'),
    error(siguddutils('readonlyerror', 'FDProdFracLength', 'FilterInternals', 'SpecifyPrecision'));
end

try
    this.fdfimath.ProductFractionLength = fdprodfl;
catch
    error(message('dsp:quantum:abstractfixedfarrowfdfilterq:set_fdprodfl:MustBeInteger'));
end
fdprodfl = [];

% [EOF]
