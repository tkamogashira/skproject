function y = InitSpikeRec;

% InitSpikeRec - initialize data structure for storing spikes
% uses global PRPinstr

global SPIKES PRPinstr SGSR

BufSize = 4096; % initial buffer size size to store incoming spikes
MaxNSubseq = 512; % max number of subsequences in one sequence

SPIKES = []; % delete previous version

SPIKES.counter = 0; % zero spikes recorded
SPIKES.SUBSEQ = zeros(1, MaxNSubseq); % holds indices that ...
                % indicate start of subsequence
SPIKES.ISUBSEQ = 0; % current subsequence
SPIKES.Buffer = zeros(1, BufSize) ;
SPIKES.BufSize = BufSize;
SPIKES.BufStep = BufSize; % stepsize for buffer enlargement
% get recording info from PRPinstr so that SPIKES contains
% all info relevant for storing spike times
if ~isempty(PRPinstr),
   SPIKES.RECORDinfo = PRPinstr.RECORD; % struct array; ith element is
   % ... info on subseq i (counted in playing order)
   % recording status info
end
SPIKES.ClockRatio = SGSR.ClockRatio;
SPIKES.recordingComplete = 0;
SPIKES.Nrecorded = 0;
% sign
SPIKES.createdby = mfilename;








