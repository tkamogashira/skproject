function [p, v] = firinterp_info(Hm)
%FIRINTERP_INFO

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

p = {getString(message('signal:dfilt:info:InterpolationFactor'))};
v = {sprintf('%d', get(Hm, 'InterpolationFactor'))};

% [EOF]
