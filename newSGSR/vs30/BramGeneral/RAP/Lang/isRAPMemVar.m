function boolean = isRAPMemVar(Token, Type)
%isRAPMemVar  checks if token is an RAP memory variable of a given type
%   boolean = isRAPMemVar(Token, Type) returns true if token is a memory
%   variable of specified Type, else returns false. The type of a variable can
%   be omitted, or can be 'all', 'char' or 'double' (Only the first letter is 
%   significant).
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 15-10-2003

if (nargin == 1), Type = 'all'; end

%Memory variables that contain character strings have a prefix 'c',
%variables that contain floating point numbers have 'v' as prefix ...
if strncmpi(Type, 'a', 1),     Pattern = {'c', 'v'};
elseif strncmpi(Type, 'c', 1), Pattern = 'c';
elseif strncmpi(Type, 'd', 1), Pattern = 'v'; end   

%Using if-statement on conditional expressions and not assignement on conditional
%expression, because the former only executes the necessary elements of the
%conditional expression ...
if ischar(Token) & (length(Token) > 1) & any(strncmp(Token(1), Pattern, 1)) & ...
   ~isempty(str2num(Token(2:end))) & (mod(str2num(Token(2:end)), 1) == 0),
    boolean = logical(1);
else, boolean = logical(0); end