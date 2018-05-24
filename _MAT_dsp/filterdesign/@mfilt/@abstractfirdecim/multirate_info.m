function [p, v] = multirate_info(Hm)
%THISINFO

%   Author(s): J. Schickler
%   Copyright 1999-2002 The MathWorks, Inc.

p = {getString(message('signal:dfilt:info:DecimationFactor'))};
v = {num2str(get(Hm, 'DecimationFactor'))};

% [EOF]
