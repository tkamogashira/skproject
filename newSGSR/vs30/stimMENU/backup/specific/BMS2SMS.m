function SMS=BMS2SMS(idfSeq,calib);

% BMS2SMS - convert BMS menu parameters to SMS

if ~isequal(idfStimName(idfSeq.stimcntrl.stimtype),'bms'),
   error('not an ''lms'' stimulus type');
end
StimName = upper(idfStimName(idfSeq.stimcntrl.stimtype));

if nargin<2, calib = 'none'; end;

[chan sc s1 s2 scmn chanNum order] = idfStimFields(idfSeq);

%------------frequencies---------------
carFreq = scmn.carrierfreq*[1 1];
% find the modulation frequencies usig the exact same call used in BMScheck
lowMod = scmn.lomodfreq;
stepMod = scmn.deltamodfreq;
highMod = scmn.himodfreq;
RelTol = 5e-1; %
% get modfreqs and depths
modFreq = logSweepChecker(lowMod, stepMod, highMod, chanNum, RelTol, 'start');
modFreq(:,2) = modFreq(:,1) + scmn.beatfreq; 
modDepth = [s1.modpercent s2.modpercent];
DoModulate = [1 1]; 
% compute safe samplefreqs and filter indices
highestFreq = [carFreq(1) + modFreq(:,1), ...
      carFreq(end) + modFreq(:,2)];
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
burstDur = scmn.duration*[1 1];
riseDur = [s1.rise s2.rise]; 
fallDur = [s1.fall s2.fall]; 
totalITD = 0;
onset = [0 0]; % will be set by stimeval
% collect timing info in struct
TIMING = CollectInStruct(totalITD, modPhase, carSphase, modSphase, ...
   repDur, totDur, burstDur, riseDur, fallDur, onset);


% ------instructions for stim definition (i.e. conversion to SD struct)
ITDsaving = 0; % no tricks with waveform vs sample delays
if totalITD>0, ITDchan = 'LEFT'; else, ITDchan = 'RIGHT'; end;
LeftConstant = 0; RightConstant = 0;
% collect in struct
SD_INSTR = CollectInStruct(ITDsaving, ...
   LeftConstant, RightConstant, ITDchan);


% -------------------presentation & levels--------------
Nrep = sc.repcount;
SPL = [s1.spl s2.spl];
Nsubseq = size(modFreq,1);
% collect in struct
PRES = CollectInStruct(Nrep, SPL, Nsubseq, chan);

% ---------PRP info------------
% order: L->R|R->L|random = 0|1|2 
playOrder = CreatePlayOrder(Nsubseq, order);
plotXlabel = 'Left-chan mod. frequency (Hz)'; % default
plotXvalues = modFreq(:,1);
plotInfo = createPlotInfo(plotXlabel, ...
   plotXvalues(playOrder), 'log', NaN, 'BurstOnly');
PRP = createPRPinfo(plotInfo, playOrder);


% ----------global info-----------
% for spk subseqInfo:
var1Values = modFreq(playOrder, :);
GI = createGlobalInfo(StimName, calib, var1Values);


SMS = createSMSsxm(FREQ, TIMING, PRES, SD_INSTR, PRP, GI, mfilename);

