function n = psd_matched_noise(x)
% PSD_MATCHED_NOISE - Synthesize noise N having the same power spectrum 
%		      and duration as original signal X.  
%		      Done by randomizing phase of Fourier spectrum. 
% Usage:  n = psd_matched_noise(x)
%
%	Copyright Bertrand Delgutte, 1999-2000
%
n = real(ifft(abs(fft(x)) .* exp(j*2*pi*rand(size(x)))));
