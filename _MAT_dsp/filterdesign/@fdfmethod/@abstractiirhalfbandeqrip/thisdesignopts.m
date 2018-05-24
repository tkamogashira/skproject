function s = thisdesignopts(this, s)
%THISDESIGNOPTS   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

s = rmfield(s, 'DesignMode');

% [EOF]
