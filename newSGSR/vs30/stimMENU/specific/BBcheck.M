function [paramsOK, varargout] = BBcheck(varargin);
if nargin>0, % query of local function
   paramsOK = 1; varargout = cell(1,nargout-1);
   [varargout{:}] = feval(varargin{:});
   return;
end

textcolors; global StimMenuStatus SGSR
paramsOK= 0; 
% first visit all edit controls and look if their formats are OK  XXXX not ready
hh = StimMenuStatus.handles;
pp = []; pp.dummy=0; % pp must be struct before other fields can be filled as below
%--- presentation params
[presOK, pp.reps, pp.interval, pp.order] = presentationCheck;
if ~presOK, return; end;
%--- duration params
[durOK, pp.burstDur, pp.riseDur, pp.fallDur] = DurationsCheck(1); % single burstDur
if ~durOK, return; end;
%--- SPLs and active channels
[splOK, pp.SPL, pp.active] = SPLandChannelCheck;
if ~splOK, return; end;
%--- modulation
[modOK, pp.modDepth, pp.modFreq pp.modPresent] = ModulationCheck(1); % single mod freq
if ~modOK, return; end;

%--- BB-sweep params
pp.carfreq = abs(UIdoubleFromStr(hh.CarFreqEdit,1));
pp.lowBeat = UIdoubleFromStr(hh.LowBeatEdit,1);
pp.stepBeat = abs(UIdoubleFromStr(hh.StepBeatEdit,1));
pp.highBeat = UIdoubleFromStr(hh.HighBeatEdit,1);
pp.whatBeats = UIintFromToggle(hh.BeatOnModButton); % 1|2|3 = Carrier|Modulation|Auto
pp.varChan = UIintFromToggle(hh.VarChanButton); % 1|2 = Left | Right

StimMenuStatus.params = pp; StimMenuStatus.paramsOK = 0;

UIinfo('Checking...');
% any non-numerical input that hasn't been caught yet?
if ~CheckNaNandInf(pp), return; end;

% ----further param checks

% consistency of BeatOn & anymod
if (pp.whatBeats==2) & ~pp.modPresent,
   mess = strvcat('Cannot impose beats on modulation',...
      'when there is no modulation');
   errh = hh.BeatOnModButton;
   if (pp.modFreq==0), errh = [errh hh.ModFreqEdit]; end
   if any(pp.modDepth==0), errh = [errh hh.ModDepthEdit]; end
   UIerror(mess, errh);
   return;
end
% determine if beats are on modulator or not
beatOnMod = pp.whatBeats>1;
if pp.whatBeats==3, % "auto" depends on presence modulation
   beatOnMod = pp.modPresent;
end

% beat sweep
[beatFreqs, mess, newLowBeat] ...
   = local_BeatFreqs(pp.lowBeat, pp.stepBeat, pp.highBeat, pp.active);

switch mess
case 'ZEROSTEP',
   mess = strvcat('zero step size','but unequal start- and',...
      'end beat-freq values');
   UIerror(mess, hh.StepBeatEdit);
   return;
case 'DIFF#STEPS',
   mess = strvcat('unequal # sweep steps','for the two channels');
   UIerror(mess, [hh.LowBeatEdit hh.StepBeatEdit hh.HighBeatEdit]);
   return;
case 'BIGADJUST',
   mess = strvcat('non-integer # sweep steps',...
      'between low & high beat frequencies:',...
      'low beat freq will be adjusted');
   if StimMenuWarn(mess, hh.LowBeatEdit), return; end;
   pp.lowBeat = newLowBeat;
   setstring(hh.LowBeatEdit,num2str(round(newLowBeat)));
   UItextColor(hh.LowBeatEdit, BLACK);
case 'SMALLADJUST',
   pp.lowBeat = newLowBeat;
   setstring(hh.LowBeatEdit,num2str(newLowBeat,3));
end

% get # subseqs from modFreqs and report
Nsubseq = size(beatFreqs,1);
if ~ReportNsubseq(Nsubseq), return; end;

% compute the per-channel carrier/mod  freqs by incorporating beats
[carFreqs, modFreqs] ...
   = local_CarFreqs(pp.carfreq, pp.modFreq, beatFreqs, beatOnMod, pp.varChan);

% freq range
TooHigh = max(carFreqs(:)+abs(modFreqs(:)))>maxStimFreq;  
TooLow = min(carFreqs(:)-abs(modFreqs(:)))<0;
if TooHigh | TooLow,
   mess = ['frequencies outside 0-' num2str(maxStimFreq,6) '-Hz range'];
   CFerr = (pp.carfreq>maxStimFreq) | (pp.carfreq<0); % car freq is to blaim
   BTerr = ~CFerr & ( (max(carFreqs(:))>maxStimFreq) | (min(carFreqs(:))<0) ); % beats are accessory
   MDerr = ~(CFerr | BTerr); % modulation must play a role
   errh = hh.CarFreqEdit;
   if BTerr, 
      if TooLow, errh = [errh hh.LowBeatEdit]; end;
      if TooHigh, errh = [errh hh.HighBeatEdit]; end;
   end
   if MDerr, errh = [errh hh.ModFreqEdit]; end
   UIerror(mess, errh);
   return;
end
% mod freq range
if any(modFreqs(:)<0),
   mess = strvcat('Sweep parameters result',...
      'negative modulation frequencies.');
   UIerror(mess,[hh.LowBeatEdit hh.ModFreqEdit]);
   return;
end

% compute maxSPL and report
MLL = sxmMaxCarSPL(modFreqs(:,1), pp.carfreq(1), pp.modDepth(1), 'L');
MLR = sxmMaxCarSPL(modFreqs(:,end), pp.carfreq(end), pp.modDepth(end), 'R');
limlevel = updateMaxSPLinfo(MLL, MLR, modFreqs, pp.active);

% check SPLs
if any(pp.SPL>limlevel),
   UIerror('level(s) too high', hh.LevelEdit);
   return;
end;

% durations
if any(pp.burstDur>pp.interval),
   mess = strvcat('interval too small to realize bursts');
   UIerror(mess, hh.IntervalEdit);
   return;
end;

% if we got here, params are OK
% put params in global idfSeq (PDP11 format) and ...
% ... convert to SMS stimulus specification (SGSR format)

global idfSeq SMS CALIB
limchan = IDFlimitChan(pp.active);
idfSeq = BBcreateIDF(pp.carfreq, pp.modFreq, pp.modDepth, ...
   pp.lowBeat, pp.stepBeat, pp.highBeat, pp.varChan, beatOnMod,...
   pp.SPL, pp.active, limchan, ...
   pp.interval, pp.burstDur, pp.riseDur, pp.fallDur, ...
   pp.reps, pp.order);

SMS = IDF2SMS(idfSeq, CALIB.ERCfile);

UIinfo('OK', -1);
ReportPlayTime(pp,Nsubseq);
StimMenuStatus.paramsOK = 1;
paramsOK= 1;

% -------------------
function [beatFreqs, mess, newLowBeat] ...
   = local_BeatFreqs(lowBeat, stepBeat, highBeat, active);
% beat sweep params -> beat freqs. Put in separate function to allow external access
AbsTol = 0.5; % absolute deviation of 1 Hz is tolerated without warning
[beatFreqs, mess, newLowBeat] = ...
   LinSweepChecker(lowBeat, stepBeat, highBeat, active, AbsTol, 'start');
beatFreqs = beatFreqs(:,1); % single col row

function [carFreqs, modFreqs] ...
   = local_CarFreqs(carfreq, modFreq, beatFreqs, beatOnMod, varChan);
% menu params -> exact, per-channel, car/mod freqs. Put in separate function to allow external access
Nsubseq = size(beatFreqs,1);
carFreqs = repmat(carfreq,Nsubseq,2); modFreqs = repmat(modFreq,Nsubseq,2);% sizes
if ~beatOnMod, % carrier beats
   carFreqs(:,varChan) = carFreqs(:,varChan) + beatFreqs;
else, % modulator beats
   modFreqs(:,varChan) = modFreqs(:,varChan) + beatFreqs;
end











