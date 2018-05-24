function [p, v] = adaptfilt_info(Ha)
%ADAPTFILT_INFO

%   Author(s): J. Schickler
%   Copyright 1999-2002 The MathWorks, Inc.

[p, v] = baseclass_info(Ha);
p = {p{:}, getString(message('signal:dfilt:info:FilterLength'))};
v = {v{:}, num2str(get(Ha, 'FilterLength'))};

% [EOF]
