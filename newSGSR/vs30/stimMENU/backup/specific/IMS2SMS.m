function SMS=IMS2SMS(idfSeq,calib);

% IMS2SMS - convert IMS menu parameters to SMS
% SYNTAX:
% function SMS=IMS2SMS(idfSeq, calib, order);

StimName = upper(idfStimName(idfSeq.stimcntrl.stimtype));

if nargin<2, calib = 'none'; end;

[chan sc s1 s2 scmn chanNum order] = idfStimFields(idfSeq);


%------------frequencies---------------
carFreq = [s1.carrierfreq s2.carrierfreq];
% find the modulation frequencies usig the exact same call used in LMScheck
lowMod = [s1.lomodfreq, s2.lomodfreq];
stepMod = [s1.deltamodfreq, s2.deltamodfreq];
highMod = [s1.himodfreq, s2.himodfreq];
AbsTol = 1; 
% get modfreqs and depths
modFreq = linSweepChecker(lowMod, stepMod, highMod, chanNum, AbsTol, 'start');
modDepth = [s1.modpercent s2.modpercent];
DoModulate = [1 1]; 
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
burstDur = [s1.duration s2.duration];
riseDur = [s1.rise s2.rise]; 
fallDur = [s1.fall s2.fall]; 
totalITD = 1e3*(s1.delay - s2.delay);
onset = [0 0]; % will be set by stimeval
% collect timing info in struct
TIMING = CollectInStruct(totalITD, modPhase, carSphase, modSphase, ...
   repDur, totDur, burstDur, riseDur, fallDur, onset);


% ------instructions for stim definition (i.e. conversion to SD struct)
ITDsaving = 0; % no tricks with waveform vs sample delays
if totalITD>0, ITDchan = 'LEFT'; else, ITDchan = 'RIGHT'; end;
LeftConstant = (s1.deltamodfreq==0); 
RightConstant = (s2.deltamodfreq==0); 
% collect in struct
SD_INSTR = CollectInStruct(ITDsaving, ...
   LeftConstant, RightConstant, ITDchan);


% -------------------presentation & levels--------------
Nrep = sc.repcount;
SPL = [s1.hispl s2.hispl]; % level-sweep option is not used, so take single SPL
Nsubseq = size(modFreq,1);
% collect in struct
PRES = CollectInStruct(Nrep, SPL, Nsubseq, chan);

% ---------PRP info------------
% order: L->R|R->L|random = 0|1|2 
playOrder = CreatePlayOrder(Nsubseq, order);
plotXlabel = 'Modulation frequency (Hz)'; % default
if chanNum~=0, % single active channel
   plotXvalues = modFreq(:,chanNum);
else, % both channels are active; pick most interesting one
   if isequal(modFreq(:,1), modFreq(:,2)), plotXvalues = modFreq(:,1);
   elseif length(unique(modFreq(:,1)))==1, plotXvalues = modFreq(:,2);
   elseif length(unique(modFreq(:,2)))==1, plotXvalues = modFreq(:,1);
   else, % both are nontrivial but different: pick left chan but tell so
      plotXvalues = modFreq(:,1);
      plotXlabel = 'Left-channel mod. frequency (Hz)';
   end
end
plotInfo = createPlotInfo(plotXlabel, ...
   plotXvalues(playOrder), 'linear', NaN, 'BurstOnly');
PRP = createPRPinfo(plotInfo, playOrder);


% ----------global info-----------
% for spk subseqInfo:
var1Values = modFreq(playOrder, :);
var2Values = repmat(SPL,Nsubseq,1);
GI = createGlobalInfo(StimName, calib, var1Values, var2Values);

% global nonsense
% nonsense = CollectInStruct(FREQ, TIMING, PRES, SD_INSTR, PRP, GI);

SMS = createSMSsxm(FREQ, TIMING, PRES, SD_INSTR, PRP, GI, mfilename);

