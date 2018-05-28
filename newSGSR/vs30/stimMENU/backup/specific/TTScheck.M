function paramsOK = TTScheck;

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
%--- frequencies
pp.probefreq = abs(UIdoubleFromStr(hh.ProbeFreqEdit,1));
pp.suppfreq = abs(UIdoubleFromStr(hh.SuppFreqEdit,1));

%--- SPL params 
[pp.active, acOK] = activeChanCheck;
if ~acOK, return; end
pp.probeSPL = UIdoubleFromStr(hh.ProbeSPLEdit,2);
pp.startSPL = UIdoubleFromStr(hh.StartSPLEdit,2);
pp.stepSPL = abs(UIdoubleFromStr(hh.StepSPLEdit,2));
pp.endSPL = UIdoubleFromStr(hh.EndSPLEdit,2);
pp.TTSversion =1;

% SPL sweep
if ~CheckNaNandInf(pp), return; end;
[SPLsweepOK, SPL] = SPLsweepchecker(pp, hh);
if ~SPLsweepOK, return; end;

UIinfo('Checking...');
% any non-numerical input that hasn't been caught yet?

StimMenuStatus.params = pp; StimMenuStatus.paramsOK = 0;

% ----further param checks
% freq range
MF = maxStimFreq; feh = [];
if (pp.probefreq>MF) | (pp.probefreq<5), feh = [feh, hh.ProbeFreqEdit]; end;
if (pp.suppfreq>MF) | (pp.suppfreq<5), feh = [feh, hh.SuppFreqEdit]; end;
if ~isempty(feh)
   mess = ['frequencies outside 5-' num2str(round(MF)) '-Hz range'];
   UIerror(mess, feh);
   return;
end

% get # subseqs from SPL and report
Nseq = size(SPL,1);
if ~ReportNsubSeq(Nseq), return; end;

% compute maxSPL and report
[dd ifilt] = safeSamplefreq(max([pp.probefreq, pp.suppfreq]));
calProbe = [calibrate(pp.probefreq(1),ifilt,'L'),calibrate(pp.probefreq(end),ifilt,'R')];
MLLp = maxNumToneLevel - calProbe(1);
MLRp = maxNumToneLevel - calProbe(end);
probeSPLOK = 1;
if (pp.probeSPL(1)> MLLp(1)) & (pp.active~=2), probeSPLOK = 0; end;
if (pp.probeSPL(end)> MLLp(end)) & (pp.active~=1), probeSPLOK = 0; end;
if ~probeSPLOK,
   mess = strvcat('probe level(s) too high', ['max.: ' num2str(min(MLLp,MLRp)) ' dB SPL']);
   UIerror(mess, hh.ProbeSPLEdit);
end
RemMaxNumToneLevel = a2db(db2a(maxNumToneLevel)-db2a(pp.probeSPL+calProbe)); % max space on top of probe
MLLs = RemMaxNumToneLevel(1) - calibrate(pp.suppfreq(1),ifilt,'L');
MLRs = RemMaxNumToneLevel(end) - calibrate(pp.suppfreq(end),ifilt,'R');
limlevel = updateMaxSPLinfo(MLLs, MLRs, nan, pp.active);

% check SPLs
if any(max(SPL)>limlevel),
   UIerror('suppressor level(s) too high');% where is that max level
   errorSPL = max(max(SPL));
   if any(pp.endSPL==errorSPL), UItextColor(hh.EndSPLEdit, RED); end;
   if any(pp.startSPL==errorSPL), UItextColor(hh.StartSPLEdit, RED); end;
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
SMS = TTS2SMS(pp);

UIinfo('OK', -1);
StimMenuStatus.paramsOK = 1;
paramsOK= 1;

