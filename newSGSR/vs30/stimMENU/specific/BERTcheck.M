function paramsOK = BERTcheck;

textcolors; global StimMenuStatus SGSR
paramsOK= 0; 
% first visit all edit controls and look if their formats are OK 
hh = StimMenuStatus.handles; 
pp = []; pp.dummy=0; % pp must be struct before other fields can be filled as below
%--- presentation params
[presOK, pp.reps, pp.interval, pp.order] = presentationCheck;
if ~presOK, return; end;
%--- duration params
[durOK, pp.burstDur, pp.riseDur, pp.fallDur] = DurationsCheck(1); % single values
if ~durOK, return; end;
%--- REVCOR params frequencies
pp.Rseed = UIdoubleFromStr(hh.RandSeedEdit);
pp.modDepth = UIdoubleFromStr(hh.ModDepthEdit);
pp.NoiseHF = abs(UIdoubleFromStr(hh.NoiseHFEdit));
pp.NoiseLF = abs(UIdoubleFromStr(hh.NoiseLFEdit));
pp.CarrierFreq = abs(UIdoubleFromStr(hh.CarrierFreqEdit));
%--- SPL params 
[splOK, pp.SPL, pp.active] = SPLandChannelCheck;
if ~splOK, return; end
pp.BERTversion =1;


UIinfo('Checking...');
% any non-numerical input that hasn't been caught yet?
if ~CheckNaNandInf(pp), return; end;

StimMenuStatus.params = pp; StimMenuStatus.paramsOK = 0;

% ----further param checks
if (pp.NoiseLF>pp.NoiseHF),
   UIerror('Noise LF exceeds noise HF', [hh.NoiseLFEdit hh.NoiseHFEdit]);
   return;
end

% freq range
MF = maxStimFreq; feh = [];
pp.CarrierFreq = abs(UIdoubleFromStr(hh.CarrierFreqEdit));
if (pp.NoiseLF>MF) | (pp.NoiseLF<2), feh = [feh, hh.NoiseLFEdit]; end;
if (pp.NoiseHF>MF) | (pp.NoiseHF<2), feh = [feh, hh.NoiseHFEdit]; end;
if (pp.CarrierFreq+pp.NoiseHF>MF) | (pp.CarrierFreq-pp.NoiseHF<2), 
   feh = [feh, hh.CarrierFreqEdit]; 
end;
if ~isempty(feh)
   mess = ['frequencies outside 2-' num2str(round(MF)) '-Hz range'];
   UIerror(mess, feh);
   return;
end


% report # subseqs (trivially one)
Nsub = 1;
if ~ReportNsubSeq(Nsub), return; end;

% generate stimulus to get maxSPL
maxSPL = prepareBERTstim(pp);
limlevel = updateMaxSPLinfo(maxSPL(1), maxSPL(end), nan, pp.active);

% check SPLs
if any(pp.SPL>limlevel),
   UIerror('Level(s) too high', hh.LevelEdit);% where is that max level
   return;
end;

% durations
if any(pp.burstDur>pp.interval),
   mess = strvcat('interval too small to realize bursts');
   UIerror(mess, hh.IntervalEdit);
   return;
end;

% if we got here, params are OK;
% convert to SMS stimulus specification (SGSR format)

global SMS
SMS = BERT2SMS(pp);

UIinfo('OK', -1);
ReportPlayTime(pp,Nsub);
StimMenuStatus.paramsOK = 1;
paramsOK= 1;

