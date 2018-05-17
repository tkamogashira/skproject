function [sigfc1, sigfc2, sigma1, sigma2, arg] = co_fbsolv(Fcoef1, Fcoef2, ngrid)
% DAMOCO Toolbox, function CO_FBSOLV, version 17.01.11
% Given the coefficients Fcoef1, Fcoef2 of the Fourier expansion of the
% protophase dynamics, computed by co_fexp2, this function computes 
% Fourier coefficients sigfc1, sigfc2 of the phase transformation. 
% Optionally it returns the transformation functions, computed on the grid
% of size ngrid.
% 
% Form of Call:
%           [sigfc1,sigfc2] =  co_fbsolv(Fcoef1, Fcoef2)
%           [sigfc1,sigfc2,sigma1,sigma2,arg] = co_fbsolv(Fcoef1,Fcoef2)
%           [sigfc1,sigfc2,sigma1,sigma2,arg] = co_fbsolv(Fcoef1,Fcoef2,ngrid)
%
% INPUT
%  Fcoef1:   Coefficients of Fourier expansion of the protophase dynamics 
%            of the 1st oscillator, produced by co_fexp2. 
%  Fcoef2:   Coefficients of protophase dynamics of the 2nd oscillator,  
%            produced by co_fexp2.
%  ngrid:    grid size is required only if sigma1, sigma 2 are computed
%            Default value is ngrid = 100.
%   
% OUTPUT
%  sigfc1:   Fourier coefficients of the 1st phase transformation function
%  sigfc2:   Fourier coefficients of the 2st phase transformation function
%  sigma1:   Transformation function for the 1st oscillator
%  sigma2:   Transformation function for the 2nd oscillator
%            These function can be plotted as  plot(arg, sigma2)
%  arg:      argument for plotting sigma1 / sigma2
%
or = size(Fcoef1); or = ((or(1)-1)/2);                   % Compute order, or, from matrix Fcoef1;
[S] = fsolve(@nls, zeros(4*or+2,1), [], Fcoef1, Fcoef2); % Solving non-linear-system for coefficients in vector S
sigfc1 = S(1:2*or);                                      % Reorganzing the coefficients of the solution S
sigfc1 = [sigfc1(1:or); 1; sigfc1(or+1:end)];            
sigfc2 = S(2*or+1:4*or);                                 
sigfc2 = [sigfc2(1:or); 1; sigfc2(or+1:end)];            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%     Computing transformation functions sigma1, sigma2
if nargout == 5;
    if nargin ==2; ngrid=100; end;
    or=(length(sigfc1)-1)/2;
    arg=2*pi*(0:ngrid-1) / (ngrid-1);
    sigma1=zeros(1,ngrid); sigma2=sigma1;
    for n = -or:-1;
        sigma1 = sigma1 + 2*real(sigfc1(n+or+1)*exp(1i*n*arg)); 
        sigma2 = sigma2 + 2*real(sigfc2(n+or+1)*exp(1i*n*arg)); 
    end;
    sigma1 = sigma1+1;
    sigma2 = sigma2+1;
end;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x] = nls(X, Fcoef1, Fcoef2)           % Defining non-linear system from coefficients Fcoef1, Fcoef2
or = size(Fcoef1); or = ((or(1)-1)/2);

S = X(1:2*or);
S = [S(1:or);1;S(or+1:end)];

R = X(2*or+1:4*or);
R = [R(1:or);1;R(or+1:end)];
omeg1 = X(end-1);
omeg2 = X(end);

M = S*R.';

Fcoef1 = conj(Fcoef1); Fcoef2 = Fcoef2';
x(1) = sum(sum(M.*Fcoef1))-omeg1;
x(2) = sum(sum(M.*Fcoef2))-omeg2;

J = Fcoef1; K = Fcoef2;
for n = 1:or;
    J(1,:) = []; K(:,1) = [];
    J = [J;zeros(1,2*or+1)]; K = [K zeros(2*or+1,1)]; 
    x = [x sum(sum(M.*J))];
    x = [x sum(sum(M.*K))];
end;

J = Fcoef1; K = Fcoef2;
for n = 1:or;
    J(end,:) = []; K(:,end) = [];
    J = [zeros(1,2*or+1); J]; K = [zeros(2*or+1,1) K]; 
    x = [x sum(sum(M.*J))];
    x = [x sum(sum(M.*K))];
end;
end
