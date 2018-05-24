function output_wave = mwaveadd(wave1, wave2, infoflag);
% function output_wave = 
% mwaveadd(wave1, wave2, infoflag);
%
% ------------------------------------------------------------------
% Adds the signals in two 'wave's
%-------------------------------------------------------------------
% 
% Input parameters
%    wave1    = 'wave' structure 
%    wave2    = 'wave' structure
%    infoflag = 1 print some information while running
%               0 dont print anything
% 
% Output parameters
%    output_wave = 'wave' structure
%
%
% The two waves should have the same duration and sampling rate.
%
% Example:
% to make a 500-Hz diotic tone and a 1000-Hz diotic tone
% and then to add them together, type:
% >> wave1 = mcreatetone(500, 60, 60, 0, 0, 250, 10, 20000, 1);
% >> wave2 = mcreatetone(1000, 60, 60, 0, 0, 250, 10, 20000, 1);
% >> wave3 = mwaveadd(wave1, wave2, 1);
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


% check sampling rates
if (wave1.samplefreq ~= wave2.samplefreq)
   fprintf('%s: error! sampling frequency of waves #1 and wave #2 differ:\n', mfilename); 
   fprintf('(samplefreq #1 = %d Hz, samplefreq #2 = %d Hz)\n', wave1.duration_samples, wave2.duration_samples);
   fprintf('\n');
   output_wave = [];
   return;
end;


% check durations
if (wave1.duration_samples ~= wave2.duration_samples)
   fprintf('%s: error! length of waves #1 and wave #2 differ:\n', mfilename); 
   fprintf('(length #1 = %d samples, length #2 = %d samples)\n', wave1.duration_samples, wave2.duration_samples);
   fprintf('\n');
   output_wave = [];
   return;
end;

 
   
% add waveforms 
if (infoflag >=1)
   fprintf('adding waves ... \n');
end;
leftwaveform = wave1.leftwaveform + wave2.leftwaveform;
rightwaveform = wave1.rightwaveform + wave2.rightwaveform;

% create wave = return value
output_wave = mwavecreate(leftwaveform, rightwaveform, wave1.samplefreq, infoflag);
output_wave.generator = mfilename;

if (infoflag >=1)
   fprintf('\n');
end;


% the end
%--------------------------------