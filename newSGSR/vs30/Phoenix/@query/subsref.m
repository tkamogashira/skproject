function varargout = subsref(Q, subscript);
% query/subsref - subsref for query objects
%   perimtted virtual fields: 
%      Q.param
%      Q.paramName or Q.parName 
%      Q.style 
%      Q.Ustring
%      Q.Tooltip
%      Q.<uicontrol>.prop,
%   where <uicontrol> is one of the uicontrols proper
%   to Q.style.
%
%   See also Query, Query/subsasgn.

switch subscript(1).type,
case '()', % simple array stuff allowed
   elem = builtin('subsref', Q, subscript(1));
   if length(subscript)==1, varargout{1} = elem;
   else,
      varargout{1} = subsref(elem, subscript(2:end));
   end
   return;
case '{}', 
   error('Q{..} is an error for query objects.');
end

NQ = numel(Q);
if NQ>1,
   for ii=1:NQ,
      varargout{NQ+1-ii} = subsref(Q(ii), subscript);
      % inversion of order is matlab bug that MIGHT be fixed in future versions, so we better check 
      ErrorOnNewRelease; 
   end
   return;
end

% staggered fields: recursive calls
if length(subscript)>1,
   Q = subsref(Q, subscript(1));
   varargout{1} = subsref(Q, subscript(2:end));
   return;
end


% single field ref below
fn = subscript(1).subs;
switch lower(fn),
case 'param',
   varargout{1} = Q.Param;
case {'paramname', 'parname'},
   P = Q.Param; 
   varargout{1} = P.name;
case 'style',
   varargout{1} = Q.Style;
case 'ustring',
   varargout{1} = Q.Ustring;
case 'tooltip',
   varargout{1} = Q.Tooltip;
case 'props',
   varargout{1} = Q.Props;
case Styles(Q),
   if length(subscript)==1,
      varargout{1} = getfield(Q.Props, fn);
   else,
      prop = subscript(2).subs;
      varargout{1} = getfield(Q.Props, fn, prop);
   end
otherwise,
   error(['Invalid query field ''' fn ''' referenced.']);
end










