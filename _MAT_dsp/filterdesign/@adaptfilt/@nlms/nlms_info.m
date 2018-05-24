function [p, v] = nlms_info(Ha)
%THISINFO

% Copyright 1999-2002 The MathWorks, Inc.

[p, v] = lms_info(Ha);

p = {p{:}, getString(message('signal:dfilt:info:Offset'))};
v = {v{:}, num2str(get(Ha, 'Offset'))};

% [EOF]
