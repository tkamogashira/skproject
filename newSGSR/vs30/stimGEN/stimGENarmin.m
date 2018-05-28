function BufDBNs = stimgenARMIN(wf, storage);

% STIMGENBN -  computes (realizes) ARMIN waveform
% SYNTAX:
% function SD = stimgenARMIN(wf, storage);
% INPUTS:
%    wf: waveform stimdef cell element.
%    storage: 'AP2' or 'MatLab' (where to store the samples)
%
% OUTPUT:
% BufDBNs is array holding AP2 or SampleLib indices (see stimGen)
% This function should only be called implicitly via stimGen -
% no complete arg checking.

% collect stimulus params from different sources
global AKbuffer
Chan = wf.channel;
sp = wf.stimpar; 
gd = wf.GENdata;
dad = wf.DAdata;
pp = AKbuffer.pp;
Fsam = AKbuffer.Fsam;
Nspec = AKbuffer.Nspec;
Nsam = AKbuffer.N;

isubseq = sp.isubs;
flipfreq = sp.AKparam.flipfreqs(isubseq);
nflip = 1+round(Nspec*flipfreq/Fsam);

scaleFactor = db2a(dad.MaxSPL-gd.numAtt);
if ChannelNum(Chan)==ChannelNum(pp.ConstEar),
   if ~isfield(AKbuffer, 'WfConst'), % generate it
      AKbuffer.WfConst = (pp.polaconst*scaleFactor).*real(ifft(AKbuffer.SpConst));
      AKbuffer.WfConst = AKbuffer.WfConst(1:Nsam);
   end
   samples = AKbuffer.WfConst;
else % varied ear:  mixed spec with correct polarities
   Spec = [pp.polalow*AKbuffer.SpVlow(1:nflip); pp.polahigh*AKbuffer.SpVhigh(nflip+1:end)]; 
   samples = real(ifft(Spec));
   samples = scaleFactor.*samples(1:Nsam);
end

% gating
Nrise = round(pp.riseDur*1e-3*Fsam);
Nfall = round(pp.fallDur*1e-3*Fsam);
RiseWin = sin(linspace(0,pi/2,Nrise).').^2;
FallWin = cos(linspace(0,pi/2,Nfall).').^2;
samples(1:Nrise) = samples(1:Nrise).*RiseWin;
ifw = Nsam-Nfall+1; % start of fall
samples(ifw:Nsam) = samples(ifw:Nsam).*FallWin;

BufDBNs = storeSamples(samples(:).', storage);



%figure; plot(real([adaptbuf cycbuf fallbuf])); hold on;
%plot(real(adaptbuf),'r');
%plot(length(adaptbuf)+length(cycbuf)+(1:gd.NsamRamp),real(fallbuf),'r');

