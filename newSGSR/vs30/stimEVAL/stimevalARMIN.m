function [DAdata, GENdata] = stimevalARMIN(wv);

% STIMevalARMIN - stimulus evaluator for 'ARMIN' stimulus category
% stimcat-independent info is stored in struct DAdata
% (this info will be used at D/A time: buffer sizes, 
% # reps of cyclic buffers, # samples to play, etc)
% stimtype-dependent info stored in struct GENdata:
% SYNTAX:
% function [DAdata, GENdata] = stimevalARMIN(wv);
% wv is single waveform element from stimdef struct.
% NOTE: this function should only be called implicitly
% by stimeval - no complete type checking here.

global AKbuffer
StimCat = 'armin';
DAdata = []; GENdata = [];
prepareARMINstim(wv.stimpar.AKparam); % creates/updates global AKbuffer
sp = wv.stimpar;
isubseq = sp.isubs;
SampleFreq = AKbuffer.Fsam; % in Hz
filterIndex = AKbuffer.iFilt;
SamP = 1e6./SampleFreq; % sample period in us
i_chan = ChannelNum(wv.channel); % L|R -> 1|2
RepSilDur =  sp.AKparam.interval - sp.AKparam.burstDur;

% #samples of different stimulus portions
% Note: must be done together to prevent rounding errors to
% result in different total sample numbers
N_TotalBurst = AKbuffer.N;
N_RepSil = round(RepSilDur*1e-3*SampleFreq);
N_Play = N_TotalBurst + N_RepSil;

% we will stick to these numbers, even if they contain rounding errors
% compute buffer sizes, etc
bufSizes = N_TotalBurst;
bufReps = 1;
TimeWarp = NaN;
% MaxSPL is computed at stim-menu time; it is stored in BufVar field of global EREVnoiseX
MaxSPL = AKbuffer.maxSPL(i_chan);

% fill DAdata structure (identical for all stimtypes)
DAdata = DAdataStruct(SamP, filterIndex,bufSizes, bufReps, ...
   N_RepSil, N_Play, TimeWarp-1, MaxSPL, mfilename);
% fill the GENdata structure (particular for each stimtype)

GENfun = 'ARMIN';
createdby = mfilename;
GENdata = CollectInstruct(GENfun, createdby);

