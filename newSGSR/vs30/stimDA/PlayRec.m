function PlayRec;

% PlayRec - play and record of one sequence

global PRPinstr
% Constants
PlotDelay = 1000; % minimal interval in ms between consecutive plot actions
DurLimit = 500; % minimal total subseq dur in ms for "slow" DAwait
DoPlot = ~isempty(PRPinstr.PLOT);

% pick up some specialized data from PRPstatus
global PRPstatus;
doRec = PRPstatus.DoRecord;
N = length(PRPinstr.PLAY);
try, % stutter option: play only first subseq, do not record
   if isequal(1, PRPstatus.Stuttering),
      N = 1;
      doRec = 0;
   end
end

if doRec,
   % empty ET1 buffer and previously stored spikes
   initSpikeRec; % initializes global SPIKES struct in which events are stored
   % open or refresh plot
   if DoPlot,
      PlotFnc = [PRPinstr.PLOT.PlotType 'Plot'];
      TWS = getfieldOrDef(PRPinstr.PLOT, 'TimeWindowStyle', 'BurstOnly');
      closeStimMenu(feval(PlotFnc, 'init', TWS)); % plot will die with stim menu
   else,
      PlotFnc = 'nop';
   end
   secureET1clear;
end;

% find out if fast or slow DA-waiting should be used
slowWait = zeros(N,1);
for ii=1:N
   subSeqDur(ii) = PRPinstr.PLAY(ii).Nplay*1e-3*PRPinstr.PLAY(ii).SamP; %in ms
   slowWait(ii) = (subSeqDur(ii)>=DurLimit);
end

% initialize report function
ReportProgress('init', subSeqDur);

% play subseqs one by one
StopOnNext = 0; tic;
for ii=0:N; 
   % recording lags re playing: in the ii-th loop, subseq ii+1 (ii<N) is played
   % and subseq ii (ii>0) is recorded.
   if (ii<N), % play the current (=ii+1) sequence if no interrupt has occurred
      StopOnNext = local_DAwait(StopOnNext, slowWait(ii+1));
      if ~StopOnNext, 
         playit(PRPinstr.PLAY(ii+1), doRec); 
         ReportProgress('play', ii+1);
      else,
         ReportProgress('pstop', ii);
         CompleteStop2;
      end;
   else, % Last play has been started - wait until D/A is finished and stop recording
      local_DAwait(StopOnNext, 1);
      ReportProgress('pfinish');
      if doRec,
         PRPsetButtons('stopping');
         et1go; % generate trailing zero in ET1's FIFO buffer
         et1stop;
      end;
   end;
   if doRec, % record spikes of ii-the subseq
      if ii>0, 
         ReportProgress('record', ii); 
         GetSpikesFromET1; % spikes of ii-th sequence are now complete
         feval(PlotFnc, ii);
         StopOnNext = PRPstatus.interrupt;
      else, % playing the first subseq: start recording ...
         % ... right away and don't stop until D/A is over (unless interrupted by user)
         ReportProgress('record', ii+1); 
         while ~PRPstatus.interrupt & s232('PD1status',1),
            GetSpikesFromET1;
            drawnow; % allow callbacks to interfere
         end
         StopOnNext = PRPstatus.interrupt;
      end;
   end % if DoRec
   if StopOnNext,
      if doRec, ReportProgress('rstop', max(1,ii)); end;
      CompleteStop2;
      break; % from play/rec loop
   end;
   % update plot and query interrupt if due
	if (toc>1e-3*PlotDelay) | (ii==0),
      if doRec, 
         feval(PlotFnc, 'draw'); 
      end;
		drawnow; tic;
      if PRPstatus.interrupt, StopOnNext = 1; drawnow; end
 	end
end; % for ii

if doRec & (~StopOnNext),
   ReportProgress('rfinish'); drawnow;
end;

if doRec,
   minimizeSpikes; % reduce size of global SPIKES to  just fit the data
   feval(PlotFnc, 'finish'); 
end

% locals----------------------------------------------------------------


function DoStop = local_DAwait(DoStop, Slow);
global PRPstatus;
if DoStop, return; end
NwaitLoop = 100;
while (s232('PD1status',1)~=0),
   for iwait=1:NwaitLoop,
      if (s232('PD1status',1)==0), break; end;
   end%for
   if Slow,
      drawnow;
      DoStop = DoStop | PRPstatus.interrupt;
   end
end;%while


