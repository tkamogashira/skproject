function [settings, X] = dcovary(factors,covariates,model)
%DCOVARY D-Optimal design with fixed covariates.
%   DCOVARY creates a D-Optimal design subject to the constraint of
%   fixed covariates for each run using the coordinate exchange
%   algorithm.
%
%   [SETTINGS, X] = DCOVARY(NFACTORS,COVARIATES,MODEL) generates the
%   factor settings matrix, SETTINGS, and the associated design
%   matrix, X. The optional string input, MODEL, 
%   controls the order of the regression model. By default,
%   DCOVARY returns the design matrix for a linear additive 
%   model with a constant term. MODEL can be following strings:
%   interaction - includes constant, linear, and cross product terms.
%   quadratic - interactions plus squared terms.
%   purequadratic - includes constant, linear and squared terms.

%   B.A. Jones 2-18-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:11 $

[nruns,ncov] = size(covariates);
settings = unifrnd(-1,1,nruns,factors);
if nargin == 2
  model = 'linear';
end

settings = [settings covariates];

X = x2fx(settings,model);
[Q,R]=qr(X,0);
logdetX = 2*sum(log(abs(diag(R))));

info = inv(X'*X);

% Create Iteration Counter Figure.
screen = get(0,'ScreenSize');
f = figure('Units','Pixels','Position',[25 screen(4)-150 300 60],...
    'Color',[0.5 0.5 0.5]);
ax = gca;
set(ax,'Visible','off');
t=text(0,0.7,'D-optimal design iteration counter');
set(t,'FontName','Geneva','FontSize',12);

maxiter = 10;
iter = 0;
madeswitch = 1;

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
      for col = 1:factors
        fx = x2fx(settings(row,:),model);
         xij = settings(row,col);
       nxij = (-1:1)';
       xnew = settings(row,:);
       xnew = xnew(ones(length(nxij),1),:);
       xnew(:,col) = nxij;
       fxnew = x2fx(xnew,model);
       fxold = fx(ones(length(nxij),1),:);

       % Compute change in determinant.
       E = fxold/R;
         F = fxnew/R;
         dxold = sum((E.*E)')';
         dxnew = sum((F.*F)')';
         dxno  = sum((E.*F)')';

         d = (1 + dxnew).*(1 - dxold) + dxno.^2;

         % Find the maximum change in the determinant.
       [d,idx] = max(d);
       if d > 1,
          madeswitch = 1;
          logdetX = log(d) + logdetX;
         settings(row,:) = xnew(idx,:);
         X(row,:) = fxnew(idx,:);
         [Q,R] = qr(X,0);      
        end
      end
   end
   delete(h);
end
close(f);       
     
