function boolean = isRAPVMemVar(Token)
%isRAPVMemVar  checks if token is an RAP memory variable of a numeric type
%   boolean = isRAPVMemVar(Token) returns true if token is a memory variable 
%   of numeric type, else returns false.
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 15-10-2003

boolean = isRAPMemVar(Token, 'double');