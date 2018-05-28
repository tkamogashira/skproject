function [DAdata, GENdata] = stimevalPS(wv);

% STIMevalPS - stimulus evaluator for 'PS' stimulus category
% stimcat-independent info is stored in struct DAdata
% (this info will be used at D/A time: buffer sizes, 
% # reps of cyclic buffers, # samples to play, etc)
% stimtype-dependent info stored in struct GENdata:
% SYNTAX:
% function [DAdata, GENdata] = stimevalPS(wv);
% wv is single waveform element from stimdef struct.
% NOTE: this function should only be called implicitly
% by stimeval - no complete type checking here.

StimCat = 'PS';
GENfun = 'PS';

DAdata = []; GENdata = [];
sp = wv.stimpar;
[maxSPL, PS] = preparePSstim(sp.param);

isubseq = sp.isubs;
SampleFreq = PS.Fsam; % in Hz
filterIndex = PS.iFilt;
SamP = 1e6./SampleFreq; % sample period in us
i_chan = ChannelNum(wv.channel); % L|R -> 1|2

% #samples of different stimulus portions
bufSizes = [PS.Nrise PS.Nsteady     PS.Nrem+PS.Nfall].';
bufReps =  [1        PS.NrepSteady  1].';
% remove empty buffers
izero = find(bufSizes==0);
bufSizes(izero) = [];
bufReps(izero) = [];

N_repSil = PS.NrepSil;
N_Play = sum(bufReps.*bufSizes) + PS.NrepSil;
TimeWarp = NaN;

% fill DAdata structure (identical for all stimtypes)
DAdata = DAdataStruct(SamP, filterIndex,bufSizes, bufReps, ...
   N_repSil, N_Play, TimeWarp-1, maxSPL, mfilename);
% fill the GENdata structure (particular for each stimtype)

createdby = mfilename;
GENdata = CollectInstruct(GENfun, createdby);

