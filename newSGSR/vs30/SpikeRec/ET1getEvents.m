function [ev, repOK] = ET1getEvents(Dev, ForceStop);

% ET1getEvents - returns all event times in ET1 buffer (zeros included)
% Syntax:
% [ev, repOk] = ET1getEvents(Dev, ForceStop);
% where
%   Dev        device number (default is 1)
% ForceStop    if 1, ET1stop is called prior to reading the buffer (default 0)
%   ev         vector containing event times in order (32 bit values)
%  repOK       0 if ET1report failed to report the correct number of events
% 
% If the ET1 is collecting evenets at the time of the call,
% an error is issued.

if nargin<1, Dev = 1; end;
if nargin<2, ForceStop = 0;  end;

if ForceStop, s232('ET1stop', Dev); end
if s232('ET1active', Dev),
   error('ET1 is active');
end

Nrep = s232('ET1report', Dev);
% don't trust ET1report - it sometimes gives wild numbers
N = min(Nrep,1e5);
ev = zeros(1,N);

t = 0;
count = 0;
for count=1:inf,
   t = s232('ET1read32', Dev);
   if t<0, Nrec = count-1; break; end;
   if count>N, [ev, N] = local_IncreaseBuf(ev,1e3); end;
   ev(count) = t;
end
ev = ev(1:Nrec);
repOK = isequal(Nrep, Nrec);


%----------locals--------------
function [ev, Nnew] = local_IncreaseBuf(ev,Ninc);
ev = [ev zeros(1,Ninc)];
Nnew = length(ev);



