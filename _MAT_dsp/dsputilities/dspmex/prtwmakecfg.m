function makeInfo=prtwmakecfg()
%PRTWMAKECFG Add include and source directories to make files.
%  Note:  This file is only used when precompiling static libraries.
%         rtwmakecfg.m is used when building models.
%  makeInfo=PRTWMAKECFG returns a structured array containing
%  following fields:
%
%     makeInfo.includePath - cell array containing additional include
%                            directories. Those directories will be 
%                            expanded into include instructions of the
%                            generated make files.
%     
%     makeInfo.sourcePath  - cell array containing additional source
%                            directories. Those directories will be
%                            expanded into rules of the generated make
%                            files.
%
%     makeInfo.library     - structure containing additional runtime library
%                            names and module objects.  This information
%                            will be expanded into rules of the generated make
%                            files.

% Copyright 1995-2010 The MathWorks, Inc.

rtDir = fullfile(matlabroot,'toolbox','dsp','extern','src');
  
makeInfo.includePath = { ...
        fullfile(matlabroot,'toolbox','dsp','include'), ...
        fullfile(matlabroot, 'toolbox','shared','dsp','vision','matlab','include')};

if (exist(rtDir)==7)
	rtSubDirs = getfilesbytype(rtDir, 'd');
	makeInfo.sourcePath = { rtSubDirs{:} };
else
	makeInfo.sourcePath = {};
end

makeInfo.precompile = 1;
makeInfo.library(1).Name     = 'dsp_rt';
makeInfo.library(1).Location = ...
        fullfile(matlabroot,'toolbox','dsp','lib',computer('arch'));
if (exist(rtDir)==7)
    makeInfo.library(1).Modules  = strrep(getfilesbytype(rtDir, '*.c'),'.c','');
else
    makeInfo.library(1).Modules  = '';
end

% Function: getfilesbytype =====================================================
% Abdtract:
%      Returns a cell array with filenames that maches the 'pattern' (eg. *.c)
%      within the given 'directory' tree.
%      Returns a cell array of directories if the 'pattern' equals 'd'.
%
function cellFiles = getfilesbytype(directory, pattern)
  cellFiles = {};
  if pattern == 'd'
    bDir = 1;
    localPattern = '*';
  else
    bDir = 0;
    localPattern = pattern;
  end
  currDir = pwd;
  
  cd(directory);
  
  strDir = dir;
  for i=1:length(strDir)
    if strDir(i).isdir & strDir(i).name(1) ~= '.' & strDir(i).name(1) ~= 'CVS'
      if bDir
	    cellFiles{end+1} = fullfile(pwd, strDir(i).name);
      else
          tempCell = getcmodules(strDir(i).name);
          cellFiles = {cellFiles{:}, tempCell{:}};
      end
    end
  end
  
  cd(currDir);
  
% -------------------------------------------------------------------------
function cellFiles = getcmodules(directory)

  cellFiles = {};
  files = dir([directory '/*.c']);
  for i=1:length(files)
	cellFiles{end+1} = files(i).name;
  end
  
% [EOF] prtwmakecfg.m
