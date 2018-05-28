function BufDBNs = stimgenNRHO(wf, storage);

% STIMGENNRHO -  computes (realizes) NRHO waveform
% SYNTAX:
% function SD = stimgenNRHO(wf, storage);
% INPUTS:
%    wf: waveform stimdef cell element.
%    storage: 'AP2' or 'MatLab' (where to store the samples)
%
% OUTPUT:
% BufDBNs is array holding AP2 or SampleLib indices (see stimGen)
% This function should only be called implicitly via stimGen -
% no complete arg checking.

% collect stimulus params from different sources
global NRHObuffer
ichan = channelNum(wf.channel);
isubseq = wf.stimpar.isubs;
sp = wf.stimpar.param;
rho = sp.rho;
pol = sp.noisePolarity;
dad = wf.DAdata;
gd = wf.GENdata;

NRHOversion = getfieldordef(sp, 'NRHOversion', 1);

% realize rho value by suitable mix of independent real&imag parts of noise buffer

if NRHOversion==1, % symmetric N0 and Npi mixing
   % convention: left/right ~ +/- of imag part
   NpiPower = (1-rho); % unnormalized power of Npi component (see MvdH&CT, 1997)
   N0Power = (1+rho); % unnormalized power of No component (see MvdH&CT, 1997)
   % compute mixing angle such that sin/cos = sqrt(Npipower/N0power)
   mixAngle = atan2(sqrt(NpiPower),sqrt(N0Power)); % sqrt: Power->amplitude
   if ichan==2, mixAngle = -mixAngle; end; % flip sign of imag contribution
   wf = real(exp(i*mixAngle)*NRHObuffer.Wv{ichan});
elseif NRHOversion>1, % varied channel
   if isequal(sp.varchan, ichan),
      mixAngle = acos(rho);
      wf = real(exp(i*mixAngle)*NRHObuffer.Wv{ichan});
   else, % constant channel: trivial
      wf = real(NRHObuffer.Wv{ichan});
   end
end

scaleFactor = pol*db2a(dad.MaxSPL-gd.numAtt);
samples = scaleFactor* wf;
BufDBNs = storeSamples(samples(:).', storage);
NRHOconstChanDBN = BufDBNs;





