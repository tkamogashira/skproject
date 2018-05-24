function thisreset(h)
%THISREST Resets the states of a CIC filter. 

%   This should be a private method.

%   Author: P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

error(nargchk(1,1,nargin,'struct'));

% Reset the private memory saved in the object.
privthisreset(h);

% [EOF]
