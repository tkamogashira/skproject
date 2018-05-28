function [ST, ichunk] = AddChunk(ST, varargin);
% stimulus/AddChunk - add chunk to a stimulus object
%   [ST, I] = AddChunk(ST, Sam) adds a chunk 
%   to stimulus object ST. A chunk is a piece of a 
%   single-channel waveform. The samples of the chunk
%   are passed in a real numeric vector Sam.
%   The output argument I is the index of the
%   chunk in the stimulus. This index uniquely
%   identifies the chunk, which is useful when defining
%   waveforms for the stimulus.
%
%   [ST, I] = AddChunk(ST, Sam1, Sam2, ...) adds multiple
%   chunks in one call. In this case, I is a vector of indexes.
%
%   AddChunk(ST, Sam, 'foo') gives a name to the chunk.
%   names of chunks are case-insensitive and must be unique
%   among the chunks of ST. Note that this syntax only allows
%   the addition of a single chunk.
%
%   See also Stimulus/DefineWaveform, Stimulus/defineWaveform, stimDefinitionFS.

if  nargout<1, 
   error('No output argument using AddChunk. Syntax is: ''ST = AddChunk(ST,...)''.');
end

name = ''; Nadd = nargin-1; % default: all varargin elements are samples to be added
if nargin==3,
   if ischar(varargin{2}), 
      name = varargin{2};
      varargin = varargin(1);
      Nadd = 1;
   end
end

if isvoid(ST),
   error('Chunks may not be added to a void stimulus object.');
elseif ~isempty(name) & ismember(lower(name), lower({ST.chunk.name})),
   error(['Stimulus already contains a chunk named ''' name '''.']);
end

for ii=1:length(varargin), % add chunks one by one
   samples = varargin{ii};
   if ~isnumeric(samples),
      error('Samples of chunk must be numeric.');
   elseif ~isreal(samples),
      error('Complex samples of chunk are not allowed.');
   elseif min(size(samples))>1,
      error('Samples of chunk must be vector.')
   end
   samples = samples(:); % make column vector
   Nsam = length(samples); % it is convenient to store the length
   ichunk(ii) = 1+length(ST.chunk);
   storage = 'none';
   address = NaN;
   ST.chunk(ichunk(ii)) = collectInStruct(Nsam, samples, name, storage, address);
end






