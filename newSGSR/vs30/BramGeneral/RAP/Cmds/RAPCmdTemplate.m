function [RAPStat, LineNr, ErrTxt] = RAPCmdTemplate(RAPStat, LineNr, varargin)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 18-10-2003

%-------------------------------------RAP Syntax------------------------------------
%
%-----------------------------------------------------------------------------------

ErrTxt = '';

LineNr = LineNr + 1;