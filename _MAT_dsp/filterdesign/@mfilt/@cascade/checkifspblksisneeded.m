function checkifspblksisneeded(this)
%CHECKIFSPBLKSISNEEDED   

%   Copyright 2005-2011 The MathWorks, Inc.

% Check if DSP System Toolbox is installed
[b, errstr, errid, msgobj] = isspblksinstalled;
if ~b
    error(msgobj);
end


% [EOF]
