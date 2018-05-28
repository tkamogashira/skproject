function BufDBNs = stimgentone(wf, storage);

% STIMGENtone -  computes (realizes) tone waveform
% SYNTAX:
% function SD = stimgentone(wf, storage);
% INPUTS:
%    wf: waveform stimdef cell element.
%    storage: 'AP2' or 'MatLab' (where to store the samples)
%
% OUTPUT:
% BufDBNs is array holding AP2 or SampleLib indices (see stimGen)
% This function should only be called implicitly via stimGen -
% no complete arg checking.

phase = 2*pi*wf.GENdata.sphase; % starting phase in rad from cycles
omega = wf.GENdata.radPerSam; % angular freq in rad/sample
BufDBNs = zeros(size(wf.DAdata.bufSizes));
stype = wf.GENdata.storage;
% amplitudes
attFac = db2a(-wf.GENdata.numAtt); % numerical attenuation
ampl = attFac*maxMagDA;
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
      samples = ampl*riseGate(ps(1), riseDur, riseStart, samP) ...
         .* sin(phase+(0:(ps(1)-1))*omega); % sinusoid
      phase = phase + omega*ps(1);
      BufDBNs(iPart) = storeSamples(samples, storage);
   end
   % cyclic buffer
   if ps(2)>0,
      iPart = iPart+1;
      samples = ampl*sin(phase+(0:(ps(2)-1))*omega); % sinusoid
      phase = phase + omega*ps(2);
      BufDBNs(iPart) = storeSamples(samples, storage);
   end
   % remainder buffer
   if ps(3)>0,
      iPart = iPart+1;
      samples = ampl*sin(phase+(0:(ps(3)-1))*omega); % sinusoid
      phase = phase + omega*ps(3);
      BufDBNs(iPart) = storeSamples(samples, storage);
   end
   % falling portion
   if ps(4)>0,
      iPart = iPart+1;
      samples = ampl*fallGate(ps(4), fallDur, relFallStart, samP) ...
         .* sin(phase+(0:(ps(4)-1))*omega); % sinusoid
      phase = phase + omega*ps(4);
      BufDBNs(iPart) = storeSamples(samples, storage);
   end
elseif strcmp(stype, 'literal'),
   % the whole thing in once
   phase2 = phase + omega*ps(1); % Phase at onset of steady ampl part
   phase3 = phase2 + omega*ps(2); % Phase at onset falling part
   BufDBNs = storeSamples(ampl*[...
         riseGate(ps(1), riseDur, riseStart, samP) ...
         	.* sin(phase+(0:(ps(1)-1))*omega) ...
        sin(phase2+(0:(ps(2)-1))*omega) ... % steady-ampl
        fallGate(ps(3), fallDur, relFallStart, samP) ...
        	   .* sin(phase3+(0:(ps(3)-1))*omega) ],...
      storage);
else, error(['unknown tone storage type ' char(stype)]);
end
