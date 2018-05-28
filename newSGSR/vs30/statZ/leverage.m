function h = leverage(data,model)
%LEVERAGE Regression diagnostic.
%   LEVERAGE(DATA,MODEL) finds the leverage on a regression of each
%   row (point) in the matrix, DATA. The argument, MODEL, controls the 
%   order of the regression model. By default, LEVERAGE assumes a linear 
%   additive model with a constant term. MODEL can be following strings:
%   interaction - includes constant, linear, and cross product terms.
%   quadratic - interactions plus squared terms.
%   purequadratic - includes constant, linear and squared terms.

%   See also REGSTATS.

%   Reference Goodall, C. R. (1993). Computation using the QR decomposition. 
%   Handbook in Statistics, Volume 9.  Statistical Computing
%   (C. R. Rao, ed.).   Amsterdam, NL: Elsevier/North-Holland.


%   B.A. Jones 1-6-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1997/11/29 01:45:44 $

if nargin == 1
  model = 'linear';
end

X = x2fx(data,model);
[Q, R] = qr(X,0);
E = X/R;
h = sum((E.*E)')';
