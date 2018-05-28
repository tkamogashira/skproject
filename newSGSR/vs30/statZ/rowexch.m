function [settings, X] = rowexch(nfactors,nruns,model)
%ROWEXCH D-Optimal design of experiments (row exchange algorithm).
%   [SETTINGS, X] = ROWEXCH(NFACTORS,NRUNS,MODEL) generates the
%   factor settings matrix, SETTINGS, and the associated design
%   matrix, X. The number of factors, NFACTORS, and desired 
%   number of runs, NRUNS. The optional string input, MODEL, 
%   controls the order of the regression model. By default,
%   ROWEXCH returns the design matrix for a linear additive 
%   model with a constant term. MODEL can be following strings:
%   interaction - includes constant, linear, and cross product terms.
%   quadratic - interactions plus squared terms.
%   purequadratic - includes constant, linear and squared terms.

%   B.A. Jones 12-30-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:46:41 $


settings = unifrnd(-1,1,nruns,nfactors);

if nargin < 3
  model = 'linear';
end

X = x2fx(settings,model);
[Q,R]=qr(X,0);
logdetX = 2*sum(log(abs(diag(R))));

info = inv(X'*X);

maxiter = 10;
iter = 0;
madeswitch = 1;

% Create Iteration Counter Figure.
screen = get(0,'ScreenSize');
f = figure('Units','Pixels','Position',[25 screen(4)-150 300 60],...
    'Color',[0.5 0.5 0.5]);
ax = gca;
set(ax,'Visible','off');
t=text(0,0.7,'Row exchange iteration counter.');
set(t,'FontName','Geneva','FontSize',12);

while madeswitch > 0 & iter < maxiter
   madeswitch = 0;
   iter = iter + 1;

   % Update iteration counter.
   s=sprintf('Iteration %4i',iter);
   set(f,'CurrentAxes',ax);
   h=text(0,0.2,s);
   set(h,'FontName','Geneva','FontSize',12);
   drawnow;
  
   for row = 1:nruns
      fx = x2fx(settings(row,:),model);
      xi = settings(row,:);
      if strcmp(model,'quadratic') | strcmp(model,'purequadratic') | ...
         strcmp(model,'q') | strcmp(model,'p')
         xnew = fullfact(3*ones(nfactors,1)) - 2;
         fxold = fx(ones(3.^nfactors,1),:);
      elseif strcmp(model,'linear') | strcmp(model,'interaction') ...
         | strcmp(model,'l') | strcmp(model,'i')
         xnew = 2*(fullfact(2*ones(nfactors,1)) - 1.5);
         fxold = fx(ones(2.^nfactors,1),:);
      else
         xnew = (fullfact(5*ones(nfactors,1)) - 3)/2;      
         fxold = fx(ones(5.^nfactors,1),:);
      end
      fxnew = x2fx(xnew,model);
      
      E = fxold/R;
      F = fxnew/R;
      dxold = sum((E.*E)')';
      dxnew = sum((F.*F)')';
      dxno  = sum((E.*F)')';

      d = (1 + dxnew).*(1 - dxold) + dxno.^2;
     
      % Find the maximum change in the determinant.
     [d,idx] = max(d);
     
      % Switch rows if the maximum change is greater than 1.
      if d > 1,
         madeswitch = 1;
         logdetX = log(d) + logdetX;
         settings(row,:) = xnew(idx,:);
         X(row,:) = fxnew(idx,:);
         [Q,R] = qr(X,0);      
      end
   end
delete(h);
end
close(f);       
     
