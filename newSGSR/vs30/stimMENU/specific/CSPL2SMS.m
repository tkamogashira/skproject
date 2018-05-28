function SMS=CSPL2SMS(idfSeq,calib);

% CFS2SMS - convert CSPL menu parameters to SMS XXX
% SYNTAX:
% function SMS=CSPL2SMS();
% XXX: varying the mod freq not the car freq!!
stimname = idfStimName(idfSeq.stimcntrl.stimtype);
StimCat = 'click';

if nargin<2, calib = 'none'; end;
[chan sc s1 s2 scmn chanNum order] = idfStimFields(idfSeq);

% -------------------presentation, SPL--------------
Nrep = sc.repcount;
maxSPL = 120;
startSPL = maxSPL - [s1.hiattn s2.hiattn ];
endSPL = maxSPL - [s1.loattn s2.loattn ];
stepSPL = abs([s1.deltaattn s2.deltaattn ]);
SPL = sweepchecker(startSPL, stepSPL, endSPL, sc.activechan);
Nsubseq = size(SPL,1);
% collect in struct
PRES = CollectInStruct(Nrep, SPL, Nsubseq, chan);

%------------frequencies---------------
pulseFreq = [s1.freq s2.freq];
% compute safe samplefreqs and filter indices
[samFreq, filterIndex] = safeSamplefreq(maxStimFreq); % highest sample rate available
samp = 1e6/samFreq;
% freq tolerances
carTol = -5e-4; % max cumulative phase error in cycles over total burst duration
% collect freq info in struct var
FREQ = CollectInStruct(pulseFreq, samFreq, filterIndex, carTol);

% ------instructions for stim definition (i.e. conversion to SD struct)
ITDsaving = 0; % no tricks with waveform vs sample delays
LeftConstant = isequal(0,s1.deltaattn);
RightConstant = isequal(0,s2.deltaattn);
ITDchan = 'LEFT';
% collect in struct
SD_INSTR = CollectInStruct(ITDsaving, ...
   LeftConstant, RightConstant, ITDchan);

% ----------durations, phases, and interaural timing-----------
ITD = 1e3*(s1.delay - s2.delay); % ms->us
ITDset = 0;
ITDindex = repmat(1,Nsubseq,1);
Nhead = round(ITD/samp);
Nhead = [max(Nhead,0), max(-Nhead,0)];
totalITD = struct(...
   'ITDset', ITDset, ...
   'ITDindex', ITDindex,...
   'Nhead', Nhead...
   );

repDur= sc.interval; 
totDur = [0 0]; % will be set by stimeval
burstDur = [s1.burst_duration s2.burst_duration]; 
clickDur = [s1.click_dur s2.click_dur]; 
clickType = 2*scmn.polarity-1;
onset = [0 0]; % will be set by stimeval
% collect timing info in struct
TIMING = CollectInStruct(totalITD, repDur, totDur, burstDur, clickDur, clickType, onset);



% ---------PRP info------------
% order: L->R|R->L|random = 0|1|2 
playOrder = CreatePlayOrder(Nsubseq, order);
plotXlabel = 'Level (dB SPL)'; % default
if chanNum~=0, % single active channel
   plotXvalues = SPL(:,chanNum);
else, % both channels are active; pick most interesting one
   if isequal(SPL(:,1), SPL(:,2)), plotXvalues = SPL(:,1);
   elseif length(unique(SPL(:,1)))==1, plotXvalues = SPL(:,2);
   elseif length(unique(SPL(:,2)))==1, plotXvalues = SPL(:,1);
   else, % both are nontrivial but different: pick left chan but tell so
      plotXvalues = SPL(:,1);
      plotXlabel = 'Left-channel Level (dB SPL)';
   end
end
plotInfo = createPlotInfo(plotXlabel, ...
   plotXvalues(playOrder), 'linear', NaN, 'BurstOnly',...
   '','spikeRate', 'grid', 'on');   
PRP = createPRPinfo(plotInfo, playOrder);

% ----------global info-----------
GlobalInfo = createGlobalInfo('CSPL', calib, SPL(playOrder,:));
GlobalInfo.variedParam = 'SPL';

createdby = mfilename;
SMS = CollectInStruct(StimCat, Nsubseq, FREQ, TIMING, PRES, SD_INSTR, PRP, GlobalInfo, createdby);
