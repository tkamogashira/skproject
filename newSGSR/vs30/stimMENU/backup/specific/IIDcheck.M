function paramsOK = IIDcheck;

textcolors; global StimMenuStatus SGSR
paramsOK= 0; 
% first visit all edit controls and look if their formats are OK  XXXX not ready
hh = StimMenuStatus.handles; 
pp = []; pp.dummy=0; % pp must be struct before other fields can be filled as below
%--- presentation params
[presOK, pp.reps, pp.interval, pp.order] = presentationCheck;
if ~presOK, return; end;
%--- duration params
[durOK, pp.burstDur, pp.riseDur, pp.fallDur pp.delay] = DurationsCheck;
if ~durOK, return; end;
%--- SPLs and active channels
[splOK, pp.maxSPL, pp.active] = SPLandChannelCheck(0,1);
if ~splOK, return; end;
%--- modulation
[modOK, pp.modDepth, pp.modFreq] = ModulationCheck;
if ~modOK, return; end;

%--- IID-sweep params
pp.carfreq = abs(UIdoubleFromStr(hh.CarFreqEdit,2));
if length(pp.carfreq)==1, % make it a dual-channel value
   pp.carfreq = [1 1] * pp.carfreq;
end
pp.meanSPL = UIdoubleFromStr(hh.MeanSPLEdit,1);
pp.stepIID = abs(UIdoubleFromStr(hh.StepIIDEdit,1));

StimMenuStatus.params = pp; StimMenuStatus.paramsOK = 0;

UIinfo('Checking...');
% any non-numerical input that hasn't been caught yet?
if ~CheckNaNandInf(pp), return; end;

% ----further param checks
% freq range
MF = maxStimFreq;
if any((pp.carfreq+abs(pp.modFreq))>MF),
   mess = ['frequencies outside 0-' num2str(MF) '-Hz range'];
   UIerror(mess, hh.CarFreqEdit);
   return;
end

% IID sweep
if (pp.stepIID==0) & ~isequal(pp.maxSPL,pp.meanSPL),
   UIerror('zero step size', hh.StepIIDEdit);
   return;
end;

if pp.maxSPL<pp.meanSPL,
   UIerror('max SPL > mean SPL', [hh.MeanSPLEdit hh.LevelEdit]);
   return;
end;

minSPL = 2*pp.meanSPL - pp.maxSPL;
if isequal(0,pp.stepIID), Nsteps = 0;
else, Nsteps = (pp.maxSPL-minSPL)/pp.stepIID; end;
if ~isequal(0,rem(Nsteps,1)),
   mess = strvcat('step size is incompatible',...
      'with max SPL and mean SPL.');
   UIerror(mess, [hh.StepIIDEdit, hh.MeanSPLEdit, hh.LevelEdit]);
   return;
end

% compute # subseqs from IID-sweep params and report
Nseq = 1 + Nsteps;
if ~ReportNsubSeq(Nseq), return; end;

% compute maxSPL and report
DontModulate = (pp.modFreq==0)  | (pp.modDepth==0);
if DontModulate,
   [dd ifilt] = safeSamplefreq(max(pp.carfreq));
   MLL = maxNumToneLevel - calibrate(pp.carfreq(1), ifilt, 'L');
   MLR = maxNumToneLevel - calibrate(pp.carfreq(end), ifilt, 'R');
else,
   MLL = sxmMaxCarSPL(pp.modFreq(1), pp.carfreq(1), pp.modDepth(1), 'L');
   MLR = sxmMaxCarSPL(pp.modFreq(end), pp.carfreq(end), pp.modDepth(end), 'R');
end
limlevel = updateMaxSPLinfo(MLL, MLR, pp.carfreq, pp.active);

% check SPLs
if any(pp.maxSPL>limlevel),
   UIerror('level(s) too high', hh.LevelEdit);
   return;
end;

% durations
if any((abs(pp.delay) + pp.burstDur)>pp.interval),
   mess = strvcat('interval too small to realize bursts',...
      'and interaural delays');
   UIerror(mess, hh.IntervalEdit);
   return;
end;

% if we got here, params are OK
% put params in global idfSeq (PDP11 format) and ...
% ... convert to SMS stimulus specification (SGSR format)

global idfSeq SMS CALIB
limchan = idfLimitChan(pp.active, [1 1]); % both channels are varied by equally amounts
idfSeq = IIDcreateIDF(pp.carfreq, ...
   pp.modFreq, pp.modDepth, pp.maxSPL, ...
   pp.meanSPL, pp.stepIID, pp.active, limchan, ...
   pp.interval, pp.burstDur, pp.delay, pp.riseDur, pp.fallDur, ...
   pp.reps, pp.order);

SMS = IDF2SMS(idfSeq, CALIB.ERCfile);

UIinfo('OK', -1);
StimMenuStatus.paramsOK = 1;
paramsOK= 1;


