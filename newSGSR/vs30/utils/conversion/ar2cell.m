function C = ar2cell(x);
% AR2CELL - convert numerical array to cell array with same elements
x = x(:).';
C = {};
for ii=1:length(x),
   C = {C{:}, x(ii)};
end

