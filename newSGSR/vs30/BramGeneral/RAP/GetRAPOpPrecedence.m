function Pr = GetRAPOpPrecedence(Op)
%GetRAPOpPrecedence  returns precedence of RAP operator
%   P = GetRAPOpPrecedence(Op)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 14-10-2003

if ismember(Op, {'^', '~'}), Pr = 3; %'~' denotes internally unary negation ...
elseif ismember(Op, {'*', '/'}), Pr = 2;
elseif ismember(Op, {'+', '-'}), Pr = 1;
end