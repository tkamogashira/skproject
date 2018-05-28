function [ypred, delta] = nlpredci(model,inputs,x,f,J)
%NLPREDCI Confidence intervals for nonlinear least squares prediction.
%   [YPRED, DELTA] = NLPREDCI(MODEL,INPUTS,X,F,J) returns predictions, 
%   YPRED, and 95% confidence interval delta on the nonlinear least
%   squares prediction X, given the residuals, F, and the Jacobian, J.   
%
%   The confidence interval calculation is valid for systems where the 
%   length of F exceeds the length of X and J has full column rank at X. 
%
%   NLPREDCI uses the outputs of NLINFIT for its inputs.
%   Example:
%      [x,f,J]  = nlinfit(input,output,model,xinit);
%      [yp, ci[ = nlpredci(model,input,x,f,J);
%
%   See also NLINFIT.

%   Bradley Jones 1-28-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.9 $  $Date: 1998/07/10 14:45:54 $

%initialization
if nargin < 5
   error('Requires five inputs. Usage: [P, D] = NLPREDCI(MODEL,INPUTS,X,F,J)');
end;

f = f(:);
[m,n] = size(J);
if m <= n
   error('The number of observations must exceed the number of parameters.');
end;

if length(x) ~= n
   error('The length of X must equal the number of columns in J.')
end;

% approximation when a column is zero vector
temp = find(max(abs(J)) == 0);
if ~isempty(temp)
   J(temp,:) = J(temp,:) + sqrt(eps);
end;

%calculate covariance
[Q, R] = qr(J,0);
Rinv = R\eye(size(R));

evalstr = [model,'(x,inputs)'];
ypred = eval(evalstr);

delta = zeros(length(inputs),length(x));

for i = 1:length(x)
   change = zeros(size(x));
   change(i) = sqrt(eps)*x(i);
   evalstr1 = [model,'(x+change,inputs)'];
   predplus = eval(evalstr1);
   delta(:,i) = (predplus - ypred)/(sqrt(eps)*x(i));
end

E = delta*Rinv;
delta = sqrt(sum(E.*E,2));

v = m-n;
rmse = sqrt(sum(f.*f)/v);

% Calculate confidence interval
delta = delta .* rmse * tinv(0.975,v);
