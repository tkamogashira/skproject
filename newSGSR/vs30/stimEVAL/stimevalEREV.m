function [DAdata, GENdata] = stimevalEREV(wv);

% STIMevalEREV - stimulus evaluator for 'EREV' stimulus category
% stimcat-independent info is stored in struct DAdata
% (this info will be used at D/A time: buffer sizes, 
% # reps of cyclic buffers, # samples to play, etc)
% stimtype-dependent info stored in struct GENdata:
% SYNTAX:
% function [DAdata, GENdata] = stimevalEREV(wv);
% wv is single waveform element from stimdef struct.
% NOTE: this function should only be called implicitly
% by stimeval - no complete type checking here.

StimCat = 'erev';
DAdata = []; GENdata = [];
SampleFreq = wv.stimpar.Both.Fsam; % in Hz
filterIndex = wv.stimpar.Both.iFilt;
SamP = 1e6./SampleFreq; % sample period in us
i_chan = ChannelNum(wv.channel); % L|R -> 1|2
bufVar = ErevBufVar(wv.channel);

NsamAdapt = round(wv.stimpar.Both.Adapt*1e-3*SampleFreq);
NsamRamp = round(wv.stimpar.Both.Ramp*1e-3*SampleFreq);
NsamCyc = bufVar.NsamNoise;
Ncyc = wv.stimpar.Noise.Ncyc;
noiseIndex = wv.stimpar.noiseIndex;

RepSilDur =  0;

% #samples of different stimulus portions
% Note: must be done together to prevent rounding errors to
% result in different total sample numbers
N_TotalBurst = NsamAdapt+ Ncyc*NsamCyc+ NsamRamp;
N_RepSil = 0;
N_Play = N_TotalBurst + N_RepSil;

% we will stick to these numbers, even if they contain rounding errors
% compute buffer sizes, etc
bufSizes = [NsamAdapt; 4*NsamCyc; NsamRamp];
bufReps = [1; Ncyc/4; 1];
TimeWarp = NaN;
% MaxSPL is computed at stim-menu time; it is stored in BufVar field of global EREVnoiseX
MaxSPL = bufVar.MaxSPL;

% fill DAdata structure (identical for all stimtypes)
DAdata = DAdataStruct(SamP, filterIndex,bufSizes, bufReps, ...
   N_RepSil, N_Play, TimeWarp-1, MaxSPL, mfilename);
% fill the GENdata structure (particular for each stimtype)

GENfun = 'Erev';
createdby = mfilename;
GENdata = CollectInstruct(GENfun, NsamAdapt, NsamCyc, NsamRamp, createdby);

%---------locals----------------
function gd = GENdataStruct(cutSeed, channel, onset, burstDur, riseDur, fallDur, NburstBuf, ...
   Nrep, GENfun, createdby);
% GENdata structure (specific for sxm stimtype)
numAtt = 0; % will be set by levelchecking
gd =CollectInStruct(channel, onset, burstDur, riseDur, fallDur, ...
   NburstBuf, Nrep, numAtt, GENfun, cutSeed, createdby);

