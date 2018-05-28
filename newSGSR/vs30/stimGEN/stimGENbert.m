function BufDBNs = stimgenBERT(wf, storage);

% STIMGENBERT -  computes (realizes) BERT waveform
% SYNTAX:
% function SD = stimgenBERT(wf, storage);
% INPUTS:
%    wf: waveform stimdef cell element.
%    storage: 'AP2' or 'MatLab' (where to store the samples)
%
% OUTPUT:
% BufDBNs is array holding AP2 or SampleLib indices (see stimGen)
% This function should only be called implicitly via stimGen -
% no complete arg checking.

% collect stimulus params from different sources
global BERTbuffer
ichan = channelNum(wf.channel);
sp = wf.stimpar; 
isubseq = sp.isubs;
dad = wf.DAdata;
gd = wf.GENdata;
% waveform was computed earlier, gating included; it only needs scaling
scaleFactor = db2a(dad.MaxSPL-gd.numAtt); % stimuli are stored @ 0 dB SPL
samples = scaleFactor* BERTbuffer.ModTone{ichan};
BufDBNs = storeSamples(samples(:).', storage);


