function boolean = ParseRAPTokenList(TokenList)
%ParseRAPTokenList    parse RAP list of tokens
%   boolean = ParseRAPTokenList(TokenList)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 10-10-2003

RAPMetaLang = DefineRAPLang;
boolean = eval(RAPMetaLang, TokenList);