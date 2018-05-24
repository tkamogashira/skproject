function abstractapwcorr_thisloadobj(this, s)
%ABSTRACTAPWCORR_THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

abstractap_thisloadobj(this, s);

set(this, ...
    'CorrelationCoeffs', s.CorrelationCoeffs, ...
    'ErrorStates',       s.ErrorStates, ...
    'EpsilonStates',     s.EpsilonStates);

% [EOF]
