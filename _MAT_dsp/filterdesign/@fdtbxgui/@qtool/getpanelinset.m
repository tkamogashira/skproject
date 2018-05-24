function paneloffset = getpanelinset(this)
%GETPANELINSET   Returns a 4 element vector for the panel inset.
%   GETPANELINSET(H) Returns a 4 element vector [x y w h] for the panel
%   offset.  Returns [0 30 0 0].

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

sz = gui_sizes(this);
paneloffset = [sz.ffs 30*sz.pixf sz.ffs 2*sz.ffs];

% [EOF]
