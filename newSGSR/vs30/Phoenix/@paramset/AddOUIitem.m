function S = AddOUIitem(S, name, class, Item);
% paramset/AddOUIitem - add OUI item to paramset object
%   S = AddOUIitem(S, Name, Class, Item) adds a named OUI item to the current
%   UIgroup of paramset S. Class indicates the type of OUI item, e.g.,
%   'query' or 'reporter'. Item is a struct or object with the properties 
%   of the OUI element. This struct is used by paramOUI to draw the OUI element.
%   Names of OUI items are case insensitive.
%
%   AddOUIitem does not check if the Item makes sense, i.e., if paramOUI
%   will be able to realize it. AddOUIitem is not intended for direct use;
%   to create OUI items, use specialized item-creators like Paramset/AddQuery.
%   
%   See also Paramset, Paramset/InitOUIgroup, Paramset/AddQuery, paramOUI.

if  nargout<1, 
   error('No output argument using AddOUIitem. Syntax is: ''S = AddOUIitem(S, Name, Class, Item)''.');
end
error(nargchk(4,4,nargin));

class = lower(class);

if isvoid(S),
   error('OUI items may not be added to void paramset objects.');
elseif hasitem(S, name),
   error(['A OUI item named ''' name ''' is already contained in the paramset.']);
elseif ~isvarname(name),
   error(['Invalid Name of OUI-item: ''' name ''' (not a valid MatLab varname).']);
elseif ~isvarname(class),
   error(['Invalid Class of OUI-item: ''' name ''' (not a valid MatLab varname).']);
elseif ~isstruct(Item) & ~isobject(Item),
   error(['OUI item must be struct or object.']);
elseif numel(Item)~=1,
   error(['OUI item may must be single struct.']);
elseif isempty(S.OUI.group), 
   error('At least one OUIgroup must exist before Reporters can be added to a paramset object. See InitOUIgroup.');
elseif ~isequal('query', class) & hasParam(S, name), 
   error('Non-query OUI items may not have names that match names of a parameter in paramset.');
end

igroup = length(S.OUI.group); % index of current OUI group
% put the item description in "spec" field of item struct array.
spec = Item;
newItem = CollectInStruct(name, class, igroup, spec);
S.OUI.item = [S.OUI.item newItem];



