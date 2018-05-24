function prodwl = set_prodwl(this, prodwl)
%SET_PRODWL   PreSet function for the 'ProductWordLength'.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if strcmpi(this.ProductMode, 'FullPrecision')
    siguddutils('readonlyerror', 'ProductWordLength', 'ProductMode', 'FullPrecision', false);
end

try
    this.fimath.ProductWordLength = prodwl;
    this.fimath2.ProductWordLength = prodwl;
catch 
    error(message('dsp:quantum:fixeddf1filterq:set_prodwl:MustBePosInteger'));
end

% Update any downstream automagic.
updateinternalsettings(this);

% Store nothing to avoid duplication.
prodwl = [];

% [EOF]
