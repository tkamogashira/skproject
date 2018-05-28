function SMS=ITD2SMS(idfSeq,calib);

% ITD2SMS - convert ITD menu parameters to SMS
% Source: e-mail RB, 30/6/1999

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
burstDur = [1 1]*scmn.duration;
riseDur = [s1.rise s2.rise]; 
fallDur = [s1.fall s2.fall]; 
onset = [0 0]; % will be set by stimeval
% 2. itd-specific stuff
if scmn.delayonmod, OneCycle = 1e3/modFreq(1); % duration of one mod cycle in ms
else, OneCycle = 1e3/carFreq(1); % duration of one car cycle in ms
end
maxITD = 1e3*OneCycle * scmn.numcycles; % in us
Nitd = 1 + 2 * scmn.numcycles * scmn.incr_per_cycle; % # itds
ITD = -linspace(-maxITD,maxITD,Nitd).'; % column vector
Nhead = [];
if scmn.phasecomp,
   carPhaseComp = ITD*1e-6*carFreq;   % us -> cyc
   modPhaseComp = ITD*1e-6*modFreq;   % us -> cyc
   carSphase = kron(carPhaseComp, [1 0]); % realize in left channel; ...
   modSphase = kron(modPhaseComp, [1 0]); % ... right channel is constant
   totalITD = ITD;
else, % avoid huge numbers of waveforms
   samp = 1e6/samFreq;
   samITDs = fix(ITD/samp); % ITDs achieved by sample delays
   rems= rem(ITD, samp); % remaining, "fractional" ITD
   [diffRems ii jj] = unique(rems);
   NdiffRems = length(ii);
   if NdiffRems>20, % cut by rounding towards multiples of 5 us
      rems = 5*round(rems*0.2);
      [diffRems ii jj] = unique(rems);
      NdiffRems = length(ii);
   end
   ITDset = diffRems; % set of waveform-ITDs
   ITDindex = jj; % index in set of nth subseq
   Nhead = [max(0,samITDs) max(0,-samITDs)]; % heading samples to cause extra ITD
   maxNhead = max(max(Nhead));
   repDur = max(repDur, max(burstDur(:))+1e-3*samp*(1+maxNhead));
   totalITD = struct(...
      'ITDset', ITDset, ...
      'ITDindex', ITDindex,...
      'Nhead', Nhead...
      );
end
% collect timing info in struct
TIMING = CollectInStruct(totalITD, modPhase, carSphase, modSphase, ...
   repDur, totDur, burstDur, riseDur, fallDur, onset);

% ------instructions for stim definition (i.e. conversion to SD struct)
ITDsaving = isstruct(totalITD); % tricks with waveform vs sample delays
ITDchan = 'LEFT';
LeftConstant = 0; RightConstant = 1;
% collect in struct
SD_INSTR = CollectInStruct(ITDsaving, ...
   LeftConstant, RightConstant, ITDchan);

% -------------------presentation--------------
Nrep = sc.repcount;
SPL = [s1.spl s2.spl];
Nsubseq = Nitd;
% collect in struct
PRES = CollectInStruct(Nrep, SPL, Nsubseq, chan);

% ---------PRP info------------
if order~=2, % i.e., if not randomized ..
   % leadchan determines play order
   if ipsiside=='L', order = 2-scmn.leadchan;  % lead = L|R = 1|2 ~ order = 1|0 = up|down
   else,             order = scmn.leadchan-1;    % lead = L|R = 1|2 ~ order = 0|1 = down|up
   end
end
playOrder = CreatePlayOrder(Nsubseq, order);
plotInfo = createPlotInfo('ITD (ipsi lead) (\mus)', ...
   ITD(playOrder), 'linear', NaN, 'BurstOnly');
PRP = createPRPinfo(plotInfo, playOrder);

% ----------global info-----------
% for spk subseqInfo:
NC = scmn.numcycles; IPC = scmn.incr_per_cycle;
varValuesR = 1e-3*ITD; % us->ms
% crazy convention of storing delays in contralateral chan
if IPSIside=='R',
   var1Values = kron([1 0],varValuesR(playOrder));
else,
   var1Values = kron([0 1],varValuesR(playOrder));
end
GI = createGlobalInfo('ITD', calib, var1Values);

% global nonsense
% nonsense = CollectInStruct(FREQ, TIMING, PRES, SD_INSTR, PRP, GI);

SMS = createSMSsxm(FREQ, TIMING, PRES, SD_INSTR, PRP, GI, mfilename);

