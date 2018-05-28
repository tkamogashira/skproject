function SMS=NSPL2SMS(idfSeq,calib);

% NSPL2SMS - convert NSPL menu parameters to SMS

if nargin<2, calib = 'none'; end;

% deal idfSeq to different parts
[chan sc s1 s2 scmn chanNum order] = idfstimfields(idfSeq);
% noise character (frozen/running) was hacked in later by RB
noisechar = NoiseCharOfIDFseq(idfSeq);
FrozenNoise = isequal(noisechar, 0);

% see NSPLcreateIDF for the exotic way some of the following parameters
% are stored in idfSeq
[Flow, Fhigh, Rho, RandomSeed, startSPL, endSPL, stepSPL, noiseSign] = extractNewNoiseParams(idfSeq);

% get SPLs from 'improper' fields of IdfSeq (see NSPLcreateIDF)
[SPL MESS] = sweepchecker(startSPL, stepSPL, endSPL, chanNum);
if size(SPL,2)==1, SPL = [SPL SPL]; end
Nsubseq = size(SPL,1); % # different SPLs in sequence

% -----------noise parameters---------
Delay = [s1.delay s2.delay];
% non-calculating call to the same noise-generating procedures that was
% ... used in NSPLcheck
if FrozenNoise, % frozen noise - use GaussNoiseBand
   noiseDur = max(s1.duration, s2.duration) + max(abs(Delay));
   [NoiseParams, MaxSPL] = GaussNoiseBand(Flow, Fhigh, noiseDur, 0, chan, Rho, RandomSeed, noiseSign);
else, % running noise - use initNoiseBuf
   [MaxSPL, NoiseParams] = InitNoiseBuf(Flow, Fhigh, 0, RandomSeed, Rho);
end
samFreq = NoiseParams.Fsample;
samp = 1e6/samFreq; % sample period in us
% ----------durations, phases, and interaural timing-----------
% 1. various
repDur= sc.interval; 
totDur = [0 0]; % will be set by stimeval
burstDur = [s1.duration, s2.duration];
riseDur = [s1.rise s2.rise]; 
fallDur = [s1.fall s2.fall]; 
onset = [0 0]; % will be set by stimeval
% 2. itd-specific stuff
Nhead = 0; % no sample delays needed - ITD is constant
wavITD = (s1.delay - s2.delay)*1e3; % in us; positive ~ left lags right by definition
NwavITD = 1;
totalITD = CollectInStruct(Nhead, wavITD, NwavITD);
% make sure that the bursts (including space for wavITD & heading/trailing zeros) fit in RepDur
maxNhead = max(max(Nhead));
repDur = max(repDur, max(burstDur(:))+1e-3*samp*(2+maxNhead)); % us->ms
% collect timing info in struct
TIMING = CollectInStruct(totalITD, ...
   repDur, totDur, burstDur, riseDur, fallDur, onset);

% ------instructions for stim definition (i.e. conversion to SD struct)
ITDsaving = 0; % no tricks with waveform vs sample delays
ITDchan = 'LEFT';
if FrozenNoise, LeftConstant = 1; RightConstant = 1;
else, LeftConstant = 0; RightConstant = 0;
end
% collect in struct
SD_INSTR = CollectInStruct(ITDsaving, ...
   LeftConstant, RightConstant, ITDchan);


% -------------------presentation--------------
Nrep = sc.repcount;
% collect in struct (SPL was computed above)
PRES = CollectInStruct(Nrep, SPL, chan);

% ---------PRP info------------
% order: L->R|R->L|random = 0|1|2 
playOrder = CreatePlayorder(Nsubseq, order);
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
plotInfo = CreatePlotInfo(plotXlabel, ...
   plotXvalues(playOrder), 'linear', NaN, 'BurstOnly',...
   '','spikeRate', 'grid', 'on');   
PRP = CreatePRPinfo(plotInfo, playOrder);


% ----------global info-----------
% for spk subseqInfo:
% conventionally, attenuation is stored in IDF/SPK files of NSPL
% varValuesL = 
varValuesL = s1.hiattn - SPL(:,1)+ SPL(1,1); % in dB; column vector like SPL
varValuesR = s2.hiattn - SPL(:,2)+ SPL(1,2); % in dB; column vector like SPL
var1Values = [varValuesL(playOrder), varValuesR(playOrder)];
GlobalInfo = CreateGlobalInfo('NSPL', calib, var1Values);

% stimulus category depends on frozen/running noise character
if FrozenNoise, StimCat = 'noise'; % frozen
else, StimCat = 'rnoise'; % running
end
createdby = mfilename;


SMS = CollectInStruct(StimCat, Nsubseq, NoiseParams, TIMING, PRES, SD_INSTR, PRP, GlobalInfo, createdby);

