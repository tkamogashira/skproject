function OK = THRcheck;

% Checks params for THRmenu and stores the stimulus info in
% global SMS  
% note: PRPstatus must be initialized at entry

global StimMenuStatus SGSR PRPstatus
textcolors;

OK = 0; StimMenuStatus.paramsOK = 0;

hh = StimMenuStatus.handles; 
set(hh.BurstDurPrompt,'tooltipstring','Burst duration, including on- and offset ramps');
set(hh.PlayButton,'visible','off'); 
set(hh.PlayMenuItem,'label','');
set(hh.PlayMenuItem,'callback','');
set(hh.PlayMenuItem,'accelerator','');
set(hh.RepeatButton,'visible','off');
set(hh.RepeatPrompt,'visible','off');

UIinfo('Checking parameters...');

% collect param values from uicontrols
pp = []; pp.dummy=''; % pp must be struct before other fields can be filled
%--- frequency sweep params
[fsOK, pp.lofreq, pp.dfreq, pp.hifreq, pp.cfreqs, Nseq, pp.stepunit] = frequencySweepCheck;
if ~fsOK, return; end;
%--- presentation params
[presOK, pp.silence, pp.interval, pp.order] = presentationCheck;
if ~presOK, return; end;
%--- duration params
[durOK, pp.burstDur, pp.riseDur, pp.fallDur, pp.delay] = DurationsCheck(1);
if ~durOK, return; end;
%--- SPLs and active channels
[splOK, pp.SPL, pp.active] = SPLandChannelCheck(0,1);
if ~splOK, return; end;

% track params
pp.stepSize = abs(uidoubleFromStr(hh.StepEdit,1));
pp.startSPL = uidoubleFromStr(hh.StartSPLEdit,1);
pp.Nrev = round(uidoubleFromStr(hh.RevCountEdit,1));
pp.critMode = UIintfromToggle(hh.CritButton); % 1|2|3|4 = spikes|percentage|std|sqrt(n)
pp.critVal = abs(uidoubleFromStr(hh.CritEdit,1));
% min level
pp.minSPL = uidoubleFromStr(hh.MinSPLEdit,1);

if ~checkNaNandInf(pp), return; end;

% convert criterium mode to string value
cModes = {'spike', 'perc', 'std', 'sqrt'};
pp.critMode = cModes{pp.critMode};

StimMenuStatus.params = pp;

[dd, ifilt] = safeSampleFreq(max(pp.cfreqs));
if ~localCheckTrackParams(pp,hh), return; end;
% get limlevel & update maxSPLinfo (pp.active = 0|1|2 ~ B|L|R)
leftActive = ~isequal(pp.active,2); 
rightActive = ~isequal(pp.active,1);
MLleft = NaN; MLright = NaN;
if leftActive, MLleft = maxNumToneLevel - calibrate(pp.cfreqs(:,1), ifilt, 'L'); end;
if rightActive, MLright = maxNumToneLevel - calibrate(pp.cfreqs(:,end), ifilt, 'R'); end;
limlevel = updateMaxSPLinfo(MLleft, MLright, pp.cfreqs, pp.active);

% SPLs
if any(pp.SPL>[limlevel(1) limlevel(2)]),
   UIerror('level(s) too high', hh.LevelEdit);
   return;
end;

dynRange = pp.SPL-pp.minSPL;
lh = [hh.LevelEdit hh.MinSPLEdit];
if dynRange<0,
   UIerror('Min SPL > Max SPL', lh);
   return
elseif dynRange>maxAnalogAtten,
   mess = strvcat('Dynamic range too large for',...
      'attenuators. Decrease Max SPL,',...
      'Increase Min SPL, or',...
      'change local system params.');
   UIerror(mess,lh);
   return
end

% durations
global SGSR
if isdeveloper, MT = 50; else MT = SGSR.switchDur; end;
if any(pp.burstDur+1.1*max(abs(pp.delay(:)))>pp.interval-MT),
   mess = strvcat('Interval too short to realize ',...
      'bursts and ITDs and to include',...
      ['a ' num2str(MT) '-ms switch time']);
   UIerror(mess, [hh.IntervalEdit hh.BurstDurEdit]);
   return;
end

% if we got here, params are OK
% put params in global idfSeq (PDP11 format) and ...
% ... convert to SMS stimulus specification (SGSR format)
global idfSeq SMS CALIB;
idfSeq = [];

SMS = THR2SMS(pp);

% report succes internally & externally
StimMenuStatus.paramsOK = 1;
OK = 1;
UIinfo('OK', -1);

%--------------------------------------------------------------------
%--------------------------------------------------------------------
function OK = localCheckTrackParams(pp,hh);
OK = 0;
nowOK=0;
if (pp.stepSize==0),
   UIerror('Stepsize must be positive', hh.StepEdit);
elseif (pp.stepSize)>30,
   UIerror('Stepsize exceeds 30 dB', hh.StepEdit);
else, nowOK = 1;
end
if ~nowOK, return; end;
nowOK = 0;
if any(pp.startSPL>pp.SPL),
   UIerror('Start level too high', hh.StartSPLEdit);
elseif any(pp.startSPL<pp.minSPL),
   UIerror('Start level too low', hh.StartSPLEdit);
else, nowOK = 1;
end
if ~nowOK, return; end;
nowOK = 0;
if (pp.Nrev<=0),
   UIerror('Invalid reversal count', hh.RevCountEdit);
else, nowOK = 1;
end
if ~nowOK, return; end;
nowOK = 0;
if (pp.critVal==0),
   UIerror('Criterium value must be positive', hh.CritEdit);
   return;
end
switch pp.critMode
case 'spike'
   if rem(pp.critVal,1), 
      UIerror('non-integer spike count', hh.CritEdit); 
      return;
   else, nowOK = 1;
   end;
   if ~nowOK, return; end;
case 'perc'
case 'std'
case 'sqrt'
end
OK = 1;   








