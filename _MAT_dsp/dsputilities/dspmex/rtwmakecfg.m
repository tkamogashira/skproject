function makeInfo=rtwmakecfg()
%RTWMAKECFG adds include and source directories to make files.
%  makeInfo=RTWMAKECFG returns a structured array containing build info. 
%  Please refer to the rtwmakecfg API section in the Simulink Coder
%  documentation for details on the format of this structure.

% Copyright 1995-2010 The MathWorks, Inc.

makeInfo.includePath = { ...
    fullfile(matlabroot,'toolbox','dsp','include'), ...
    fullfile(matlabroot,'toolbox','dsp','extern','src','export','include','src'), ...
    fullfile(matlabroot,'toolbox','dsp','extern','src','export','include'), ...
    fullfile(matlabroot, 'toolbox','shared','dsp','vision','matlab','include') };

makeInfo.sourcePath = {};
