function [OK, varargout] = FMcheck(varargin);

% Checks params for FMmenu and stores the stimulus info in
% globals idfSeq and SMS  (PDP11 and SGSR formats, resp)
% note: PRPstatus must be initialized at entry

global StimMenuStatus SGSR PRPstatus
textcolors;

if nargin>0, % call local fnc
   varargout = cell(1,nargout-1);
   [varargout{:}] = feval(varargin{:});
   OK = 1;
   return;
end

OK = 0; StimMenuStatus.paramsOK = 0;

hh = StimMenuStatus.handles; 
uitoggle(hh.OrderButton,'Forward'); % effectively disable order button
UIinfo('Checking parameters...');

% collect param values from uicontrols
pp = []; pp.dummy=''; % pp must be struct before other fields can be filled
%--- presentation params
[presOK, pp.reps, pp.interval, pp.order] = presentationCheck;
if ~presOK, return; end;
%--- duration params
[durOK, dummy, pp.riseDur, pp.fallDur, pp.delay] = DurationsCheck(0,0,1); % noburstdur
if ~durOK, return; end;
%--- SPLs and active channels
[splOK, pp.SPL, pp.active] = SPLandChannelCheck;
if ~splOK, return; end;
%--- frequency sweep params
pp.lofreq = UIdoubleFromStr(hh.LowFreqEdit,2);
pp.hifreq = UIdoubleFromStr(hh.HighFreqEdit,2);
pp.updur = UIdoubleFromStr(hh.UpDurEdit,2);
pp.holddur = UIdoubleFromStr(hh.HoldDurEdit,2);
pp.downdur = UIdoubleFromStr(hh.DownDurEdit,2);
StimMenuStatus.params = pp;
        
% now start more sophisticated param checks
[MLleft, critFreqL] = localLimLevel(pp.lofreq(1), pp.hifreq(1),'L', pp.active);
[MLright, critFreqR] = localLimLevel(pp.lofreq(end), pp.hifreq(end),'R', pp.active);

% get limlevel & update maxSPLinfo (pp.active = 0|1|2 ~ B|L|R)
limlevel = updateMaxSPLinfo(MLleft, MLright, [critFreqL, critFreqR], pp.active);

% SPLs
if any(pp.SPL>[limlevel(1) limlevel(2)]),
   UIerror('level(s) too high', hh.LevelEdit);
   return;
end;

% durations
burstDur = pp.updur + pp.holddur + pp.downdur;
if any(burstDur+1.1*max(abs(pp.delay(:)))>pp.interval),
   mess = strvcat('Interval too short to realize ','bursts and ITDs');
   UIerror(mess, ...
      [hh.IntervalEdit hh.UpDurEdit hh.HoldDurEdit hh.DownDurEdit hh.DelayEdit]);
   return;
end
if any(pp.riseDur+pp.fallDur>burstDur),
   UIerror('Ramps exceed burst duration',[hh.RiseDurEdit]);
   return;
end

% always one condition only
ReportNsubSeq(1);

% if we got here, params are OK
% put params in global idfSeq (PDP11 format) and ...
% ... convert to SMS stimulus specification (SGSR format)
global idfSeq SMS CALIB;

idfSeq = FMcreateIDF(pp);
SMS = IDF2SMS(idfSeq, CALIB.ERCfile);

% report succes internally & externally
StimMenuStatus.paramsOK = 1;
OK = 1;
UIinfo('OK', -1);
Nsub = 1;
ReportPlayTime(idfSeq,Nsub);

%-------locals---------
function [MaxLevel, critFreq] = localLimLevel(lofreq,hifreq, chan, active);
chan = channelNum(chan);
if nargin<4, % trust that the specified channel is active
   active = 0;
end
if ((chan==1) & (active==2)) | ((chan==2) & (active==1)),
   % dead channel
   MaxLevel = NaN;
   critFreq = 0;
   return
end
[dd, ifilt] = safesamplefreq(max(max(lofreq, hifreq)));
DF = 100; % Hz spacing for level checking
Nf = 1+round((hifreq-lofreq)/DF);
freqs = linspace(lofreq,hifreq,Nf)';
% get most critical (i.e., level-limiting) freq
calAmp = calibrate(freqs, ifilt, chan);
[critCalAmp, index] = max(calAmp);
MaxLevel = maxNumToneLevel - critCalAmp;
critFreq = freqs(index);






