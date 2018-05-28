function SMS=FS2SMS(pp);

% THR2SMS - convert THR menu parameters to SMS XXX
stimname = 'thr';
maxNrepPerRevPair = 20; % max # reps per pair of reversals in case of non-convergence
    
carFreq = repmat([1e3*pi;pp.cfreqs],1,2);  % first pi-Hz subseq is fake for spont rate
% compute safe samplefreqs and filter indices
[samFreq, filterIndex] = safeSamplefreq(carFreq(:,1));
% freq tolerances
carTol = standardTolerances(carFreq);
carTol(1) = 1e3*pi; % first subseq is spont rate
DoModulate = [0 0];
modFreq = [0 0];
modDepth = [0 0]; 
modTol = [0 0]; 
% collect freq info in struct var
FREQ = CollectInStruct(carFreq, modFreq, modDepth, DoModulate,...
   samFreq, filterIndex, carTol, modTol);
% ------instructions for stim definition (i.e. conversion to SD struct)
ITDsaving = 0; % no tricks with waveform vs sample delays
LeftConstant = 0;
RightConstant = 0;
ITDchan = 'LEFT';
% collect in struct
SD_INSTR = CollectInStruct(ITDsaving, LeftConstant, RightConstant, ITDchan);
Nsubseq = size(carFreq,1);

% ----------durations, phases, and interaural timing-----------
totalITD = 1e3*pp.delay; % ms->us
totalITD = totalITD(1) - totalITD(2); % left vs right
modPhase = [0 0]; % 0 deg mod phase = AM
modSphase = [0 0]; % starting phase of modulation
carSphase = [0 0]; % starting phase of carrier
modSphase = [0 0]; % starting phase of modulation
repDur= pp.interval; 
totDur = [0 0]; % will be set by stimeval
burstDur = repmat(pp.burstDur, Nsubseq, 2);
Nspont = max(1,round(pp.silence*1e3/pp.burstDur)); % number of burstdurs contained in spont rate measurement
burstDur(1,:) = pp.burstDur*Nspont; % spontaneous interval; s->ms
riseDur =  pp.riseDur*[1 1] ;
fallDur =  pp.fallDur*[1 1] ;
onset = [0 0]; % will be set by stimeval
% collect timing info in struct
TIMING = CollectInStruct(totalITD, modPhase, carSphase, modSphase, ...
   repDur, totDur, burstDur, riseDur, fallDur, onset);

% -------------------presentation--------------
maxNrep = round(maxNrepPerRevPair*pp.Nrev/2);
Nrep = repmat(maxNrep,Nsubseq,1);  % max # intervals
Nrep(1) = 1; % spontaneous stuff
SPL = repmat(pp.minSPL, Nsubseq, 2);
SPL(1,:) = -400; % silence
chan = channelChar(pp.active);
% collect in struct
PRES = CollectInStruct(Nrep, SPL, Nsubseq, chan);


% ---------PRP info------------
playOrder = [1, 1+CreatePlayOrder(Nsubseq-1, pp.order)]; % spontaneous rate always precedes the rest
PRES.Nrep(playOrder(2)) = PRES.Nrep(playOrder(2)) +10; % allow longer search
PlotMode = pp.stepunit;
minSPL = pp.minSPL;
maxSPL = pp.SPL;
plotInfo = createPlotInfo('Frequency (Hz)', ...
   carFreq(playOrder), PlotMode, NaN,'BurstOnly', '', 'tCurve', 'Ylim', [minSPL maxSPL]);
% tracking stuff
stepSize = pp.stepSize;
startSPL = pp.startSPL;
Nrev = pp.Nrev;
critMode = pp.critMode;
critVal = pp.critVal;
Tracking = CollectInStruct(stepSize, startSPL, minSPL, maxSPL, Nrev, critMode, critVal, Nspont);
Instructor = 'TCurveInstr'; % non-default mlfile for compilation of PRP instructions
PRP = createPRPinfo(plotInfo, playOrder, Tracking, Instructor);

% ----------global info-----------
global CALIB
GI = createGlobalInfo('', CALIB.ERCfile, carFreq(playOrder,:),[],1);
GI = rmfield(GI,'cmenu');
GI.stimName = stimname;
GI.nonPDP11 = 1;
GI.variedParam = 'trueFreq';
GI.StimParams = pp;

SMS = createSMSsxm(FREQ, TIMING, PRES, SD_INSTR, PRP, GI, mfilename);
