function N = names(S);
% paramset/names - names of paramset array in cell string
%   names(S)  returns the names of the elements of S:
%     names([S1 S2 ..]) = {S1.name S2.name ..}
%
%   This function is created to avoid MatLab's buggy behavior
%   of overload subsref for object arrays.
%
%   See also paramset/types, paramset/subsref.

N = {};

for ii=1:numel(S),
   Sii = S(ii);
   N{ii} = Sii.Name;
end



