function [RAPStat, LineNr, ErrTxt] = RAPCmdEND(RAPStat, LineNr)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 10-10-2003

LineNr = 0; ErrTxt = '';