function [Type, Nr, ErrTxt] = ParseRAPMemVar(VarName)
%ParseRAPMemVar   parses an RAP memory variable name
%   [Type, Nr, ErrTxt] = ParseRAPMemVar(VarName)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 06-02-2004

[Type, ErrTxt] = deal(''); Nr = [];

if ~ischar(VarName) | ~any(strcmpi(VarName(1), {'c', 'v'})),
    ErrTxt = 'Invalid memory variable name'; 
    return;
else, Type = lower(VarName(1)); end

if length(VarName) > 1, 
    Nr = str2num(VarName(2:end));
    if isempty(Nr) | (mod(Nr, 1) ~= 0),
        ErrTxt = 'Invalid memory variable name';
        return;
    end
else,
    ErrTxt = 'Invalid memory variable name';
    return;
end   