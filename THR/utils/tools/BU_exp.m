function [SCS] = BU_exp(ExpName, FC, OR)
% BU_exp - backup current experiment folder
%   Usage: BU_exp(ExpName, FC, OR)
%   Inputs:
%     ExpName = the name of the experiment to be backed up (e.g. 'RG12397').
%          FC = Force creation of parent folder (experimenter's folder), 
%               if doesn't exist. False by default.
%          OR = Override destination folder, if already exists. False by default.
%
%    An error if thrown if the backup failed.
%
%    See also BU_curr_exp.


if 0 == nargin
    disp('Please specify the experiment to be backed up');
    SCS = false;
    return;
elseif 1 == nargin
    forceCreate = false;
    Override = false;
elseif 2 == nargin
    forceCreate = FC;
    Override = false;
else
    forceCreate = FC;
    Override = OR;
end

%---check whether backup device is "on line"
BUdir = fullfile('Z:',compuname,'rawdata','EARLY','expdata');
if ~exist(BUdir, 'dir'),
    error(['Directory ''' BUdir ''' not found. Backup device may be off line.']);
end

%---check the target directory exists---
currExp = find(experiment, ExpName);
currExpPath = folder(currExp);
currExper = experimenter(currExp);
destPrntPath = fullfile(BUdir, currExper);
destPath = fullfile(destPrntPath, currExp.name);
if ~exist(destPrntPath,'dir') && forceCreate,
    mkdir(destPrntPath);
elseif ~exist(destPrntPath, 'dir') && ~forceCreate
    error('Experimenter does not have a folder and force flag is off');
end
if ~exist(destPath, 'dir'),
    mkdir(destPath);
elseif exist(destPath, 'dir') && ~Override,
    error('Experiment already exists for experimenter and override flag is off');
end

%---copy folder to destination---
srcPrntPath = fullfile(currExpPath, '*.*');
SCS = copyfile(srcPrntPath, destPath);
if ~SCS,
    error(['Error while copying data to ''' destPath '''.']);
end

