function output_wave = mcreatenoise1rho(centerfreq, bandwidth, spectrumlevelleft, spectrumlevelright, rho, duration, gatelength, samplefreq, infoflag)
% function output_wave = ...
%  mcreatenoise1rho(centerfreq, bandwidth, ...
%                spectrumlevelleft, spectrumlevelright, rho,  ...
%                duration, gatelength, samplefreq, infoflag)
%
%-------------------------------------------------------------------------
% Makes a bandpass noise and stores it as a 'wave' signal
% Frequency of noise specified as centerfrequency and bandwidth
% Only IID and interaural correlation (rho) of noise can be specified.
%-------------------------------------------------------------------------
%
% Input parameters
%    centerfreq         = center frequency of noise band (Hz)
%    bandwidth          = bandwidth of noise band (Hz)
%    spectrumlevelleft  = spectrum level of left channel of 
%                           noise band (dB re 1.0)
%    spectrumlevelright = spectrum level of right channel of
%                           noise band (dB re 1.0)
%    rho                = interaural correlation
%    duration           = duration of noise (milliseconds)
%    gatelength         = duration of raised-cosine gates applied to
%                            onset and offset (milliseconds)
%    samplefreq         = sampling frequency (Hz)
%    infoflag           = 1 : print some information while running
%                         0 : dont print anything
%
% Output parameters:
%    output_wave = 'wave' structure, using the format defined 
%                  in mwavecreate.m
%
% The noise is constructed in the frequency domain and then
% converted to a waveform using an inverse FFT
%
%
% Examples:
% to create a noise of 500-Hz center frequency, 400-Hz bandwidth,
% 40-dB spectrum level, correlation 0.0, 10-ms raised-cosine gates
% and using a sampling frequency of 20000 Hz, type:
% >> wave1 = mcreatenoise1rho(500, 400, 40, 40, 0, 250, 10, 20000, 1);
%
% to use a correlation of -1 instead:
% >> wave1 = mcreatenoise1rho(500, 400, 40, 40, -1, 250, 10, 20000, 1);
%
%
% Uses Licklider/Dzendolet three-noise method of making a decorrelated noise
% see also Akeroyd/Summerfield (JASA May 1999 vol 105(5) p. 2812),
% but modified to allow for correlations < 0
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


if infoflag >= 1
  fprintf('This is %s.m\n', mfilename);
end;

% in the Licklider/Dzendolet method the common:independent
% noises are in a power ratio of rho:(1-rho)

% make common noise
powerfactor = abs(rho);
if infoflag >= 1,
   fprintf('creating common noise: relative power             = %.2f ...\n', powerfactor);
   end;
commonwave = mcreatenoise1(centerfreq, bandwidth, spectrumlevelleft, ...
   spectrumlevelright, 0, 0, duration, gatelength, samplefreq, 0);
if rho >= 0 
   commonwave.leftwaveform = commonwave.leftwaveform * sqrt(powerfactor);
   commonwave.rightwaveform = commonwave.rightwaveform * sqrt(powerfactor);
else
   if infoflag >= 1,
      fprintf('inverting one channel of common noise to get negative correlation ...\n');
   end;
   commonwave.leftwaveform = commonwave.leftwaveform * sqrt(powerfactor);
   commonwave.rightwaveform = -1 * commonwave.rightwaveform * sqrt(powerfactor);
end;


% make independent noise for left channel
powerfactor = 1-abs(rho);
if infoflag >= 1,
   fprintf('creating first independent noise: relative power  = %.2f ...\n', powerfactor);
   end;
indywave1 = mcreatenoise1(centerfreq, bandwidth, spectrumlevelleft, ...
      spectrumlevelright, 0, 0, duration, gatelength, samplefreq, 0);
indywave1.leftwaveform = indywave1.leftwaveform * sqrt(powerfactor);
indywave1.rightwaveform = indywave1.rightwaveform * sqrt(powerfactor);


% make independent noise for right channel
powerfactor = 1-abs(rho);
if infoflag >= 1,
   fprintf('creating second independent noise: relative power = %.2f ...\n', powerfactor);
   end;
indywave2 = mcreatenoise1(centerfreq, bandwidth, spectrumlevelleft, ...
      spectrumlevelright, 0, 0, duration, gatelength, samplefreq, 0);
indywave2.leftwaveform = indywave2.leftwaveform * sqrt(powerfactor);
indywave2.rightwaveform = indywave2.rightwaveform * sqrt(powerfactor);

% add up
leftwaveform = commonwave.leftwaveform + indywave1.leftwaveform;
rightwaveform = commonwave.rightwaveform + indywave2.rightwaveform;

% save 
output_wave = mwavecreate(leftwaveform, rightwaveform, samplefreq,infoflag);
output_wave.generator = mfilename;     % string containing what code made the stimulus

if infoflag >= 1
   fprintf('storing waveform to workspace as wave structure .. \n');
end;


if infoflag >= 1,
   fprintf('\n');
end;



% the end!
%-----------------------------------------------


