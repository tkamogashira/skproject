function [BufDBNs, CTone, CNoise, DT] = stimgenEREV(wf, storage);

% STIMGENEREV -  computes (realizes) EREV waveform
% SYNTAX:
% function SD = stimgenEREV(wf, storage);
% INPUTS:
%    wf: waveform stimdef cell element.
%    storage: 'AP2' or 'MatLab' (where to store the samples)
%
% OUTPUT:
% BufDBNs is array holding AP2 or SampleLib indices (see stimGen)
% This function should only be called implicitly via stimGen -
% no complete arg checking.

% collect stimulus params from different sources
Chan = wf.channel;
sp = wf.stimpar; 
gd = wf.GENdata;
bv = erevbufvar(Chan);
DoTwist = ~isequal(bv.NoiseTwistor,0);

% tone:
ToneAmp = MaxMagDA * db2a(bv.MaxSPL-bv.MaxSPLtone-gd.numAtt);
RadPerSam = 2*pi*bv.TrueToneFreq/bv.Fsam; % angular freq in radians per sample
AdaptTone = ToneAmp*exp((i*RadPerSam)*(gd.NsamAdapt-1:-1:0));
CycTone = ToneAmp*exp((i*RadPerSam)*(1:4*gd.NsamCyc));
FallTone = ToneAmp*exp((i*RadPerSam)*(4*gd.NsamCyc+(1:gd.NsamRamp)));
% noise:
NoiseAttFac = db2a(bv.MaxSPL + sp.Pres.LevelNoise-bv.MaxSPLnoise-gd.numAtt);

Gname = ['EREVnoise' Chan];
eval(['global ' Gname]);
if ~bv.Mix,
   eval(['cycbuf = NoiseAttFac*' Gname '.NoiseWaveform(:,sp.noiseIndex).'';']);
else,
   error('noise-token mixing not implemented');
end
if DoTwist,
   cycbuf = cycbuf.*exp(bv.NoiseTwistor*(0:bv.NsamNoise-1));
end
GateWin = cos(linspace(0,pi/2,gd.NsamRamp));
if DoTwist, cycbuf = [cycbuf, (-i)*cycbuf, (-1)*cycbuf, i*cycbuf ]; % 4 twisted noise cycles
else, cycbuf = repmat(cycbuf,1,4); % 4 identical noise cycles
end
adaptbuf = AdaptTone + cycbuf(end-gd.NsamAdapt+1:end); % the "preceding" part
adaptbuf(1:gd.NsamRamp) = adaptbuf(1:gd.NsamRamp).*fliplr(GateWin);
fallbuf = GateWin.*(FallTone + cycbuf(1:gd.NsamRamp));
% before we add, return the unmixed cyclic complex waveforms when asked
if nargout>1, CTone = CycTone; end
if nargout>2, CNoise = cycbuf; end
if nargout>3, DT = 1e6/bv.Fsam; end

cycbuf = cycbuf + CycTone;

BufDBNs(1,1) = storeSamples(real(adaptbuf), storage);
BufDBNs(2,1) = storeSamples(real(cycbuf), storage);
BufDBNs(3,1) = storeSamples(real(fallbuf), storage);

%figure; plot(real([adaptbuf cycbuf fallbuf])); hold on;
%plot(real(adaptbuf),'r');
%plot(length(adaptbuf)+length(cycbuf)+(1:gd.NsamRamp),real(fallbuf),'r');

