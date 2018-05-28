function [N, Spec, Wf, fAxis] = GenWhiteNoise(Flow, Fhigh, iFilt, Dur, Rseed, Chan, delay, Cyclic);
% GenWhiteNoise - low-level gaussian noise generator
%   empty iFilt -> choose safe Fsam
%   if chan is specified, calibration is taken into account
%   NaN will leave the random seed alone
%   (analytical) waveform only computed if requested by # argouts
%   expected level of real part of waveform: 0 dB SPL
%   delay is zero is not specified
%   delay and Dur in ms; all freqs in Hz

if nargin<5, Rseed = NaN; end
if nargin<6, Chan = NaN; end
if nargin<7, delay = 0; end
if nargin<8, Cyclic = 0; end
% sample freq from specified iFilt or from Nyquist requirement
if isempty(iFilt), [Fsam, iFilt] = safeSamplefreq(Fhigh); % Nyquist
else, global SGSR; Fsam = SGSR.samFreqs(iFilt); % specified
end
N = round(Fsam*1e-3*Dur); % true # samples
if Cyclic, NsamNoise = N; % exact
else, NsamNoise = 2^ceil(log2(N)); % round # samples to speed up FFTs
end

df = Fsam/NsamNoise; % freq spacing
fAxis = (0:NsamNoise-1).'*df; % freq axis in Hz (col vector)

n0 = 1+round(Flow/df); % first non-zero sample in spectrum
NnonZero = round((Fhigh-Flow)/df); % # nonzero spectral components
n1 = n0+NnonZero-1; % last non-zero sample in spectrum
% calibrate
if ~isnan(Chan),
   [CalAmp, CalPhase] = calibrate(fAxis(n0:n1), iFilt, Chan);
   CalPhase = 2*pi * CalPhase; % cyc->rad
   CalibFac = db2a(CalAmp).*exp(i*CalPhase);
else, CalibFac = 1;
end

CalibFac = exp((-2*pi*i*delay*1e-3)*fAxis(n0:n1)).*CalibFac/(NnonZero^0.5/NsamNoise); % normalize to 0 dB SPL
% compute spectrum
if ~isnan(Rseed), SetRandState(Rseed); end
Spec = (randn(NnonZero,1)+i*randn(NnonZero,1)).*CalibFac;
upZero = zeros(n0-1,1); 
downZero = zeros(NsamNoise-n1,1);
Spec = [upZero; Spec; downZero];
% return complex waveform if requested
if nargout>2, Wf = ifft(Spec); end
