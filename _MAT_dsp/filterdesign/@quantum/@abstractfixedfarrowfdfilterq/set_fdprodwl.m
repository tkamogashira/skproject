function fdprodwl = set_fdprodwl(this, fdprodwl)
%SET_FDPRODWL   

%   Author(s): V. Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.

if strcmpi(this.FilterInternals,'FullPrecision'),
    error(siguddutils('readonlyerror', 'FDProdWordLength', 'FilterInternals', 'SpecifyPrecision'));
end

try
    this.fdfimath.ProductWordLength = fdprodwl;
catch
    error(message('dsp:quantum:abstractfixedfarrowfdfilterq:set_fdprodwl:MustBePosInteger'));
end
fdprodwl = [];

% [EOF]
