function OK = PScheck;

% Checks params for PSmenu and stores the stimulus info in global SMS

global StimMenuStatus SGSR PRPstatus
textcolors;

OK = 0; StimMenuStatus.paramsOK = 0;

hh = StimMenuStatus.handles; 
try, % first time: hide ITD edits
   set(hh.DelayEdit, 'string', '0');
   set([hh.DelayEdit hh.DelayUnit hh.DelayPrompt], 'visible', 'off');
end
UIinfo('Checking parameters...');

% collect param values from uicontrols
pp = []; pp.dummy=''; % pp must be struct before other fields can be filled
%--- presentation params
[presOK, pp.reps, pp.interval, pp.order] = presentationCheck;
if ~presOK, return; end;
%--- duration params
[durOK, pp.burstDur, pp.riseDur, pp.fallDur] = DurationsCheck;
if ~durOK, return; end;
%--- SPLs and active channels
[splOK, pp.SPL, pp.active] = SPLandChannelCheck;
if ~splOK, return; end;
%--- frequency and # phase steps
pp.Nphase = UIdoublefromStr(hh.NPhaseEdit,1);
if pp.Nphase>20,
   UIerror('Nphase may not 20', hh.NPhaseEdit);
   return;
end
pp.freq = UIdoublefromStr(hh.FreqEdit, 1);
[dum dum mess] = safeSamplefreq(pp.freq); 
if ~isempty(mess),
   UIerror('Invalid stim freq', hh.FreqEdit);
   return;
end
pp.PSversion = 1;

StimMenuStatus.params = pp;
% versions:

% any non-numerical or oversized input that hasn't been caught yet?
if ~CheckNaNandInf(pp), return; end;

% now start more sophisticated param checks
Nsub = pp.Nphase;
if ~ReportNsubSeq(Nsub), return; end;

% get limlevel & update maxSPLinfo (pp.active = 0|1|2 ~ B|L|R)
% initialize waveform buffer to get maximum SPL.
maxSPL = preparePSstim(pp);

% update maxSPLinfo (pp.active = 0|1|2 ~ B|L|R)
limlevel = updateMaxSPLinfo(maxSPL(1), maxSPL(end), NaN, pp.active);

% check SPLs
if any(pp.SPL>limlevel),
   UIerror('level(s) too high', hh.LevelEdit);
   return;
end;

% durations
if any(pp.burstDur)>pp.interval,
   mess = strvcat('Interval too short to realize ','bursts and ITDs');
   UIerror(mess, [hh.IntervalEdit hh.BurstDurEdit]);
   return;
end

% if we got here, params are OK
% put params in global idfSeq (PDP11 format) and ...
% ... convert to SMS stimulus specification (SGSR format)
global SMS;
SMS = PS2SMS(pp);

% report succes internally & externally
StimMenuStatus.paramsOK = 1;
OK = 1;
UIinfo('OK', -1);
ReportPlayTime(pp,Nsub);






