function f = addNode(f, inode, iaction, next, name);
% floco/addNode - add node to floco object
%   f = addNode(f, inode, iaction, Next, Name) defines node #inode of f.
%   iaction is the associated action; negative and positive values
%   correspond to expressions and commands, respectively. 
%
%   Next is a list of next nodes to jump to after completing the action 
%   (or evaluating the expression). For commands, Next contains a single 
%   element; %   for expressions, Next must contain as many elements as the
%   associated expression has return values. Note that Next may contain
%   node indices of nodes that have not been defined yet ("forward declaration").
%   The "exit" node is inf by convention. Next defaults to inf.
%   Consistency checking will be done upon calling the Finalize method.
%
%   Name is optional name of the node for debugging purposes.
%
%   By convention node #1 is the entry node of the floco object.
%
%   See also Floco, Floco/AddExpr, Floco/Finalize.

if nargin<4, next = inf; end % no next node: exit
if nargin<5, name = ''; end
if isempty(name) & isequal(1,inode), name = 'entry'; end

if f.Operational, error('Cannot change an operational floco object.'); end

if iaction<1, % expression node
   % first check input params
   iexpr = -iaction;
   if iexpr>f.Nexpression, 
      error('Expression index exceeds # expressions of floco object.'); 
   end
   Nbranche = length(f.ReturnValues{iexpr}); % # return values
   if ~isequal(length(next), Nbranche),
      error('# exit branches does not match # return values of associated expression.');
   end
   f.node(inode) = collectInStruct(name, next, iaction);
else, % command node
   if iaction>f.Ncommand, 
      error('Expression index exceeds # commands of floco object.'); 
   end
   f.node(inode) = collectInStruct(name, next, iaction);
end



