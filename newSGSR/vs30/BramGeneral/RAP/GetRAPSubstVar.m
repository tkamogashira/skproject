function V = GetRAPSubstVar(RAPStat, VarName)
%GetRAPSubstVar   gets substitution variable from RAP status structure
%   V = GetRAPSubstVar(RAPStat, VarName)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.
%
%   See also EvalRAPSubstVar

%B. Van de Sande 16-20-2003

[dummy, V] = EvalRAPSubstVar(RAPStat, VarName);