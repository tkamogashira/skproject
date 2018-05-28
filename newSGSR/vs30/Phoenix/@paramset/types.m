function N = types(S);
% paramset/types - types of paramset array in cell string
%   types(S)  returns the types of the elements of S:
%     types([S1 S2 ..]) = {S1.type S2.type ..}
%
%   This function is created to avoid MatLab's buggy behavior
%   of overload subsref for object arrays.
%
%   See also paramset/names, paramset/subsref.

N = {};

for ii=1:numel(S),
   Sii = S(ii);
   N{ii} = Sii.Type;
end



