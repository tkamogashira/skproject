function newVal = TCtrack(response, itrack,varargin);
% TCtrack - adaptive tracking for tuning curves

persistent TS % trackstatus

if isequal(response, 'init'),
   if isempty(TS), TS = local_initTrackStatus; end;
   %---rules----
   DownUp = varargin{1};
     TS(itrack).Ndown = DownUp(1); 
     TS(itrack).Nup = DownUp(2); 
     TS(itrack).Nfloor = DownUp(3); 
     TS(itrack).Nceil = DownUp(4); 
   Vals = varargin{2};
     TS(itrack).StartVal = Vals(1); 
     TS(itrack).MinVal = min(Vals); % floor because of limited range
     TS(itrack).MaxVal = max(Vals); % ceiling for protection
   StepInfo = varargin{3};
     TS(itrack).StepSize = StepInfo(1,:); % step after FALSE response
     TS(itrack).NRevStep = StepInfo(2,:); % # reversals after which to change stepsize or quit
     TS(itrack).Nstepsize = length(TS(itrack).StepSize); % # different stepsizes
   TS(itrack).MaxNrun = varargin{4}; % max # runs
   %--status-------
   TS(itrack).Nfalse = 0;
   TS(itrack).Ncorrect = 0;
   TS(itrack).Nrev = 0;
   TS(itrack).istep = 1; % first elem of StepVal vector
   TS(itrack).UpTrend = 0; % as if we have been going down lately
   TS(itrack).Nrun = 1; % upon next call, one run has been run
   %--bookkeeping----
   TS(itrack).AllVal = repmat(nan,1,TS(itrack).MaxNrun);
   TS(itrack).Res = repmat(nan,1,TS(itrack).MaxNrun);
   TS(itrack).Rev = repmat(0,1,TS(itrack).MaxNrun);
   TS(itrack).AllVal(1) = TS(itrack).StartVal;
   TS(itrack).FloorHits = 0;
   TS(itrack).CeilHits = 0;
   TS(itrack).EndReason = '';
   return;
end

if nargin<2, itrack=1; end;
if isempty(TS), error('No tracks initialized'); end
if itrack>length(TS), error('Track number exceeds number of initialized tracks'); end
if (ischar(TS(itrack).Nup) |isempty(TS(itrack).Nup)), error('Specified track has not been initialized'); end

if isnumeric(response),
   if localEnded(TS,itrack),
      error('Run was completed at previous call')
   end
   % ---check # preceding runs
   if TS(itrack).Nrun>=TS(itrack).MaxNrun,
      newVal = nan;
      TS(itrack).EndReason = 'Nrun';
      return;
   end
   % ---store response & update nrun
   [TS, nrun] = localStoreResp(TS,itrack, response);
   % ---return NaN if max # runs has been reached
   [TS, direction, isreversal] = localDirection(TS,itrack);
   % ---update stepsize
   [TS, absStep] = localStep(TS, itrack, isreversal);
   step = direction*absStep;
   % ---check for hitting the limits
   [TS, step] = localCheckLimits(TS,itrack, step);
   % ---update value, store & return
   newVal = localPrevVal(TS, itrack) + step;
   TS = localStoreNewVal(TS, itrack, newVal);
   return
end


if isequal(response, 'result'), 
   nrun = TS(itrack).Nrun;
   if  nrun == TS(itrack).MaxNrun, 
      TS(itrack).EndReason = 'Nrun';
   end;
   newVal = TS(itrack);
   % remove NaN initial values from arrays
   if ~isempty(TS(itrack).EndReason),
      newVal.AllVal = newVal.AllVal(1:nrun);
      newVal.Res = newVal.Res(1:nrun);
      newVal.Rev = newVal.Rev(1:nrun);
   end
   return;
end

if isequal(response, 'debug'), % debug
   keyboard;
   return;
end


%---------------------locals--------------------------------
function TS = local_initTrackStatus;
% structure with appropriate fileds
fn = {'Nup' 'Ndown' 'StartVal' 'MinVal' 'MaxVal' 'StepSize' ...
      'NRevStep' 'MaxNrun' 'Nstepsize' 'Nfloor' 'Nceil' ...
      'Nfalse' 'Ncorrect' 'Nrev' 'istep' 'UpTrend' 'Nrun' ...
      'Res' 'AllVal' 'EndReason' 'FloorHits' 'CeilHits' 'Rev'};
fn = {fn{:}; fn{:}};
TS = struct(fn{:});

function e = localEnded(TS,itrack);
e = TS(itrack).Nrun > TS(itrack).MaxNrun ...
   | ~isempty(TS(itrack).EndReason);

function [TS, nrun] = localStoreResp(TS,itrack, response);
TS(itrack).Res(TS(itrack).Nrun) = response;
% update # runs
TS(itrack).Nrun = TS(itrack).Nrun+1;
nrun = TS(itrack).Nrun;

function cval = localPrevVal(TS,itrack);
nrun = TS(itrack).Nrun;
cval = TS(itrack).AllVal(nrun-1);

function TS = localStoreNewVal(TS,itrack,newVal);
nrun = TS(itrack).Nrun;
TS(itrack).AllVal(nrun) = newVal;

function [TS, direction, isrev] = localDirection(TS,itrack);
nrun = TS(itrack).Nrun;
direction = 0;
response = TS(itrack).Res(TS(itrack).Nrun-1);
if response, % correct
   TS(itrack).Ncorrect = TS(itrack).Ncorrect + 1;
   direction = -(TS(itrack).Ncorrect==TS(itrack).Ndown);
   isrev = direction & TS(itrack).UpTrend;
else,
   TS(itrack).Nfalse = TS(itrack).Nfalse + 1;
   direction = (TS(itrack).Nfalse==TS(itrack).Nup);
   isrev = direction & ~TS(itrack).UpTrend;
end
% exception: first response never causes reversal
if (TS(itrack).Nrun==2) & direction,
   isrev = 0;
   % falsify Uptrend
   TS(itrack).UpTrend = (direction==1);
end
% reset counters
if direction,
   TS(itrack).Ncorrect = 0;
   TS(itrack).Nfalse = 0;
end
% update state variables
if isrev, 
   TS(itrack).UpTrend = ~TS(itrack).UpTrend;
   TS(itrack).Nrev = TS(itrack).Nrev+1; 
   TS(itrack).Rev(nrun) = 1;
end

function [TS, absStep] = localStep(TS, itrack, isrev);
if (~isrev) | TS(itrack).Nrev<TS(itrack).NRevStep(TS(itrack).istep),
   absStep = TS(itrack).StepSize(TS(itrack).istep); % current stepsize is okay
   return;
end
% stepsize must be updated
if TS(itrack).istep==TS(itrack).Nstepsize, % through!
   absStep=nan; 
   TS(itrack).EndReason = 'Nrev';
else, % take next stepsize value and start counting reversals again
   TS(itrack).istep = TS(itrack).istep + 1;
   TS(itrack).Nrev = 0; % start counting again
   absStep=TS(itrack).StepSize(TS(itrack).istep); 
end; 

function [TS, step] = localCheckLimits(TS,itrack, step);
% check for hitting the limits
newVal = localPrevVal(TS,itrack) + step; % tentative new value
if newVal>TS(itrack).MaxVal,
   if TS(itrack).CeilHits+1>TS(itrack).Nceil,
      step = nan;
      TS(itrack).EndReason = 'Nceil';
      return;
   end
   TS(itrack).CeilHits = TS(itrack).CeilHits+1;
   step = TS(itrack).MaxVal - localPrevVal(TS,itrack);
elseif newVal<TS(itrack).MinVal,
   if TS(itrack).FloorHits+1>TS(itrack).Nfloor, 
      step = nan;
      TS(itrack).EndReason = 'Nfloor';
      return;
   end
   TS(itrack).FloorHits = TS(itrack).FloorHits+1;
   step = TS(itrack).MinVal - localPrevVal(TS,itrack);
end

nrun = TS(itrack).Nrun;
