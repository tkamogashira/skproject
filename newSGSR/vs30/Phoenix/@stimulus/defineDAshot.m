function [ST, ishot] = DefineDAshot(ST, waveform, Atten, Param, weight);
% stimulus/DefineDAshot - single shot of D/A conversion in terms of waveforms
%   [ST, I] = DefineDAshot(ST, [iL iR], Atten);
%   defines a single shot of DA conversion. iL and iR are the waveform
%   indexes of waveforms for left and right channels, respectively.
%   Zero-valued iL or iR mean: no D/A conversion over that channel.
%   Atten is the setting of the analog attenuators; pairs of
%   numbers are interpreted as [AttenLeft, AttenRight].
%   The output arg I is an index that identifies the DAshot.
%
%   [ST, I] = DefineDAshot(ST, [iL iR], Atten, P) also associates
%   a parameter object P with the DAshot. This is useful for
%   visual cueing of sounds and for the selection of sounds.
%
%   [ST, I] = DefineDAshot(ST, [iL iR], Atten, Param, [WL WR]), where
%   now L, R, WL, WR are N-element column vectors, indicates that the
%   stimulus to be played is a weighted sum of the N indexed waveforms.
%   Thus the waveform to be played is [sum(WL.*L,2) sum(WR.*R,2)], where
%   L and R stand for the left and right waveforms indexed by iL and iR.
%
%   See also Stimulus/DefineWaveform, Stimulus/AddChunk, stimDefinitionFS.

if  nargout<1, 
   error('No output argument using DefineDAshot. Syntax is: ''ST = DefineDAshot(ST,...)''.');
end

if nargin<4, Param = []; end % no parameter is associated with the DAshot
if nargin<5, weight = ones(size(waveform)); end % default weights

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
DAmode = 'B'; % assume both channels are active but see below
zmess = 'Waveforms in one channel of DAshot must either be all zeros or all non-zero values.';
if any(iwavL==0), 
   if ~all(iwavL==0), error(zmess); end
   WL = []; DAmode = 'R';
else, 
   WL = ST.waveform(iwavL);
   if ~all(1==[WL.DAchannel]),
      error('Left waveforms must have left DAchannel.');
   end;
end
if any(iwavR==0), 
   if ~all(iwavR==0), error(zmess); end
   WR = []; DAmode = 'L';
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
HardwareSettings = CollectInStruct(TDTsys, DAmode, Atten, Nsam, ifilt, Fsam);

ishot = 1+length(ST.DAshot);

ST.DAshot(ishot) = collectInStruct(HardwareSettings, waveform, weight, Param);












