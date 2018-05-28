function ci = nlparci(x,f,J)
%NLPARCI Confidence intervals on parameters of nonlinear models.
%   CI = NLPARCI(X,F,J) returns the 95% confidence interval CI
%   on the nonlinear least squares parameter estimate X, given the 
%   residual sum of squares, F, and the Jacobian matrix ,J, at the solution.
%
%   The confidence interval calculation is valid for systems where 
%   the number of rows of J exceeds the length of X. 
%
%   NLPARCI uses the outputs of NLINFIT for its inputs.
%   Example:
%      [x,f,J]=nlinfit(input,output,model,xinit);
%      ci = nlparci(x,f,J);
%
%   See also NLINFIT.
%

%   Bradley Jones 1-28-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1998/07/10 14:45:54 $

%initialization
if nargin < 3
   error('Requires three inputs.');
end;

f = f(:);
[m,n] = size(J);
if m <= n
   error('The number of observations must exceed the number of parameters.');
end;

if length(x) ~= n
   error('The length of x must equal the number of columns in J.')
end

% approximation when a column is zero vector
temp = find(max(abs(J)) == 0);
if ~isempty(temp)
   J(temp,:) = J(temp,:) + sqrt(eps);
end;

%calculate covariance
[Q R] = qr(J,0);
Rinv = R\eye(size(R));
diag_info = sum((Rinv.*Rinv)')';

v = m-n;
rmse = sqrt(sum(f.*f)/v);

% calculate confidence interval
delta = sqrt(diag_info) .* rmse*tinv(0.975,v);
ci = [(x(:) - delta) (x(:) + delta)];

%--end of nlparci.m---

