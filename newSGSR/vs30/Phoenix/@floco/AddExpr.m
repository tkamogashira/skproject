function f = addExpr(f, iexpr, returnvalues);
% floco/addExpr - add expression argument to floco object
%   f = addExpr(f, iexpr, Returnvalues) adds an expression
%   whose possible return values are listed in array Returnvalues
%   (Note: Returnvalues may be cell array if necessary).
%
%   Upon associating a branching node with this expression, the
%   actual outcome of the expression determines which branch is taken
%   by comparison with the Returnvalues array.
%
%   See also Floco.

if f.Operational, error('Cannot change an operational floco object.'); end
if iexpr>f.Nexpression, error('Expression index exceeds # expressions of floco object.'); end

f.ReturnValues{iexpr} = returnvalues(:).'; % column cell vector


