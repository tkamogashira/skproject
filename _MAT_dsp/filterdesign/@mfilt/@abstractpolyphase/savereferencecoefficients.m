function s = savereferencecoefficients(this)
%SAVEREFERENCECOEFFICIENTS   Save the reference coefficients.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

s.refpolym = get(this, 'refpolym');

% We need to save the ncoeffs so that we can properly reconstruct the
% Numerator from the Reference Polyphase Matrix.
s.ncoeffs  = get(this, 'ncoeffs');

% [EOF]
