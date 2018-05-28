function paramsOK = ITDcheck;

textcolors; global StimMenuStatus SGSR
paramsOK= 0; 
% first visit all edit controls and look if their formats are OK  XXXX not ready
hh = StimMenuStatus.handles; 
pp = []; pp.dummy=0; % pp must be struct before other fields can be filled as below
%--- presentation params
[presOK, pp.reps, pp.interval, pp.order] = presentationCheck;
if ~presOK, return; end;
%--- duration params
[durOK, pp.burstDur, pp.riseDur, pp.fallDur] = DurationsCheck(1);
if ~durOK, return; end;
%--- SPLs and active channels
[splOK, pp.SPL, pp.active] = SPLandChannelCheck;
if ~splOK, return; end;
%--- modulation
[modOK, pp.modDepth, pp.modFreq] = ModulationCheck(1);
if ~modOK, return; end;

%--- ITD-sweep params
pp.carfreq = abs(UIdoubleFromStr(hh.CarFreqEdit,1));
pp.Ncycle = abs(UIdoubleFromStr(hh.NcycleEdit,1));
pp.Nsteps = round(abs(UIdoubleFromStr(hh.StepsPerCycleEdit,1)));
% phasecomp from button
pp.phaseComp = UIintfromToggle(hh.PhaseCompButton)-1;

StimMenuStatus.params = pp; StimMenuStatus.paramsOK = 0;

UIinfo('Checking...');
% any non-numerical input that hasn't been caught yet?
if ~CheckNaNandInf(pp), return; end;

% ----further param checks
% freq range
MF = maxStimFreq;
if ((pp.carfreq+abs(pp.modFreq))>MF),
   mess = ['frequencies outside 0-' num2str(MF) '-Hz range'];
   UIerror(mess, hh.CarFreqEdit);
   return;
end
% number of steps/cycle
if pp.Nsteps==0,
   UIerror('zero steps/cycle specified', hh.StepsPerCycleEdit);
   return;
end;
% compute # subseqs from ITD-sweep params and report
Nseq = 1 + 2 * pp.Nsteps * pp.Ncycle;
if ~ReportNsubSeq(Nseq), return; end;

% compute maxSPL and report
DontModulate = (pp.modFreq==0)  | (pp.modDepth==0);
if DontModulate,
   [dd ifilt] = safesamplefreq(pp.carfreq);
   MLL = maxNumToneLevel - calibrate(pp.carfreq, ifilt, 'L');
   MLR = maxNumToneLevel - calibrate(pp.carfreq, ifilt, 'R');
else,
   MLL = sxmMaxCarSPL(pp.modFreq, pp.carfreq, pp.modDepth(1), 'L');
   MLR = sxmMaxCarSPL(pp.modFreq, pp.carfreq, pp.modDepth(end), 'R');
end
limlevel = updateMaxSPLinfo(MLL, MLR, pp.carfreq, pp.active, 1);

% check SPLs
if any(pp.SPL>limlevel),
   UIerror('level(s) too high', hh.LevelEdit);
   return;
end;

% durations
DelayOnMod = any((pp.modFreq>0) & (pp.modDepth~=0));
if DelayOnMod, OneCycle = 1e3/pp.modFreq; % duration of one mod cycle in ms
else, OneCycle = 1e3/pp.carfreq; % duration of one car cycle in ms
end
maxITD = OneCycle * pp.Ncycle; % in ms
if (maxITD*1.1 + pp.burstDur)>pp.interval,
   if DelayOnMod, cStr = 'modulation'; else, cStr = 'carrier'; end;
   mess = strvcat('interval too small to realize burst & ITDs',...
      ['(' cStr ' cycle ~ ITD of ' num2str(maxITD) ' ms)']);
   UIerror(mess, hh.IntervalEdit);
   return;
end;

% if we got here, params are OK
% put params in global idfSeq (PDP11 format) and ...
% ... convert to SMS stimulus specification (SGSR format)
LeadChan = pp.order+1; % order=(0,1,2)=(I2C, C2I, Random)
if LeadChan==3, LeadChan = 2; end; % correct for random order
% ipsi/contra -> left/right
if isequal(ipsiSide,'R'),  LeadChan=3-LeadChan; end;% swap 1 & 2

global idfSeq SMS CALIB
limchan = idfLimitChan(pp.active,[0 0 ;1 2]); % default: right channel is varied
idfSeq = ITDcreateIDF(pp.carfreq, ...
   pp.modFreq, pp.modDepth, pp.SPL, ...
   pp.Ncycle, pp.Nsteps, pp.phaseComp, DelayOnMod, LeadChan, ...
   pp.interval, pp.burstDur, pp.riseDur, pp.fallDur, ...
   pp.reps, pp.order, pp.active, limchan);

SMS = IDF2SMS(idfSeq, CALIB.ERCfile);

UIinfo('OK', -1);
StimMenuStatus.paramsOK = 1;
paramsOK= 1;


