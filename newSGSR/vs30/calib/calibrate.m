function [Level, Phase] = calibrate(freq, ifilt, chan, fake, complexFactor);
% CALIBRATE - compute frequency-dependent calibration amplitude and phase corrections
%   Syntax: [Level, Phase] = calibrate(freq, ifilt, chan);
%   Level is a amplitude corerction in dB such that:
%
%   (1)  level(DAC) = level(sound) + Level,
%   where all levels are in dB;  
%   level(DAC) is in dB re 1 DACbit. i.e., "numerical dB" of D/A samples
%   level(sound) is in dB re 20 uPa at the eardrum,
%   assuming no analog attenuation.
%
%   (2)  phase(DAC) = phase(sound) + Phase,
%   where all phases are in CYCLES and positive
%   values correspond to phase leads by convention.
%
%   Level and Phase returned by CALIBRATE are thus correction
%   parameters allowing one to pass from the numerical domain to 
%   the actual sound (and vice versa).
%
%   Simple example: Prepare playing a tone at 65 dB SPL w zero starting phase
%      A = sqrt(2)*db2a(65); % sqrt(2)=RMS(sinusoid) factor between tone amp&RMS
%      Ph = 0; % zero-cycle starting phase
%      [calLv, calPh] = calibrate(freq, ifilt, DAchan);
%      A = A*db2a(calLv); % correct amplitude for DACbit -> SPL transition
%      Ph = Ph + calPh; % correct for phase delay due to DAC->driver path
%      w = A*sin(2*pi*(Ph+freq*t)); % t is sampled time vector in s
%   The vector w can now be sent to the D/A without any further scaling.
% 
%   [Level, Phase] = calibrate(freq, ifilt, chan, 1) gives flat fake calibration
%   for which full D/A range corresponds with 140 dB SPL by convention, and no
%   phase compensation is assumed.
%
%   Z = calibrate(freq, ifilt, chan, isfake, 1) returns amplitude and phase
%   factors as a single, complex, linear factor. This is convenient for the
%   calibration of complex spectra.

if nargin<4, fake=0; end;
if nargin<5, complexFactor=0; end; % return linear complex scaled factor by which ...
%                    ... complex waveform can directly be multiplied when
%                    ... passing from numerical Amp/Phase to DA Amp/Phase

global SGSR CALIB % contains the actual ERC data

artMaxSPL = SGSR.defaultMaxSPL; % default value of artificial max SPL
fake = fake | isempty(CALIB);
if ~fake, 
   if isnumeric(CALIB.ERC), 
      artMaxSPL = CALIB.ERC;
      fake = 1;
   end
end

if fake, % flat fake calibration; by convention, max tone level is <artMaxSPL> dB SPL
   Phase = 0*freq; % impose correct size
   Level = 0*freq + MaxNumToneLevel-artMaxSPL;
   if complexFactor,
      Level = db2a(Level);
      clear Phase; % produces warning when phase is asked for
   end
   return;
end

chan = channelNum(chan); % convert character format L|R to numerical format 1|2
if chan==0, % recursive call; horzcat individual channels
   [L1, pp1] = calibrate(freq, ifilt, 1);
   [L2, pp2] = calibrate(freq, ifilt, 2);
   Level = [L1, L2]; Phase = [pp1 pp2];
   return;
end

% single chan from here   
index = CALIB.ichan(chan);
if index==0, 
   % disp('requested D/A channel not present in calibration data');
   Level = nan*freq; Phase = nan*freq;
   return;
end;
Z = CDinterpol(CALIB.ERC(index), ifilt, freq); % complex trf amplitudes in Pa/DACbit
SPLfactor = 20e-6; % conversion factor Pa -> "re 20 uPa"
AmpFactor = SPLfactor./Z; 
if complexFactor,
   Level = AmpFactor; 
else,
   Level = a2db(abs(AmpFactor)); % lin -> dB
   Phase = angle(AmpFactor)/(2*pi); % rad->cycle
end








