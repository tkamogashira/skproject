function h = genmcode(this)
%GENMCODE   Generate MATLAB code.

%   Author(s): J. Schickler
%   Copyright 1999-2009 The MathWorks, Inc.

h = fir_genmcode(this);

if ~this.CoeffAutoScale
    h.add(', ...\n    ''NumFracLength'', %d', this.NumFracLength);
end

% [EOF]
