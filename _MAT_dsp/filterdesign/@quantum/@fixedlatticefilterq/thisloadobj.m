function thisloadobj(this, s)
%THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

lattice_thisloadobj(this, s);

if strcmp(this.ProductMode, 'SpecifyPrecision')
    set(this, 'ProductFracLength', s.ProductFracLength);
end

if strcmp(this.AccumMode, 'SpecifyPrecision')
    set(this, 'AccumFracLength', s.AccumFracLength);
end

% [EOF]
