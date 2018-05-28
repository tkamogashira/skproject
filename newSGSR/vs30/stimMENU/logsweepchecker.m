function [allValues, mess,  AdjustedVal] = ...
   logSweepchecker(startVal, stepVal, endVal, ...
   ActiveChan, ...
   RelTol, WhichToAdjust);

if nargin<5, RelTol =1e-2; end;
Adjustment = (nargin>=5);

% provide default return values to avoid warnings on premature return
allValues = [];
mess = '';
AdjustedVal = NaN;
% Channels is list of all active channels
if ActiveChan==0, Channels = [1,2];
else Channels = ActiveChan; end;

% convert limits to octaves since step is in octaves
startVal = log2(1e-20+abs(startVal)); % avoid log-of-zero warnings
stepVal = abs(stepVal); % direction does't matter; determined by start/end values
endVal = log2(1e-20+abs(endVal));
% any double valued values?
MaxValLen = max([length(startVal), length(stepVal), length(endVal)]);
% duplicate 
startVal = local_dup(startVal); 
stepVal = local_dup(stepVal);
endVal = local_dup(endVal);
% default value for adjusted value is original value
if Adjustment,
   eval(['AdjustedVal = ' WhichToAdjust 'Val;']);
end

Nstep = [0 0];
for ch=Channels,
   % check zero step and equality of start/end values
   if (stepVal(ch)==0) & (startVal(ch)~=endVal(ch));
      mess = 'ZEROSTEP';
      return;
   end	
   % compute # steps demanded by each channel
   if stepVal(ch)~=0,
      Nstep(ch) = abs((endVal(ch)-startVal(ch))/stepVal(ch));
      if rem(Nstep(ch),1),
         if ~Adjustment,
            mess = 'BADSTEP';
            return;
         else, % try to adjust the value
            [startVal(ch), stepVal(ch), endVal(ch), ...
                  Nstep(ch), AdjustedVal(ch), mess] = ...
               local_adjust(startVal(ch), stepVal(ch), endVal(ch), ...
               RelTol, WhichToAdjust);
         end % if ~Adjustment
      end % if rem
   end % if stepVal
end % for ch=Channels

% check if different number of steps are needed in the two channels
if all(Nstep~=0) & (Nstep(1)~=Nstep(end)),
   mess = 'DIFF#STEPS';
   return;
end
% the # steps equals the maximum of the two channels
Nstep = max(Nstep);
% compute the values while converting back to lin values
Left = pow2(linspace(startVal(1),endVal(1),Nstep+1));
Right = pow2(linspace(startVal(end),endVal(end),Nstep+1));
allValues = [Left.' Right.'];
if ActiveChan~=0,
   AdjustedVal = AdjustedVal(ActiveChan);
elseif MaxValLen==1,
   AdjustedVal = AdjustedVal(1);
end

%-----------------locals --------------
function y = local_dup(x);
% changes single valued variable into a double-valued one
if length(x)==1, y = [x x];
else, y = x;
end

function [nx0, ndx, nx1, nNstep, AdjustedVal, mess] = ...
   local_adjust(x0, dx, x1, RelTol, WhichToAdjust);
nNstep = round((x1-x0)/dx); % has sign for use below
switch WhichToAdjust
case 'start'
   ndx = dx;
   nx1 = x1;
   nx0 = x1 - dx*nNstep;
   AdjustedVal = pow2(nx0);
   GraveOne = local_graveDeviation(nx0, x0, RelTol);
case 'step'
   nx0 = x0;
   nx1 = x1;
   ndx = abs(x0-x1)/nNstep;
   GraveOne = local_graveDeviation(ndx, dx, RelTol);
   AdjustedVal = ndx;
case 'end'
   ndx = dx;
   nx0 = x0;
   nx1 = x0 + dx*nNstep;
   GraveOne = local_graveDeviation(nx1, x1, RelTol);
   AdjustedVal = pow2(nx1);
end % switch
nNstep = abs(nNstep);
if GraveOne, mess = 'BIGADJUST';
else, mess = 'SMALLADJUST'; end;

function isGrave=local_graveDeviation(x,nx,RelTol);
isGrave = (abs(pow2(x)-pow2(nx)) > RelTol*pow2(x));