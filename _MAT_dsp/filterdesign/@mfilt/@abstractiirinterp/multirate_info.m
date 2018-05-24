function [p,v] = multirate_info(this)
%MULTIRATE_INFO   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

p = {getString(message('signal:dfilt:info:InterpolationFactor'))};
v = {sprintf('%d', get(this, 'InterpolationFactor'))};

% [EOF]
