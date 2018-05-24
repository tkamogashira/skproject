function [p, v] = multirate_info(Hm)
%THISINFO

%   Author(s): J. Schickler
%   Copyright 1999-2002 The MathWorks, Inc.

[p, v] = firinterp_info(Hm);

p = {p{:}, getString(message('signal:dfilt:info:BlockLength'))};
v = {v{:}, num2str(get(Hm, 'BlockLength'))};

% [EOF]
