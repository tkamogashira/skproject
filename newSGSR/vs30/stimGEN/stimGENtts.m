function BufDBNs = stimgenTTS(wf, storage);

% STIMGENTTS -  computes (realizes) TTS waveform
% SYNTAX:
% function SD = stimgenTTS(wf, storage);
% INPUTS:
%    wf: waveform stimdef cell element.
%    storage: 'AP2' or 'MatLab' (where to store the samples)
%
% OUTPUT:
% BufDBNs is array holding AP2 or SampleLib indices (see stimGen)
% This function should only be called implicitly via stimGen -
% no complete arg checking.

% collect stimulus params from different sources
global TTSbuffer
ichan = channelNum(wf.channel);
sp = wf.stimpar; 
isubseq = sp.isubs;
dad = wf.DAdata;
gd = wf.GENdata;
% waveform was computed earlier, gating included; it only needs scaling
scaleFactor = db2a(-gd.numAtt);
samples = scaleFactor* TTSbuffer.WV{isubseq,ichan};
BufDBNs = storeSamples(samples(:).', storage);


