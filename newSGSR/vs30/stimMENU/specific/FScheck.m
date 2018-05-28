function OK = FScheck;

% Checks params for FSmenu and stores the stimulus info in
% globals idfSeq and SMS  (PDP11 and SGSR formats, resp)
% SGSR version 06 & higher
% note: PRPstatus must be initialized at entry

global StimMenuStatus SGSR PRPstatus
textcolors;

OK = 0; StimMenuStatus.paramsOK = 0;

hh = StimMenuStatus.handles; 
UIinfo('Checking parameters...');

% collect param values from uicontrols
pp = []; pp.dummy=''; % pp must be struct before other fields can be filled
%--- frequency sweep params
[fsOK, pp.lofreq, pp.dfreq, pp.hifreq, cfreqs, Nsub, pp.stepunit] = frequencySweepCheck;
if ~fsOK, return; end;
%--- presentation params
[presOK, pp.reps, pp.interval, pp.order] = presentationCheck;
if ~presOK, return; end;
%--- duration params
[durOK, pp.burstDur, pp.riseDur, pp.fallDur, pp.delay] = DurationsCheck;
if ~durOK, return; end;
%--- SPLs and active channels
[splOK, pp.SPL, pp.active] = SPLandChannelCheck;
if ~splOK, return; end;
%--- modulation
[modOK, pp.modDepth, pp.modFreq] = ModulationCheck;
if ~modOK, return; end;

StimMenuStatus.params = pp;
             
% now start more sophisticated param checks

% Modulation
DontModulate = (pp.modFreq==0)  | (pp.modDepth==0);
if DontModulate,
   UItextColor(hh.ModulationFrameTitle, CGRAY);
else, 
   UItextColor(hh.ModulationFrameTitle, BLACK);
end

% get limlevel & update maxSPLinfo (pp.active = 0|1|2 ~ B|L|R)
leftActive = ~isequal(pp.active,2); 
rightActive = ~isequal(pp.active,1);
MLleft = NaN; MLright = NaN;
if DontModulate,
   if leftActive, MLleft = maxNumToneLevel - calibrate(cfreqs(:,1), NfiltInsetup, 'L'); end;
   if rightActive, MLright = maxNumToneLevel - calibrate(cfreqs(:,end), NfiltInsetup, 'R'); end;
else, % % sxm: level is *carrier* level by definition
   if leftActive, 
      MLleft = sxmMaxCarSPL(pp.modFreq(1), cfreqs(:,1), pp.modDepth(1), 'L');
   end
   if rightActive, 
      MLright = sxmMaxCarSPL(pp.modFreq(end), cfreqs(:,end), pp.modDepth(end), 'R');
   end
end
limlevel = updateMaxSPLinfo(MLleft, MLright, cfreqs, pp.active);

% SPLs
if any(pp.SPL>[limlevel(1) limlevel(2)]),
   UIerror('level(s) too high', hh.LevelEdit);
   return;
end;

% durations
if any(pp.burstDur+1.1*max(abs(pp.delay(:)))>pp.interval),
   mess = strvcat('Interval too short to realize ','bursts and ITDs');
   UIerror(mess, [hh.IntervalEdit hh.BurstDurEdit]);
   return;
end

% if we got here, params are OK
% put params in global idfSeq (PDP11 format) and ...
% ... convert to SMS stimulus specification (SGSR format)
global idfSeq SMS CALIB;
limchan = idfLimitChan(pp.active, cfreqs);
idfSeq = FScreateIDF(pp.hifreq, pp.lofreq, pp.dfreq,...
   pp.modFreq, pp.modDepth, pp.SPL, pp.delay, ...
   pp.interval, pp.burstDur, pp.riseDur , pp.fallDur, ...
   pp.reps, pp.order,...
   pp.active, limchan, pp.stepunit);

SMS = IDF2SMS(idfSeq, CALIB.ERCfile);

% report succes internally & externally
StimMenuStatus.paramsOK = 1;
OK = 1;
UIinfo('OK', -1);
ReportPlayTime(idfSeq,Nsub);








