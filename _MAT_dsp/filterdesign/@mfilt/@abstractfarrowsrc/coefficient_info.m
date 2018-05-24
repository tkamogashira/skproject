function [p,v] = coefficient_info(this)
%MULTIRATE_INFO   

%   Copyright 2005 The MathWorks, Inc.

p = {getString(message('signal:dfilt:info:InterpolationFactor')), ...
    getString(message('signal:dfilt:info:DecimationFactor')), ...
    getString(message('signal:dfilt:info:FilterLength'))};
coeffs = coefficients(this);

v = {sprintf('%d', get(this, 'InterpolationFactor')), ...
    sprintf('%d', get(this, 'DecimationFactor')), ...
    sprintf('%d', length(coeffs{1}))};


% [EOF]
