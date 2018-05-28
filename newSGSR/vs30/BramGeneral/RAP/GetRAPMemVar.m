function V = GetRAPMemVar(RAPStat, VarName)
%GetRAPMemVar   gets memory variable from RAP status structure
%   V = GetRAPMemVar(RAPStat, VarName)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 06-02-2004

[Type, Nr, ErrTxt] = ParseRAPMemVar(VarName);
if ~isempty(ErrTxt), V = []; return; end

try, 
    V = getfield(RAPStat, 'Memory', upper(Type), {Nr});
    if ~isempty(V), V = V{1}; else V = []; end
catch, V = []; end