function boolean = isRAPSubstVar(Token, Type)
%isRAPSubstVar  checks if token is an RAP substitution variable of a given type
%   boolean = isRAPSubstVar(Token, Type) returns true if token is a substitution
%   variable of specified Type, else returns false. The type of a variable can
%   be omitted, or can be 'all', 'char' or 'double' (Only the first letter is 
%   significant).
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.
%
%   See also EvalRAPSubstVar

%B. Van de Sande 16-10-2003

if ~ischar(Token), boolean = logical(0); return; end

if (nargin == 1) | strncmpi(Type , 'a', 1),
    boolean = ~isempty(EvalRAPSubstVar(Token));
else, boolean = strncmpi(Type, EvalRAPSubstVar(Token), 1); end