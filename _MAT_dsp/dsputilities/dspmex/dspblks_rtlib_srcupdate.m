function makeInfo = dspblks_rtlib_srcupdate(makeInfo)
%DSPBLKS_RTLIB_SRCUPDATE Update common fields in the makeInfo structure
%  used by DSP System Toolbox (and dependent toolboxes) to control
%  building and linking generated code using the DSP Run Time Library.
%    
%  This function updates the following fields:
%
%     makeInfo.sourcePath
%     makeInfo.includePath
%    
%  This function sets the following fields:
%
%     makeInfo.library

% Copyright 1995-2010 The MathWorks, Inc.

% For Linking in with DSP System Toolbox Run-time library
rtDir = fullfile(matlabroot,'toolbox','dsp','extern','src');
if exist(rtDir,'dir')
    % dsp runtime function sources
    rtSubDirs = {'dspeph'};
    rtSubDirs = cellfun(@(x)({fullfile(rtDir,x)}), rtSubDirs);
    makeInfo.sourcePath = {makeInfo.sourcePath{:} ...
        rtSubDirs{:}};
    if isfield(makeInfo,'includePath')     
        makeInfo.includePath = { makeInfo.includePath{:}, ...
            fullfile(matlabroot,'toolbox','dsp','extern','src'), ...
            fullfile(matlabroot, 'toolbox','shared','dsp','vision','matlab','include')};
    end
else
    makeInfo.sourcePath = { makeInfo.sourcePath{:}};
end

arch = computer('arch');

makeInfo.precompile = 1;

if dsptargetsupportsdll(get_param(0, 'CurrentSystem'))
    makeInfo.library(1).Name = 'dsp_dyn_rt';
else
    makeInfo.library(1).Name = 'dsp_rt';
end

makeInfo.library(end).Location = ...
    fullfile(matlabroot,'toolbox','dsp', 'lib', arch);
if exist(rtDir,'dir')
    makeInfo.library(1).Modules  = getModules(rtSubDirs);
else
    makeInfo.library(1).Modules  = '';
end

function modules = getModules(dirs)
modules = {};
for i=1:length(dirs)
    files = dir([dirs{i} '/*.c']);
    modules = [modules(:)' strrep({files.name},'.c','')];
end
  
% [EOF]
