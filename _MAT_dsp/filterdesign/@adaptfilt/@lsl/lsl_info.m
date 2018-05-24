function [p, v] = lsl_info(Ha)
%LSL_INFO

%   Author(s): J. Schickler
%   Copyright 1999-2002 The MathWorks, Inc.

[p, v] = abstractrls_info(Ha);

p = {p{:}, ...
     getString(message('signal:dfilt:info:InitFactor'))};
v = {v{:}, num2str(get(Ha, 'InitFactor'))};

% [EOF]
