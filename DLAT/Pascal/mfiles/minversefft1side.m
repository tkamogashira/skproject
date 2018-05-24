function [output_waveform] = minversefft1side(fftmatrix, samplefreq, infoflag)
% function [output_waveform] = 
% minversefft1side(fftmatrix, samplefreq, infoflag)
%
%----------------------------------------------------
% Returns a waveform from a three-column freq/magnitude/power
% spectrum (as made by mfft1siee).
%----------------------------------------------------
%
% Input parameters:
%   fftmatrix   = matrix of frequencies x FFT results.
%                     column 1 = FFT frequencies (Hz)
%                     column 2 = magnitudes (linear units not dB)
%                     column 3 = phases (radians)
%   samplefreq   = sampling frequency (Hz)
%   infoflag     = 2: plot the waveform
%                  1: report some information while running only
%                = 0  dont report anything
%
% Output parameters:
%   output_waveform = monaural waveform (*not* a 'wave' signal
%
% Figures:
%  figure 1 plots the waveform.
%
%
% The number of points in the FFt is taken from the number of rows in
% fftmatrix.
% Unlike mfft1side.m, this function does not plot any pictures.
%
% Examples:
% to create a waveform from a FFT matrix 'fftmatrix' made by
% mfft1side.m and using a 20000-Hz sampling rate, type:
% >> waveform = minversefft1side(fftmatrix, 20000, 1);
%
% See also mcreatenoise1.m for another example.
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


nfftpoints = (size(fftmatrix, 1)-1) * 2;
hzperpoint = samplefreq/nfftpoints; % resolution of FFT, Hz
if infoflag >= 1,
   fprintf('FFT = %d-point buffer with %d sampling rate ...\n', nfftpoints, samplefreq);
   fprintf('FFT resolution = %.2f Hz \n', hzperpoint);
end;

% undo magnitude scaling that was in mfft1side
if infoflag >= 1
   fprintf('undoing scaling by number of points in FFT ... \n');
end;
fftmatrix(:,2) = fftmatrix(:,2)*nfftpoints;

% undo doubling of magnitudes
if infoflag >= 1
   fprintf('undoing doubling magnitudes... \n');
end;
fftmatrix(2:nfftpoints/2,2) = 0.5*fftmatrix(2:nfftpoints/2,2);

% mirror the spectrum so undo the cutting of half of it
if infoflag >= 1
   fprintf('mirroring magnitude spectrum... \n');
end;
magnitudespectrum = [fftmatrix(:,2);flipud(fftmatrix(2:(nfftpoints/2),2))];

% do the same for phase (but invert as well)
if infoflag >= 1
   fprintf('mirroring and inverting phase spectrum... \n');
end;
phasespectrum = [fftmatrix(:,3); -1*flipud(fftmatrix(2:(nfftpoints/2),3))];

% convert to complex numbers
complexspectrum = magnitudespectrum .* exp(i*phasespectrum);

if infoflag >= 1
   fprintf('inverse-FFTing and taking real part... \n');
end;
% inverse fft and take real part
output_waveform = real(ifft(complexspectrum, nfftpoints))';

% make a time vector for uses as the x-axis
% subtract one because the first sample is at t=0
timeaxis_samples = (1:1:length(output_waveform)) -1;
timeaxis_ms = timeaxis_samples/samplefreq*1000;

% plot if required
if (infoflag >= 2)
   close
   figure(1);
   fprintf('plotting waveform in figure %d ...\n', gcf);
   
   plot(timeaxis_ms, output_waveform);
   xlabel('Time (ms)');
   ylabel('Amplitude');
end;

if infoflag >= 1
   fprintf('waveform = %d samples = %.2f ms\n', length(output_waveform), length(output_waveform)/samplefreq*1000);
   fprintf('\n');
end;


% the end !
%----------------------------------
