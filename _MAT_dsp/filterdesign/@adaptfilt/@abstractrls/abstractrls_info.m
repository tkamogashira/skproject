function [p, v] = abstractrls_info(Ha)
%ABSTRACTRLS_INFO

%   Author(s): J. Schickler
%   Copyright 1999-2002 The MathWorks, Inc.

[p, v] = adaptfilt_info(Ha);

p = {p{:}, getString(message('signal:dfilt:info:ForgettingFactor'))};
v = {v{:}, num2str(get(Ha, 'ForgettingFactor'))};

% [EOF]
