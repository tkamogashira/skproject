function PST = revart(CF,BW, Nspike, maxLag, maxFreq);
% RevArt - test for artefacts in HF revcor analysis

if nargin<3, Nspike = 1e4; end
if nargin<4, maxLag = 10; end % ms max lag
if nargin<5, maxFreq = nan; end % max freq in spec

   
   
Fsam = 12; % kHz sample freq
if isnan(maxFreq), maxFreq = Fsam/2; end
Dur = 20000; % ms noise duration
Flo = CF-0.5*BW; Fhi = CF+0.5*BW; % filter cutoffs

NsamF = round(Fsam*Dur/2); % # spectral samples
Nlo = round(2*NsamF*Flo/Fsam); % first sample of spectrum
Nhi = round(2*NsamF*Fhi/Fsam);

NoiseSpec = randn(NsamF,1)+i*randn(NsamF,1); % pos freqs only
NoiseSpec(1) = 0; % no DC
NoiseSpec = [NoiseSpec; conj(flipUD(NoiseSpec))]; % pos & neg freqs
WF = real(ifft(NoiseSpec)); % waveform of broadband noise

% bandpass filter in spectral domain
NoiseSpec(1:Nlo-1) = 0;
NoiseSpec(Nhi+1:end) = 0;
NoiseSpec(NsamF+1:end) = 0; % no negative freq contributions
% plot(abs(NoiseSpec)); pause; clf
NB = ifft(NoiseSpec); % analytical narrowband waveform

EE = abs(NB); EE = EE-min(EE); EE = EE.^2; % envelope
% EE = real(NB); EE  = max(0,EE); % rectified waveform

%plot(real(BB)); xplot(EE,'r')

% normalize envelope to get instantaneous firing rate
EE = Nspike*EE/sum(EE);
Dice = rand(size(EE));
PST = double(Dice<EE);
N = sum(PST);
% figure; dplot(1/Dur, a2db(abs(fft(PST)))); pause; delete(gcf)

% revcor
NmaxLag = round(maxLag*Fsam);
IR = xcorr(PST, WF, NmaxLag);
IR = flipUD(IR);

subplot(2,2,3); 
Ni = length(IR);
time = (0:Ni-1)/Fsam - maxLag;
irDur = diff(time([1 end]))
plot(time, IR);
DT = diff(time(1:2));

subplot(2,2,1); 
dplot(DT,EE(1:10*Ni),'r')

subplot(2,2,2);
DF = 1/irDur; % freq spacing in kHz
SP = fft(IR);
Ns = length(SP);
Ns = round(Ns/2); % pos freqs only
SP = SP(1:Ns);
freq = DF*(0:Ns-1);
Gain = a2db(abs(SP));
Gain = Gain - max(Gain);
Phase = unwrap(angle(SP))/2/pi;

subplot(2,2,2);
plot(freq,Gain);
xlim([0 maxFreq]);

subplot(2,2,4);
plot(freq,Phase);
xlim([0 maxFreq]);

figure(gcf);

