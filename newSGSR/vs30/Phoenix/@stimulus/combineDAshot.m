function [ST, inew] = CombineDAshot(ST, ishot);
% stimulus/CombineDAshot - combine DAshots of stimulus into new DAshot
%   [ST, Icomb] = CombineDAshot(ST, I) defines a single shot of 
%   DA conversion with index Icomb that consists of a sequence
%   of existing DAshots with indices I.
%   All DAshots I must have the hardware settings, attenuator settings,
%   and weights. They may only differ in their waveforms and lengths.
%
%   See also Stimulus/DefineDAshot, Stimulus/DefineWaveform, stimDefinitionFS.

if  nargout<1, 
   error('No output argument using CombineDAshot. Syntax is: ''ST = DefineDAshot(ST,...)''.');
end

Nchan = size(waveform,2);
if isvoid(ST),
   error('DAshots may not be defined for a void stimulus object.');
elseif Nchan>2,
   error('Waveform must be column vector or Nx2 matrix.');
elseif ~isequal(size(waveform), size(weight)),
   error('Waveform and weight must have the same size.');
elseif size(Atten,2)>Nchan,
   error('Atten must have same width as waveform.');
elseif size(Atten,1)~=1,
   error('Atten must be scalar or length-2 row vector.');
end

if any(waveform(:))>length(ST.waveform),
   error('Waveform indexes exceed # defined waveforms.');
end

% get the waveform definitions themselves from their indexes
iwavL = waveform(:,1); iwavR = waveform(:,2);
zmess = 'Waveforms in one channel of DAshot must either be all zeros or all non-zero values.';
if any(iwavL==0), 
   if ~all(iwavL==0), error(zmess); end
   WL = [];
else, 
   WL = ST.waveform(iwavL);
   if ~all(1==[WL.DAchannel]),
      error('Left waveforms must have left DAchannel.');
   end;
end
if any(iwavR==0), 
   if ~all(iwavR==0), error(zmess); end
   WR = [];
else, 
   WR = ST.waveform(iwavR);
   if ~all(2==[WR.DAchannel]),
      error('Right waveforms must have right DAchannel.');
   end;
end

WV = [WL WR];
% all waveforms must have same Nsam and Fsam and ifilt
if ~all(0==diff([WV(:).Nsam])),
   error('All waveforms in DAshot must contain same # samples.');
elseif ~all(0==diff([WV(:).Fsam])),
   error('All waveforms in DAshot must contain same sample frequency.');
elseif ~all(0==diff([WV(:).ifilt])),
   error('All waveforms in DAshot must contain same filter index.');
end

% store the parameters of the DA shot
Nsam = WV(1).Nsam;
Fsam = WV(1).Fsam;
ifilt = WV(1).ifilt;
TDTsys = TDTsystem;
HardwareSettings = CollectInStruct(TDTsys, Atten, Nsam, ifilt, Fsam);

ishot = 1+length(ST.DAshot);

ST.DAshot(ishot) = collectInStruct(HardwareSettings, waveform, weight, Param);












