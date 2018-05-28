function SMS=IID2SMS(idfSeq,calib);

% IID2SMS - convert IID menu parameters to SMS
% SYNTAX:
% function SMS=IID2SMS(idfSeq, calib, randomize);

if nargin<2, calib = 'none'; end;

[chan sc s1 s2 scmn chanNum order] = idfStimFields(idfSeq);


%------------frequencies---------------
carFreq = [s1.freq s2.freq];
modFreq = [s2.modfreq s2.modfreq];
modDepth = [s1.modpercent s2.modpercent];
% check per channel if modulation is needed
DoModulate = [(modFreq.*modDepth)~=0];
% collect modfreqs and depths in row vector ([left right])
modFreq = [s1.modfreq s2.modfreq];
modDepth = [s1.modpercent s2.modpercent];
% compute safe samplefreqs and filter indices
highestFreq = [carFreq(:,1) + DoModulate(1)*modFreq(1), ...
      carFreq(:,2) + DoModulate(2)*modFreq(2)];
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
LeftConstant = 1; RightConstant = 1;
% collect in struct
SD_INSTR = CollectInStruct(ITDsaving, ...
   LeftConstant, RightConstant, ITDchan);


% -------------------presentation & levels--------------
Nrep = sc.repcount;
minSPL = 2*scmn.meanspl - scmn.hispl;
SPLcontra = (minSPL:scmn.deltaspl:scmn.hispl).'; % column vector
SPLipsi = SPLcontra(end:-1:1); % column vector
if ipsiside=='L', SPL = [SPLipsi , SPLcontra];
else, SPL = [SPLcontra, SPLipsi];
end
Nsubseq = length(SPLipsi);
% collect in struct
PRES = CollectInStruct(Nrep, SPL, Nsubseq, chan);

% ---------PRP info------------
% order: L->R|R->L|random = 0|1|2 
playOrder = CreatePlayOrder(Nsubseq, order);
% spike plotting: positive IID <-> louder ipsi
IID = SPLipsi-SPLcontra; 
plotInfo = createPlotInfo('IID [ipsi vs contra] (dB)', ...
   IID(playOrder), 'linear', NaN, 'BurstOnly');
PRP = createPRPinfo(plotInfo, playOrder);


% ----------global info-----------
% for spk subseqInfo:
var1Values = SPL(playOrder, :);
GI = createGlobalInfo('IID', calib, var1Values);

% global nonsense
% nonsense = CollectInStruct(FREQ, TIMING, PRES, SD_INSTR, PRP, GI);

SMS = createSMSsxm(FREQ, TIMING, PRES, SD_INSTR, PRP, GI, mfilename);

