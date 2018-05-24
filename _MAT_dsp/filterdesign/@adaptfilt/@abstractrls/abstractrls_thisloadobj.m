function abstractrls_thisloadobj(this, s)
%ABSTRACTRLS_THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

dffir_thisloadobj(this, s);

set(this, 'ForgettingFactor', s.ForgettingFactor);

% [EOF]
