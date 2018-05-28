function RR = DPOAE(freq1, Frat, DPlevel, phi, Nrep, Twait);
% DPOAE - measurement of DPAOEs in ear canal
if nargin<5, Nrep = 1; end
if nargin<6, Twait = 12; end

Atten = 30;

if length(phi)>1,
   RR = [];
   pause(Twait);
   for ii=1:length(phi),
      rr = DPOAE(freq1, Frat, DPlevel, phi(ii), Nrep, 0.1);
      RR = [RR; rr];
   end
   return
end

global SGSR

rampDur = 20; % ms

TT=0; 
Dur = 4000; 
Amp = 1e4; 
freq = freq1*[1; Frat]; 
Fsam = SGSR.samFreqs(1); 
NN = round(1e-3*Dur*Fsam);
% NN = 2^nextpow2(NN);
tim = linspace(0,Dur, NN); 
TT = Amp*sin(2*pi*freq*tim); 
TT(2,:) = 0.5*TT(2,:);


fCDT = [2 -1]*freq; 
phase = 2*pi*(phi + fCDT*tim);
Nflip = 16; 
FlipFrac = 0.05;
NsamFlip = round(NN/Nflip);
Nsweep = round(FlipFrac*NsamFlip);
Sweep = linspace(0,pi,Nsweep);
for iflip=1:Nflip,
   offset = (iflip-1)*NsamFlip;
   isam = offset+(1:Nsweep); 
   phase(isam) = phase(isam) + Sweep;
   if isequal(1, rem(iflip,2)),
      jsam = offset+(Nsweep+1:NsamFlip); 
   else, jsam = isam;
   end
   phase(jsam) = phase(jsam) + pi;
end
% f2; plot(tim, phase); ihjkjgh
CDT = db2a(DPlevel)*(Amp*sin(phase));
NN = length(TT); 
% f2; plot(tim, CDT); ihjkjgh
TT(2,:) = TT(2,:) + CDT;

Nramp = round(1e-3*rampDur*Fsam);
Rise = sin(linspace(0,pi/2,Nramp)).^2;
Fall = flipLR(Rise);
for ichan=1:2,
   TT(ichan, 1:Nramp) = TT(ichan, 1:Nramp).*Rise;
   TT(ichan, end-Nramp+1:end) = TT(ichan, end-Nramp+1:end).*Fall;
end

II = 0; 
cleanAP2; 
PlayRecOAE({TT}, 1, 99); RR = 0 ; 
setPA4s(Atten);

pause(Twait); 
for ii= 1:Nrep, 
   RR = RR + PlayRecOAE([], 1, Atten); pause(0.2); 
end; 

%f1
%Spec = a2db(abs(fft(RR))); 
%Spec = a2db(abs(hann(length(RR)).'.*fft(RR))); 
%Spec = Spec-max(Spec); dplot(1e3/Dur, Spec(1:3e4)); 
%ylim([-100 0]); grid on


