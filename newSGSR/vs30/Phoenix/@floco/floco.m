function f = floco(Nexpression, Ncommand, Name);
% floco - constructor of floco objects
%    floco(Nexpr, Ncmd, 'foo') returns an uninitialized floco
%    (flow control) object having Nexpr expression slots and Ncmd 
%    command slots. Use floco methods to build the flow control graph.
%    Example:
%
%       f = floco(1,2,'IfThenElse'); 
%       f = addExpr(f,1,[1 0]); % logical expression, true=1, false=0
%       f = addNode(f,1,-1,[2 3]); % the corresponding logical fork: (true,false)->node (2,3)
%       f = addNode(f,2,1); % action of true branch, exit afterwards
%       f = addNode(f,3,2); % action of false branch, exit afterwards  
%       f = finalize(f); % check for dead ends, etc and enable for use.
%       GoWithTheFlow(f, 'rand>0.5', 'disp(''heads'')', 'disp(''tails'')');
%
%    See also floco/addExpres, floco/addNode, floco/finalize, floco/GoWithTheFlow.

% f = floco(2,5,'xor'); f = addexpr(f,1,[1 0]); f = addexpr(f,2,[1 0]); f = addnode(f,1,-1,[2 3]); f = addnode(f,2,-2,[4 5]); f = addnode(f,3,-2,[5 4]); f = addnode(f, 4, 1);  f = addnode(f, 5, 2);  finalize(f)

if nargin<1, Nexpression = 0; end; % no expression args
if nargin<2, Ncommand = 0; end; % no command args yet
if nargin<3, Name = 'NN'; end

%=====directed graph. 
% Each node has an action associated with it. Actions may be shared by multiple nodes.
next = inf; % array of next: where to jump from this node; inf = exit ("sink") by convention
iaction = 0; % index telling what to do at this node (0 = nothing)
% ........ iaction = -j points to expression (valued action) number j in the argument list
% ........ iaction = +j points to command (non-valued action) number j in the argument list
name = 'entry'; % name for debugging purposes. "entry" for unique entry point
node = CollectInStruct(name, next, iaction); % this becomes array when f is elaborated.

%=====action interface.
% Each action corresponds to an expression or command block.
% The return value of the action, if any, determines which branch is taken.
% Valued actions are called "expressions"; nonvalued actions are called "commands."
ReturnValues = cell(1,Nexpression); % upon elaboration by floco methods, ReturnValues{iexpr} 
% will contain an array of return values that expression #iexpr can yield. Its elements
% correspond to the choices of the respective branches of f.next.
% (the branches are the consecutive next positions)

Operational = 0; % flag indicating whether f is ready for use, i.e., fully defined & checked.

f = CollectInStruct(Name, Nexpression,  Ncommand, node, ReturnValues, Operational, node);

f = class(f, 'floco');


