function stimcntrl = CreateStimCntrl(stimtype, iSeq, ...
   caChan, activeChan, limitChan,  SPLlimitChan, ...
   interval, repcount);
% fills stimcntrl struct. SPLlimitchan is ignored (set equal to
% limitChan) UNLESS SPLlimitchan is negative (see code).

if SPLlimitChan<0, SPLlimitChan= round(-SPLlimitChan); % use -0.1  for 0, etc
else SPLlimitChan = limitChan;
end

stimcntrl.complete=0; % recording complete
stimcntrl.stimtype=stimtype;
stimcntrl.seqnum=iSeq;
stimcntrl.max_subseq=0; % # subseqs recorded 
stimcntrl.contrachan=caChan;
stimcntrl.activechan=activeChan;
stimcntrl.limitchan=limitChan;
stimcntrl.spllimitchan=SPLlimitChan;
stimcntrl.interval=interval;
stimcntrl.repcount=repcount;
stimcntrl.dsid = '----------';
stimcntrl.spl_loops=1; 
stimcntrl.DUR2delay=[0 0];
dd=round(datevec(now)); stimcntrl.today=dd([3 2 1 4 5 6]);
stimcntrl.tape_ctl.block=[8 0 0 0 0 0 0 0];
   