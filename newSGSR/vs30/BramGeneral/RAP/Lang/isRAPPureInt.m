function boolean = isRAPPureInt(Token)
%isRAPXXX  code for evaluation of complex RAP tokens
%   boolean = isRAPXXX(Token)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 13-11-2003

%Using if-statement on conditional expressions and not assignement on conditional
%expression, because the former only executes the necessary elements of the
%conditional expression ...
if (isnumeric(Token) & (mod(Token, 1) == 0)),
    boolean = logical(1);
else, boolean = logical(0); end