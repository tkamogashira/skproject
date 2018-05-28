function [DAdata, GENdata] = stimevalsxm(pe);

% STIMevalSxm - stimulus evaluator for 'sxm' stimcat
% stimtype-independent info is stored in struct DAdata
% (this info will be used at D/A time: buffer sizes, 
% # reps of cyclic buffers, # samples to play, etc)
% stimtype-dependent info stored in struct GENdata:
%  literal/cyclic
%  if cyclic: # samples of different portions
%  radPersam: radians/per sample (possibly rounded due to
%    cyclic storage)
% SYNTAX:
% function [DAdata, GENdata] = stimevalsxm(pe);
% wv is single waveform element from stimdef struct.
% NOTE: this function should only be called implicitly
% by stimeval - no complete type checking here.

% first look if any modulation is needed; if not, delegate
mfreq = pe.stimpar.modFreq;
mdepth = pe.stimpar.modDepth;
if (mfreq==0) | (mdepth==0), % no modulation
   [DAdata GENdata] = stimevalTone(pe);
   return;
end

DAdata = []; GENdata = [];
cfreq = pe.stimpar.carFreq;
hfreq = cfreq + mfreq;
lfreq = cfreq - mfreq;
SampleFreq = pe.stimpar.Fsample; % in Hz
filterIndex = pe.stimpar.FiltIndex;
SamP = 1e6./SampleFreq; % sample period in us

% figure out what the durations are, expressing them in samples
% a sxm stimulus consists of 6 parts:
%   1. HS = heading silence (due to onset variations)
%   2. RP = rising portion
%   3. SA = steady-amplitude portion
%   4. FP = falling portion
%   5. TS = trailing silence (due to onset variations)
%   6. RS = repition silence (in between reps)
% the following computes the duration of these parts in ms
HSdur = pe.stimpar.onset;
RPdur = pe.stimpar.riseDur;
FPdur = pe.stimpar.fallDur;
SAdur = pe.stimpar.burstDur-(RPdur+FPdur);
TSdur = pe.stimpar.totDur-(pe.stimpar.burstDur+HSdur);
RSdur = pe.stimpar.repDur - pe.stimpar.totDur; 
% from a computational point of view, the different
% parts are only four:
%    BeforeSteady: BS = HS plus RP
%    Steady: SA
%    PostSteady: PS = FP plus TS
%    RepSilence: RS
%
BSdur = HSdur + RPdur;
PSdur = FPdur + TSdur;
% compute the #samples corresponding to the above four durations
% Note: must be done together to prevent rounding errors to
% result in different total sample numbers
[N_BS N_SA N_PS N_RS] = ...
   nSamplesOfChain([BSdur SAdur PSdur RSdur], SamP);
% number of samples for single repetition (including rep silence)
N_Play = N_BS + N_SA + N_PS + N_RS;
% we will stick to these numbers, even if they contain rounding errors
% Therefore, we will have to adapt SAdur to contain exactly
% N_SA samples (as cyclic storage could yield different roundings)
SAdur = N_SA*SamP*1e-3; % in ms

% start time of falling portion in ms (needed for exact timing...
% of fall window independent of rounding the # samples)
startFallPortion = (N_BS + N_SA)*SamP*1e-3;
% # AP2 samples needed to store non-zero parts of burst using
% literal storage:
Nliteral = N_BS + N_SA + N_PS;

% Now look if cyclic storage will help us save memory.
% note: imag parts are specs of modulation freq (see 
% evalCyclicStorage2)
ftol = pe.stimpar.carTol + i*pe.stimpar.modTol;
freqInfo = evalCyclicStorage2(cfreq+i*mfreq, SAdur, SampleFreq, ftol);

% decide which storage method to use
UseCyclicStorage = isequal(freqInfo.StorageAdvice,'Cyclic');
% compute buffer sizes, etc
if UseCyclicStorage,
   % common field of stimeval cell
   NsamCyc = freqInfo.NsamInCycBuf;
   NsamRem = freqInfo.NsamInRemBuf;
   bufSizes = [N_BS; NsamCyc; NsamRem; N_PS];
   bufReps =  [1; freqInfo.NrepOfCycBuf; 1; 1];
   nonZeroSizeIndices = find(bufSizes~=0); % find zero-sized entries..
   bufSizes = bufSizes(nonZeroSizeIndices);% .. and remove them
   bufReps = bufReps(nonZeroSizeIndices);
   TimeWarp = NaN; % obsolete
   % GENdata field of stimeval cell
   storage = 'cyclic';
   % true frequencies
   trueFreq.car = real(freqInfo.NewFreq);
   trueFreq.mod = imag(freqInfo.NewFreq);
   % ang. freq in rad/sample
   RadPerSam.car = real(freqInfo.RadPerSam);
   RadPerSam.mod = imag(freqInfo.RadPerSam);
   partSizes = [N_BS; NsamCyc; NsamRem; N_PS]; %diff parts of burst
else % literal storage
   % common part of stimeval
   bufSizes = Nliteral;
   bufReps = 1;
   TimeWarp = 1;
   % GENdata field of stimeval cell
   storage = 'literal';
   % true frequencies
   trueFreq.car = cfreq;  
   trueFreq.mod = mfreq;
   % ang. freq in rad/sample
   RR = 2*pi*1e-6*SamP; % conversion factor for freq -> rad/sample
   RadPerSam.car = RR*cfreq; RadPerSam.mod = RR*mfreq;
   partSizes = [N_BS; N_SA; N_PS];
end; % if use cyclic storage

% ----------level stuff & calibration--------

% Now the real work starts

% Any sinusoidally-modulated tone is a 3-tone complex.
% first compute the sideband phases and amplitudes
%
% levels: modDepth is in %, which in fact is a convention that 
% only makes sense for SAM tones. 100% modulation depth
% corresponds to the sidebands having amplitudes equal to
% 0.5 times the carrier amplitude.
% The amplitudes of the sidebands are equal (prior to calibration).
% Note: the SPLs are taken to be those of the *carrier* level by 
% convention; this could be compensated for in the stimulus menus.
%
% assume the carrier has an SPL of 0 dB and analyze the
% consequences of calibration.
carSPL = 0;
% The sideband SPLs depend on the modulation depth:
lowSPL = A2dB(0.5*1e-2*pe.stimpar.modDepth); 
highSPL = lowSPL;
% Now do the (freq-dependent) calibration
[calLevelCar calPhaseCar] = calibrate(cfreq, filterIndex, pe.channel);
[calLevelLow calPhaseLow] = calibrate(lfreq, filterIndex, pe.channel);
[calLevelHigh calPhaseHigh] = calibrate(hfreq, filterIndex, pe.channel);
% The numerical levels are SPL + calLevel
carLevel = carSPL + calLevelCar;
lowLevel = lowSPL + calLevelLow;
highLevel = highSPL + calLevelHigh;
% how much can we amplify this 3-tone stimulus before
% it hits the numerical ceiling given by MaxMagDA?
% Since westarted from a test carSPL of 0 dB, this 
% max Amplification is exactly the max car SPL.
PeakMag = 2^0.5*... % sqrt(2) factor due to RMS(sin) = sqrt(0.5)
   (db2a(lowLevel) + db2a(carLevel) + db2a(highLevel));
maxAmp = a2db(MaxMagDA/PeakMag); % in dB
MaxSPL = maxAmp; % convention is: "SPL" = carrier SPL
% Now compute linear amplitudes of the 3 sinusoids
carAmp = 2^0.5*db2a(carLevel + maxAmp);
lowAmp = 2^0.5*db2a(lowLevel + maxAmp);
highAmp = 2^0.5*db2a(highLevel + maxAmp);

% the phases are tricky: modPhase is the phase of the sidebands 
% re carPhase at the moment when low- and
% high-band phases meet (i.e., when their phases are identical);
% modSphase is the phase of the higher band re modPhase at the onset
% of the stimulus (this is identical to *minus* the same phase
% of the lower band, because it spins the other way re the carrier)
lowSphase = ...
   pe.stimpar.carSphase + pe.stimpar.modPhase - pe.stimpar.modSphase;
highSphase = ...
   pe.stimpar.carSphase + pe.stimpar.modPhase + pe.stimpar.modSphase;
% incorporate calibration
carSphase = pe.stimpar.carSphase + calPhaseCar;
lowSphase = lowSphase + calPhaseLow;
highSphase = highSphase + calPhaseHigh;
% these starting phase are re the onset of the burst - correct
% to get the starting phases at time=zero
% Note: we are working in CYCLES!
carSphase = carSphase - 1e-3*pe.stimpar.onset*cfreq;
lowSphase = lowSphase - 1e-3*pe.stimpar.onset*lfreq;
highSphase = highSphase - 1e-3*pe.stimpar.onset*hfreq;

% fill DAdata structure (identical for all stimtypes)
DAdata = DAdataStruct(SamP, filterIndex,bufSizes, bufReps, ...
   N_RS, N_Play, TimeWarp-1, MaxSPL, mfilename);
% fill the GENdata structure (particular for each stimtype)
GENdata = GENdataStruct(storage, trueFreq, RadPerSam, ...
   carAmp, lowAmp, highAmp, carSphase, lowSphase, highSphase, ...
   startFallPortion, partSizes, 'sxm', mfilename);


%---------
function N= nsamples(dur,sampleperiod);
% returns # samples for given dur in ms and sampleperiod in us
N=round(dur*1e3./sampleperiod);
%---------
function gd = GENdataStruct(storage ,trueFreq, RadPerSam, ...
   carAmp, lowAmp, highAmp, carSphase, lowSphase, highSphase, ...
   startFallPortion, partSizes, GENfun, createdby);
% GENdata structure (specific for sxm stimtype)
gd =struct('storage',storage, ...
   'trueFreq', trueFreq,...
   'radPerSam', RadPerSam,...
   'carAmp', carAmp, ...
   'lowAmp', lowAmp, ...
   'highAmp', highAmp, ...
   'carSphase', carSphase, ...
   'lowSphase', lowSphase, ...
   'highSphase', highSphase, ...
   'startFallPortion', startFallPortion, ...
   'partSizes', partSizes, ...
   'GENfun',    GENfun, ...
   'numAtt',    0, ...
   'createdby', createdby);

