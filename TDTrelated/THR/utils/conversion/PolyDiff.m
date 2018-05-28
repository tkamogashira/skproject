function P = PolyDiff(P,N);
% PolyDiff - derivative of a polynomial
%    PolyDiff(P), where P is an array representing a polynomial,
%    returns an array representing its first derivative.
%
%    PolyDiff(P,N) returns the Nth-order derivative of polynomial P.
%
%    See also POLYVAL, DIFF.

if nargin<2, N = 1; end % default: first-order derivative

if (N<0) || ~isreal(N) || ~isequal(round(N), N), 
    error('Order N must be nonnegative integer.'); 
end
iscol = (size(P,1)>1); % is P a column vector?
P = P(:).'; % force P to be a row vector
for ii=1:N,
    NP = length(P)-1; % order of P
    P = (NP:-1:1).*P(1:NP);
end
if isempty(P),
    P = 0;
end

if iscol, P = P(:); end