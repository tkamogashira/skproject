function [p,S,mu] = wpolyfit(x,y,w,n)
% WPOLYFIT - Fit polynomial to data using weight factors.
%   P = WPOLYFIT(X,Y,W,N) finds the coefficients of a polynomial P(X) of
%   degree N that fits the data Y best in a least-squares sense using
%   weights W. The error minimized is SSQ = sum(W.*(Y-Yp).^2), where Yp
%   denotes the description of the data in terms of the polynomial P.
%   P is a row vector of length N+1 containing the polynomial coefficients
%   in descending powers, P(1)*X^N + P(2)*X^(N-1) +...+ P(N)*X + P(N+1).
%   When all weights are equal, WPOLYFIT is equivalent to POLYFIT.
%   When Y(k) are measured data with estimated variance S(k), a proper
%   choice for the weights is W(k) == 1./S(k).
%
%   [P,S] = WPOLYFIT(X,Y,N) returns the polynomial coefficients P and a
%   structure S for use with POLYVAL to obtain error estimates for
%   predictions.  S contains fields for the triangular factor (R) from a QR
%   decomposition of the Vandermonde matrix of X, the degrees of freedom
%   (df), and the norm of the residuals (normr).  If the data Y are random,
%   an estimate of the covariance matrix of P is (Rinv*Rinv')*normr^2/df,
%   where Rinv is the inverse of R.
%
%   [P,S,MU] = WPOLYFIT(X,Y,N) finds the coefficients of a polynomial in
%   XHAT = (X-MU(1))/MU(2) where MU(1) = MEAN(X) and MU(2) = STD(X). This
%   centering and scaling transformation improves the numerical properties
%   of both the polynomial and the fitting algorithm.
%
%   Warning messages result if N is >= length(X), if X has repeated, or
%   nearly repeated, points, or if X might need centering and scaling.
%
%   Class support for inputs X,Y:
%      float: double, single
%
%   See also POLYFIT, POLY, POLYVAL, ROOTS, Polyval2D.

%---------------------------
%   Adapted from MATLAB's polyfit by MvdH
%   The idea is simple: p=polyfit(x,y,n) minimizes 
%              SSQ=sum((y-yp).^2), 
%   where yp=polyval(p,x). In POLYVAL.m this is reformulated as a matrix
%   problem for finding p from y=V*p (with V the Vandermonde matrix for x),
%   which is then solved using matrix left division.
%   Now in order to change SSQ into its weigthed version
%              SSQW=sum(w.*(y-yp).^2), 
%   we simply have to scale both y and yp by sqrt(w):
%             y ->  y.*sqrt(w)
%            yp -> yp.*sqrt(w).
%   In the matrix formulation, yd = V*p, so a scaling of the rows of V
%   using weigthing coefficients w will effectively scale the yp.
%   Summarizing, the substitution of y and V by y.*sqrt(w) and
%   V.*repmat(sqrt(w),1,n+1).
%---------------------------

% The regression problem is formulated in matrix format as:
%
%    y = V*p    or
%
%          3  2
%    y = [x  x  x  1] [p3
%                      p2
%                      p1
%                      p0]
%
% where the vector p contains the coefficients to be found.  For a
% 7th order polynomial, matrix V would be:
%
% V = [x.^7 x.^6 x.^5 x.^4 x.^3 x.^2 x ones(size(x))];

if ~isequal(size(x),size(y)) || ~isequal(size(x),size(w)), 
    error('MATLAB:wpolyfit:XYSizeMismatch',...
          'X, Y, W vectors must be the same size.')
end

x = x(:);
y = y(:);
sw = sqrt(w(:)); % scalors (see above comments on implementing weights)

% weighing of y
y = y.*sw;

if nargout > 2
   mu = [mean(x); std(x)];
   x = (x - mu(1))/mu(2);
end

% Construct Vandermonde matrix.
V(:,n+1) = ones(length(x),1,class(x));
for j = n:-1:1
   V(:,j) = x.*V(:,j+1);
end
% scale rows of V (see above comments on implementing weights)
V = V.*samesize(sw,V);

% Solve least squares problem.
[Q,R] = qr(V,0);
ws = warning('off','all'); 
p = R\(Q'*y);    % Same as p = V\y;
warning(ws);
if size(R,2) > size(R,1)
   warning('MATLAB:wpolyfit:PolyNotUnique', ...
       'Polynomial is not unique; degree >= number of data points having non-zero weights.')
elseif warnIfLargeConditionNumber(R)
    if nargout > 2
        warning('MATLAB:wpolyfit:RepeatedPoints', ...
                ['Polynomial is badly conditioned. Add points with distinct X\n' ...
                 '         values or reduce the degree of the polynomial.']);
    else
        warning('MATLAB:wpolyfit:RepeatedPointsOrRescale', ...
                ['Polynomial is badly conditioned. Add points with distinct X\n' ...
                 '         values, reduce the degree of the polynomial, or try centering\n' ...
                 '         and scaling as described in HELP POLYFIT.']);
    end
end
r = y - V*p;
p = p.';          % Polynomial coefficients are row vectors by convention.

% S is a structure containing three elements: the triangular factor from a
% QR decomposition of the Vandermonde matrix, the degrees of freedom and
% the norm of the residuals.
S.R = R;
S.df = max(0,length(y) - (n+1));
S.normr = norm(r);

function flag = warnIfLargeConditionNumber(R)
if isa(R, 'double')
    flag = (condest(R) > 1e+10);
else
    flag = (condest(R) > 1e+05);
end
