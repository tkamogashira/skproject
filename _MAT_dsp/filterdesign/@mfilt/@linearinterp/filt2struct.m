function s = filt2struct(this)
%FILT2STRUCT   Returns a structure representation of the filter.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

s.class = class(this);
s.InterpolationFactor = this.InterpolationFactor;

% [EOF]
