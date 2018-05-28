function N = TCspikeCount(acceptWindow, maxCount);
% TCspikeCount - fast spike counter for tuning curves
%   empties buffer after counting acceptible spikes
%   acceptance window must be given in "ET1 microseconds"

if nargin<2, maxCount = inf; end; % no upper limit for spike count

low = acceptWindow(1);
high = acceptWindow(2);
M = et1report;
N = 0;
if M==0, return; end;
for istamp=1:M,
   stamp = s232('ET1read32',1);
   if stamp==-1, return; end; % empty buffer
   if stamp>high, % ready
      et1drop; % clear all events collected since the last one
      return;
   end
   if (stamp>low), % within window - count
      N = N + 1;
      if N>=maxCount, return; end;
   end
end

