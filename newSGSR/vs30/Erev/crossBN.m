function crossBN(apple1,apple2, plotArg, tau, difcorr);
% crossBN - analyze cross correlation of two apple transfers
global XCAT
if isempty(XCAT), XCAT='catXXX' ; end

if nargin<3, plotArg='n'; end
if nargin<4, tau=[]; end

isig1 = apple1.isign;
isig2 = apple2.isign;
Fcar1 = [apple1.Fcar(isig1)];
Fcar2 = [apple2.Fcar(isig2)];
Fmin = max([min(Fcar1) min(Fcar2)])
Fmax = min([max(Fcar1) max(Fcar2)])
fcar = linspace(Fmin,Fmax);

% interpolate trf functions
L1 = interp1(Fcar1,apple1.TRFamp(isig1),fcar);
L2 = interp1(Fcar2,apple2.TRFamp(isig2),fcar);
P1 = interp1(Fcar1,apple1.TRFphase(isig1),fcar);
P2 = interp1(Fcar2,apple2.TRFphase(isig2),fcar);

P1 = delayPhase(P1, fcar, -apple1.CDELAY, 0); % undo compensating delay
P2 = delayPhase(P2, fcar, -apple2.CDELAY, 0); % undo compensating delay

trf1 = db2a(L1).*exp(2*pi*i*P1);
trf2 = db2a(L2).*exp(2*pi*i*P2);
Xtrf = trf1.*conj(trf2);

LevelTrf = a2db(abs(Xtrf));
PhaseTrf = unwrap(angle(Xtrf))/2/pi;

subplot(3,1,1);
xplot(fcar,LevelTrf-max(LevelTrf),plotArg);
ylabel('Amplitude (dB)');
ylim([-40 0]);
title([XCAT ', cells ' num2str(apple1.iCell) '/' num2str(apple2.iCell)]);

subplot(3,1,2);
xplot(fcar,PhaseTrf,plotArg);
xlabel('Freq (kHz)')
ylabel('Phase (cycle)')

Nfft = 2^12;
fftFreq = linspace(0,15*Fmax,Nfft);
ltr = interp1([0 fcar 100], [-300 LevelTrf -3000],fftFreq);
Fpeak = maxloc(fftFreq,ltr)
ptr = interp1([0 fcar 1e6], PhaseTrf([1 1:end end]),fftFreq);
tfr = db2a(ltr).*exp(2*pi*i*ptr);
XC = real(ifft(tfr));
XC = fftshift(XC);

subplot(3,1,3);
time = linspace(0,1./diff(fftFreq(1:2)),Nfft);
time = time-0.5*max(time);
if isempty(tau),
   maxtau = 15;
else,
   maxtau = max(tau);
end
iok = find(abs(time)<=maxtau);
time = time(iok);
XC = XC(iok);

if isempty(tau),
   scalefactor = 1/std(XC);
else,
   difcorr = interp1(tau,difcorr,time);
   scalefactor = dot(difcorr,XC)/dot(XC,XC) % minimize squared diff between XC and difcorr
   xplot(time, difcorr, 'k:');
end
XC = scalefactor*XC;
xplot(time,XC,plotArg);
xlim(maxtau*[-1 1]);
% set(gca,'xtick',[-15:5:15]);
grid on
xlabel('delay (ms)');

figure(gcf);
%Tangle = unwrap(2*pi*([apple1.TRFphase]-[AA2.TRFphase]))




