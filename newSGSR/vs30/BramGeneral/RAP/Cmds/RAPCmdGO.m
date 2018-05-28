function [RAPStat, LineNr, ErrTxt] = RAPCmdGO(RAPStat, LineNr, Token)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 20-02-2004

%-------------------------------------RAP Syntax------------------------------------
%   GO #	    	          Branch to specified record
%   GO @@..@@   	          Branch to specified label 
%-----------------------------------------------------------------------------------

%-------------------------------implementation details-------------------------------
%   When the GO command is used with a label identifier, then the output argument
%   LineNr contains the label identifier. In RAPCmdEM this is translated to an actual
%   line number.
%------------------------------------------------------------------------------------

ErrTxt = '';

LineNr = Token;