function [DAdata, GENdata] = stimevalBN(wv);

% STIMevalBN - stimulus evaluator for 'BN' stimulus category
% stimcat-independent info is stored in struct DAdata
% (this info will be used at D/A time: buffer sizes, 
% # reps of cyclic buffers, # samples to play, etc)
% stimtype-dependent info stored in struct GENdata:
% SYNTAX:
% function [DAdata, GENdata] = stimevalBN(wv);
% wv is single waveform element from stimdef struct.
% NOTE: this function should only be called implicitly
% by stimeval - no complete type checking here.

global BNbuffer
StimCat = 'bn';
DAdata = []; GENdata = [];
prepareBNstim(wv.stimpar.BNparam); % creates/updates global BNbuffer
isubseq = wv.stimpar.isubs;
SampleFreq = BNbuffer.Fsam(min(end,isubseq));% in Hz
filterIndex = BNbuffer.ifilt(min(end,isubseq));
SamP = 1e6./SampleFreq; % sample period in us
i_chan = ChannelNum(wv.channel); % L|R -> 1|2

% NsamCyc = BNbuffer.NsamCyc(min(end,isubseq));
NsamCyc = BNbuffer.NsamCyc(min(end,i_chan));
% Ncyc = BNbuffer.Ncyc(min(end,isubseq));
Ncyc = BNbuffer.Ncyc(min(end,i_chan));


RepSilDur =  0;

% #samples of different stimulus portions
% Note: must be done together to prevent rounding errors to
% result in different total sample numbers
N_TotalBurst = (Ncyc+2)*NsamCyc;
N_RepSil = 0;
N_Play = N_TotalBurst + N_RepSil;

% we will stick to these numbers, even if they contain rounding errors
% compute buffer sizes, etc
bufSizes = NsamCyc*[1 1 1];
bufReps = [1; Ncyc; 1];
TimeWarp = NaN;
% MaxSPL is computed at stim-menu time; it is stored in BufVar field of global EREVnoiseX
MaxSPL = BNbuffer.maxSPL(min(end,isubseq), min(i_chan,end));

% fill DAdata structure (identical for all stimtypes)
DAdata = DAdataStruct(SamP, filterIndex,bufSizes, bufReps, ...
   N_RepSil, N_Play, TimeWarp-1, MaxSPL, mfilename);
% fill the GENdata structure (particular for each stimtype)

GENfun = 'BN';
createdby = mfilename;
GENdata = CollectInstruct(GENfun, NsamCyc, createdby);

