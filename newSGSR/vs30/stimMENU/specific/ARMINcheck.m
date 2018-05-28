function OK = ARMINcheck;

% ARMINcheck
% Checks params for ARMINmenu and stores the stimulus info in
% global SMS

global StimMenuStatus SGSR PRPstatus
textcolors;

OK = 0; StimMenuStatus.paramsOK = 0;

hh = StimMenuStatus.handles; 
UIinfo('Checking parameters...');

% collect param values from uicontrols
pp = []; pp.dummy=''; % pp must be struct before other fields can be filled
%--- presentation params
[presOK, pp.reps, pp.interval, pp.order] = presentationCheck;
if ~presOK, return; end;
%--- duration params
[durOK, pp.burstDur, pp.riseDur, pp.fallDur pp.delay] = DurationsCheck(1); % no dual dur values allowed
if ~durOK, return; end;
%--- generic noise parameters
[fbOK, pp.Flow, pp.Fhigh] = NoiseParamChecker;
if ~fbOK, return; end;
%--- flip-frequency sweep params
[fsOK, pp.loflip, pp.dflip, pp.hiflip, flipfreqs, Nsub, pp.flipstepunit] ...
   = frequencySweepCheck(1); % no duals
if ~fsOK, return; end
%--- SPLs and active channels
[splOK, pp.SPL, pp.active] = SPLandChannelCheck;
%--- Noise details
pp.seedC = UIdoubleFromStr(hh.RseedEdit);
pp.seedVlow = UIdoubleFromStr(hh.Rseed1Edit);
pp.seedVhigh = UIdoubleFromStr(hh.Rseed2Edit);
pp.polaconst = -3+2*UIintFromToggle(hh.Polarity0Button); % -1 or +1
pp.polalow = -3+2*UIintFromToggle(hh.LowPolarity1Button); % -1 or +1
pp.polahigh = -3+2*UIintFromToggle(hh.LowPolarity2Button); % -1 or +1
pp.ConstEar = UIintFromToggle(hh.ConstChanChanButton);
pp.VarEar = UIintFromToggle(hh.VariedChanChanButton);
pp.AKversion = 3; 
% vs 2: polarity also for const ear
% vs 3: always add endpoints to flipfreqs

% any non-numerical or oversized input that hasn't been caught yet?
if ~CheckNaNandInf(pp), return; end;
StimMenuStatus.params = pp;

if pp.AKversion>2, flipfreqs = [pp.Flow; pp.Fhigh; flipfreqs]; end;
pp.flipfreqs = flipfreqs;

% get and report # subseqs
Nsub = size(flipfreqs,1);
if ~ReportNsubSeq(Nsub), return; end;

if ~isequal(0,pp.active),
   if ~isequal(pp.active, pp.VarEar),
      mess = 'Varied DA channel is not active';
      if StimMenuWarn(mess, hh.VariedChanChanButton), return; end;
   end
end

% now start more sophisticated param checks
doReturn = 1; % pessimistic default
% interval / duration
noiseDur = max(abs(pp.delay))+ max(pp.burstDur);
if (noiseDur>pp.interval),
   mess = strvcat('interval too small to realize bursts',...
      'and interaural delays');
   UIerror(mess, hh.IntervalEdit);
elseif any(flipfreqs<pp.Flow*0.9),
   mess = ('flip frequencies outside noise spectrum');
   UIerror(mess, [hh.Freq1Edit hh.LowFreqEdit]);
elseif any(flipfreqs>pp.Fhigh*1.1),
   mess = ('flip frequencies outside noise spectrum');
   UIerror(mess, [hh.Freq2Edit hh.HighFreqEdit]);
else, doReturn = 0;
end;
if doReturn, return; end;

% initialize noise buffer to get maximum SPL.
AK = prepareARMINstim(pp);

% update maxSPLinfo (pp.active = 0|1|2 ~ B|L|R)
limlevel = updateMaxSPLinfo(AK.maxSPL(1), AK.maxSPL(end), flipfreqs, pp.active);

% SPLs
% check SPLs
if any(max(pp.SPL)>limlevel),
   UIerror('level(s) too high', hh.LevelEdit);
   return;
end;

% if we got here, params are OK
% put params in global idfSeq (PDP11 format) and ...
% ... convert to SMS stimulus specification (SGSR format)
global SMS;

SMS = ARMIN2SMS(pp);

% report succes internally & externally
StimMenuStatus.paramsOK = 1;
OK = 1;
UIinfo('Checking parameters...OK');
ReportPlayTime(pp,Nsub);







