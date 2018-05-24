function [p,v] = multirate_info(this)
%MULTIRATE_INFO   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

p = {getString(message('signal:dfilt:info:DecimationFactor'))};
v = {sprintf('%d', get(this, 'DecimationFactor'))};

% [EOF]
