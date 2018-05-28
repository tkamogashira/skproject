function pv = PolyVal2D(P,X,Y);
% PolyVal2D - Evaluate polynomial in two variables
%   Y = PolyVal2D(P, Xa, Xb,N) returns the value of a polynomial P
%   evaluated at (Xa, Xa). P is a square matrix whose elements are 
%   the coefficients of the polynomial in descending powers.
%
%      Y = P(1,1)*Xa^N*Xb^N+P(2,1*Xa^(N-1)*Xb(N)+ .. + P(N+1,N+1)
%
%   Thus P(i,j) is the coefficient of the term Xa^(N+1-i)*Xa^(N+1-j).
%   If Xa and Xb are matrices or vectors, the polynomial is evaluated at 
%   all points in Xa and Xb. In this case, Xa must have the same or
%   compatible sizes as described in SameSize.
%
%   See also POLYFIT2D, POLYVAL SameSize.

% check if P is square
M = size(P,1);
if ~isequal(M, size(P,2)),
    error('Polynomial coeffient martix P must be square matrix');
end

% force X and Y into same size, if possible
[X,Y] = sameSize(X,Y);
SizeX = size(X); % store original size
% reshape X & Y in order to use matrix formulation
X = X(:); 
Y = Y(:).';
N = length(X);
% initialize X & Y Vandermonde matrices
MX = zeros(N,M);
MY = zeros(M,N); 
for m=1:M,
    Power = M-m;
    MX(:, m)=X.^Power;
    MY(m,:)=Y.^Power;
end
pv = diag(MX*P*MY);
pv = reshape(pv, SizeX);





