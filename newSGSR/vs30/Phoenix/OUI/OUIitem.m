function Item = OUIitem(name);
% OUIitem - return named item of OUI
%   OUIitem('foo') returns the element of the S.OUI.item
%   struct array whose name is 'foo'. S is the paramset carried
%   by the current OUI.
%
%   See also paramOUI, paramset/hasItem, readOUI.

GD = OUIdata;
S = GD.ParamData;
for ii = 1:length(S),
   [HI, I, itemClass, Item] = hasItem(S(ii), name);
   if HI, return; end % hit! we're done
end





