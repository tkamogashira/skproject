function V = polyvalND(P, varargin);
% polyvalND - evaluation of polynomials in N variables
%    V = polyvalND(P, X,Y,..) evaluates the polynomial P in multiple variables
%    X,Y... P is an array vector holding the coefficients of the monomials
%    1, X, Y, ... X^2, X*Y, ... The order of the coefficients is described
%    in Monomial.
%
%    The input variables X,Y .. may be arrays or matrices having equal or
%    compatible sizes (see SameSize), in which case V is an array or matrix
%    holding the respective values of the N-D polynomial.
%
%    See also POLYVAL, Monomial, Partitions, SameSize.

V = 0;
for ii=1:length(P),
    V = V + P(ii)*monomial(ii, varargin{:});
end




