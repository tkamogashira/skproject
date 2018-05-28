function SMS=BB2SMS(idfSeq,calib);

% BB2SMS - convert BB menu parameters to SMS

StimName = upper(idfStimName(idfSeq.stimcntrl.stimtype));

if nargin<2, calib = 'none'; end;

[chan sc s1 s2 scmn chanNum order] = idfStimFields(idfSeq);



%------------frequencies---------------
% find out exact frequencies per channel using the local fncts in BBcheck
[dummy beatFreqs] = ...
   BBcheck('local_BeatFreqs',scmn.lobeatfreq, ...
   scmn.deltabeatfreq, scmn.hibeatfreq, sc.activechan);
Nsubseq = size(beatFreqs,1);
[dummy carFreq, modFreq] ...
   = BBcheck('local_CarFreqs', scmn.carrierfreq, scmn.modfreq, beatFreqs, ...
   scmn.beatonmod, scmn.var_chan);
modDepth = [s1.modpercent s2.modpercent];
DoModulate = (modDepth.*scmn.modfreq~=0);
% compute safe samplefreqs and filter indices
highestFreq = [carFreq(1) + modFreq(:,1), ...
      carFreq(2) + modFreq(:,2)];
% pick highest of two channels
highestFreq = max(highestFreq,[],2); % maximum along rows
[samFreq, filterIndex] = safeSamplefreq(highestFreq);
% freq tolerances
carTol = standardTolerances(carFreq);
modTol = standardTolerances(modFreq);
% collect freq info in struct var
FREQ = CollectInStruct(carFreq, modFreq, modDepth, DoModulate,...
   samFreq, filterIndex, carTol, modTol);


% ----------durations, phases, and interaural timing-----------
% 1. various
repDur= sc.interval; 
modPhase = [0 0]; % 0 deg mod phase = AM
modSphase = [0 0]; % starting phase of modulation
carSphase = [0 0]; % starting phase of carrier
totDur = [0 0]; % will be set by stimeval
burstDur = [1 1]*scmn.duration;
riseDur = [s1.rise s2.rise]; 
fallDur = [s1.fall s2.fall]; 
totalITD = 0;
onset = [0 0]; % will be set by stimeval
% collect timing info in struct
TIMING = CollectInStruct(totalITD, modPhase, carSphase, modSphase, ...
   repDur, totDur, burstDur, riseDur, fallDur, onset);

% ------instructions for stim definition (i.e. conversion to SD struct)
ITDsaving = 0; % no tricks with waveform vs sample delays
ITDchan = 'LEFT';
LeftConstant = (scmn.deltabeatfreq==0); 
RightConstant = LeftConstant;
% collect in struct
SD_INSTR = CollectInStruct(ITDsaving, LeftConstant, RightConstant, ITDchan);

% -------------------presentation & levels--------------
Nrep = sc.repcount;
SPL = [s1.spl s2.spl];
% collect in struct
PRES = CollectInStruct(Nrep, SPL, Nsubseq, chan);

% ---------PRP info------------
% order: L->R|R->L|random = 0|1|2 
playOrder = CreatePlayOrder(Nsubseq, order);
plotXlabel = 'Beat frequency (Hz)'; % default
plotInfo = createPlotInfo(plotXlabel, ...
   beatFreqs(playOrder), 'lin', NaN, 'BurstOnly');
PRP = createPRPinfo(plotInfo, playOrder);


% ----------global info-----------
% for spk subseqInfo:
var1Values = repmat(beatFreqs(playOrder),1,2);
GI = createGlobalInfo(StimName, calib, var1Values);

% global nonsense
% nonsense = CollectInStruct(FREQ, TIMING, PRES, SD_INSTR, PRP, GI);

SMS = createSMSsxm(FREQ, TIMING, PRES, SD_INSTR, PRP, GI, mfilename);

