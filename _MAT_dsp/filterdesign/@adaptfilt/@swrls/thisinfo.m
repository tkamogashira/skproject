function [p, v] = thisinfo(Ha)
%THISINFO

%   Author(s): J. Schickler
%   Copyright 1999-2002 The MathWorks, Inc.

[p, v] = abstractrls_info(Ha);

p = {p{:}, ...
     getString(message('signal:dfilt:info:SlidingWindowBlockLength'))};
v = {v{:}, num2str(get(Ha, 'SWBlockLength'))};

% [EOF]
