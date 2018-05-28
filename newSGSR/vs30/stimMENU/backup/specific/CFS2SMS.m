function SMS=CFS2SMS(idfSeq,calib);

% CFS2SMS - convert CFS menu parameters to SMS XXX
% SYNTAX:
% function SMS=CFS2SMS();
% XXX: varying the mod freq not the car freq!!
stimname = idfStimName(idfSeq.stimcntrl.stimtype);
StimCat = 'click';
if ~isequal(stimname,'cfs') ,
   error('not an ''cfs'' stimulus type');
end

if nargin<2, calib = 'none'; end;
if nargin<3, randomize = 0; end;
[chan sc s1 s2 scmn chanNum order] = idfStimFields(idfSeq);

%------------frequencies---------------
logSweep = abs(rem(1e6*s1.click_dur,1))>0.4; % see CFScreateIDF
% collect carrier frequencies Nx2 matrix (columns are channels)
pulseFreq = sweep2carFreq(...
   [s1.lofreq s2.lofreq],...
   [s1.deltafreq s2.deltafreq],...  
   [s1.hifreq s2.hifreq], logSweep ,chan);
Nsubseq = size(pulseFreq,1);

% compute safe samplefreqs and filter indices
[samFreq, filterIndex] = safeSamplefreq(maxStimFreq); % highest sample rate available
samp = 1e6/samFreq;
% freq tolerances
carTol = -5e-4; % max cumulative phase error in cycles over total burst duration
% collect freq info in struct var
FREQ = CollectInStruct(pulseFreq, samFreq, filterIndex, carTol);

% ------instructions for stim definition (i.e. conversion to SD struct)
ITDsaving = 0; % no tricks with waveform vs sample delays
LeftConstant = isequal(0,s1.deltafreq);
RightConstant = isequal(0,s2.deltafreq);
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

% -------------------presentation--------------
Nrep = sc.repcount;
SPL = [s1.spl s2.spl];
% collect in struct
PRES = CollectInStruct(Nrep, SPL, Nsubseq, chan);


% ---------PRP info------------
playOrder = CreatePlayOrder(Nsubseq, order);
if logSweep, PlotMode = 'log'; 
else, PlotMode = 'linear'; end
plotInfo = createPlotInfo('Frequency (Hz)', ...
   pulseFreq(playOrder), PlotMode, NaN,'BurstOnly');
PRP = createPRPinfo(plotInfo, playOrder);

% ----------global info-----------
GlobalInfo = createGlobalInfo('FS', calib, pulseFreq(playOrder,:));
GlobalInfo.variedParam = 'trueFreq';

createdby = mfilename;
SMS = CollectInStruct(StimCat, Nsubseq, FREQ, TIMING, PRES, SD_INSTR, PRP, GlobalInfo, createdby);
