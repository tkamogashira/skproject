function PRPsaveSpikes2; 

% function PRPsaveSpikes; 

global SPIKES PRPstatus SMS SESSION


% first find how many *complete* recordings have taken place
Nrecorded = SPIKES.ISUBSEQ-1;
if PRPstatus.interruptRec>0,
   Nrecorded = PRPstatus.interruptRec-1;
end
if Nrecorded<1, 
   if SESSION.requestID,
      % reset counter
      SESSION.iseqPerCell = SESSION.iseqPerCell - 1;
   end
   return; 
end;
% does this represent a "complete" recording?
Ntotal = length(SMS.PRP.playOrder);
SPIKES.recordingComplete = isequal(Nrecorded,Ntotal);
SPIKES.Nrecorded = Nrecorded;
% if collection is incomplete, ask user if he wants to save data 
if PRPstatus.interrupt,
   answer = warnchoice1('Spike Collection interrupted', ...
      '', ...
      '\Data collection was interrupted.\save (incomplete) spike data anyhow?',...
      'Yes','No');
   if isequal(answer,'No'),
      if SESSION.requestID,
         % reset counter
         SESSION.iseqPerCell = SESSION.iseqPerCell - 1;
      end
      return; 
   end;
end

% pick up handle to report activity
mess = ['saving subseqs 1-' num2str(Nrecorded)];
UIinfo(mess);

% find out if PDP11 format must be used
[stimType, stimName] = stimTypeOf(SMS);
[IDstr, oldIDstr] = IDrequest('current');
if isPDP11compatible(SMS),
   % convert to notorious PDP11 format
   [idfSeq spkSeq] = SGSR2PDP(SMS, SPIKES);
   % ...save ....
   PDPaddSeqToFiles(SESSION.dataFile, idfSeq, spkSeq);
   SESSION.iJustRecorded = -abs(SESSION.iSeq);
   % update counting of sequences
   SESSION.iSeq = SESSION.iSeq + 1;
   iseq = SESSION.iSeq;
elseif isequal(stimName,'thr'),  % special case: tuning curves
   SpikeInfo = collectTcurveInfo;
   % SpikeInfo
   iseq = AddToSGSRdataFile(SESSION.dataFile, SpikeInfo);
   SESSION.iJustRecorded = abs(iseq);
   SESSION.SGSRSeqIndex = iseq + 1;
else,
   SpikeInfo = collectSpikeTimes(SMS, SPIKES,1); % compressed storage
   iseq = AddToSGSRdataFile(SESSION.dataFile, SpikeInfo);
   SESSION.iJustRecorded = abs(iseq);
   SESSION.SGSRSeqIndex = iseq + 1;
end

PRPstatus.SpikesSaved = 1;
SESSION.SeqRecorded = [SESSION.SeqRecorded iseq];
recStr = [num2str(Nrecorded) ' of ' num2str(Ntotal) ' subseqs'];
rStr = strvcat([oldIDstr 'saved to file:'], recStr);

UIinfo(rStr,1);
% extraLogLines = {recStr};
if SESSION.requestID,
   newIDstr = [' <' IDstr '> '];
else,
   newIDstr = '';
end
addToLog([ oldIDstr newIDstr ' saved']);

