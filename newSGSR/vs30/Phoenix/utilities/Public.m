function XV = Public(X);
% Public - make local variable public or retrieve public variable
%   Public(X) makes a copy of variable X and stores it as a field of
%   a persistent struct within public.
%
%   Public('X') retrieves the value of X that was stored previously.
%   and defines a variabe X with that value in the caller workspace.
%
%   (debugging tool)

persistent QQ

if isempty(inputname(1)),
   global qq_______qq
   qq_______qq = getfield(QQ, X);
   evalin('caller', ['global qq_______qq;' X ' = qq_______qq']);
   clear global qq_______qq
else,
   QQ = setfield(QQ, inputname(1), X);
end


