function Hm = tofirinterp(this)
%TOFIRINTERP   Convert to an FIR Interpolator.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

Hm = mfilt.firinterp;

set(Hm, 'FilterStructure', 'Direct-Form FIR Polyphase Interpolator', ...
    'InterpolationFactor', this.InterpolationFactor,...
    'Numerator', this.Numerator);

% [EOF]
