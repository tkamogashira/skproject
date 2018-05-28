function [hi, Index, itemClass, Item] = hasItem(S, Name);
% paramset/hasItem - true if paramset object contains named item.
%   hasItem(S, Name) returns true if Name is the name of a OUI item
%   contained in S. Names of OUI items are case insensitive.
%
%   [HI, I, itemClass, Item] = hasItem(S, Name) also returns the index I
%   of the item in the S.OUI.item struct array, the class of
%   the item, and the Item itself as it is stored in S.OUI. 
%   Empty values are returned for I, itemClass and Item if 
%   the named item is not found in S.
%
%   See also Paramset/HasParam, Paramset/HasQuery, Paramset/AddQuery.

% pessimist defaults
hi = 0;
Index = [];
itemClass = '';
Item = struct([]);

if isempty(S.OUI.item), return; end

inames = {S.OUI.item.name};
Index = strmatch(lower(Name), lower(inames), 'exact');
hi = ~isempty(Index);
if hi, 
   Item = S.OUI.item(Index);
   itemClass = Item.class;
end


