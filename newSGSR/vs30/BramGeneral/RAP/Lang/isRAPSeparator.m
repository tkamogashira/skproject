function boolean = isRAPSeparator(Token)
%isRAPSeparator  check if token is a valid separator for RAP
%   boolean = isRAPSeparator(Token)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 16-20-2003

Separators = {'='};
boolean = ismember(Token, Separators);