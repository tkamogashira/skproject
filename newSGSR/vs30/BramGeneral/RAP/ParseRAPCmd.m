function [LblID, Cmd, Args] = ParseRAPCmd(TokenList)
%ParseRAPCmd   parses an RAP command
%   [LblID, Cmd, Args] = ParseRAPCmd(TokenList)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 20-02-2004

[LblID, Cmd] = deal(''); Args = cell(0);

if isempty(TokenList), return;
elseif isRAPLbl(TokenList{1}),
    LblID = TokenList{1}(1:end-1); %Discard final colon ...
    if (length(TokenList) > 1),
    Cmd   = TokenList{2};
    Args  = TokenList(3:end);
    end
else
    Cmd   = TokenList{1}; 
    Args  = TokenList(2:end);    
end