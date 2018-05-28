function [CC, empty] = RemoveEmptyCells(C);

nc = 0;
N = length(C);
empty = zeros(1,N);
for ii=1:N,
   if ~isempty(C{ii}),
      nc = nc+1;
      CC{nc} = C{ii};
   else,
      empty(ii) = 1;
   end
end
