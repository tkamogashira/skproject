function GoWithTheFlow(f, varargin);
% Floco/GoWithTheFlow - realize flow diagram using floco object
%   GoWithTheFlow(f,expr1,...exprN, cmd1, .., cmdM) executes the
%   flow diagram defined in floco object f by evaluating
%   the expressions and commands in the caller workspace
%   (using evalin)
%
%   Let f be the elementary if/then/else control flow given in
%   the floco help text. Then the following lines illustrates its
%   use in a concrete situation:
%
%      GoWithTheFlow(f, 'rand>0.5', 'disp(''heads'')', 'disp(''tails'')');
%
%   See also floco, evalin.

Ntot = f.Nexpression + f.Ncommand;
if ~isequal(Ntot, nargin-1),
   error('Argument count mismatch.')
end

Expr = varargin(1:f.Nexpression);
Cmd = varargin(f.Nexpression+1:end);

inode = 1; % entry point
while 1,
   n = f.node(inode);
   if n.iaction<0, % evaluate expression
      iexpr = -n.iaction;
      xpval = evalin('caller', Expr{iexpr});
      returnvalues = f.ReturnValues{iexpr};
      % xpvalue determines which branch to take
      ibranch = nan; % default: value not in list of valid return values
      for ii=1:length(returnvalues),
         if isequal(xpval, returnvalues(ii)),
            ibranch = ii; break;
         end
      end
      if isnan(ibranch), error(['Return value of expression [' num2str(iexpr) '] not is not in branch list.']); end
      % next node to jump to
      inode = n.next(ibranch);
   else, % evaluate command
      evalin('caller', Cmd{n.iaction});
      inode = n.next;
   end
   % inf node index means exit the flow.
   if isinf(inode), break, end;
end





