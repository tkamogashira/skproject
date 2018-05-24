function [p, v] = baseclass_info(Ha)
%BASECLASS_INFO

%   Author(s): J. Schickler
%   Copyright 1999-2002 The MathWorks, Inc.

p = {getString(message('signal:dfilt:info:Algorithm'))};
v = {get(Ha, 'Algorithm')};

% [EOF]
