function [recSig, measStd, allAtt, Anom] = MeasureDAADtrf(playSig, DAchan, fltIndex, startAtt, minAtt, BGstd, MaxStd, HPfilt, hardMaxStd);
% MeasureDAADtrf - measure microphone response to given waveform while optimizing sound level iteratively
% Params:
%   playsig, DAchan, fltIndex: DAC samples and DAC params
%   startAtt: start value of attenuator(s)
%   minAtt: minimum value of attenuator(s) during iterative search for best level
%   BGstd: standard deviation of background noise ( = ADC input when no DAC output is present)
%   MaxStd: maximum value that std of DC  signal may attain
%
%  The returned Trf is corrected for the attenuation used, i.e., it is the
%  (theoretical) transfer fnc obtained with attenuator(s) wide open

if nargin<8, HPfilt = []; end;
if nargin<9, hardMaxStd = MaxStd; end;

minAttStep = [-10 3]; % smaller [down up] steps in attenuation are regarded as a waste of time

% correct any surrealistic values of params
minAtt = max(minAtt,0); % negative attenuation not possible
startAtt = max(startAtt, minAtt); % start value may never exceed max value
MaxStd = max(MaxStd, BGstd); % do not demand an ADC signal that is smaller than ever-present background noise

% first shot
Atten = startAtt;
allAtt = []; % keep list of all Atten used

while 1, % play/record, evaluate, reiterate
   [recSig, Anom] = CalibPlayRecSys2(playSig, DAchan, fltIndex, Atten);
   allAtt = [allAtt Atten]; % update list of Atten's used
   measStd = std(recSig);
   if isempty(HPfilt), 
      HPmeasStd = measStd; % filtered version identical to unfiltered one
   else, % use filtered RecSig to suppress boosted low-freq demodulation
      HPmeasStd = std(conv(HPfilt(:).', recSig)); 
   end
   HPAttenIncr = a2db(measStd/MaxStd) % atten change to converge to MaxStd
   hardAttenIncr = a2db(measStd/hardMaxStd) % atten increment needed to avoid clipping
   AttenIncr = max(hardAttenIncr, HPAttenIncr);
   % now adjust Atten so that, in the absence of BG noise, it would yield measStd=maxStd
   Atten = Atten + max(hardAttenIncr, HPAttenIncr);;
   % Atten = Atten + a2db(measStd/MaxStd);
   % limit Atten to allowed values
   Atten = clip(Atten, minAtt, MaxAnalogAtten);
   Steps = Atten-allAtt; % differences with previous attenuations
   if any((minAttStep(1)<Steps) & (Steps<minAttStep(2))), break; end
end

