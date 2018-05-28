function [DAdata, GENdata] = stimevalWavList(wvf);

% STIMevalWavList - stimulus evaluator for 'WavList' stimcat
% stimtype-independent info is stored in struct DAdata
% (this info will be used at D/A time: buffer sizes, 
% # reps of cyclic buffers, # samples to play, etc)
% stimtype-dependent info stored in struct GENdata:
% SYNTAX: 
% function [DAdata, GENdata] = stimevalWavList(wvf);
% wv is single waveform element from stimdef struct.
% NOTE: this function should only be called implicitly
% by stimeval - no complete type checking here.

DAdata = []; GENdata = [];
SampleFreq = wvf.stimpar.Fsample; % in Hz
filterIndex = wvf.stimpar.FilterIndex;
iwav = wvf.stimpar.WAVdataIndex;
samP = 1e6./SampleFreq; % sample period in us
channel = wvf.channel;
repDur = wvf.stimpar.repDur;

% pick up # samples in burst from global WAVdata
global WAVdata
[Nsample NwavCh]= size(WAVdata{iwav}.waveform);
% figure out how many zero samples need to be added to get correct RepDur
Nrepsil = ceil(repDur*1e3/samP)-Nsample;
% both burst and zeros need to be played on each repetition
N_Play = Nsample + Nrepsil;
% we will stick to these numbers, even if they contain rounding errors


bufSizes = Nsample; bufReps = 1;
TimeWarp = NaN;
MaxSPL = NaN;

% fill DAdata structure (identical for all stimtypes)
DAdata = DAdataStruct(samP, filterIndex,bufSizes, bufReps, ...
   Nrepsil, N_Play, TimeWarp-1, MaxSPL, mfilename);
% fill the GENdata structure (particular for each stimtype)

% GENdata field of stimeval cell
storage = 'WAVdata';
scalor = wvf.stimpar.scalor;
% find out which channel from WAVdata is to be played
% Note: number of channels in WAVdata is made consistent
% with active channels during call to  ReadWAVfiles
if isequal(channel,'L'), iwavchan = 1;
else, iwavchan = 2; end
GENfun = 'wavList';

GENdata = CollectInStruct(GENfun, storage, scalor, iwav, iwavchan);



