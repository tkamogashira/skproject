function output_wave = mcreatetone(freq, powerleft, powerright, itd, ipd, duration, gatelength, samplefreq, infoflag)
% function output_wave = ...
% mcreatetone(freq, powerleft, powerright, itd, ipd, ...
%             duration, gatelength, samplefreq, infoflag)
% 
%-------------------------------------------------------------------
% Makes a tone and stores it as a 'wave' signal
%-------------------------------------------------------------------
% 
% Input parameters:
%    freq       = frequency of tone (Hz)
%    powerleft  = power of left channel (dB re 1.0)
%    powerright = power of right channel (dB re 1.0)
%    itd        = interaural time delay (microseconds)
%                 (positive ITDs corresponds to right-channel leading)
%    ipd        = interaural phase delay (degrees)
%                 (positive IPDs corresponds to right-channel leading)
%    duration   = duration of tone (milliseconds)
%    gatelength = duration of raised-cosine gates applied to
%                 onset and offset (milliseconds)
%    samplefreq = sampling frequency (Hz)
%    infoflag:  = 1 : print some information while running
%                 0 : dont print anything
%
% Output parameters:
%    output_wave = 'wave' structure, using the format defined 
%                  in mwavecreate.m
%
% Example: 
% to make a 500-hz tone, of 60-dB power in each channel,
% of 500-us ITD, o-degrres IPD, 250-ms duiration, 10-ms gates, 
% and 20000-Hz sampling rate, type:
% >> wave1 = mcreatetone(500, 60, 60, 500, 0, 250, 10, 20000, 1);
%
% to use an IID of 10 dB instead of a 500-ms ITD, type:
% >> wave1 = mcreatetone(500, 50, 60, 0, 0, 250, 20, 20000, 1);
%
% to use an IPD of 90 degrees instead of an ITD or IID, type:
% >> wave1 = mcreatetone(500, 60, 60, 0, 90, 250, 20, 20000, 1);
%
%
% version 1.0 (Jan 20th 2001)
% MAA Winter 2001 
%----------------------------------------------------------------

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
   
% abort if no output specified 
if nargout ~= 1 
   fprintf('%s: error! an output argument must be specified\n\n', mfilename);
   output_stereowaveform = [];
   return;
end;
   
% abort if the duration is 0 
if duration <= 0 
   fprintf('%s: error! duration <= 0 ms\n\n', mfilename); 
   output_stereowaveform = [];
   return;
end;

% abort if the freq <= 0
if freq <= 0 
   fprintf('%s: error! frequency <= 0 Hz\n\n', mfilename);
   output_stereowaveform = [];
   return;
end;
   
% abort if the samplefreq is 0 
if samplefreq <= 0 
   fprintf('%s: error! samplefreq <= 0 Hz\n\n', mfilename); 
   output_stereowaveform = [];
   return;
end;
   
% abort if the twice gate duration is > overall duration
if (2*gatelength > duration) 
   fprintf('%s: error! total gate duration (=%.1f ms) > overall duration (=%.1f ms)\n\n', mfilename, 2*gatelength, duration); 
   output_stereowaveform = [];
   return;
end;
   
   
%---------------------------------------------------


% define length of waveform in samples
sampleduration=1/samplefreq;
nsamples = duration/1000*samplefreq;

% define time of each sample in waveform
sampletime = 0:sampleduration:((nsamples-1)*sampleduration);
tone_l = linspace(0,0,nsamples);
tone_r = linspace(0,0,nsamples);

% get amplitude of tone
amplitudeleft = 10^(powerleft/20) * sqrt(2);
amplituderight = 10^(powerright/20) * sqrt(2);

% convert IPD to a time delay
trueitd = itd + (1000000/freq)*ipd/360.0; % usecs

% set ITD so that right leads left (and its in microsecs)
phase_left = 0; % radians
phase_right = phase_left + (2*pi*trueitd/(1000000/freq)); % radians
if infoflag >= 1
   fprintf('frequency =%.1f Hz \n', freq);
   fprintf('itd = %.1f usecs  ipd = %.1f degs  => trueitd: %.3f usecs\n', itd, ipd, trueitd);
   fprintf('left channel  : level = %.2f dB  amplitude = %.1f samples\n', powerleft, amplitudeleft);
   fprintf('right channel : level = %.2f dB  amplitude = %.1f samples\n', powerright, amplituderight);
   fprintf('left channel  : starting phase (sin) = %.3f cycles \n', phase_left/(2*pi));
   fprintf('right channel : starting phase (sin) = %.3f cycles \n', phase_right/(2*pi));
end;
 
% make left and right channels
if infoflag >= 1
   fprintf('creating sinwaves ...\n');
end;
angularfreq = 2*pi*freq;
tone_l = amplitudeleft * sin(angularfreq.*sampletime + phase_left);
tone_r = amplituderight * sin(angularfreq.*sampletime + phase_right);


%---------------------------------------------------


% apply raised-cosine onset/offset gates
if (gatelength > 0)
   if infoflag >= 1
      fprintf('applying %.1f-ms raised cosine gates ...\n', gatelength);
   end;
   % create gates
   onsetlength_samples = gatelength*samplefreq/1000;  % gate length is in msecs
   offsetlength_samples = onsetlength_samples;
   onsetgate = 0:1:onsetlength_samples-1;
   onsetgate = 0.5 - 0.5*cos(pi*(mod(onsetgate, onsetlength_samples)/onsetlength_samples));
   offsetgate = 0:1:offsetlength_samples-1;
   offsetgate = 0.5 - 0.5*cos(pi*(mod(offsetgate, offsetlength_samples)/offsetlength_samples));
   offsetgate = fliplr(offsetgate);
   if ((onsetlength_samples + offsetlength_samples) == nsamples)
      middlegate = [];
   else
      middlegate = linspace(1,1, (nsamples - onsetlength_samples - offsetlength_samples));  
   end;
   gate = [onsetgate, middlegate, offsetgate];
   
   % apply gates
   signal_l = tone_l.*gate;
   signal_r = tone_r.*gate;
   
else
   if infoflag >= 1
      fprintf('no gates applied \n');
   end;
   signal_l = tone_l;
   signal_r = tone_r;
   
end;


%---------------------------------------------------

% return values 
output_wave = mwavecreate(signal_l, signal_r, samplefreq,infoflag);
output_wave.generator = mfilename;

if infoflag >= 1
   fprintf('storing waveform in workspace as ''wave'' .. \n');
end;


if infoflag >= 1,
   fprintf('\n');
end;


% the end 
% --------------------------------------------
