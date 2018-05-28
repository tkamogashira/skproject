function y=storeSpikes;

% storeSpikes - reads events from ET1 and stores them in global SPIKES XXXX
% Note: it is important that the events stored in the ET1 end
% with a zero - a dummy call to ET1go after all real spikes
% have been recorded
% ET1report seems to be unreliable - added extra break in case -1 are returned by ET1read32

global SPIKES PRPstatus;

N = s232('ET1report',1); % number of events to read
% NeventsToGet = N
Nlast = SPIKES.counter + N;
% alloc more memory if we run out of buffer
% Note: in-place allocation is inefficient but we hardly expect
% to use it - initial BufSize is quite big.
while SPIKES.BufSize<Nlast,
   SPIKES.Buffer = [SPIKES.Buffer zeros(1, SPIKES.BufStep)];
   SPIKES.BufSize = SPIKES.BufSize + SPIKES.BufStep;
end
% now that we have enough room, get the events from ET1 and
% store them in SPIKES.Buffer
counter = SPIKES.counter; % local var might be faster
for ii = 1:N, % get event from ET1 and store
   spt = s232('ET1read32',1);
   if isequal(spt,0), % new subsequence marker
      SPIKES.ISUBSEQ = SPIKES.ISUBSEQ + 1;
      SPIKES.SUBSEQ(SPIKES.ISUBSEQ) = counter; % subseq offset
   elseif isequal(spt,-1), % nothing to report (bug in TDT ET1report)
      break;
   else % real event, store it
      counter = counter + 1;
      % which block to store the event
      SPIKES.Buffer(counter) = spt;
   end
   % for long recordings: allow interrupts to come through
   if ~rem(ii,100),
      drawnow;
      if PRPstatus.interrupt, 
         PRPstatus.interruptRec = SPIKES.ISUBSEQ;
         break; 
      end;
   end
end
% store new counter  value in SPIKES
SPIKES.counter = counter;
