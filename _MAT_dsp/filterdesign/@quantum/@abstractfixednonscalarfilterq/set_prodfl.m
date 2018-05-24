function prodfl = set_prodfl(this, prodfl, prop)
%SET_PRODFL   PreSet function for the 'ProductFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if nargin < 3
    prop = 'ProductFracLength';
end

if ~strcmpi(this.ProductMode, 'SpecifyPrecision')
    siguddutils('readonlyerror', prop, 'ProductMode', 'SpecifyPrecision');
end

try
    this.fimath.ProductFractionLength = prodfl;
catch
    error(message('dsp:quantum:abstractfixednonscalarfilterq:set_prodfl:MustBeInteger', prop));
end

% Update any downstream automagic.
updateinternalsettings(this);

prodfl = [];

% [EOF]
