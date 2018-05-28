function OK = NRHOcheck;

% NRHOcheck
% Checks params for NRHOmenu and stores the stimulus info in global SMS 

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
[durOK, pp.burstDur, pp.riseDur, pp.fallDur pp.delay] = DurationsCheck;
if ~durOK, return; end;
%--- generic noise parameters
[fbOK, pp.lowFreq, pp.highFreq, pp.rho, pp.noisechar, pp.varchan] = NoiseParamChecker(1,1); % 1: multiple rho values allowed; 1: no running noise
if ~fbOK, return; end;
%--- SPL-sweep params 
%--- SPLs and active channels
[splOK, pp.SPL, pp.active] = SPLandChannelCheck;
if ~splOK, return; end
%--- Rseed & polarity
if NsplExtra('enabled'),
   [XtraOK, pp.Rseed, pp.noisePolarity] = NsplExtra;
   if ~XtraOK, return; end
else, pp.noisePolarity = 1; % default: no reversed phases
end
pp.NRHOversion = 2;
% versions:
%  2. add var chan; change the way rho is realized to an asymmetric procedure (see stimgenNrho)

% any non-numerical or oversized input that hasn't been caught yet?
if ~CheckNaNandInf(pp), return; end;

StimMenuStatus.params = pp;
% get and report # subseqs
Nsub = size(pp.rho,1);
if ~ReportNsubSeq(Nsub), return; end;
% now start more sophisticated param checks
% interval / duration
noiseDur = max(abs(pp.delay))+ max(pp.burstDur);
if (noiseDur>pp.interval),
   mess = strvcat('interval too small to realize bursts',...
      'and interaural delays');
   UIerror(mess, hh.IntervalEdit);
   return;
end;

% initialize noise buffer to get maximum SPL. Distinguish frozen & running noise
maxSPL = prepareNRHOstim(pp);

% update maxSPLinfo (pp.active = 0|1|2 ~ B|L|R)
limlevel = updateMaxSPLinfo(maxSPL(1), maxSPL(end), NaN, pp.active);

% check SPLs
if any(pp.SPL>limlevel),
   UIerror('level(s) too high', hh.LevelEdit);
   return;
end;

% if we got here, params are OK
% put params in global idfSeq (PDP11 format) and ...
% ... convert to SMS stimulus specification (SGSR format)
global SMS;

SMS = NRHO2SMS(pp);

% report succes internally & externally
StimMenuStatus.paramsOK = 1;
OK = 1;
UIinfo('OK', -1);







