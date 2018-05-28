function OK = CFScheck;

% Checks params for CFSmenu and stores the stimulus info in
% globals idfSeq and SMS  (PDP11 and SGSR formats, resp)
% note: PRPstatus must be initialized at entry

global StimMenuStatus SGSR PRPstatus clickData
textcolors;

OK = 0; StimMenuStatus.paramsOK = 0;

hh = StimMenuStatus.handles; 

UIinfo('Checking parameters...');

% collect param values from uicontrols
pp = []; pp.dummy=''; % pp must be struct before other fields can be filled
%--- frequency sweep params
[fsOK, pp.lofreq, pp.dfreq, pp.hifreq, cfreqs, Nseq, pp.stepunit] = frequencySweepCheck;
if ~fsOK, return; end;
%--- presentation params
[presOK, pp.reps, pp.interval, pp.order] = presentationCheck;
if ~presOK, return; end;
%--- duration params
[durOK, pp.burstDur, pp.riseDur, pp.fallDur, pp.delay] = DurationsCheck(0,1); % 1=no gating;
if ~durOK, return; end;
%--- SPLs and active channels
[splOK, pp.SPL, pp.active] = SPLandChannelCheck;
if ~splOK, return; end;
%--- click params
[clickOK, pp.polarity, pp.clickDur] = ClickParamCheck;
if ~clickOK, return; end;

StimMenuStatus.params = pp;

% now start more sophisticated param checks

% durations
if any(pp.burstDur+1.1*max(abs(pp.delay(:)))>pp.interval),
   mess = strvcat('Interval too short to realize ','bursts and ITDs');
   UIerror(mess, [hh.IntervalEdit hh.BurstDurEdit]);
   return;
end
highestRate = max(cfreqs); % per-channel maximum
if any(pp.clickDur*1e-6.*highestRate>0.99),
   mess = strvcat('Combination of click rate and','click duration leads to', 'overlapping pulses.');
   UIerror(mess, [hh.ClickDurEdit hh.HighFreqEdit]);
   return;
end

% generate click trains to evaluate max SP
MaxLevels = NaN+zeros(size(cfreqs,1), channelCount(pp.active));
if pp.order==1, cfreqs = flipUD(cfreqs); end; % fix problems with RB order fix
for ii=1:Nseq,
   PT = pulseTrain(cfreqs(ii,:),pp.burstDur,ChannelChar(pp.active), pp.clickDur, pp.polarity);
   if isempty(clickData), clickData = PT ; end; % faliure of implicit array assignment
   clickData(ii) = PT; % store for stimDEF stage
   MaxLevels(ii,:) = PT.maxSPL;
end
% get limlevel & update maxSPLinfo (pp.active = 0|1|2 ~ B|L|R)
MLleft = min(MaxLevels(:,1));
MLright = min(MaxLevels(:,end));
limlevel = updateMaxSPLinfo(MLleft, MLright, cfreqs, pp.active);

% SPLs
if any(pp.SPL>[limlevel(1) limlevel(2)]),
   UIerror('Level(s) too high', hh.LevelEdit);
   return;
end;

% if we got here, params are OK
% put params in global idfSeq (PDP11 format) and ...
% ... convert to SMS stimulus specification (SGSR format)
global idfSeq SMS CALIB;
limchan = idfLimitChan(pp.active,cfreqs);
idfSeq = CFScreateIDF(pp.hifreq, pp.lofreq, pp.dfreq, ...
   pp.polarity, pp.clickDur, pp.SPL, pp.delay, ...
   pp.interval, pp.burstDur, ...
   pp.reps, pp.order,...
   pp.active, limchan, pp.stepunit);
SMS = IDF2SMS(idfSeq, CALIB.ERCfile);

% report succes internally & externally
StimMenuStatus.paramsOK = 1;
OK = 1;
UIinfo('OK', -1);



