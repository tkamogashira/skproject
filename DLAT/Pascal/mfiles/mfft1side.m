function output_spectrum = mfft1side(waveform, samplefreq, nfftpoints, infoflag)
% function output_spectrum = ...
% mfft1side(waveform, samplingfreq, nfftpoints, infoflag)
%
%-------------------------------------------------------------------
% Returns the magnitude and phase of the FFT of a monaural waveform
% Interface to the MATLAB function 'fft'
%-------------------------------------------------------------------
%
% Input parameters:
%   waveform     = monaural waveform (*not* a 'wave' signal
%   samplefreq   = sampling frequency (Hz)
%   nfftpoints   =:number of points in FFT
%   infoflag     = 2: plot figures and report some information while running
%                = 1: report some information while running only
%                = 0  dont report anything
%
%
% Output parameters:
%   output_spectrum = matrix of frequencies x FFT results.
%                     column 1 = FFT frequencies (Hz)
%                     column 2 = magnitudes (linear units not dB)
%                     column 3 = phases (radians)
%
% Figures:
%  figure 1 plots the phase spectrum
%  figure 2 plots the magnitude spectrum
%
% Examples:
% to plot the 2048-point FFT of the left channel of the 'wave' 
% signal wave1 (see mcreatetone1.m), using a sampling rate
% of 20000 Hz, type:
% >> fftmatrix = mfft1side(wave1.leftwaveform, 20000, 2048, 2);
%
% See also mcreatenoise1.m for another example.
%
% Thanks to Les Bernstein for supplying this function
%
%
% version 1.0 (January 20th 2001)
% MAA Winter 2001 
%--------------------------------

% ******************************************************************
% This MATLAB software was developed by Michael A Akeroyd for 
% supporting research at the University of Connecticut
% and the University of Sussex.  It is made available
% in the hope that it may prove useful. 
% 
% Any for-profit use or redistribution is prohibited. No warranty
% is expressed or implied. All rights reserved.
% 
%    Contact address:
%      Dr Michael A Akeroyd,
%      Laboratory of Experimental Psychology, 
%      University of Sussex, 
%      Falmer, 
%      Brighton, BN1 9QG, 
%      United Kingdom.
%    email:   maa@biols.susx.ac.uk 
%    webpage: http://www.biols.susx.ac.uk/Home/Michael_Akeroyd/
%  
% ******************************************************************


if size(waveform, 2) > 1
   % transpose
   waveform = waveform';
end;

hzperpoint = samplefreq/nfftpoints; % resolution of FFT, Hz
if infoflag >= 1,
   fprintf('creating %d-point FFT buffer with %.0 Hz sampling rate ...\n', nfftpoints, samplefreq);
   fprintf('FFT resolution = %.2f Hz \n', hzperpoint);
end;

% create the frequency vector
freqvector = (samplefreq/2)*(0:(nfftpoints/2))/(nfftpoints/2);

% FFT
if infoflag >= 1
   fprintf('FFTing ... \n');
end;
complexspectrum = fft(waveform, nfftpoints);

% get magnitude and phase spectra
magnitudespectrum = abs(complexspectrum);
phasespectrum = angle(complexspectrum);

% discard half of the array but preserve DC and the nyquist frequyency
if infoflag >= 1
   fprintf('discarding negative frequencies ... \n');
end;
magnitudespectrum(((nfftpoints/2)+2):nfftpoints) = [];
phasespectrum(((nfftpoints/2)+2):nfftpoints) = [];

% double magnitudes (to account for half the spectrum being removed)
if infoflag >= 1
   fprintf('doubling magnitudes... \n');
end;
magnitudespectrum(2:nfftpoints/2) = 2*magnitudespectrum(2:nfftpoints/2);

% scale by number of points in FFT
if infoflag >= 1
   fprintf('scaling by number of points in FFT ... \n');
end;
magnitudespectrum = magnitudespectrum/nfftpoints;

% plot if required
if (infoflag >= 2)
   close 
   close;
   
   symbol = 'o-'; % 'o'= circles  '-'=lines joining the circles
   symbolsize = 2;
   
   figure(1);
   fprintf('plotting phase spectrum in figure %d ...\n', gcf);
   plot(freqvector, phasespectrum, symbol, 'Markersize', symbolsize);
   xlabel('Frequency (Hz)');
   ylabel('Phase (radians)')
   grid on;
   
   figure(2);
   fprintf('plotting magnitude spectrum in figure %d ...\n', gcf);
   plot(freqvector, 20*log10(magnitudespectrum), symbol, 'Markersize', symbolsize);
   xlabel('Frequency (Hz)');
   ylabel('Magnitude (dB)')
   grid on;
   
   
end;

% convert to columns for final output
if infoflag >= 1
   fprintf('storing answers as %dx%d matrix ...\n', length(freqvector), 3);
   fprintf('(%d frequencies = %d/2 + 1 (for 0-Hz component))\n', length(freqvector), nfftpoints);
end;
output_spectrum = [freqvector' magnitudespectrum phasespectrum];

if infoflag >= 1
   fprintf('\n');
end;

% the end!
%------------------------------------
