function dffir_thisloadobj(this, s)
%DFFIR_THISLOADOBJ   Load this object

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

adapt_thisloadobj(this, s);

set(this, ...
    'Coefficients', s.Coefficients, ...
    'States',       s.States);

% [EOF]
