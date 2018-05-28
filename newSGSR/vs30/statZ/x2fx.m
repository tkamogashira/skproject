function D = x2fx(x,model)
%X2FX   Factor settings matrix (x) to design matrix (fx).
%   D = X2FX(X,'MODEL') Transforms a matrix of system inputs, X, to 
%   the design matrix for a regression analysis. The optional string
%   input, MODEL, controls the order of the regression model. By 
%   default, X2FX returns the design matrix for a linear additive
%   model with a constant term. MODEL can be following strings:
%   interaction (i)   - includes constant, linear, and cross product terms.
%   quadratic (q)     - interactions plus squared terms.
%   purequadratic (p) - includes constant, linear and squared terms.
%   
%   Alternatively, MODEL can be a matrix of terms. Each row of MODEL 
%   represents one term. The value in a column is the exponent to raise 
%   the same column in X for that term. D(i,j) = prod(x(i,:).^model(j,:)). 
%   This allows for models with polynomial terms of arbitrary order.
%
%   Example: x = [1 2 3]' model = [0 1 2]'
%   D = [1 1 1; 1 2 4; 1 3 9] 
%   The first column is x to the 0th power. The second column is x to
%   the 1st power. And the last column is x squared.
% 
%   X2FX is a utility function for RSTOOL, REGSTATS and CORDEXCH.
%   See also RSTOOL, CORDEXCH, ROWEXCH, REGSTATS. 

%   B.A. Jones 12-20-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.10 $  $Date: 1998/03/18 19:20:27 $


[m,n]  = size(x);

if nargin == 1,
   D = [ones(m,1) x];
   return,
end

if strcmp(model,'linear') | strcmp(model,'l') | strcmp(model,'L') | ...
   strcmp(model,'Linear') | strcmp(model,'additive') | strcmp(model,'Additive'),
   D = [ones(m,1) x];

elseif strcmp(model,'interaction') | strcmp(model,'quadratic') | ...
   strcmp(model,'q') | strcmp(model,'i') | strcmp(model,'Interaction') | ...
   strcmp(model,'Quadratic') | strcmp(model,'interactions') | ...
   strcmp(model,'Interactions') | strcmp(model,'Q') | strcmp(model,'I'),
   D = [ones(m,1) x];
   for idx = 1:n
      xidx   = x(:,idx);
      xidx   = xidx(:,ones(n-idx,1));
      D = [D xidx .* x(:,idx+1:n)];
   end
   if strcmp(model,'quadratic') | strcmp(model,'q') | strcmp(model,'Q') | ...
      strcmp(model,'Quadratic'),
      D = [D x.*x];
   end

elseif strcmp(model,'purequadratic') | strcmp(model,'p') | ...
    strcmp(model,'Purequadratic') | strcmp(model,'P'),
    D = [ones(m,1) x x.*x];
	
elseif strcmp(model,'model') | strcmp(model,'MODEL')
    dlgname = 'Not a Model';
	warningstr = ['Sorry, ' model ' is not a valid string for the  model parameter.'];
	warndlg(warningstr,dlgname);
	
elseif isstr(model)
    D = feval(model,x);  %Allows for extensions to named higher order models. (e.g. 'cubic')

elseif ~isstr(model)
   [row,col] = size(model);
   if col ~= n
      error('A numeric second argument must have the same number of columns as the first argument.');
   end
   D = zeros(m,row);
   for idx = 1:row
      carat = model(idx,:);
      tmp = x.^carat(ones(m,1),:);
      if size(tmp,2) == 1
         D(:,idx) = tmp;
      else
         D(:,idx) = (prod(tmp'))';
      end
   end
end
