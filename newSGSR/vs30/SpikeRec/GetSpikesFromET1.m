function y=getSpikesFromET1;

% getSpikesFromET1 - reads events from ET1 and stores them in global SPIKES XXXX
% Note: it is important that the events stored in the ET1 end
% with a zero - a dummy call to ET1go after all real spikes
% have been recorded
% ET1report seems to be unreliable - not used anymore

global SPIKES PRPstatus;

% get the events from ET1 and store them in SPIKES.Buffer
counter = SPIKES.counter; % local var might be faster
bufSize = SPIKES.BufSize; % current buffer size; might need upgrade
maxNsubseq = length(SPIKES.SUBSEQ); % current max # subseqs, might need upgrade
for ii=1:inf, % get one event from ET1 and store; when -1 is encountered, a break is made
   spt = s232('ET1read32',1);
   if isequal(spt,0), % new subsequence marker
      SPIKES.ISUBSEQ = SPIKES.ISUBSEQ + 1;
      if SPIKES.ISUBSEQ>maxNsubseq, % allocate more space
         maxNsubseq = local_increaseNsubseq;
      end
      SPIKES.SUBSEQ(SPIKES.ISUBSEQ) = counter; % subseq offset
   elseif isequal(spt,-1), % ET1 buffer exhausted
      break;
   else % real event, store it
      counter = counter + 1;
      % increase buffer size if needed
      if counter>bufSize, bufSize = local_increaseBuffer; end;
      % which block to store the event
      SPIKES.Buffer(counter) = spt;
   end
   % for long recordings: allow interrupts to come through
   if ~rem(ii,100),
      drawnow; % i.e., process Stop Button status
      if PRPstatus.interrupt, 
         PRPstatus.interruptRec = SPIKES.ISUBSEQ;
         break; 
      end;
   end % if rem
end
% store new counter  value in SPIKES
SPIKES.counter = counter;

%---------locals----------
function newBufsize = local_increaseBuffer;
% increases size of SPIKES.Buffer  by one BufStep
global SPIKES
SPIKES.Buffer = [SPIKES.Buffer zeros(1, SPIKES.BufStep)];
SPIKES.BufSize = SPIKES.BufSize + SPIKES.BufStep;
newBufsize = SPIKES.BufSize;

function newMaxSubseq = local_increaseNsubseq
% increases size of SPIKES.SUBSEQ  by 512
global SPIKES;
SPIKES.SUBSEQ = [SPIKES.SUBSEQ zeros(1, 512)];
newMaxSubseq = length(SPIKES.SUBSEQ);
