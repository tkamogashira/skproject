function SPTanova(DF, iseq, isub, Ntau, plotArg);
% SPTanova - variance comparisons for spiketrains
%   syntax: SPTanova(DF, iseq, isub, Ntau, plotArg);
%   Quick & dirty implementation.
%
%   Examples:
%     SPTanova() 
%     sac('M0314', '5-3', 2) adds plots to current figure 
%         using different colors
%
%   Note
%   make sure to set datadir correctly, e.g., at kiwi 
%   type: datadir B:\SGSRwork\ExpData\philip

if nargin<3,
   isub = [1 2];
end
if nargin<4,
   Ntau = 5;
end
if nargin<5,
   plotArg = ''; 
end

if length(iseq)>1, % recursive, one by one
   PC = '';
   for ii=1:length(iseq),
      SPTanova(DF, iseq(ii), isub, Ntau, PC);
      PC = ploco(ii+1);
      drawnow; pause(0.1);
   end
   return
end

ds = dataset(DF, iseq); 
tauExt = [0.050 20];
tau = exp(linspace(log(tauExt(1)), log(tauExt(2)), Ntau));
[V1 V2 V12] = sptvar(1./tau, ds, ds, isub);
V01 = sptvar(0, ds, isub(1));
V02 = sptvar(0, ds, isub(end));
Vrat = 2*V12./(V1+V2);

if isempty(plotArg), figure; end

subplot(2,1,1);
title(ds.title);
xplot(tau, tau*0+V01, [plotArg '--']);
xplot(tau, tau*0+V02, [plotArg '--']);
xplot(tau, [V1; V2], [plotArg ':']);
xplot(tau, [V12], [plotArg '-']);
ylabel('Spike-train variance')
set(gca,'xscale', 'log', 'xtick', [0.05 0.1 0.2 0.5 1 2 5 10 20]);
set(gca,'yscale', 'log');


subplot(2,1,2);
xplot(tau, Vrat, [plotArg '-']);
set(gca,'xscale', 'log', 'xtick', [0.05 0.1 0.2 0.5 1 2 5 10 20]);
xlabel('time scale (ms)');
ylabel('\sigma^2_{across} / \sigma^2_{within}')






