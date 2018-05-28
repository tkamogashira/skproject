function BufDBNs = stimgenBN(wf, storage);

% STIMGENBN -  computes (realizes) BN waveform
% SYNTAX:
% function SD = stimgenBN(wf, storage);
% INPUTS:
%    wf: waveform stimdef cell element.
%    storage: 'AP2' or 'MatLab' (where to store the samples)
%
% OUTPUT:
% BufDBNs is array holding AP2 or SampleLib indices (see stimGen)
% This function should only be called implicitly via stimGen -
% no complete arg checking.

% collect stimulus params from different sources
global BNbuffer
Chan = wf.channel;
sp = wf.stimpar; 
gd = wf.GENdata;
dad = wf.DAdata;
isubseq = sp.isubs;

% get samples of one cycle
attFactor = db2a(-gd.numAtt);
switch channelChar(Chan),
case 'L', cycle = attFactor*real(BNbuffer.CWaveL(isubseq,:));
case 'R', cycle = attFactor*real(BNbuffer.CWaveR(isubseq,:));
end % switch/case
NsamCyc = length(cycle);
RW = sin(linspace(0,pi/2,NsamCyc)).^2; % rise window
FW = cos(linspace(0,pi/2,NsamCyc)).^2; % fall window
 
BufDBNs(1,1) = storeSamples(RW.*cycle, storage);
BufDBNs(2,1) = storeSamples(cycle, storage);
BufDBNs(3,1) = storeSamples(FW.*cycle, storage);

%figure; plot(real([adaptbuf cycbuf fallbuf])); hold on;
%plot(real(adaptbuf),'r');
%plot(length(adaptbuf)+length(cycbuf)+(1:gd.NsamRamp),real(fallbuf),'r');

