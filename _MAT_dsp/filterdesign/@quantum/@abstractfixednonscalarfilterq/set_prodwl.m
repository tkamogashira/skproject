function prodwl = set_prodwl(this, prodwl)
%SET_PRODWL   PreSet function for the 'ProductWordLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if strcmpi(this.ProductMode, 'FullPrecision')
    siguddutils('readonlyerror', 'ProductWordLength', 'ProductMode', ...
        'FullPrecision', false);
end

try
    this.fimath.ProductWordLength = prodwl;
    thisset_prodwl(this, prodwl);
catch
    error(message('dsp:quantum:abstractfixednonscalarfilterq:set_prodwl:MustBePosInteger'));
end
updateinternalsettings(this);
prodwl = [];

% [EOF]
