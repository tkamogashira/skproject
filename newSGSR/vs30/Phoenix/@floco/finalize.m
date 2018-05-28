function f = finalize(f);
% Floco/finalize - check floco object and make it operational

if f.Operational, error('Cannot change an operational floco object.'); end

% List all non-empty nodes (user deteremined the numbering in Addnode, so there may be gaps)
actions = {f.node.iaction};
realnodes = [];
for ii=1:length(actions),
   if ~isempty(actions{ii}),
      realnodes = [realnodes ii];
   end
end
if isempty(realnodes),
   error('No nodes defined.')
end
%realnodes

% Check if an exit exists and if no undefined nodes are pointed to.
allnexts = unique([f.node.next]);
if ~any(isinf(allnexts)),
   error('No node has exit branch.');
end
inonexist = find(~ismember(allnexts, [realnodes inf])); 
nonexist = allnexts(inonexist);
if ~isempty(nonexist),
   error(['Non-existent node(s) [' trimspace(num2str(nonexist)) '] referenced.']);
end

% Check if all nodes can be reached, either as entry (inode=1) or as another's Next.
% (they might not all be reachable from the entry node, but that is not severe)
internalnodes = setdiff(realnodes,1);
inonref = find(~ismember(internalnodes, allnexts));
nonref = internalnodes(inonref);
if ~isempty(nonref),
   error(['Internal node(s) [' trimspace(num2str(nonref)) '] never pointed to.']);
end

% now the fun: are there any "traps", i.e. nodes who never lead to an exit?
% A trivial example is a single-branch node pointing to itself.
for ii=1:length(realnodes),
   inode = realnodes(ii);
   if ~localHasWayOut(inode, f.node),
      error(['Node ' num2str(inode) ' is a trap.']);
   end
end

% f passed all tests - render it operational.
f.Operational = 1;

%---------------
function hwo = localHasWayOut(inode, nodes);
% true if exit can be reached from node #inode
%nodes(inode)
hwo = 0; % pessimistic default
if length(inode)>1, % any of them having an exit suffices. Check one-by-one recursively
   for ii=1:length(inode),
      hwo = localHasWayOut(inode(ii), nodes);
      if hwo, break; end
   end
   return;
end
% ---single inode from here---
n = nodes(inode); % current node
% if there is an exit among the branches, we're ready
hwo = any(isinf(n.next));
if hwo, return; end 
if isequal(0, n.next), return; end % "disabled" node - has been visited before (see below)
% The only escape now is via n's descendants listed in n.next.
% So we need recursion. To avoid infinite recursion, we effectively ...
% ... "disable" n in the sense that its descendants replaced by a single zero:
nodes(inode).next = 0; % means: has no branches -> no way out
hwo = localHasWayOut(n.next, nodes);










