function checkrequiredlicense(Hd,hTar)
%CHECKREQUIREDLICENSE check required license for realizemdl

%   Copyright 2009-2011 The MathWorks, Inc.

% Check if Simulink is installed
[b, errstr, errid, msgobj] = issimulinkinstalled;
if ~b
    error(msgobj);
end

% Check if DSP System Toolbox is installed
[b, errstr, errid, msgobj] = isspblksinstalled;
if ~b
    error(msgobj);
end

% [EOF]
