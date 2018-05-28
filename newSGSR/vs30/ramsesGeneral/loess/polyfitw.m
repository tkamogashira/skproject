function p = polyfitw (x,y,n,w)
% polyfitw - weighted polynomial to data
%	p = polyfitw (x,y,n,w) finds the coefficients of a polynomial
%	p(x) of degree n that fits the data, p(x(i)) ~= y(i),
%	in a weighted least-squares sense with weights w(i). 
%       The weights are defined so that w=1/sigma^2.
%	This routine is based on polyfit. 
%
%	See also POLYFIT, POLY, POLYVAL, ROOTS.

%	Author(s): R. Johnson
%	$Revision: 1.0 $  $Date: 1995/11/27 $

% The regression problem is formulated in matrix format as:
%
%    A'*W*y = A'*W*A*p
%
% where the vector p contains the coefficients to be found.  For a
% 2nd order polynomial, matrix A would be:
%
% A = [x.^2 x.^1 ones(size(x))];

if nargin==4
    if any(size(x) ~= size(w))
        error('X and W vectors must be the same size.')
	end
    else
%		default weights are unity.
        w = ones(size(x));
    end
if any(size(x) ~= size(y))
    error('X and Y vectors must be the same size.')
end
x = x(:);
y = y(:);
w = w(:);

%  remove data for w=0 to reduce computations and storage
zindex=find(w==0);
x(zindex) = [];
y(zindex) = [];
w(zindex) = [];
nw = length(w);

% Construct the matrices. Use sparse form to avoid large weight matrix.
W = spdiags(w,0,nw,nw);

A = vander(x);
A(:,1:length(x)-n-1) = [];

V = A'*W*A;
Y = A'*W*y;

% Solve least squares problem. Use QR decomposition for computation.
[Q,R] = eval('qr(V,0)','qr(V)');

% The current PC version does not have the two-argument form of qr
[rows, cols] = size(R);
if rows ~= cols
   R = R(1:cols,:);
   Q = Q(:,1:cols);
end
    
p = R\(Q'*Y);    % Same as p = V\Y;
p = p';          % Polynomial coefficients are row vectors by convention.

