function im = structIsmember(S, T);
%  structIsmember - Ismember for struct
%   structIsmember(S,T) with struct arrays SA and SB returns a vector
%   or matrix containing 1 where the elements of S are in the set of 
%   elements of T and 0 otherwise. T maybe equal to [], in which
%   case all zeros are returned.
%
%   See ismember.

if ~isstruct(S) | (~isstruct(T) & ~isempty(T)), 
   error('Input args S and T must be struct arrays.')
end

NS = numel(S);
NT = numel(T);
im = zeros(size(S));
for ii=1:NS,
   im(ii) = 0;
   for jj=1:NT,
      if isequal(S(ii), T(jj)),
         im(ii) = 1;
         break;
      end
   end
end




