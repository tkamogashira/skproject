function boolean = isRAPUnOperator(Token)
%isRAPUnOperator  check if token is a valid unary operator for RAP
%   boolean = isRAPUnOperator(Token)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 06-02-2004

Operators = {'~'}; %'~' denotes internally unary negation ...
%Using if-statement on conditional expressions and not assignement on conditional
%expression, because the former only executes the necessary elements of the
%conditional expression ...
if ischar(Token) & ismember(Token, Operators), boolean = logical(1);
else, boolean = logical(0); end