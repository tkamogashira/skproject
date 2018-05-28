function SMS=NTD2SMS(idfSeq,calib);

% NTD2SMS - convert NTD menu parameters to SMS

if nargin<2, calib = 'none'; end;

% deal idfSeq to different parts
[chan sc s1 s2 scmn chanNum order] = idfStimFields(idfSeq);
% noise character (frozen/running) was hacked in later by RB/MH
noisechar = noiseCharOfIdfseq(idfSeq);
FrozenNoise = isequal(noisechar, 0);

% compute ITDs in exactly the same way as is done in NTD check
AbsTol = 0.01;
ITD = LinSweepChecker(scmn.start_itd, scmn.delta_itd, scmn.end_itd, ...
   1, AbsTol, 'start');
ITD=1e3*ITD(:,1); % ms->us & linsweepchecker always returns Nx2 matrix
ITD_IC = ITD; % ITD expressed in ipsi vs contra (for plotting)
ITD = doubleDelay(ITD); % pos/neg = ipsi/contr leading
ITD = ITD(:,1)-ITD(:,2);
Nitd = length(ITD); % # different ITDs in sequence

% -----------noise parameters---------
% see NSPLcreateIDF for the exotic way some of the following parameters
% are stored in idfSeq
[Flow, Fhigh, Rho, RandomSeed] = extractNewNoiseParams(idfSeq);
% non-calculating call to noise generating function; see
if FrozenNoise, % frozen noise - use GaussNoiseBand
   noiseDur = scmn.duration + max(abs(1e-3*ITD)); % see NTDcheck
   [NoiseParams, MaxSPL] = GaussNoiseBand(Flow, Fhigh, noiseDur, 0, chan, Rho, RandomSeed);
else, % running noise - use initNoiseBuf
   [MaxSPL, NoiseParams] = InitNoiseBuf(Flow, Fhigh, 0, RandomSeed, Rho);
end
samFreq = NoiseParams.Fsample;
samp = 1e6/samFreq; % sample period in us

% ----------durations, phases, and interaural timing-----------
% 1. various
repDur= sc.interval; 
totDur = [0 0]; % will be set by stimeval
burstDur = [1 1]*scmn.duration;
riseDur = [s1.rise s2.rise]; 
fallDur = [s1.fall s2.fall]; 
onset = [0 0]; % will be set by stimeval
% 2. itd-specific stuff
Nhead = [];
% avoid huge numbers of waveforms: ...
% ... realize ITDs by a mixture of sample delays and true waveform delays
samp = 1e6/samFreq;
samITDs = fix(ITD/samp); % ITDs achieved by sample delays
rems= rem(ITD, samp); % remaining, "fractional" ITD
[diffRems ii jj] = unique(rems);
NdiffRems = length(ii);
if (NdiffRems>20) | FrozenNoise, % cut by rounding towards multiples of 5 us
   rems = 5*round(rems*0.2);
   [diffRems ii jj] = unique(rems);
   NdiffRems = length(ii);
end
wavITD = rems;
NwavITD = NdiffRems;
Nhead = [max(0,samITDs) max(0,-samITDs)]; % heading samples to cause extra ITD
totalITD = CollectInStruct(Nhead, wavITD, NwavITD);
% make sure that the bursts (including space for wavITD & heading/trailing zeros) fit in RepDur
maxNhead = max(max(Nhead));
repDur = max(repDur, max(burstDur(:))+1e-3*samp*(2+maxNhead)); % us->ms
% collect timing info in struct
TIMING = CollectInStruct(totalITD, ...
   repDur, totDur, burstDur, riseDur, fallDur, onset);

% ------instructions for stim definition (i.e. conversion to SD struct)
ITDsaving = 1; % tricks with waveform vs sample delays
ITDchan = 'LEFT';
if FrozenNoise, LeftConstant = 0; RightConstant = 1;
else, LeftConstant = 0; RightConstant = 0; % new waveforms for each rep of each subseq
end
% collect in struct
SD_INSTR = CollectInStruct(ITDsaving, LeftConstant, RightConstant, ITDchan);


% -------------------presentation--------------
Nrep = sc.repcount;
SPL = [s1.total_pts s2.total_pts]; % see NTDcreateIDF
% collect in struct
PRES = CollectInStruct(Nrep, SPL, chan);

% ---------PRP info------------
Nsubseq = Nitd;
playOrder = CreatePlayOrder(Nsubseq, order);
plotInfo = createPlotInfo('ITD (ipsi lead) (\mus)', ...
   ITD_IC(playOrder), 'linear', NaN, 'BurstOnly');
PRP = createPRPinfo(plotInfo, playOrder);

% ----------global info-----------
% for spk subseqInfo:
varValuesL = 1e-3*ITD_IC; % in ms; column vector like ITD
if ipsiside=='L', ddd=[0 1]; else, ddd=[1 0]; end;
var1Values = kron(ddd,varValuesL(playOrder));
GlobalInfo = createGlobalInfo('ITD', calib, var1Values);

if FrozenNoise, StimCat = 'noise'; % frozen
else, StimCat = 'rnoise'; % running
end
createdby = mfilename;


SMS = CollectInStruct(StimCat, Nsubseq, NoiseParams, TIMING, PRES, SD_INSTR, PRP, GlobalInfo, createdby);

