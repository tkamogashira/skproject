function [p, v] = multirate_info(Hm)
%THISINFO

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

[p, v] = abstractcic_info(Hm);

p = {p{:},getString(message('signal:dfilt:info:DecimationFactor'))};
v = {v{:}, sprintf('%d', get(Hm, 'DecimationFactor'))};

% [EOF]
