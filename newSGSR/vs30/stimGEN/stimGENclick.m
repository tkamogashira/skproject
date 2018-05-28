function BufDBNs = stimgenClick(wf, storage);

% STIMGENclick -  computes (realizes) click waveform
% SYNTAX:
% function SD = stimgenclick(wf, storage);
% INPUTS:
%    wf: waveform stimdef cell element.
%    storage: 'AP2' or 'MatLab' (where to store the samples)
%
% OUTPUT:
% BufDBNs is array holding AP2 or SampleLib indices (see stimGen)
% This function should only be called implicitly via stimGen -
% no complete arg checking.

% this function is entirely trivial since the trains have already
% been generated at stimmenu time


% collect generating params from GENdata field of waveform
channel = wf.channel;
gd = wf.GENdata;
CDI = gd.clickDataIndex;
global clickData
cdata = chanOfStruct(clickData(CDI), channel);
if iscell(cdata.CycBuf), Waveform = cdata.CycBuf{1}'; 
else, Waveform = cdata.CycBuf';
end
numAtt = gd.numAtt;

% now look if cycBuf and remBuf are needed
if gd.NrepCyc==0, % never played completely
   DBNcyc = [];
else, % complete cycbuffer
   DBNcyc = storeSamples(Waveform, storage);
end

gd.Nremain = round(gd.Nremain);
if gd.Nremain==0, % no remainder
   DBNrem = [];
else,
   DBNrem = storeSamples(Waveform(1:gd.Nremain), storage);
end


BufDBNs = [DBNcyc; DBNrem];

