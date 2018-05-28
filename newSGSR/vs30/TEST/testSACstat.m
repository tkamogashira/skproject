function testSACstat(ds,isub,BinWidth, NTrials)
% testSACstat - test theoretical sptcorr stats against bootstrap computation
% syntax:
%   testSACstat(ds,isub,BinWidth, NTrials)

if nargin<3, BinWidth = 0.05; end
if nargin<4, NTrials = 1e3; end
SPT = Anwin(ds,[],0,isub);
ds
Nspike = sum(cellnumel(SPT));
disp(['Nspike=' num2str(Nspike)]);

[p, BinCenters, Ppdf, Pcdf, Nco] = SACPeakSign(SPT, BinWidth, NTrials,ds.burstdur);
plot(BinCenters, Pcdf, 'x');
mu0 = round(mean(Nco)); si0 = std(Nco);
disp(['mu0=' num2str(mu0) '   si0=' num2str(si0)]);

tau = BinWidth/2;
Dur = ds.burstdur;

mu = round(2*Nspike^2*tau/Dur*(1-1/ds.nrep)); si = mu*sqrt((2+Dur/(tau*Nspike))/Nspike);
disp(['mu=' num2str(mu) '   si=' num2str(si)]);

xplot(BinCenters, 0.5*(1+erf((BinCenters-mu)/(sqrt(2)*si))),'g')

title([ds.title ' isub=' num2str(isub) '  SPL=' num2str(ds.SPL) ' dB  ' num2str(Nspike) ' spikes'])



