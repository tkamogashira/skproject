function [p, v] = multirate_info(Hm)
%THISINFO

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

p = {getString(message('signal:dfilt:info:InterpolationFactor')), ...
    getString(message('signal:dfilt:info:DecimationFactor'))};
v = {sprintf('%d', Hm.RateChangeFactors(1)), ...
    sprintf('%d', Hm.RateChangeFactors(2))};

% [EOF]
