function boolean = isRAPInt(Token)
%isRAPXXX  code for evaluation of complex RAP tokens
%   boolean = isRAPXXX(Token)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 06-02-2004

%This routine doesn't check if memory variable is an integer, this is done
%further on by the routine GetRAPInt.m ...
boolean = isRAPPureInt(Token) | isRAPVMemVar(Token); 