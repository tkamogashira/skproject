function Y = convmult(X,M);
% convmult - convolution of columns of a matrix by the same vector
%   Y = multconv(X,M) is a column-wise convolution of matrix M and array X,
%   that is, Y = [conv(X,M(:,1)), conv(X,M(:,2)), ..]. Note that this
%   different from 2D convulution with a matrix.
%
%   See CONV, CONV2.

Ncol = size(M,2);
Nrow= size(M,1);
if ~isvector(X), error('Input X must be vector.'); end
X = X(:);
Y = zeros(numel(X)+Nrow-1,Ncol);
for icol=1:Ncol,
    Y(:,icol) = conv(X,M(:,icol));
end







