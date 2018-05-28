function [RAPStat, ErrTxt] = SetRAPMemVar(RAPStat, VarName, Value)
%SetRAPMemVar   gets memory variable from RAP status structure
%   [RAPStat, ErrTxt] = SetRAPMemVar(RAPStat, VarName, Value)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 06-02-2004

[Type, Nr, ErrTxt] = ParseRAPMemVar(VarName);
if ~isempty(ErrTxt), return; end

switch Type,
case 'v', Com = strcmpi(class(Value), 'double');
case 'c', Com = strcmpi(class(Value), 'char');
end    
if ~Com, ErrTxt = 'Incompatible datatype for memory variable'; return; end

try, RAPStat = setfield(RAPStat, 'Memory', upper(Type), {Nr}, {Value});
catch, ErrTxt = 'Could not set memory variable'; end    