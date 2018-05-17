function [phi1, phi2] = co_fbth2phi(theta1, theta2, sigfc1, sigfc2)
% DAMOCO Toolbox, function CO_FBTH2PHI, version 17.01.11
% This function performs the theta --> phi transformation,
% using the coefficients sigfc1, sigfc2, provided by co_fbsolv.
%
% Form of call: [phi1,phi2] = co_fbth2phi(theta1,theta2,sigfc1,sigfc2)
% Input:  
%        theta1: Protophase of the 1st oscillator
%        theta2: Protophase of the 2nd oscillator
%        sigfc1: Coefficients of phase transformation, provided by co_fbsolv
%        sigfc2: Coefficients of phase transformation, provided by co_fbsolv
%   
% Output:
%        phi1: Phase of the 1st oscillator
%        phi2: Phase of the 2nd oscillator
%
or = (length(sigfc1)-1)/2;       % Computing order, or, from coefficients sigfc1
phi1 = theta1;   phi2 = theta2;
for n= 1 : or;                          % Performing transformation
    phi1 = phi1 + 2*real( sigfc1(n)*exp(1i*(n-(or+1))*theta1) / (1i*(n-(or+1))) );
    phi2 = phi2 + 2*real( sigfc2(n)*exp(1i*(n-(or+1))*theta2) / (1i*(n-(or+1))) );
end;
phi1 = mod(phi1,2*pi);
phi2 = mod(phi2,2*pi);
end
