function [beta,r,J] = nlinfit(X,y,model,beta0)
%NLINFIT Nonlinear least-squares data fitting by the Gauss-Newton method.
%   NLINFIT(X,Y,'MODEL',BETA0) finds the coefficients of the nonlinear 
%   function described in MODEL. MODEL is a user supplied function having 
%   the form y = f(beta,x). That is MODEL returns the predicted values of y
%   given initial parameter estimates, beta, and the independent variable, X.   
%   [BETA,R,J] = NLINFIT(X,Y,'MODEL',BETA0) returns the fitted coefficients
%   BETA the residuals, R, and the Jacobian, J, for use with NLINTOOL to
%   produce error estimates on predictions.

%   B.A. Jones 12-06-94.
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.12 $  $Date: 1998/09/09 19:39:39 $

n = length(y);
if min(size(y)) ~= 1
   error('Requires a vector second input argument.');
end
y = y(:);

if size(X,1) == 1 % turn a row vector into a column vector.
   X = X(:);
end

p = length(beta0);
beta0 = beta0(:);

J = zeros(n,p);
beta = beta0;
betanew = beta + 1;
maxiter = 100;
iter = 0;
betatol = 1.0E-4;
rtol = 1.0E-4;
sse = 1;
sseold = sse;
seps = sqrt(eps);
zbeta = zeros(size(beta));
s10 = sqrt(10);
eyep = eye(p);
zerosp = zeros(p,1);

while (norm((betanew-beta)./(beta+seps)) > betatol | abs(sseold-sse)/(sse+seps) > rtol) & iter < maxiter
   if iter > 0, 
      beta = betanew;
   end

   iter = iter + 1;
   yfit = feval(model,beta,X);
   r = y - yfit;
   sseold = r'*r;

   for k = 1:p,
      delta = zbeta;
      delta(k) = seps*beta(k);
      yplus = feval(model,beta+delta,X);
      J(:,k) = (yplus - yfit)/delta(k);
   end

   Jplus = [J;(1.0E-2)*eyep];
   rplus = [r;zerosp];

   % Levenberg-Marquardt type adjustment 
   % Gauss-Newton step -> J\r
   % LM step -> inv(J'*J+constant*eye(p))*J'*r
   step = Jplus\rplus;
   
   betanew = beta + step;
   yfitnew = feval(model,betanew,X);
   rnew = y - yfitnew;
   sse = rnew'*rnew;
   iter1 = 0;
   while sse > sseold & iter1 < 12
      step = step/s10;
      betanew = beta + step;
      yfitnew = feval(model,betanew,X);
      rnew = y - yfitnew;
      sse = rnew'*rnew;
      iter1 = iter1 + 1;
   end
end
if iter == maxiter
   disp('NLINFIT did NOT converge. Returning results from last iteration.');
end
