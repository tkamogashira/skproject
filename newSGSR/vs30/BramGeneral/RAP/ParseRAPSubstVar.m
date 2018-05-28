function [SubstVarName, DSSName, ErrTxt] = ParseRAPSubstVar(Token)
%ParseRAPSubstVar   parses an RAP substitution variable name
%   [SubstVarName, DSSName, ErrTxt] = ParseRAPSubstVar(Token)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 13-20-2003

[SubstVarName, DSSName, ErrTxt] = deal('');

Token = lower(Token);
idx = strfind(Token, '#');
if ~isempty(idx),
    SubstVarName = Token(1:idx-1);
    if idx == length(Token), 
        ErrTxt = 'Invalid syntax of RAP substitution variable';
        return;
    else, DSSFlag = Token(idx+1); end
    
    switch DSSFlag,
    case 'm', DSSName = 'master';
    case 's', DSSName = 'slave';    
    otherwise, ErrTxt = 'Invalid syntax of RAP substitution variable'; end
else, 
    SubstVarName = Token;
    DSSName      = 'master';
end