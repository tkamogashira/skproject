function SetPsychtoolboxPath
% function SetPsychtoolboxPath
%
% Set the psychtoolbox path to include the Psychtoolbox directory and all folders under it,
% but only if the Psychtoolbox folder exists and is located within Matlab's toolbox
% directory. Because SetPsychtoolboxPath checks to see if the Psychtoolbox folder exists 
% before setting the path, SetPsychtoolboxPath can be called automatically when Matlab is 
% started, regardless of whether the Psychtoolbox folder exists.  
% 
% The Psychtoolbox intstaller places SetPsychtoolboxPath.m in the directory 
% [matlab root folder]/toolbox/local. If the file [matlab root folder]/toolbox/local/startup.m 
% does not already exist then the installer creates it.  The installer inserts at the end 
% startup.m a call to SetPsychtoolboxPath.  Matlab automatically executes startup.m at when 
% started, setting the Matlab path to include the Psychtoolbox and all of its sub-folders.
%
% 6/12/02   awi Wrote it.  Added to Windows installer. 
% 8/05/02   awi Added conditional second argument to genpath call.  Genpath in Matlab 5 SE 
%               requires that argument, though it is undocumented. Seems like a bug in earlier 
%               versions of genpath, Matlab 6 behaves differently and better, requiring only 
%               the one documented argument.   

%read the contents of the Matlab toolbox directory
files=dir(pwd);
%check to see if it containts the Psychtoolbox, if so add it to the path.  
isPsychToolbox=0;
for i = 1:length(files)
    if strcmp(upper(files(i).name),'PSYCHTOOLBOX')
        if(nargin('genpath')) == 2 
            addpath(genpath(fullfile(pwd,'PsychToolbox'),0));
        else % its 1
            addpath(genpath(fullfile(pwd,'PsychToolbox')));
        end 
        break;
    end
end





