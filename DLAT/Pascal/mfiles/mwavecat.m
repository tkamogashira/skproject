function output_wave = mwavecat(wave1, wave2, silence_ms, infoflag);
% function output_wave = 
% mwavecat(wave1, wave2, silence_ms, infoflag);
%
%--------------------------------------------------------------------
% Concatenates two 'wave' signals. A portion of
% silence can be placed in between if needed
%--------------------------------------------------------------------
% 
% Input parameters
%    wave1      = 'wave' structure (goes first in result)
%    wave2      = 'wave' structure (goes second in result)
%    silence_ms = duration of silence to put between waves
%    infoflag   = 1 print some information while running
%                 0 dont print anything
% 
% Output parameters
%    output_wave = 'wave' structure
%
%
% The two waves should have the same duration and sampling rate.
%
%
% Examples:
% to make a 500-Hz diotic tone and a 1000-Hz diotic tone
% and then to put them in sequence, with the 500-Hz tone
% first, followed by the 1000-Hz tone, and separated by
% 250-ms of silence, type:
% >> wave1 = mcreatetone(500, 60, 60, 0, 0, 250, 10, 20000, 1);
% >> wave2 = mcreatetone(1000, 60, 60, 0, 0, 250, 10, 20000, 1);
% >> wave3 = mwavecat(wave1, wave2, 250, 1);
%
%
% to instead put the 1000-Hz first and with no silence
% inbetween, type:
% >> wave1 = mcreatetone(500, 60, 60, 0, 0, 250, 10, 20000, 1);
% >> wave2 = mcreatetone(1000, 60, 60, 0, 0, 250, 10, 20000, 1);
% >> wave3 = mwavecat(wave2, wave1, 0, 1);
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


% concatenate waveforms with silence
if (infoflag >=1)
   fprintf('concatenating waves ... \n');
end;
if (silence_ms >= 0)
   nsamples = silence_ms/1000*wave1.samplefreq;
   silence = zeros(nsamples, 1);
   leftwaveform = [wave1.leftwaveform; silence; wave2.leftwaveform];
   rightwaveform = [wave1.rightwaveform; silence; wave2.rightwaveform];
else
   leftwaveform = [wave1.leftwaveform; wave2.leftwaveform];
   rightwaveform = [wave1.rightwaveform; wave2.rightwaveform];
end;


% create wave = return value
output_wave = mwavecreate(leftwaveform, rightwaveform, wave1.samplefreq, infoflag);


   
% the end
%--------------------------------