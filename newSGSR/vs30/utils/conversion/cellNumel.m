function S = cellNumel(c);
% cellNumel - number of elements per cell of call matrix
%   cellNumel(c), where c is a MxN cell array, returns an
%   MxN matrix S with S(I,J) = numel(c{I,J})
%
%   See also Numel

if ~iscell(c),
   error('Input argument is not a cell array.')
end

% % two nested loops .. shame on me, but I don't know how to vectorize this one
% [M N] = size(c);
% S = zeros(M,N);
% for i=1:M
%    for j=1:N,
%       S(i,j) = numel(c{i,j});
%    end
% end

% found it - although MatLab's implementation cannot be called elegant either ..
S = cellfun('prodofsize',c);


