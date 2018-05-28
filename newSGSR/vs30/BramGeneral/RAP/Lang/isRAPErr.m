function boolean = isRAPErr(Token)
%isRAPXXX  code for evaluation of complex RAP tokens
%   boolean = isRAPXXX(Token)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 19-02-2004

%Using if-statement on conditional expressions and not assignement on conditional
%expression, because the former only executes the neccessary elements of the
%conditional expression ...
if iscell(Token) & (length(Token) == 3) & strcmpi(Token{1}, 'err') & ...
   strcmpi(Token{2}, '=') & ((isnumeric(Token{3}) & (Token{3} > 0) & ...
   (mod(Token{3}, 1) == 0)) | ischar(Token{3})),
        boolean = logical(1);
else, boolean = logical(0); end