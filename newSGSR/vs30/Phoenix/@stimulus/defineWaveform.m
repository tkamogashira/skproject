function [ST, iwav] = defineWaveform(ST, ChunkIndex, ChunkRep, ichan, ifilt, Fsam, maxSPL);
% stimulus/defineWaveform - define stimulus waveform in terms of chunks
%   [ST, I] = defineWaveform(ST, ChunkIndex, ChunkRep, ichan, ifilt, fsam) 
%   defines a waveform for stimulus object ST and returns its index I.
%   Vector ChunkIndex contains the indexes of the subsequent chunks 
%   of the waveform. Vector ChunkRep specifies the number of
%   repetitions of the respective chunks; ichan specifies over
%   which DAchannel the waveform is played (1|2 = Left|Right), and
%   ifilt and fsam are the filter index and sample frequency in Hz.
%   DAchannel may also be specified as 'L' or 'R' or as a DAchan parameter object.
%
%   Special values for ChunkIndex are negative integers -M. They represent
%   a chunk of M zeros. These zero chunks are realized by a combination
%   of the standard zero chunks prepared by the stimulus contructor.
%
%   defineWaveform(ST, ChunkIndex, ChunkRep, ichan, ifilt, fsam, maxSPL) 
%   also specifies the sound level in dB SPL of the waveform when it
%   is played non-attenuated. The default maxSPL is inf, i.e., unknown.
%
%   See also Stimulus/DefineDAshot, Stimulus/AddChunk, stimDefinitionFS.

if  nargout<1, 
   error('No output argument using defineWaveform. Syntax is: ''ST = defineWaveform(ST,...)''.');
end

if nargin<7, , maxSPL = inf; end % do not use NaN; logical evaluation of NaNs is buggy

Nchunk = length(ST.chunk);
if isvoid(ST),
   error('Waveforms may not be defined for a void stimulus object.');
elseif min(size(ChunkIndex))>1,
   error('ChunkIndex must be vector.');
elseif min(size(ChunkRep))>1,
   error('ChunkRep must be vector.');
elseif ~isequal(length(ChunkIndex), length(ChunkRep)),
   error('ChunkIndex and ChunkRep must have the same equal lengths.');
elseif any(ChunkIndex>Nchunk),
   error('Elements of ChunkIndex must be negative or indexes of existing chunks of ST.');
end

[ChunkIndex, ChunkRep] = localEvaluateSilentChunks(ChunkIndex, ChunkRep);

Nsam = [ST.chunk(ChunkIndex).Nsam]; % the lengths of the chunks
chunkList = [ChunkIndex(:), ChunkRep(:), Nsam(:)];
% total # samples. Take abs value to allow for negative Nreps = backward play
Nsam = sum(prod(chunkList(:,2:3),2));

% convert ichan to DAchan parameter 
if ischar(ichan), 
   DAchannel=parameter('activeDA',  ichan,  'LRB', 'DAchan');
elseif isnumeric(ichan), 
   DAchannel=parameter('activeDA',  ichan,  'chanNum', 'DAchan');
elseif isa(DAchannel, 'parameter'), % OK, we assume
else, error(['Invalid channel specification of class ''' class(ichan) '''.']);
end
% convert to 1|2
DAchannel = DAchannel.in_chanNum;
if ~ismember(DAchannel, [1 2]),
   error(['Invalid DA-channel specification ''' ichan '''.']);
end

iwav = 1+length(ST.waveform);
ST.waveform(iwav) = CollectInStruct(Nsam, Fsam, ifilt, DAchannel, chunkList, maxSPL);

% --------------------locals-----------------------------------------
function [ChunkIndex, ChunkRep] = localEvaluateSilentChunks(ChunkIndex, ChunkRep);
% replace negative entry by combination of zero buffers
ineg = find(ChunkIndex<0);
if isempty(ineg), return; end
lastineg = 0;
nzero = [1 10 100 1000];
[newIndex newRep] = deal([]);
ChunkIndex = ChunkIndex(:);
ChunkRep = ChunkRep(:);
for ii=ineg(:).'
   % copy previous, non-negative stuff into new index/rep variables
   newIndex = [newIndex; ChunkIndex(lastineg+1:ii-1)];
   newRep = [newRep; ChunkRep(lastineg+1:ii-1)];
   lastineg = ii;
   % decompose #samples (ab)using decimal notation
   Nsam = round(-ChunkIndex(ii));
   samStr = ['000' num2str(Nsam)];
   ns = str2num([samStr(1:end-3) ' ' samStr(end-2) ' ' samStr(end-1) ' ' samStr(end)]);
   newIndex = [newIndex; 4; 3; 2; 1];
   newRep = [newRep; ns(:)];
end
% copy last, non-negative stuff into new index/rep variables
ChunkIndex = [newIndex; ChunkIndex(lastineg+1:end)];
ChunkRep = [newRep; ChunkRep(lastineg+1:end)];




