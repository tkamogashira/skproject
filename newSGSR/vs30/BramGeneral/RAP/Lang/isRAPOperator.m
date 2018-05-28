function boolean = isRAPOperator(Token)
%isRAPOperator  check if token is a valid operator for RAP
%   boolean = isRAPOperator(Token)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 14-20-2003

boolean = isRAPUnOperator(Token) | isRAPBinOperator(Token);