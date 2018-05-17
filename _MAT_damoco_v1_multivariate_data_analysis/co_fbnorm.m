function Nrmq = co_fbnorm(Qcoef)
% DAMOCO Toolbox, function CO_FBNORN, version 17.01.11
% Given the coefficients Qcoef of the Fourier expansion of the coupling
% function q, this functions returs the norm of q
% 
% Form of call: Nrmq = co_fbnorm(Qcoef)
% Input:        Qcoef are Fourier coefficients of the function
%
S=size(Qcoef);
or = (S(1)-1) / 2;
Qcoef(or+1,or+1)=0;                      % Setting the constant term omega to zero  
Nrmq = sqrt(sum(sum (abs(Qcoef).^2)));   % Computing the norm of coupling function 
end
