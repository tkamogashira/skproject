function null = mcallccdisplay(correlogram)
% function null = mcallccdisplay(correlogram)
%
%---------------------------------------------------------------
% MATLAB interface for calling Windows 95 program 'ccdisplay.exe'
% for displaying correlograms in three dimensions
%----------------------------------------------------------------
%
% Input parameters:
%    correlogram  = 'correlogram' structure as defined in mccgramcreate.m
%
% Output parameters:
%    none
%
% The program ccdisplay.exe should be in the same directory
% as this function.
% 
% Example;
% to display the previously-made correlogram cc1, type:
% >> mcallccdisplay(cc1);
%
%
% version 1.0 (Jan 20th 2001)
% MAA Winter 2001 
%----------------------------------------------------------------

% ******************************************************************
% This MATLAB software was developed by Michael A Akeroyd for 
% supporting research at the University of Connecticut
% and the University of Sussex.  It is made available
% in the hope that it may prove useful. 
% 
% Any for-profit use or redistribution is prohibited. No warranty
% is expressed or implied. All rights reserved.
% 
%    Contact address:
%      Dr Michael A Akeroyd,
%      Laboratory of Experimental Psychology, 
%      University of Sussex, 
%      Falmer, 
%      Brighton, BN1 9QG, 
%      United Kingdom.
%    email:   maa@biols.susx.ac.uk 
%    webpage: http://www.biols.susx.ac.uk/Home/Michael_Akeroyd/
%  
% ******************************************************************
   
   
% set the path to be the same directory as this function
thisfile = which(mfilename);
stringindex = findstr(thisfile, mfilename);
pathname = thisfile(1:stringindex-1);

% define the name of the temporary file
filename='tempmatlab.bcc';

% save correlogram in a ccdisplay.exe-friendly format
ccname = inputname(1);
msaveccdisplay(filename, correlogram, ccname);

% call ccdisplay.exe program and return to MATLAB
executablename='ccdisplay.exe';
fprintf('calling Windows-95 program %s ...\n', executablename);
fprintf('(using path %s)\n', pathname);
[s,w] = dos([pathname,executablename, ' ', filename, ' &']);

fprintf('\n');
fprintf('returning to MATLAB workspace.\n');
fprintf('\n');


% the end!
%------------------------------------------------------------
