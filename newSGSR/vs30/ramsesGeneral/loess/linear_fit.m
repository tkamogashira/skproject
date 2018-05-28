function [a,b,Sigma_a,Sigma_b,Q,Cov_ab,r_ab,Chi2,R] = linear_fit (x,y,Sigma_y)
%
% [a,b,Sigma_a,Sigma_b,Q,Cov_ab,R_ab,Chi2,R] = linear_fit (x,y,?Sigma_y?)
%
% Given data vectors (x,y) with optional individual standard 
% deviations, Sigma_y, fits them to a straight line, 
%         y = a + b*x.
% Returns intercept a and slope b and their respective probable
% uncertainties, Sigma_a and Sigma_b. Also returns the covariance, 
% Cov_ab, and correlation coefficient, r_ab, between the uncertainties 
% in a and b. Also returns the value of chi^2, Chi2, and the goodness-of-fit
% probability, Q, that the fit would have chi^2 this large or larger by
% chance (Q > 0.1 is good). Finally, returns in R the value of the
% linear correlation coefficient (Pearson's product-moment coefficient).
%
% If the Sigma_y are not provided, the routine estimates these
% errors statistically by *assuming* a good fit. Consequently,
% no independent goodness-of-fit probability Q is returned.
%
% If called with a single output variable, the output parameters
% are assembled into a vector with corresponding elements. Hence,
% a=argout(1), b=argout(2), etc. This is useful for bootstrap applications.
%
% Reference: Press et al, Numerical Recipes in C, 2nd Edition, pg 661ff.
% See also fitexy().
%  
% C.A.Shera
%
estimate_errors = 0;
if (nargin < 3)
  Sigma_y = ones (size (y));
  estimate_errors = 1;
end
if (length (x) ~= length (y))
  error ('Vectors x and y must have the same length');
end
if (length (x) < 2)
  error ('Need at least two points to fit a line');
end
if (length (Sigma_y) == 1)
  Sigma_y = Sigma_y * ones (size (y));
end
if (length (Sigma_y) ~= length (y))
  error ('Vectors y and Sigma_y must have the same length');
end

x       = x(:);
y       = y(:);
Sigma_y = Sigma_y(:);

wt = 1./Sigma_y.^2;

S  = sum (wt);
Sx = sum (x.*wt);
Sy = sum (y.*wt);

SxoS = Sx/S;

t = (x - SxoS)./Sigma_y;
Stt = sum (t.*t);

N        = length (x);
b        = sum (t.*y./Sigma_y) / Stt;
a        = (Sy-Sx*b) / S;
Sigma_a  = sqrt ((1+Sx*Sx/(S*Stt))/S);
Sigma_b  = sqrt (1/Stt);
Cov_ab   = -Sx / (S*Stt);
r_ab     = Cov_ab / (Sigma_a*Sigma_b);
Chi2     = sum (((y-(a+b*x))./Sigma_y).^2);
Q        = 1 - gammainc (Chi2/2, (N-2)/2);

% from Eqs. 15.2.13 and 15.2.14
R       = corrcoef(x,y);		% returns matrix
R       = R(1,2);

if (estimate_errors)
  Q = 1.0;		  % assume good fit
  factor = sqrt(Chi2/(N-2));
  Sigma_a  = Sigma_a * factor;
  Sigma_b  = Sigma_b * factor;
end

if (nargout==1)
  % return everything as a row vector (this is useful
  % for bootstrapping...)
  a = [a,b,Sigma_a,Sigma_b,Q,Cov_ab,r_ab,Chi2,R];
end


