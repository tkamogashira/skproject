function q = query(Param, Style, Prompt, Ustring, Tooltip);
% query - constructor for query objects
%    Queries are created from a parameter object and a
%    so-called spec string. 
%    The syntax for creating a query associated with parameter P is:
%        Q = QUERY(P, style, prompt, ustring, tooltip); 
%    or, in a single char string:
%        Q = QUERY(P, 'style\prompt\ustring\tooltip'); 
%    Examples:
%    query(lowfreq, 'edit\start: \21000.5 21000.1\Frequency at start of sweep. Pairs of numbers mean [left right].')
%    query(activeDA, 'toggle', 'DA channel: ', {'Left','Right','Both'}, 'Hit button to set active DA channels to Left, Right or Both.')
%
%    To set handle graphic properties of the individual uicontrols launched by
%    qdraw(Q), use the syntax Q.edit.prop = val, etc.
%
%   See also query/subsasgn, query/Styles, QDRAW and documentation on Paramset and Parameter objects.

if nargin==0, % implicit call in matrix manipulation, etc
   [Param, Style, Prompt, Ustring, Tooltip] = deal([]); 
elseif isa(Style, 'query'), q = Style; return;  % (pseudo) casting
elseif isa(Style, 'struct'), q = class(Style, 'query'); return;  % (pseudo) casting
elseif ~ischar(Style), error(['Cannot convert ' class(Style) ' to query object.']);
elseif nargin==2, % Style is defining string as in help text, parse it
   [mess, Style, Prompt, Ustring, Tooltip] = localParseDefString(Style);
   error(mess); % report any errors in main fnc for simpler debug stack
end

if isempty(Style), Props = [];
else,
   uifields = Styles(query,Style); % list of uicontrols
   empties = repmat({struct([])}, size(uifields));
   propvallist = ([uifields.' empties.'].'); % field names intersparsed with []
   Props = struct(propvallist{:});
end

q = CollectInStruct(Param, Style, Prompt, Ustring, Tooltip, Props);
q = class(q, 'query');

% ================locals=============
function [mess, Style, Prompt, Ustring, Tooltip] = localParseDefString(D);
% suppress warnings on un-assigned outargs in case of premature exit
[mess, Style, Prompt, Ustring, Tooltip] = deal([]);
mess = ''; % default: no errors
if ischar(D), % single char string: tokenize says Bram. '\' is delimiter, but \\ means \.
   D = strSubst(D, '\\', char(0)); % untypable 
   WW = words2cell(D, '\'); % tokenize says Bram
   WW = strSubst(WW, char(0), '\');
else,
   WW = D; % caller already passed tokens
end
%- - - - - - - - - - - - - - - - - - - - - 
% sample: 'edit\start: \21000.5 21000.1\Frequency at start of sweep. Pairs of numbers mean [left right].'
%   ^        1    2           3                    4   
%- - - - - - - - - - - - - - - - - - - - - 
if length(WW)<2, 
   mess = ['Incomplete specs for query definition (spec string reads: ''' D ''').']; 
   return; 
end 
% defaults
if length(WW)<2, WW{2} = ''; end % prompt
if length(WW)<3, WW{3} = '1000'; end % utility string, e.g. for setting width of edit or text on button
if length(WW)<4, WW{4} = ''; end % tooltip
% ---Parse tokens.
% 1) Style
Style = WW{1};
if ~ismember(Style, Styles(query)), 
   mess = ['Unknown query Style ''' Style '''.']; return ; 
end;
% 2,3,4) Prompt, Utility string and Tooltip
[Prompt, Ustring, Tooltip] = deal(WW{2:4});





