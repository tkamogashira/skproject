% STARTSGSR - startup script for SGSR
% In order to launch SGSR, MatLab should be started in
% <siglibroot>\startupDir. The startup.m script in this
% directory will look for the most recent version of SGSR
% that is installed, patches included.
% At the time of calling this function, the init dir should at least 
%    be in the path

global SGSR;

% 1. ------MatLab default behavior----------
% disable pager - it will result in pause mode when messages
% are written to screen
more off;
% some generic MatLab defaults
set(0, 'formatspacing','compact');
% no huge figures
set(0,'defaultfigureposition',[140 100 0.8*[560 375]]);
% prevent xlabels from falling off the figure
set(0,'defaultaxesposition',[0.13 0.13 0.75 0.775]);
% buttons etc, have about the same color as their dialog
set(0,'defaultuicontrolbackgroundcolor',[0.76 0.76 0.76 ]);

%drawnow;
disp('starting SGSR ...');
drawnow; % flush pending output of MatLab startup

%CheckMLversion(6.1); % check if MatLab version is not too old
SGSRpath; % define SGSR path 

DefaultDirs; % define special directories for data, default settings, etc

% local system parameters
systemParameters; % sets global SGSR to its factory settings
localSysParam retrieve; % get local settings from setup file - they override factory settings
AddToLog('System parameters loaded');

if AP2present, 
   HardwareInit;
   InitSessionDefaults; % across-menu defaults
end

%if atBigscreen || atKiwi || ~inLeuven
   %sgsr(1); % launch SGSR main dialog after scrolling the command window
%else
   if or(inLeuven,inUtrecht) % set sample rates to those of setup so stimuli are correctly reconstructed
      SGSR.samFreqs = [60096.1551890 125000.0027940]-1e-6*[-0.407592 0.032218];
   end
   disp('SGSR settings initialized.');
%end

clear SGSR;
