function [p, v] = multirate_info(Hm)
%MULTIRATE_INFO

%   Author(s): J. Schickler
%   Copyright 1999-2002 The MathWorks, Inc.

[p, v] = firinterp_info(Hm);

% [EOF]
