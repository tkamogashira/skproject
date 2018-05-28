function [DAdata, GENdata] = stimevaltone(pe);

% STIMevalTone - stimulus evaluator for 'tone' stimCat
% (i.e., unmodulated sxm stimuli)
% stimtype-independent info is stored in struct DAdata
% (this info will be used at D/A time: buffer sizes, 
% # reps of cyclic buffers, # samples to play, etc)
% stimtype-dependent info stored in struct GENdata:
%  literal/cyclic
%  if cyclic: # samples of different portions
%  radPersam: radians/per sample (possibly rounded due to
%    cyclic storage)
% SYNTAX: function [DAdata, GENdata] = stimevaltone(wv);
% wv is waveform filed from stimdef.
% NOTE: this function should only be called implicitly
% via stimeval - no complete type checking here.

DAdata = [];
GENdata = [];
% find out if cyclic or literal storage must be used 
freq = pe.stimpar.carFreq;
ftol = pe.stimpar.carTol;
bdur = pe.stimpar.burstDur;
SampleFreq = pe.stimpar.Fsample;
SamP = 1e6./SampleFreq; % sample period in us
[calLevel calPhase] = calibrate(freq, 1, pe.channel);
maxSPL = maxnumToneLevel - calLevel;
Ampl = maxMagDA;
% correct starting phase for: 1) calibration; 2) onset delay
Sphase = pe.stimpar.carSphase + calPhase - 1e-3*pe.stimpar.onset*freq;
tol = pe.stimpar.carTol;
filterIndex = pe.stimpar.FiltIndex;

% figure out what the durations are, expressing them in samples
% one rep consists of 6 parts:
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
% number of samples for single repetition (including rep silince)
N_Play = N_BS + N_SA + N_PS + N_RS;
% We will stick to these numbers, even if they contain rounding errors.
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
freqInfo = evalCyclicStorage2(freq, SAdur, SampleFreq, ftol);

% decide which storage method to use
UseCyclicStorage = isequal(freqInfo.StorageAdvice,'Cyclic');
% compute buffer sizes, etc

if UseCyclicStorage,
   % common field of stimeval cell
   bufSizes = [N_BS; freqInfo.NsamInCycBuf; freqInfo.NsamInRemBuf; N_PS];
   bufReps =  [  1 ;  freqInfo.NrepOfCycBuf  ;   1 ;  1];
   nonZeroSizeIndices = find(bufSizes~=0); % find zero-sized entries..
   bufSizes = bufSizes(nonZeroSizeIndices);% .. and remove them
   bufReps = bufReps(nonZeroSizeIndices);
   TimeWarp = NaN; % obsolete
   trueFreq = freqInfo.NewFreq;
   % GENdata field of waveform
   storage = 'cyclic';
   RadPerSam = freqInfo.RadPerSam; % angular freq in rad/sample
   %diff parts of burst:
   partSizes = [N_BS; freqInfo.NsamInCycBuf; freqInfo.NsamInRemBuf; N_PS]; 
else % literal storage
   % common part of stimeval
   bufSizes = Nliteral;
   bufReps = 1;
   TimeWarp = 1;
   trueFreq = freq;
   % GENdata field of waveform
   storage = 'literal';
   RadPerSam = 2*pi*freq/SampleFreq; % angular freq in rad/sample
   partSizes = [N_BS; N_SA; N_PS];
end; % if use cyclic storage
% fill DAdata structure (identical for all stimtypes)
DAdata = DAdataStruct(SamP, filterIndex,bufSizes, bufReps, ...
   N_RS, N_Play, TimeWarp-1, maxSPL, mfilename);
% fill the GENdata structure (particular for each stimtype)
GENdata = GENdataStruct(storage, trueFreq, RadPerSam, Ampl, ...
   Sphase, startFallPortion, partSizes, 'tone',mfilename);

%---------
function N= nsamples(dur,sampleperiod);
% returns # samples for given dur in ms and sampleperiod in us
N=round(dur*1e3./sampleperiod);
%---------
function gd = GENdataStruct(storage, trueFreq, RadPerSam, Ampl, ...
   Sphase, startFallPortion, partSizes, GENfun, createdby);
% GENdata structure (specific for tone stimtype)
gd =struct('storage',storage, ...
   'trueFreq',  trueFreq,...
   'radPerSam', RadPerSam,...
   'Ampl',      Ampl,...
   'sphase',    Sphase,...
   'startFallPortion', startFallPortion, ...
   'partSizes', partSizes, ...
   'numAtt',    0, ...
   'GENfun',    GENfun, ...
   'createdby', createdby);
