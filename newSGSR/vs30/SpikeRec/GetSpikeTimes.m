function spt = GetSpikeTimes(iSubseq, SPIKES);

% GetSpikeTimes - returns stored spike times of iSubseq-th subseq
% Syntax: 
% spt = GetSpikeTimes(iSubseq, SPIKES);
% if SPIKES is not specified, the global SPIKES is taken
% Note: spike times are returned in us (according to ET1!) measured 
% from the synch pulse, i.e., including the switch time.
% the synch event itself is not returned

if nargin<2,
   global SPIKES;
end

% ISEQ is incremented on each zero encountered (see storeSpikeTimes).
% Because of the last dummy call to ET1go (at the end of recording;
% see PLayRec) the ISEQ will eventually equal NsubSeqs+1.
if iSubseq<1, spt = []; return; end;;
if iSubseq >= SPIKES.ISUBSEQ, spt = []; return; end;
startCounter = SPIKES.SUBSEQ(iSubseq) + 1; % index of first event = synch pulse
stopCounter = SPIKES.SUBSEQ(iSubseq+1);  % index of last spike
if isnumeric(SPIKES.Buffer),
   spt = SPIKES.Buffer((startCounter+1):stopCounter) ...
      -SPIKES.Buffer(startCounter); % subtract time of sync pulse
elseif isstruct(SPIKES.Buffer),
   qq = decodeSpikeTimes(SPIKES.Buffer);
   spt = qq((startCounter+1):stopCounter) ...
      -qq(startCounter); % subtract time of sync pulse
end
