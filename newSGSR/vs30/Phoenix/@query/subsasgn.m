function Q = subsasgn(Q, subscript, RHS);
% query/subsasgn - subsasgn for query objects
%   Q.field = value is used to set query properties.
%   The only fields that can be set are the
%   uicontrol properties returned by Styles(Q).
%   
%   Example:
%    Q.prompt.fontsize = 10;
%
%   See also query, query/subsref.

switch subscript(1).type,
case '()', 
   Q = builtin('subsasgn', Q, subscript, RHS);
   return;
case '{}', 
   error('Q{..} is an error for query objects.');
end

if numel(Q)>1, 
   error('Cannot assign multiple query objects.'); 
end

if length(subscript)~=2,
   error('The only valid subscripted reference for query objects is Q.X.Y = Z. See Query/subsasgn.');
end


% field assignment of single Q from here
ui = lower(subscript(1).subs);
fn2 = lower(subscript(2).subs);
if ~ismember(ui, fieldnames(Q.Props)),
   error(['Fieldname ''' ui ''' is not a uicontrol of query object passed to subsasgn.']);
end
eval(['Q.Props.' ui '(1).' fn2 ' = RHS;']); % must use (1) in case of empty struct














