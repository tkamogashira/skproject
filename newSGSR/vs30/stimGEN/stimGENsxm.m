function BufDBNs = stimgensxm(wf, storage);

% STIMGENsxm -  computes (realizes) sxm waveform
% SYNTAX:
% function BufDBNs = stimgensxm(wf, storage);
% INPUTS:
%    wf: waveform stimdef cell element.
%    storage: 'AP2' or 'MatLab' (where to store the samples)
%
% OUTPUT:
% BufDBNs is array holding AP2 or SampleLib indices (see stimGen)
% This function should only be called implicitly via stimGen -
% no complete arg checking.


% thoughout, sxm is treated as a simple 3-topne complex (which it is)

% convert starting phases from cycles to rad
lPhase = 2*pi*wf.GENdata.lowSphase; 
cPhase = 2*pi*wf.GENdata.carSphase; 
hPhase = 2*pi*wf.GENdata.highSphase; 
 % angular freqs in rad/sample
cOmega = wf.GENdata.radPerSam.car;
mOmega = wf.GENdata.radPerSam.mod;
lOmega = cOmega - mOmega;
hOmega =  cOmega + mOmega;
% linear amplitudes
attFac = db2a(-wf.GENdata.numAtt); % numerical attenuation
lAmp = attFac*wf.GENdata.lowAmp;
cAmp = attFac*wf.GENdata.carAmp;
hAmp = attFac*wf.GENdata.highAmp;

BufDBNs = zeros(size(wf.DAdata.bufSizes));
stype = wf.GENdata.storage;
ps = wf.GENdata.partSizes;

% params for riseGate and FallGate
samP = wf.DAdata.samP;
riseDur = wf.stimpar.riseDur;
fallDur = wf.stimpar.fallDur;
riseStart = wf.stimpar.onset; % exact start of rising part
fallStart = riseStart + wf.stimpar.burstDur - fallDur;% idem falling
% exact start of falling part re the start of the falling portion:
relFallStart = fallStart - wf.GENdata.startFallPortion;

% distinguish cyclic vs literal storage 
if strcmp(stype,'cyclic'),
   iPart = 0; % counter for different portions of waveform
   % rising portion
   if ps(1)>0,
      iPart = iPart+1;
      samples = riseGate(ps(1), riseDur, riseStart, samP) ...
         .* (...
         lAmp*sin(lPhase+(0:(ps(1)-1))*lOmega) ...
         + cAmp*sin(cPhase+(0:(ps(1)-1))*cOmega) ...
         + hAmp*sin(hPhase+(0:(ps(1)-1))*hOmega) ...
         );
      lPhase = lPhase + lOmega*ps(1);
      cPhase = cPhase + cOmega*ps(1);
      hPhase = hPhase + hOmega*ps(1);
      BufDBNs(iPart) = storeSamples(samples, storage);
   end
   % cyclic buffer
   if ps(2)>0,
      iPart = iPart+1;
      samples = lAmp*sin(lPhase+(0:(ps(2)-1))*lOmega) ...
         + cAmp*sin(cPhase+(0:(ps(2)-1))*cOmega) ...
         + hAmp*sin(hPhase+(0:(ps(2)-1))*hOmega);
      lPhase = lPhase + lOmega*ps(2);
      cPhase = cPhase + cOmega*ps(2);
      hPhase = hPhase + hOmega*ps(2);
      BufDBNs(iPart) = storeSamples(samples, storage);
   end
   % remainder buffer
   if ps(3)>0,
      iPart = iPart+1;
      samples = lAmp*sin(lPhase+(0:(ps(3)-1))*lOmega) ...
         + cAmp*sin(cPhase+(0:(ps(3)-1))*cOmega) ...
         + hAmp*sin(hPhase+(0:(ps(3)-1))*hOmega);
      lPhase = lPhase + lOmega*ps(3);
      cPhase = cPhase + cOmega*ps(3);
      hPhase = hPhase + hOmega*ps(3);
      BufDBNs(iPart) = storeSamples(samples, storage);
   end
   % falling portion
   if ps(4)>0,
      iPart = iPart+1;
      samples = fallGate(ps(4), fallDur, relFallStart, samP) ...
         .* ( ...
         lAmp * sin(lPhase+(0:(ps(4)-1))*lOmega) ...
         + cAmp * sin(cPhase+(0:(ps(4)-1))*cOmega) ...
         + hAmp * sin(hPhase+(0:(ps(4)-1))*hOmega) ...
         );
      lPhase = lPhase + lOmega*ps(4);
      cPhase = cPhase + cOmega*ps(4);
      hPhase = hPhase + hOmega*ps(4);
      BufDBNs(iPart) = storeSamples(samples, storage);
   end
elseif strcmp(stype, 'literal'),
   % the whole thing in once
   % Phases at onset of steady ampl part
   lPhase2 = lPhase + lOmega*ps(1); 
   cPhase2 = cPhase + cOmega*ps(1); 
   hPhase2 = hPhase + hOmega*ps(1); 
   % Phase at onset falling part
   lPhase3 = lPhase2 + lOmega*ps(2); 
   cPhase3 = cPhase2 + cOmega*ps(2); 
   hPhase3 = hPhase2 + hOmega*ps(2); 
   BufDBNs = storeSamples([ ...
         riseGate(ps(1), riseDur, riseStart, samP) ...
         .* ( ... 
         lAmp*sin(lPhase+(0:(ps(1)-1))*lOmega) ...
         + cAmp*sin(cPhase+(0:(ps(1)-1))*cOmega) ...
         + hAmp*sin(hPhase+(0:(ps(1)-1))*hOmega) ) ...
      , ...         % steady-ampl
         lAmp*sin(lPhase2+(0:(ps(2)-1))*lOmega) ...
         + cAmp*sin(cPhase2+(0:(ps(2)-1))*cOmega) ...
         + hAmp*sin(hPhase2+(0:(ps(2)-1))*hOmega)  ...
      , ...    % falling
      fallGate(ps(3), fallDur, relFallStart, samP)...
      	.* ( ...
         lAmp*sin(lPhase3+(0:(ps(3)-1))*lOmega) ...
         + cAmp*sin(cPhase3+(0:(ps(3)-1))*cOmega) ...
         + hAmp*sin(hPhase3+(0:(ps(3)-1))*hOmega)  )...
           ],storage);
else, error(['unknown sxm storage type ' char(stype)]);
end
