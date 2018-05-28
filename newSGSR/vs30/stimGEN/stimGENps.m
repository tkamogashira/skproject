function BufDBNs = stimgenPS(wf, storage);

% STIMGENPS -  computes (realizes) PS waveform
% SYNTAX:
% function SD = stimgenPS(wf, storage);
% INPUTS:
%    wf: waveform stimdef cell element.
%    storage: 'AP2' or 'MatLab' (where to store the samples)
%
% OUTPUT:
% BufDBNs is array holding AP2 or SampleLib indices (see stimGen)
% This function should only be called implicitly via stimGen -
% no complete arg checking.

% collect stimulus params from different sources
ichan = channelNum(wf.channel);
isubseq = wf.stimpar.isubs;
sp = wf.stimpar.param;
[maxSPL, PS] = PreparePSstim(sp);
dad = wf.DAdata;
gd = wf.GENdata;
PSversion = getfieldordef(sp, 'PSversion', 1);

scaleFactor = db2a(-gd.numAtt);

% cut respective pieces from PS waveworms
startSamples = 1+cumsum([0; dad.bufSizes(1:end-1)]);
endSamples = startSamples+dad.bufSizes-1;
Npiece = length(startSamples);

for ipiece=1:Npiece,
   i0 = startSamples(ipiece);
   i1 = endSamples(ipiece);
   maxSam = max(PS.WF{ichan}(i0:i1, isubseq));
   samples = scaleFactor*PS.WF{ichan}(i0:i1, isubseq);
   BufDBNs(ipiece,1) = storeSamples(samples(:).', storage);
end





