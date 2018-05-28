function [DAdata, GENdata] = stimevalRnoise(pe);

% STIMevalRnoise - stimulus evaluator for 'rnoise' stimulus category
% stimcat-independent info is stored in struct DAdata
% (this info will be used at D/A time: buffer sizes, 
% # reps of cyclic buffers, # samples to play, etc)
% stimtype-dependent info stored in struct GENdata:
% SYNTAX:
% function [DAdata, GENdata] = stimevalRnoise(wv);
% wv is single waveform element from stimdef struct.
% NOTE: this function should only be called implicitly
% by stimeval - no complete type checking here.

StimCat = 'rnoise';
DAdata = []; GENdata = [];
SampleFreq = pe.stimpar.Fsample; % in Hz
filterIndex = pe.stimpar.FiltIndex;
SamP = 1e6./SampleFreq; % sample period in us
i_chan = ChannelNum(pe.channel); % L|R -> 1|2

% figure out what the durations are, expressing them in samples
% a single rep of a noise stimulus consists of 4 parts:
%   1. HS = heading silence (due to onset variations)
%   2. BP = burst portion (gated)
%   3. TS = trailing silence (due to onset variations)
%   4. RS = repition silence (in between reps)
% the following computes the duration of these parts in ms
% Only the rep silence will be treated separately; the rest is "the burst"
% So we have BURST + REPSIL
RepSilDur =  pe.stimpar.repDur - pe.stimpar.totDur;
% compute the #samples corresponding to these two durations
% Note: must be done together to prevent rounding errors to
% result in different total sample numbers
[N_TotalBurst, N_RepSil] = nSamplesOfChain([pe.stimpar.totDur RepSilDur], SamP);
% number of samples for single repetition (including rep silence)
N_Play = N_TotalBurst + N_RepSil;
% we will stick to these numbers, even if they contain rounding errors
% compute buffer sizes, etc
bufSizes = N_TotalBurst * ones(1, pe.stimpar.Nrep); % multiple copies needed; one for each rep
bufReps = ones(1, pe.stimpar.Nrep);
TimeWarp = NaN;
% Max SPL is computed at stim-menu time; it is stored in global NoiseBuffer
global RnoiseBuffer
MaxSPL = RnoiseBuffer.MaxSPL;
MaxSPL = MaxSPL(min(i_chan,length(MaxSPL)));

% fill DAdata structure (identical for all stimtypes)
DAdata = DAdataStruct(SamP, filterIndex,bufSizes, bufReps, ...
   N_RepSil, N_Play, TimeWarp-1, MaxSPL, mfilename);
% fill the GENdata structure (particular for each stimtype)
GENdata = GENdataStruct(pe.stimpar.cutSeed, pe.channel, pe.stimpar.onset, pe.stimpar.burstDur, ...
   pe.stimpar.riseDur, pe.stimpar.fallDur, N_TotalBurst, pe.stimpar.Nrep, StimCat, mfilename);

%---------locals----------------
function gd = GENdataStruct(cutSeed, channel, onset, burstDur, riseDur, fallDur, NburstBuf, ...
   Nrep, GENfun, createdby);
% GENdata structure (specific for sxm stimtype)
numAtt = 0; % will be set by levelchecking
gd =CollectInStruct(channel, onset, burstDur, riseDur, fallDur, ...
   NburstBuf, Nrep, numAtt, GENfun, cutSeed, createdby);

