function [SNR, Lmean, Lstd, PhaseStd] = NoisefloorVar;
% NoisefloorVar - variance of spectral components due to noise floor
%   syntax:
%     [SNR, Lmean, Lstd, PhaseStd] = NoisefloorVar;

% construct sample signal+noise vectors
sig = 1; % amp=1; phase=0 by convention
SNR = linspace(0.1,40,500); % dB S/N ratio
amp = db2a(-SNR); % noise amplitude re unity signal vector
phi = rand(1e3,1); % random orientation of added noise component
phasor = exp(2*pi*i*phi); % phase factor corresponing to angle phi
S_plus_N = sig+phasor*amp; % signal plus noise

L = a2db(abs(S_plus_N));
Phase = angle(S_plus_N)/2/pi;
Lmean = mean(L);
Lstd = std(L);
PhaseStd = std(Phase);




