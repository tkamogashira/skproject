function SMS=FS2SMS(idfSeq,calib);

% FS2SMS - convert FS menu parameters to SMS XXX
% SYNTAX:
% function SMS=FS2SMS();
% XXX: varying the mod freq not the car freq!!

stimname = IDFstimname(idfSeq.stimcntrl.stimtype);
logSweep = isequal(stimname, 'fslog');

if nargin<2, calib = 'none'; end;
if nargin<3, randomize = 0; end;
[chan sc s1 s2 scmn chanNum order] = idfstimfields(idfSeq);

%------------frequencies---------------
% collect carrier frequencies Nx2 matrix (columns are channels)
carFreq = sweep2carFreq(...
   [s1.lofreq s2.lofreq],...
   [s1.deltafreq s2.deltafreq],...
   [s1.hifreq s2.hifreq], logSweep, chan);

% collect modfreqs and depths in row vector ([left right])
modFreq = [s1.modfreq s2.modfreq];
modDepth = [s1.modpercent s2.modpercent];
% check per channel if modulation is needed
DoModulate = [(modFreq.*modDepth)~=0];
% if not, set both modDepth and modFreq to zero
if ~DoModulate,
   modFreq = 0*modFreq;
   modDepth = 0*modDepth;
end
% compute safe samplefreqs and filter indices
highestFreq = [carFreq(:,1) + DoModulate(1)*modFreq(1), ...
      carFreq(:,2) + DoModulate(2)*modFreq(2)];
% pick highest of two channels
highestFreq = max(highestFreq,[],2); % maximum along rows
[samFreq, filterIndex] = safeSampleFreq(highestFreq);
% freq tolerances
carTol = StandardTolerances(carFreq);
modTol = StandardTolerances(modFreq);
% collect freq info in struct var
FREQ = CollectInStruct(carFreq, modFreq, modDepth, DoModulate,...
   samFreq, filterIndex, carTol, modTol);

% ------instructions for stim definition (i.e. conversion to SD struct)
ITDsaving = 0; % no tricks with waveform vs sample delays
LeftConstant = isequal(0,s1.deltafreq);
RightConstant = isequal(0,s2.deltafreq);
ITDchan = 'LEFT';
% collect in struct
SD_INSTR = CollectInStruct(ITDsaving, ...
   LeftConstant, RightConstant, ITDchan);

% ----------durations, phases, and interaural timing-----------
totalITD = 1e3*(s1.delay - s2.delay); % ms->us
modPhase = [0 0]; % 0 deg mod phase = AM
modSphase = [0 0]; % starting phase of modulation
carSphase = [0 0]; % starting phase of carrier
modSphase = [0 0]; % starting phase of modulation
repDur= sc.interval; 
totDur = [0 0]; % will be set by stimeval
burstDur = [s1.duration s2.duration]; 
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
playOrder = CreatePlayorder(Nsubseq, order);
if logSweep, PlotMode = 'log'; 
else, PlotMode = 'linear'; end
plotInfo = CreatePlotInfo('Frequency (Hz)', ...
   carFreq(playOrder, max(1,channelNum(chan))), PlotMode, NaN,'BurstOnly');
PRP = CreatePRPinfo(plotInfo, playOrder);

% ----------global info-----------
GI = CreateGlobalInfo(stimname, calib, carFreq(playOrder,:));
GI.variedParam = 'trueFreq';

SMS = CreateSMSsxm(FREQ, TIMING, PRES, SD_INSTR, PRP, GI, mfilename);
