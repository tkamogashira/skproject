function [RAPStat, LineNr, ErrTxt] = RAPCmdEXP(RAPStat, LineNr, VarName, varargin)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 23-02-2004

%-------------------------------------RAP Syntax------------------------------------
%   EXP V#/C# "..." [V#/C# "..." V#/C# ...] Export variable to MATLAB base
%                             workspace
%-----------------------------------------------------------------------------------

ErrTxt = '';

Value = GetRAPMemVar(RAPStat, VarName);
if isempty(Value), ErrTxt = 'Variable not yet set'; return; end

CmdStr = ParseRAPStrArgs(RAPStat, varargin, '');
if isempty(CmdStr), ErrTxt = 'One of the variables is not yet set'; return; end

try, 
    if isa(Value, 'char'), CmdStr = sprintf('%s = ''%s'';', CmdStr, Value);
    else, CmdStr = sprintf('%s = %s;', CmdStr, mat2str(Value)); end    
    evalin('base', CmdStr);
catch, ErrTxt = 'Could not export memory variable'; return; end

LineNr = LineNr + 1;