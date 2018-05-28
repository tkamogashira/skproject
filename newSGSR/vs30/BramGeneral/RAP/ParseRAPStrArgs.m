function Str = ParseRAPStrArgs(RAPStat, Tokens, Sep)
%ParseRAPStrArgs parses complex string input arguments of RAP commands
%   Str = ParseRAPStrArgs(RAPStat, Tokens)
%   Str = ParseRAPStrArgs(RAPStat, Tokens, Sep)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 23-02-2004

%--------------------------implementation details---------------------------
%   This function is used by RAP commands SET, ECHO and EXP.
%---------------------------------------------------------------------------

Str = '';

if (nargin == 2), Sep = ' '; end

NTokens = length(Tokens); 
for n = 1:(NTokens-1), 
    Str = AddToken(RAPStat, Str, Tokens{n}, Sep); 
    if isempty(Str), return; end
end
Str = AddToken(RAPStat, Str, Tokens{NTokens}, ''); %Add last token without separator ...

%-------------------------local functions-----------------------
function Str = AddToken(RAPStat, Str, Token, Sep)

if isRAPMemVar(Token, 'char'), 
    ValStr = GetRAPMemVar(RAPStat, Token);
    if isempty(ValStr), Str = ''; return;
    else, Str = [Str, ValStr, Sep]; end
elseif isRAPMemVar(Token, 'double'), 
    ValNum = GetRAPMemVar(RAPStat, Token);
    if isempty(ValNum), Str = ''; return;
    else, Str = [Str, mat2str(ValNum), Sep]; end
elseif isnumeric(Token), 
    Str = [Str, num2str(Token), ' '];
else, Str = [Str, Token, Sep]; end