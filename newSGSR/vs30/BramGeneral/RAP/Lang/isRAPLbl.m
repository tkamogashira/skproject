function boolean = isRAPLbl(Token)
%isRAPXXX  code for evaluation of complex RAP tokens
%   boolean = isRAPXXX(Token)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 20-02-2004

if ischar(Token) & strcmp(Token(end), ':'), boolean = logical(1);
else, boolean = logical(0); end