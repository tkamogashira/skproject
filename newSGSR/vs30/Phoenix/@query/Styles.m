function s = Styles(Q, S);
% Query/Styles - returns all known query styles as cell string
%   Styles(VQ), where VQ is a vois query object, returns a list 
%   of all valid styles of uicontrol that are used to
%   retrieve data from the user. VQ is obtained by calling
%   query without any input arguments.
%
%   Styles(VQ,S) returns the uicontrols types of style-S queries.
%   Styles(Q), where Q is a non-void query, returns the uicontrols 
%   types of queries having the same style as Q.
%
%   Examples
%     Styles(query) returns {'edit'  'toggle'  'frame'}
%     Styles(query, 'toggle') returns {'prompt'  'button'}
%     Styles(Q), where Q.style=='toggle' returns the same as previous call.
%
%   Note: the ackward implementation using the void query input
%   serves to provide a substitute for a static class method, which 
%   cannot be used in MatLab.
%  
%   See also Query.


allStyles = {'edit' 'toggle' 'frame'};

if isvoid(Q) & (nargin==1),
   s = allStyles;
   return
end

% styles of a specific query style S
if nargin==1, % get query style from query
   S = Q.Style;
end

if isempty(S), S = '_______________'; end
switch S,
case 'edit', s = {'prompt', 'edit', 'unit'};
case 'toggle', s = {'prompt', 'button'};
case 'frame', s = {'frame', 'title'};
case '_______________', s = {};
otherwise,
   error(['Unknown query style ''' S '''.']);
end




