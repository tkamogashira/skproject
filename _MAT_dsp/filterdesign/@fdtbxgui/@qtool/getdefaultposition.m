function pos = getdefaultposition(this)
%GETDEFAULTPOSITION   Returns the default position.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

sz = gui_sizes(this);

pos = [10 10 730 248]*sz.pixf;

% [EOF]
