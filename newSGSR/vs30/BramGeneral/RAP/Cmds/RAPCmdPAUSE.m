function [RAPStat, LineNr, ErrTxt] = RAPCmdPAUSE(RAPStat, LineNr, varargin)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 18-02-2004

%-------------------------------------RAP Syntax------------------------------------
%   PAUSE                     Pause execution of script (~)
%-----------------------------------------------------------------------------------

ErrTxt = '';

%Always output a message on the command window, regardless of verbose setting of RAP!
%PAUSE is an interactive command, so the user should always be notified ...
fprintf('Press any key to continue ...\n');
pause

LineNr = LineNr + 1;