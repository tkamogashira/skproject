function [allValues, mess] = ...
   sweepchecker(startVal, stepVal, endVal, ActiveChan, dualSweep);

if nargin<5, dualSweep=1; end;

allValues = [];
mess = '';

if ActiveChan==0, Channels = [1,2];
elseif ActiveChan==1, Channels = 1;
else, Channels = 2; end

if dualSweep,
   startVal = local_dup(startVal);
   stepVal = local_dup(stepVal);
   endVal = local_dup(endVal);
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
         mess = 'BADSTEP';
         return;
      end
   end
end
% check if different number of steps are needed in the two channels
if all(Nstep~=0) & (Nstep(1)~=Nstep(end)),
   mess = 'DIFF#STEPS';
   return;
end
% the # steps equals the maximum of the two channels
Nstep = max(Nstep);
% compute the values
Left = linspace(startVal(1),endVal(1),Nstep+1);
Right = linspace(startVal(end),endVal(end),Nstep+1);
allValues = [Left.' Right.'];
if ~dualSweep,
   allValues = allValues(:,Channels);
end


%-----------------locals --------------
function y = local_dup(x);
% changes single valued variable into a double-valued one
if length(x)==1, y = [x x];
else, y = x;
end
