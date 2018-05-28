function [DAdata, GENdata] = stimevalNRHO(wv);

% STIMevalNRHO - stimulus evaluator for 'NRHO' stimulus category
% stimcat-independent info is stored in struct DAdata
% (this info will be used at D/A time: buffer sizes, 
% # reps of cyclic buffers, # samples to play, etc)
% stimtype-dependent info stored in struct GENdata:
% SYNTAX:
% function [DAdata, GENdata] = stimevalNRHO(wv);
% wv is single waveform element from stimdef struct.
% NOTE: this function should only be called implicitly
% by stimeval - no complete type checking here.

global NRHObuffer
StimCat = 'nrho';
GENfun = 'NRHO';
% NOTE: global NRHObuffer is assumed to exist and ..
%   ... match current stim params (see stimDEFnrho)

DAdata = []; GENdata = [];
sp = wv.stimpar;
isubseq = sp.isubs;
SampleFreq = NRHObuffer.Fsam; % in Hz
filterIndex = NRHObuffer.iFilt;
SamP = 1e6./SampleFreq; % sample period in us
i_chan = ChannelNum(wv.channel); % L|R -> 1|2
RepSilDur =  sp.param.interval - sp.param.burstDur;

% #samples of different stimulus portions
% Note: must be done together to prevent rounding errors to
% result in different total sample numbers
N_TotalBurst = NRHObuffer.Nburst;
N_Play = round(sp.param.interval*1e-3*SampleFreq);
N_RepSil = N_Play - N_TotalBurst;
% we will stick to these numbers, even if they contain rounding errors
% compute buffer sizes, etc
bufSizes = N_TotalBurst;
bufReps = 1;
TimeWarp = NaN;
% MaxSPL is computed at stim-menu time; it is stored in global NRHObuffer
MaxSPL = NRHObuffer.maxSPL(i_chan);

% fill DAdata structure (identical for all stimtypes)
DAdata = DAdataStruct(SamP, filterIndex,bufSizes, bufReps, ...
   N_RepSil, N_Play, TimeWarp-1, MaxSPL, mfilename);
% fill the GENdata structure (particular for each stimtype)

createdby = mfilename;
GENdata = CollectInstruct(GENfun, createdby);

