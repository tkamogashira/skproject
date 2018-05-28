function SMS=BFS2SMS(idfSeq,calib);

% BFS2SMS - convert BFS menu parameters to SMS XXX
% SYNTAX:
% function SMS=BFS2SMS();

if ~isequal(idfStimName(idfSeq.stimcntrl.stimtype), 'bfs'),
   error('not an ''bfs'' stimulus type');
end
if nargin<2, calib = 'none'; end;
if nargin<3, randomize = 0; end;

[chan sc s1 s2 scmn chanNum order] = idfStimFields(idfSeq);

%------------frequencies---------------
% collect carrier frequencies Nx2 matrix (columns are channels)
carFreq = sweep2carFreq(scmn.lofreq, scmn.deltafreq, scmn.hifreq);
Nsubseq = size(carFreq,1);
beatFreq = scmn.beatfreq;
% beat freq is freqRight-freqLeft by definition
% car freq is left-chan freq by def
carFreq(:,2) = carFreq(:,2) + beatFreq;
[sampleFreq filterIndex] = safeSampleFreq(max(carFreq.')'); % max over left/right
% no modulation
modFreq = [0 0]; modDepth = [0 0];
DoModulate = [0 0];
% compute safe samplefreqs and filter indices
highestFreq = [carFreq(:,1) + DoModulate(1)*modFreq(1), ...
      carFreq(:,2) + DoModulate(2)*modFreq(2)];
% pick highest of two channels
highestFreq = max(highestFreq,[],2); % maximum along rows
[samFreq, filterIndex] = safeSamplefreq(highestFreq);
% tolerances of frequency  deviations
MaxBeatDrift = 0.02; % max error in # cycles of beat freq ..
% .. over the duration of the burst
carTol = 0*carFreq-0.5*MaxBeatDrift; % see evalCyclicStorage
modTol = standardTolerances(modFreq);
% collect freq info in struct var
FREQ = CollectInStruct(carFreq, modFreq, modDepth, DoModulate,...
   samFreq, filterIndex, carTol, modTol);

% ------instructions for stim definition (i.e. conversion to SD struct)
ITDsaving = 0; % no tricks with waveform vs sample delays
LeftConstant = isequal(0,scmn.deltafreq);
RightConstant = LeftConstant;
ITDchan = 'LEFT';
% collect in struct
SD_INSTR = CollectInStruct(ITDsaving, ...
   LeftConstant, RightConstant, ITDchan);


% ----------durations, phases, and interaural timing-----------
totalITD = 0;
modPhase = [0 0]; % 0 deg mod phase = AM
modSphase = [0 0]; % starting phase of modulation
carSphase = [0 0]; % starting phase of carrier
modSphase = [0 0]; % starting phase of modulation
repDur= sc.interval; 
totDur = [0 0]; % will be set by stimeval
burstDur = [scmn.duration scmn.duration]; 
riseDur = [s1.rise s2.rise]; 
fallDur = [s1.fall s2.fall]; 
onset = [0 0]; % will be set by stimeval
% collect timing info in struct
TIMING = CollectInStruct(totalITD, modPhase, carSphase, modSphase, ...
   repDur, totDur, burstDur, riseDur, fallDur, onset);

% -------------------presentation--------------
Nrep = sc.repcount;
SPL = [s1.spl s2.spl];
Nsubseq = size(carFreq,1);
% collect in struct
PRES = CollectInStruct(Nrep, SPL, Nsubseq, chan);

% ---------PRP info------------
playOrder = CreatePlayOrder(Nsubseq, order);
plotInfo = createPlotInfo('Frequency (Hz)', ...
   carFreq(playOrder,1), 'linear', NaN,'BurstOnly');
PRP = createPRPinfo(plotInfo, playOrder);

% global info
GI = createGlobalInfo('BFS', calib, carFreq(playOrder,:));
GI.variedParam = 'trueFreq';

SMS = createSMSsxm(FREQ, TIMING, PRES, SD_INSTR, PRP, GI, mfilename);

