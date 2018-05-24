function loadreferencecoefficients(this, s)
%LOADREFERENCECOEFFICIENTS   Load the reference coefficients.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

if s.version.number == 0
    this.Numerator = s.Numerator;
else
    this.Numerator = formnum(this, s.refpolym, s.ncoeffs);
end

% [EOF]
