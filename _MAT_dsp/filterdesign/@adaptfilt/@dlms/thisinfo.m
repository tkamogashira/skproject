function [p, v] = thisinfo(Ha)
%THISINFO

%   Author(s): J. Schickler
%   Copyright 1999-2002 The MathWorks, Inc.

[p, v] = lms_info(Ha);

p = {p{:}, getString(message('signal:dfilt:info:UpdateDelay'))};
v = {v{:}, num2str(get(Ha, 'Delay'))};

% [EOF]
