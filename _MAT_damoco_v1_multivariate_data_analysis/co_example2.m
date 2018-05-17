function co_example2
% DAMOCO Toolbox, function CO_EXAMPLE2, version 16.01.11
%
% This function illustrates the bivariate analysis.
% It reads input data from the file co_vdp2.mat,
% reconstructs the phase model and quantifies the coupling.
% The data are from simulation of two coupled van der Pol 
% oscillators, see manual for parameters.
% This examples illustrates the Fourier-based algorithm.
% Contrary to the first example, this program illustrates
% every step of the algorithm and plots intermediate results.
%
disp(' ');disp(' ');disp(' ');disp(' ');
disp('--------  Starting co_example2  -----------');
disp('--  Plotting a piece of bivariate data  --');
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
disp(['Sampling frequency =' num2str(fsamp)]);
%
%%%%%%%%%%%%%%   step 1: computation of protophases  %%%%%%%%%%%%%%%%%%%%%
%
disp('--  Computung and plotting protophases via Hilbert transform  --');
% In simple cases like this one, the protophases can be computed via
% the Hilbert transform
[theta1,minampl]= co_hilbproto(x1,2); % Embedding is plotted as figure 2
% We use the default values for other parameters
disp(['Minimal amplitude over average amplitude is ' num2str(minampl)]);
% Graphic output and computation of the minimal instantaneous amplitude
% help to check whether the trajectory does not come too close to the origin,
% i.e. that the protophase is well-defined
[theta2]= co_hilbproto(x2); % Second protophase: without plot and 
% explicit check. Note that the program automatically checks the minamp 
% value, even if it is skipped in the call, and issues a warning, 
% if the data are not good enough for the Hilbert transform.
figure(3); plot(theta1,theta2,'r.','MarkerSize',1);
xlabel('\theta_1'); ylabel('\theta_2'); axis square; 
title('Raw protophases'); axis tight;
%
% For comparison we plot the coupling functins, constructed from raw
% protophases
%
Forder=10;      % order of Fourier series is 10
ngrid=50;       % grid size is 50
[Fcoef1,Fcoef2,f1,f2]=co_fexp2(theta1,theta2,Forder,fsamp,ngrid); 
co_plot2cplf(f1,f2,0,4,'\theta_1','\theta_2','F_1(\theta_1,\theta_2)',...
    'F_2(\theta_2,\theta_1)',...
    'Coupling function from raw protophases');
%%%%%%   step 2: univariate transformation as preprocessing   %%%%%%
%
disp('--  Performing 1D theta --> transformation  --');
[theta1_1,arg,sigma1] = co_fbtransf1(theta1);% default parameters are used
[theta2_1,arg,sigma2] = co_fbtransf1(theta2);
figure(5); plot(arg,sigma1,arg,sigma2,'r-'); % transformation functions are 
xlabel('\theta');ylabel('\sigma_{1,2}');     % plotted for illustration  
title('Univariate transformation functions'); xlim([0 pi2]);
% plot of protophases after univariate transformations
figure(6); plot(theta1_1,theta2_1,'r.','MarkerSize',1);
xlabel('\phi_1'); ylabel('\phi_2'); axis square; 
title('Protophases after univariate transformations'); axis tight;
%
%%%%%%%%%%%%   step 3: bivariate transformation   %%%%%%%%%%%%%%%%%%%
%
disp('--  Reconstructing phase dynamics from 1D transformed protophases  --');
[Fcoef1,Fcoef2,f1,f2]=co_fexp2(theta1_1,theta2_1,Forder,fsamp,ngrid); 
% These are coupling functions constructed from 1D-transformed protophases,
% The first one is plotted for further comparison.
co_plot2cplf(f1,f2,0,7,'\theta_1','\theta_2','F_1(\theta_1,\theta_2)',...
    'F_2(\theta_2,\theta_1)',...
    'Coupling function from 1D-transformed protophases');
%
% Now comes the bivariate transformation itself
disp('--  Performing 2D transformation  --');
[sigfc1,sigfc2,sigma1,sigma2,arg] = co_fbsolv(Fcoef1,Fcoef2,ngrid);
figure(8); plot(arg,sigma1,arg,sigma2,'-r'); % transformation functions are 
xlabel('\theta');ylabel('\sigma_{1,2}');     % plotted for illustration  
title('Bivariate transformation functions');  xlim([0 pi2]);
%
[phi1,phi2] = co_fbth2phi(theta1_1,theta2_1,sigfc1,sigfc2);
[Qc1,Qc2,q1,q2]=co_fexp2(phi1,phi2,Forder,fsamp,50); 
omeg1 = real(Qc1(Forder+1,Forder+1));         % 1st frequency is extracted from matrix Qcoef1 
omeg2 = real(Qc2(Forder+1,Forder+1));         % 2nd frequency is extracted from matrix Qcoef2
disp('Constant terms of the coupling functions');
disp('   (estimates of natural frequencies) are:');
disp(['omega1 = ' num2str(omeg1) ', omega2 = ' num2str(omeg2)]);
co_plot2cplf(q1,q2,0,9,'\phi_1','\phi_2','\omega_1+Q_1(\phi_1,\phi_2)',...
    '\omega_2+Q_2(\phi_2,\phi_1)',...
    'True coupling functions after bivariate transformation');
%
%%%%%%%%%%    step 5: quantification of coupling  %%%%%%%%%%%%%%%%%%%%
%
disp('--  Quantification of interaction  --');
siproto=co_sync(theta1,theta2,1,1);
disp(['Synchronization index from protophases ' num2str(siproto)]); 
siphase=co_sync(phi1,phi2,1,1);
disp(['Synchronization index from phases ' num2str(siphase)]); 
%
Nq1=co_fbnorm(Qc1); Nq2=co_fbnorm(Qc2);  % Norms of coupling functions
dirin1=co_dirin(Nq1,Nq2,omeg1,omeg2);
disp(['Directionality index (new version) = ' num2str(dirin1)]); 
dirin2=co_dirpar(Qc1, Qc2);
disp(['Directionality index (old version) = ' num2str(dirin2)]); 
%
disp('--------  End of co_example2  --------');
end