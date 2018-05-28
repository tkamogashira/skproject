function [p, s] = linregfit(xk, yk, wk)
%LINREGFIT Linear regression of data.
%   LINREGFIT(X, Y) weighted linear regression of sampled data in X and Y. The coefficients of a first order 
%   polynomial P(X) are returned as a two element vector.
%
%   [P, S] = LINREGFIT(X, Y, W) weighted linear regression of sampled data in X and Y. W is a vector
%   of same length as X and Y giving the weigth factor for each sample point. If requested the least square
%   deviation of this fit can be retrieved.
%      
%   See also SIGNLINREG, POLYFIT

%B. Van de Sande 23-04-2003

if ~any(nargin == [2,3]), error('Wrong number of input arguments.'); end
if nargin == 2, wk = repmat(1, length(xk), 1); end
if ~isequal(length(xk),length(yk),length(wk)), error('Arguments must be vectors with same length.'); end

[xk, yk, wk] = deal(xk(:), yk(:), wk(:));

%LSQ is functie van a en b
%Eerste afgeleide naar a van LSQ : y = a1*a + a2*b + a3
a1 = 2 * sum(wk.*(xk.^2));
a2 = 2 * sum(wk.*xk);
a3 = -2 * sum(wk.*xk.*yk);

%Eerste afgeleide naar b van LSQ : y = b1*b + b2*a + b3
b1 = 2 * sum(wk);
b2 = 2 * sum(wk.*xk);
b3 = -2 * sum(wk.*yk);

%Minimum is gegeven door oplossing van stelsel:
% 1) a1*a + a2*b + a3 = 0
% 2) b1*b + b2*a + b3 = 0

p(2) = (b2*a3 - a1*b3)/(b1*a1 - b2*a2);
p(1) = -(a2*p(2) + a3)/a1;

s = sum(wk.*(yk - polyval(p, xk)).^2);