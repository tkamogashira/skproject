function[COR, Del1, Del2, Qcoef2_shift]=co_fbcfcor(Qcoef1, Qcoef2, ngrid) 
% DAMOCO Toolbox, function CO_FBCFCOR, version 17.01.11
%
% This function computes the correlation between two coupling functions
% given in terms of Fourier coefficients Qcoef1, Qcoef2. The correlation
% is defined as the maximum over all possible relative shifts of two coupling
% functions. The resolution of tested phase shifts is defined by ngrid.  
% In the computation, the coupling function of the first oscillator is taken
% as a reference, while the second one is shifted with respect to the
% first.
% 
% Form of call: 
%               COR = co_fbcfcor(Qcoef1, Qcoef2) 
%               COR = co_fbcfcor(Qcoef1, Qcoef2, ngrid) 
%               [COR, Delta1, Delta2]=co_fbcfcor(Qcoef1, Qcoef2, ngrid) 
%               [COR, Delta1, Delta2, Qcoef2_shift]=co_fbcfcor(Qcoef1, Qcoef2, ngrid) 
% Input:
%       Qcoef1, Qcoef2: The Fourier coefficients of both coupling functions
%       ngrid:          grid size, defaul is ngrid =100
% Output:
%       COR:            Maxmimal correlation of the coupling functions
%       Del1, Del2      Shifts of the own (phi2) and external (phi1) 
%                       phases which maximize the correlation between
%                       the shifted second coupling function and
%                       the first one (reference)  
%       Qcoef2_shift:   Fourier coefficients of the shifted coupling
%                       function for the second oscillator. Correlation
%                       between this function and the first one is maximal
%                       for zero shifts. 
if nargin<3; ngrid=100; end;
S = size(Qcoef1); S = S(1);
or = (S-1)/2;
Qcoef1(or+1, or+1)=0; % Autonomous frequencies are deleted if they are still present
Qcoef2(or+1, or+1)=0;
[X,Y] = meshgrid(2*pi*(0:ngrid-1)/ngrid, 2*pi*(0:ngrid-1)/ngrid);
M = zeros(size(X));
autCor1 = real(sum(sum(Qcoef1.*conj(Qcoef1)))); % Autocorrelation
autCor2 = real(sum(sum(Qcoef2.*conj(Qcoef2)))); 
for n = - or : or;
    for m = - or : or;     % Computing correlation for combinations of shifts
       M = M + (exp( 1i * (-n*X - m*Y) ) * Qcoef2(-n+or+1, -m+or+1) * Qcoef1(or+1+n, or+1+m)); 
    end;
end;
M=real(M);
Cor12 = M ./ sqrt( autCor2 .* autCor1 );
COR  = max(max(Cor12)); % computing maximal  correlation 
if nargout > 1 
    [m1, m2] = find(Cor12==COR);
    Del1 = X(m1,m2);
    Del2 = Y(m1,m2);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargout >3;
    Qcoef2_shift = zeros(S,S);
    for n = - or : or;
        for m = - or : or;       % Computing coefficients of the shifted coupling function 
            Qcoef2_shift(n+or+1, m+or+1) = exp( 1i * ( n*Del1 + m*Del2 )) * Qcoef2(n+or+1, m+or+1); 
        end;
    end;
end;
end
