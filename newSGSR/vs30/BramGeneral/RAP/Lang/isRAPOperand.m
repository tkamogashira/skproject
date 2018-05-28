function boolean = isRAPOperand(Token)
%isRAPOperand  check if token is a valid operand for RAP expressions
%   boolean = isRAPOperand(Token)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 15-20-2003

%An operand can be a number, a RAP variable (V#, not C#) or a substition
%name for a dataset information entry ...
boolean = isnumeric(Token) | isRAPMemVar(Token, 'double') | isRAPSubstVar(Token, 'double');