function Z = VectorZip(varargin)
% VectorZipN "zips" (interleaves) N equal-length vectors
% Syntax: VZ = VectorZip(X,Y,..Z);
% VZ = [X1 Y1 .. Z1 X2 Y2 .. Z2 ...]. 
% all inputs must be equal length vectors. VZ will be row (col)
% vector when the input vectors are row (col) vectors.

xs = size(varargin{1});
isRow = isequal(xs(1),1);
for ii=2:nargin
   if ~isequal(xs, size(varargin{ii}))
      error('all inputs must have equal size');
   end
end

Z = [];
for ii=1:nargin
   Z = [Z; varargin{ii}(:).']; 
end
Z = Z(:);

if isRow
   Z = Z.';
end
