function [p, v] = coefficient_info(this)
%COEFFICIENT_INFO   Get the coefficient information for this filter.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

p = {getString(message('signal:dfilt:info:InterpolationFactor'))};
v = {sprintf('%d', get(this, 'InterpolationFactor'))};

% [EOF]
