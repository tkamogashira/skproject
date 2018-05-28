function SMS=SPL2SMS(idfSeq,calib)

% SPL2SMS - convert SPL menu parameters to SMS
StimName = upper(IDFstimname(idfSeq.stimcntrl.stimtype));

if nargin<2
    calib = 'none';
end

[chan sc s1 s2 scmn chanNum order] = idfstimfields(idfSeq);

%------------frequencies---------------
carFreq = [s1.freq s2.freq];
modFreq = [s2.modfreq s2.modfreq];
modDepth = [s1.modpercent s2.modpercent];
% check per channel if modulation is needed
DoModulate = (modFreq.*modDepth)~=0;
% collect modfreqs and depths in row vector ([left right])
modFreq = [s1.modfreq s2.modfreq];
modDepth = [s1.modpercent s2.modpercent];
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


% ----------durations, phases, and interaural timing-----------
% 1. various
repDur= sc.interval; 
modPhase = [0 0]; % 0 deg mod phase = AM
modSphase = 0*[0.75 0.75]; % starting phase of modulation in CYCLES (0.75: sine phase modulator)
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
if totalITD>0
    ITDchan = 'LEFT';
else
    ITDchan = 'RIGHT';
end
LeftConstant = 1; RightConstant = 1;
% collect in struct
SD_INSTR = CollectInStruct(ITDsaving, ...
   LeftConstant, RightConstant, ITDchan);


% -------------------presentation & levels--------------
Nrep = sc.repcount;
% sweepchecker call below is also used by SPLcheck -> consistency
startSPL = [s1.lospl s2.lospl];
stepSPL = [s1.deltaspl s2.deltaspl];
endSPL = [s1.hispl s2.hispl];
SPL = sweepchecker(startSPL, stepSPL, endSPL, chanNum); 
Nsubseq = size(SPL,1);
% collect in struct
PRES = CollectInStruct(Nrep, SPL, Nsubseq, chan);

% ---------PRP info------------
playOrder = CreatePlayorder(Nsubseq, order);
plotXlabel = 'Level (dB SPL)'; % default
if chanNum~=0, % single active channel
   plotXvalues = SPL(:,chanNum);
else % both channels are active; pick most interesting one
   if isequal(SPL(:,1), SPL(:,2))
       plotXvalues = SPL(:,1);
   elseif length(unique(SPL(:,1)))==1
       plotXvalues = SPL(:,2);
   elseif length(unique(SPL(:,2)))==1
       plotXvalues = SPL(:,1);
   else % both are nontrivial but different: pick left chan but tell so
      plotXvalues = SPL(:,1);
      plotXlabel = 'Left-channel Level (dB SPL)';
   end
end
plotInfo = CreatePlotInfo(plotXlabel, ...
   plotXvalues(playOrder), 'linear', NaN, 'BurstOnly',...
   '','spikeRate', 'grid', 'on');
PRP = CreatePRPinfo(plotInfo, playOrder);

% ----------global info-----------
% for spk subseqInfo:
var1Values = SPL(playOrder, :);
GI = CreateGlobalInfo(StimName, calib, var1Values);

% global nonsense
% nonsense = CollectInStruct(FREQ, TIMING, PRES, SD_INSTR, PRP, GI);

SMS = CreateSMSsxm(FREQ, TIMING, PRES, SD_INSTR, PRP, GI, mfilename);
