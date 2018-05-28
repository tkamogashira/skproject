function [RAPStat, LineNr, ErrTxt] = RAPCmdDI(RAPStat, LineNr, varargin)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 26-03-2004

%-------------------------------------RAP Syntax------------------------------------
%   DI V#/C# [ERR=#]          Show value of specified variable (*)
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), ListRAPMem(RAPStat); end
    LineNr = LineNr + 1;
    return;
else,    
    VarName = varargin{1};
    if (nargin == 4), ErrLine = ExtractRAPErrLineNr(varargin{2});
    else, ErrLine = []; end

    Value = GetRAPMemVar(RAPStat, VarName);
    if isempty(Value) & isempty(ErrLine), ErrTxt = 'Variable not yet set'; return; 
    elseif isempty(Value) & ~isempty(ErrLine), LineNr = ErrLine; return; 
    elseif isRAPStatDef(RAPStat, 'ComLineParam.Verbose'),
        if isa(Value, 'char'), fprintf('Variable %s = ''%s''.\n', VarName, Value);
        else, fprintf('Variable %s = %s.\n', VarName, mat2str(Value, 4)); end
    end
end

LineNr = LineNr + 1;