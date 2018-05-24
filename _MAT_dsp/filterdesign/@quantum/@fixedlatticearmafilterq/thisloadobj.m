function thisloadobj(this, s)
%THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

lattice_thisloadobj(this, s);

if ~this.CoeffAutoScale
    set(this, 'LadderFracLength', s.LadderFracLength);
end

if strcmpi(lower(this.ProductMode), 'specifyprecision')
    set(this, ...
        'LatticeProdFracLength', s.LatticeProdFracLength, ...
        'LadderProdFracLength',  s.LadderProdFracLength);
end

if strcmpi(lower(this.AccumMode), 'specifyprecision')
    set(this, ...
        'LatticeAccumFracLength', s.LatticeAccumFracLength, ...
        'LadderAccumFracLength',  s.LadderAccumFracLength);
end

% [EOF]
