function Z = VectorZip(varargin);
% VectorZip - interleave N equal-length vectors
%   VZ = VectorZip(X,Y,..Z) distributes the elements of equal-length
%   arrays X,Y,..,Z as follows:
%       VZ = [X(1) Y(1) .. Z(1) X(2) Y(2) .. Z(2) ...]. 
%   VZ will be row (col) vector when the input vectors are row (col) vectors.

Z = []; % default return value for trivial cases
if nargin<1, return; end

N = cellfun(@numel, varargin);
if any(diff(N)~=0),
    error('All inputs must have same # elements.');
end
N = N(1);
if N==0, return; end

if any(~cellfun(@isvector, varargin)),
    error('All inputs must be vectors.');
end

Sz = cellfun(@size, varargin, 'uniformoutput', false);
Sz = unique(cat(1,Sz{:}), 'rows');
if size(Sz,1)>1,
    error('All inputs must have same size.');
end

isRow = Sz(2)>1; % inputs are row vectors

if isRow,
    Z = cat(1,varargin{:});
    Z = Z(:).';
else,
    Z = cat(2,varargin{:}).';
    Z = Z(:);
end






