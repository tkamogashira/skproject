function h = sos_genmcode(this)
%SOS_GENMCODE   Generate MATLAB code.

%   Author(s): J. Schickler
%   Copyright 1999-2009 The MathWorks, Inc.

h = iir_genmcode(this);

if ~this.CoeffAutoScale
    h.add(', ...\n    ''ScaleValueFracLength'', %d', this.ScaleValueFracLength);
end

% [EOF]
