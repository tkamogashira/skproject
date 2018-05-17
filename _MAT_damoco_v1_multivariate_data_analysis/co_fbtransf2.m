function [phi1,phi2,omeg1,omeg2,q1,q2,Qcoef1,Qcoef2,norm1,norm2,dirin] =...
    co_fbtransf2(theta1,theta2,or,safr,ngrid)
% DAMOCO Toolbox, function CO_FBTRANSF2, version 17.01.11
% This high-level function performs all steps of the phase transformation at once,
% using the Fourier-based method.
% Given two protophases theta1 and theta2, the order of the Fourier expansion, or, 
% and the sampling frequency of the data, safr, this function computes:
%      the true phases phi1 and phi2, 
%      the true coupling functions q1 and q2 on a grid of size ngrid, 
%      the Fourier coefficients of the coupling functions, Qcoef1 and Qcoef2,
%      the frequencies (constant terms of coupling functions) omeg1 and omeg2,
%      the norms of the coupling functions, norm1 and norm2, 
%      and the directionality index dirin.
% Form of call: 
%      [phi1,phi2,omeg1,omeg2,q1,q2,Qcoef1,Qcoef2,norm1,norm2,dirin] = co_fbtransf2(theta1,theta2,or,safr,ngrid)
%      [phi1,phi2,omeg1,omeg2,q1,q2,Qcoef1,Qcoef2,norm1,norm2,dirin] = co_fbtransf2(theta1,theta2,or,safr)
% Input:
%       theta1:     protophase of the 1st oscillator
%       theta2:     protophase of the 2nd oscillator
%       or:         order of the Fourier expansion: or = 10 is a good first choice.
%                   To check and optimize this parameter: plot the  matrix of abs(Qcoef) 
%                   using co_plotcoef and verify that the coefficients at the boundary of the matrix are small. 
%                   If not, increase the parameter or. If the region, where the coefficients are nearly zero, 
%                   is large, reduce or.    
%       safr:       sampling frequency
%       ngrid:      size of the grid to compute q1, q2; default value is ngrid=100
% Output: 
%       phi1:       true phase of the 1st oscillator
%       phi2:       true phase of the 2nd oscillator
%       omeg1:      autonomous frequency (constant term of the coupling function) of the 1st oscillator
%       omeg2:      autonomous frequency (constant term of the coupling function) of the 2nd oscillator
%       q1:         coupling function of the 1st oscillator, computed on a grid 
%                   Note: It does not contain the constant term, i.e. the
%                   phase dynamics is given by dphi1/dt = omeg1 + q1(phi1,phi2).
%       q2:         coupling function of the 2nd oscillator, computed on a
%                   grid, without constant term.
%       Qcoef1:     the coefficients of the Fourier expansion of q1.
%       Qcoef1:     the coefficients of the Fourier expansion of q2.
%       norm1:      the norm of q1.
%       norm2:      the norm of q2.
%       dirin:      the index of directionality of interaction between both oscillators: 
%                   dirin = 1: unidirectional coupling from 1 to 2. 
%                   dirin = -1: unidirectional coupling from 2 to 1.
%                   dirin = 0: equally strong bidirectional coupling  
%
co_testproto(theta1, theta2);        % Testing protophases
pr_theta1 = co_fbtransf1(theta1);    % Preprocessing with univariate Fourier based transform
pr_theta2 = co_fbtransf1(theta2);    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%       WARNING,  if protophases are too strongly correlated
[dummy, maxind]=co_maxsync(pr_theta1, pr_theta2, 2*or); clear dummy;
if maxind > 0.6;
    disp(['Synchronisation index is ' num2str(maxind)]);
    disp('Protophases are strongly correlated, the results may not be reliable!');
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%           FOURIER BASED METHOD
[Fcoef1, Fcoef2] = co_fexp2(pr_theta1, pr_theta2, or, safr);        % Computing coeffs of Fourier expansion of the protophase dynamics
[sigfc1, sigfc2] = co_fbsolv(Fcoef1, Fcoef2);                       % Computing coefficients of phase transformation
[phi1, phi2] = co_fbth2phi(pr_theta1, pr_theta2, sigfc1, sigfc2);   % Performing phase transformation
if nargin == 4; ngrid = 100; end;                                   % Default value of grid szize
[Qcoef1, Qcoef2, q1, q2] = co_fexp2(phi1, phi2, or, safr, ngrid);   % Computing coupling functions and their Fourier coeffs
omeg1 = real(Qcoef1(or+1,or+1));                    % Autonomous frequency is extracted from matrix Qcoef1 
omeg2 = real(Qcoef2(or+1,or+1));                    % Autonomous frequency is extracted from matrix Qcoef2
q1 = q1 - omeg1;                                    % Coupling function of the phase does not contain the autonomous frequency
q2 = q2 - omeg2;                                    % Coupling function of the phase does not contain the autonomous frequency
Qcoef1(or+1,or+1) = 0;                              % The coefficients describe the coupling function only, 
Qcoef2(or+1,or+1) = 0;                              % they do not contain the autonomous frequency omeg1
norm1 = co_fbnorm(Qcoef1);                          % Norms of the coupling functions
norm2 = co_fbnorm(Qcoef2);                      
dirin = co_dirin(norm1, norm2, omeg1,omeg2);        % Direction of couplinmg
end
