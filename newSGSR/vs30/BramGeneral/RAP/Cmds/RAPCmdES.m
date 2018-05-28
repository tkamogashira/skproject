function [RAPStat, LineNr, ErrTxt] = RAPCmdES(RAPStat, LineNr, StructName, varargin)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 23-03-2005

%-------------------------------------RAP Syntax------------------------------------
%   ES @@..@@ V#/C# [V#/C# ...]  Export list of memory- and/or substitution-
%                                variables as an extra row of a structure-array
%                                @@..@@ in the MATLAB base workspace (*)
%-----------------------------------------------------------------------------------

ErrTxt = '';

%Checking structure-array in MATLAB base workspace ...
if evalin('base', sprintf('~exist(''%s'', ''var'');', StructName)),
    ErrTxt = sprintf('''%s'' is not an existing variable in the base MATLAB workspace', StructName);
    return;
end
if evalin('base', sprintf('~isstruct(%s);', StructName)),
    ErrTxt = sprintf('''%s'' is an existing variable in the base MATLAB workspace, but not a structure');
    return;
end
try, [Data, FNames] = evalin('base', sprintf('destruct(%s)', StructName));
catch, ErrTxt = sprintf('Structure-array ''%s'' is not valid.', StructName); return; end    
NArgs = length(varargin);
if (length(FNames) ~= NArgs),
    ErrTxt = sprintf('Structure-array ''%s'' has %d columns', StructName, length(FNames));
    return;
end

%Retrieving input arguments ...
NewRow = cell(1, NArgs);
for n = 1:NArgs,
    %Arguments can only be memory- or substitution-variables ...
    if isRAPMemVar(varargin{n}), NewRow{n} = GetRAPMemVar(RAPStat, varargin{n});   
    else, NewRow{n} = GetRAPSubstVar(RAPStat, varargin{n}); end
    if isempty(NewRow{n}),
        ErrTxt = sprintf('Memory- or substitutionvariable ''%s'' is not assigned a value yet', varargin{n});
        return;
    end
end    

%Appending new row ...
try,
    [Data, FNames] = evalin('base', sprintf('destruct(%s)', StructName));
    Data = [Data; NewRow]; S = construct(Data, FNames);
    assignin('base', StructName, S);
catch, ErrTxt = 'Could not append new row to structure-array'; return; end    

LineNr = LineNr + 1;