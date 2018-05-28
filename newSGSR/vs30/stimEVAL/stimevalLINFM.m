function [DAdata, GENdata] = stimevalLINFM(wv);

% STIMevalLINFM - stimulus evaluator for 'LINFM' stimulus category
% stimcat-independent info is stored in struct DAdata
% (this info will be used at D/A time: buffer sizes, 
% # reps of cyclic buffers, # samples to play, etc)
% stimtype-dependent info stored in struct GENdata:
% SYNTAX:
% function [DAdata, GENdata] = stimevalLINFM(wv);
% wv is single waveform element from stimdef struct.
% NOTE: this function should only be called implicitly
% by stimeval - no complete type checking here.

StimCat = 'linfm';
sp = wv.stimpar;
DAdata = []; GENdata = [];
SampleFreq = sp.samFreq; % in Hz
filterIndex = sp.filterIndex; 
SamP = 1e6./SampleFreq; % sample period in us
chan = wv.channel; % L|R
i_chan = ChannelNum(chan); % L|R -> 1|2

% #samples of different stimulus portions
onsetDur = sp.delay;
burstDur = sp.upDur + sp.holdDur + sp.downDur;
repsilDur = sp.repDur - burstDur - onsetDur;
durVec = [onsetDur sp.upDur sp.holdDur sp.downDur repsilDur];
[Nonset, NsamUp, NsamHold, NsamDown, NrepSil] ...
   = NsamplesOfChain(durVec,SamP);
Nburst = NsamUp + NsamHold + NsamDown;
Nplay = Nonset + Nburst + NrepSil;
% we will stick to these numbers, even if they contain rounding errors
% compute buffer sizes, etc
bufSizes = [Nburst];
bufReps = [1];
TimeWarp = NaN;

% max SPL - depends on calibration, sweep range and conventional ...
% ... freq spacing during check time
[OK, MaxSPL, critFreq] = FMcheck('localLimLevel', sp.Flow, sp.Fhigh, chan);

% fill DAdata structure (identical for all stimtypes)
DAdata = DAdataStruct(SamP, filterIndex,bufSizes, bufReps, ...
   NrepSil, Nplay, TimeWarp-1, MaxSPL, mfilename);

% fill the GENdata structure (particular for each stimtype)
GENfun = 'linfm';
numAtt = NaN; % will be set by levelChecking
createdby = mfilename;
GENdata = CollectInstruct(GENfun, Nonset, NsamUp, NsamHold, NsamDown, ...
   critFreq, numAtt, createdby);


