function s = filt2struct(this)
%FILT2STRUCT   Returns a structure representation of the filter.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

s.class               = 'mfilt.firinterp';
s.InterpolationFactor = this.InterpolationFactor;
s.Numerator           = this.Numerator;

% [EOF]
