function [lbA,ic]=leastBoringColumn(A);
% leastBoringColumn - matrix column with largest std
if size(A,2)==1, % return one and only column
   lbA = A;
   ic=1;
else,
   s = std(A);
   [dummy,ic] = max(s);
   lbA = A(:,ic);
end
