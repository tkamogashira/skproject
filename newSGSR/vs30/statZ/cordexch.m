function [settings, X] = cordexch(nfactors,nruns,model)
%CORDEXCH D-Optimal design of experiments - coordinate exchange algorithm.
%   CORDEXCH(NFACTORS,NRUNS,MODEL)  creates a d-optimal experimental
%   design using the coordinate exchange algorithm.
%
%   [SETTINGS, X] = CORDEXCH(NFACTORS,NRUNS,MODEL) generates the
%   factor settings matrix, SETTINGS, and the associated design
%   matrix, X. The number of factors, NFACTORS, and desired 
%   number of runs, NRUNS. The optional string input, MODEL, 
%   controls the order of the regression model. By default,
%   CORDEXCH returns the design matrix for a linear additive 
%   model with a constant term. MODEL can be following strings:
%   interaction - includes constant, linear, and cross product terms.
%   quadratic - interactions plus squared terms.
%   purequadratic - includes constant, linear and squared terms.

%   B.A. Jones 12-30-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.9 $  $Date: 1997/11/29 01:45:09 $


settings = unifrnd(-1,1,nruns,nfactors);
if nargin == 2
  model = 'linear';
end

if ~isstr(model)
   if nfactors ~= size(model,2)
      error('The number of columns in a numeric model matrix must equal the number of factors.');
   end
   nxij = linspace(-1,1,max(model(:))+1)';
else
   nxij = (-1:1)';
end

X = x2fx(settings,model);
if size(X,2) > size(X,1)
   error('There are not enough runs to fit the specified model.');
end


[Q,R]=qr(X,0);
logdetX = 2*sum(log(abs(diag(R))));

maxiter = 10;
iter = 0;
madeswitch = 1;

% Create Iteration Counter Figure.
screen = get(0,'ScreenSize');
f = figure('Units','Pixels','Visible', 'Off', ...
    'Position',[25 screen(4)-150 300 60], 'Color',[0.5 0.5 0.5]);
ax = gca;
set(ax,'Visible','off');
t=text(0,0.7,'Coordinate exchange iteration counter');
set(t,'FontName','Geneva','FontSize',12);
a = get(t,'extent');
set(f,'Position', [25,screen(4)-150,300*a(3), 60], 'Visible', 'On');

while madeswitch > 0 & iter < maxiter
   madeswitch = 0;
   iter = iter + 1;
   
   % Update iteration counter.
   s=sprintf('Iteration %4i',iter);
   set(f,'CurrentAxes',ax);
   h=text(0,0.2,s);
   set(h,'FontName','Geneva','FontSize',12);
   drawnow;
   
   %Loop over rows of factor settings matrix.
   for row = 1:nruns
      %Loop over columns of factor settings matrix.
      for col = 1:nfactors
         fx = x2fx(settings(row,:),model);
         xij = settings(row,col);
         xnew = settings(row,:);
         xnew = xnew(ones(length(nxij),1),:);
         xnew(:,col) = nxij;
         fxnew = x2fx(xnew,model);
         % Compute change in determinant.
         fxold = fx(ones(length(nxij),1),:);
         E = fxold/R;
         F = fxnew/R;
         dxold = sum((E.*E)')';
         dxnew = sum((F.*F)')';
         dxno  = sum((E.*F)')';

         d = (1 + dxnew).*(1 - dxold) + dxno.^2;

         % Find the maximum change in the determinant.
         [d,idx] = max(d);
         % Switch coordinates if the maximum change is greater than 1.
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
     
