function Ggrid = barycentriclagrange(this,Ck,grid)
%BARYCENTRICLAGRANGE   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

% Evaluate the approximating polynomial at all grid points by using the
% Lagrange interpolation formula in barycentric form
M = this.M;
fext = this.fext(1:end-1); % Notice last point not used

beta = lagrangecoeff(this,M+1,fext);

% 
Ggrid = zeros(size(grid));
for n = 1:length(grid),
   Ggrid(n) = evalG(Ck,beta,fext,grid(n));
end

%----------------------------------------
function Ggrid_x = evalG(Ck,beta,fext,x)

Ggrid_x = Ck(x==fext);
if isempty(Ggrid_x),
    betaprime = beta./(cos(x*pi)-cos(fext*pi));
    Ggrid_x = sum(Ck.*betaprime)/sum(betaprime);
end

% [EOF]
