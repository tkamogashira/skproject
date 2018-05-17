function [phi1,phi2,omeg1,omeg2,q1,q2,Nrmq1,Nrmq2,dirin] =...
    co_ittransf2(theta1,theta2,or,fsamp,ngrid)
% DAMOCO Toolbox, function CO_ITTRANSF2, version 17.01.11
% This high-level function performs all steps of the phase transformation at once,
% using the iteration method.
% Given two protophases theta1 and theta2, the order of the Fourier expansion, or, 
% the sampling frequency of the data, fsamp,  and the grid size ngrid, this
% function computes: 
%      the true phases phi1 and phi2, 
%      the true coupling functions q1 and q2 on a grid of size ngrid, 
%      the frequencies (constant terms of coupling functions) omeg1 and omeg2,
%      the norms of the coupling functions, norm1 and norm2, 
%      and the directionality index dirin.
% Form of call: 
%      [phi1,phi2,omeg1,omeg2,q1,q2,Nrmq1,Nrmq2,dirin] = co_ittransf2(theta1,theta2,or,fsamp,ngrid)
%      [phi1,phi2,omeg1,omeg2,q1,q2,Nrmq1,Nrmq2,dirin] = co_ittransf2(theta1,theta2,or,fsamp)
% Input:
%       theta1:     protophase of the 1st oscillator
%       theta2:     protopahse of the 2nd oscillator
%       or:         order of the Fourier expansion: or = 10 is a good first choice.
%       fsamp:      sampling frequency
%       ngrid:      size of the grid to compute q1, q2; default value is ngrid=100
% Output: 
%       phi1:       true phase of the 1st oscillator
%       phi2:       true phase of the 2nd oscillator
%       omeg1:      autonomous frequency (constant term of the coupling function) of the 1st oscillator
%       omeg2:      autonomous frequency (constant term of the coupling function) of the 2nd oscillator
%       q1:         coupling function of the 1st oscillator, computed on an a grid 
%                   Note: It does not contain the constant term, i.e. the
%                   phase dynamics is given by dphi1/dt = omeg1 + q1(phi1,phi2).
%       q2:         coupling function of the 2nd oscillator, computed on a
%                   grid, without constant term.
%       Nrmq1:      the norm of q1.
%       Nrmq2:      the norm of q2.
%       dirin:      the index of directionality of interaction between both oscillators: 
%                   dirin = 1: unidirectional coupling from 1 to 2. 
%                   dirin = -1: unidirectional coupling from 2 to 1.
%                   dirin = 0: equally strong bidirectional coupling  
%
if nargin < 5       % default value for the grid size
    ngrid=100; 
end         
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
%%%%%%%%%%%%%%%%%%%%%           Iteration Method
[Fcoef1,Fcoef2,f1,f2]=co_fexp2(pr_theta1,pr_theta2,or,fsamp,ngrid); 
niter=4;       % number of iterations; 4 is usually sufficient
showiter=1;    % intermediate results are shown if showiter >0
[q1,q2,omeg1,omeg2,Nrmq1,Nrmq2,sigma1,sigma2]=co_itersolv(f1,f2,niter,showiter);
q1=q1-omeg1; q2=q2-omeg2;            % coupling functions do not contain constant terms
phi1=co_gth2phi(pr_theta1,sigma1);   % final transform of 1D-transformed protophases
phi2=co_gth2phi(pr_theta2,sigma2);
dirin = co_dirin(Nrmq1, Nrmq2, omeg1,omeg2);        % Direction of coupling
end
