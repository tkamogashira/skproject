function [p, v] = thisinfo(Ha)
%THISINFO

%   Author(s): J. Schickler
%   Copyright 1999-2002 The MathWorks, Inc.

[p, v] = adaptfilt_info(Ha);

p = {p{:}, ...
     getString(message('signal:dfilt:info:BlockLength')), ...
     getString(message('signal:dfilt:info:InitializationFactor'))};
v = {v{:}, num2str(get(Ha, 'BlockLength')), num2str(get(Ha, 'InitFactor'))};

% [EOF]
