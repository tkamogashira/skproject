function co_example1
% DAMOCO Toolbox, function CO_EXAMPLE1, version 16.01.11
%
% This function illustrates the bivariate analysis.
% It reads the input data from the file co_vdp2.mat,
% reconstructs the phase model and quantifies the coupling.
% The data are from two coupled van der Pol oscillators,
% see manual for parameters.
% This examples illustrates the Fourier-based algorithm
%
pi2=pi+pi;
load co_vdp2.mat;
% The previous line loads to wokspace three variables:
%    signals x1 and x2, 
%    sampling frequency fsamp. 
figure(1); time=(1:1000)/fsamp;     % plotting a piece of data
plot(time,x1(1:1000),time,x2(1:1000),'-r'); 
xlabel('time'); ylabel('x_1,x_2'); 
title('Data from 2 coupled van der Pol oscillators (not all shown)');
xlim([0 time(end)]);
%
%%%%%%%%%%%%%%   step 1: computation of protophases  %%%%%%%%%%%%%%%%%%%%%
%
% In simple cases like this one, the protophases can be computed via
% the Hilbert transform
theta1= co_hilbproto(x1); % First protophase, no plot of the embedding, 
%                           default parameter values
theta2= co_hilbproto(x2); % Second protophase: also without plot.
% Note that the program automatically checks the minimal amplitude,
% even if the corresponding output parameter is skipped in the call, 
% and issues a warning, if the data are not good enough for 
% the Hilbert transform.
%
%%%%%%      Auxiliary step: univariate transformation just for    %%%%%%
%%%%%%    comparison with the results of bivariate trasformation  %%%%%%
%
Forder=7;       % order of Fourier series is 7
ngrid=50;        % grid size is 50
[Fcoef1,f1]=co_fexp1(theta1,theta2,Forder,fsamp,ngrid); 
% This is the first coupling functions constructed from raw protophases
% It is plotted for further comparison in the window number 2 (third
% parameter. Second parameter is zero; it means that all labels for the
% plot should be given manually.
co_plotcplf(f1,0,2,'\theta_1','\theta_2','F_1(\theta_1,\theta_2)',...
    'Coupling function from raw protophases');
%
%%% step 2: bivariate transformation by means of the high-level function %%%
[phi1,phi2,omeg1,omeg2,q1,q2,Qcoef1,Qcoef2,norm1,norm2,dirin]...
              = co_fbtransf2(theta1, theta2, Forder, fsamp, ngrid);
% First coupling function is plotted in the window number 3
co_plotcplf(q1,0,3,'\phi_1','\phi_2','\omega_1+Q_1(\phi_1,\phi_2)',...
    'True coupling function after bivariate transformation');
%
%%%%%%%%%%    step 4: quantification of coupling  %%%%%%%%%%%%%%%%%%%%
%
siphase=co_sync(phi1,phi2,1,1);
disp(['Synchronization index from phases ' num2str(siphase)]); 
disp(['Directionality index ' num2str(dirin)]); 
%
end