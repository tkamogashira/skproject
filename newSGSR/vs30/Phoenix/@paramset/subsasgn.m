function S = subsasgn(S, subscript, RHS);
% paramset/subsasgn - subsasgn for paramset objects
%   S.foo = [] removes an parameter named 'foo' from parameset S.
%   S.foo = X changes the value of parameter foo.
%
%   See also Paramset, Parameter, Query, Paramset/subsref.

if length(subscript)>1, % handle by recursion
   Ssub = subsref(S, subscript(1));
   Ssub = subsasgn(Ssub, subscript(2:end),RHS);
   S = subsasgn(S, subscript(1), Ssub);
   return;
end


% -----------single-level subsasgn from here
trivial = 1;
switch subscript.type,
case '()', 
   if ~isa(RHS, 'paramset'), error('RHS is not a paramset object.'); end
   S = builtin('subsasgn', S, subscript, RHS);
case '{}', error('S{...} not defined for paramset objects.');
otherwise, trivial = 0;
end
if trivial, return; end

% -----------single field asignment from here
if numel(S)>1, error('Field assignment of paramset arrays is an error.'); end

fn = subscript.subs; % virtual fieldname
iparam = paramIndex(S, fn); % index of fn in param list
if isequal(1, strfind(lower(fn), 'uipos_')), % uipos_XXX position setting of uicontrol(s) of param XXX
   iparam = paramIndex(S, fn(7:end));
   if isnan(iparam), error(['Reference to non-existent paramset parameter ''' fn(7:end) '''.']); end
   fn = 'uipos';
end
switch lower(fn),
otherwise, % fn is name of existing parameter?
   if isnan(iparam), % no valid field, no existing param
      error(['Paramset fieldname must be generic field or name of an existing parameter of the paramset. ''' fn ''' is neither.']);
   elseif isempty(RHS), % remove existing param altogether
      S.Stimparam(iparam) = [];
   elseif isa(RHS, 'parameter'), % replace parameter
      S.Stimparam(iparam) = RHS;
   else, % change value of parameter
      S.Stimparam(iparam).value = RHS;
   end
end
















