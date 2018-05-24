function R = getrate(varargin)
%GETRATE   get rate of subsequence in dataset.
%   R = GETRATE(ds) gives the rate in spikes/sec for each of the recorded subsequences of dataset ds. The 
%   analysis window is from 0ms to the stimulus duration.
%
%   R = GETRATE(ds, NSub) gives rate of subsequences in vector NSub in spikes/sec. 
%   R = GETRATE(ds, NSub, AOn, AOff) sets the analysis onset and offset to AOn and AOff respectively.

%B. Van de Sande 27-03-2003

switch nargin
case 1
   ds   = varargin{1}; 
   NSub = 1:ds.nsubrecorded; 
   AOn  = 0;
   AOff = -1;
case 2
   ds   = varargin{1}; 
   NSub = varargin{2}; 
   AOn  = 0;
   AOff = -1;
case 3
   ds   = varargin{1}; 
   NSub = 1:ds.nsubrecorded; 
   AOn  = varargin{2};
   AOff = varargin{3};
case 4
   ds   = varargin{1}; 
   NSub = varargin{2}; 
   AOn  = varargin{3};
   AOff = varargin{4};
otherwise, error('Wrong number of input arguments.'); end

if isempty(ds.spt), error('Dataset doesn''t contain spiketimes.'); end
if ~all(ismember(NSub, 1:ds.nsubrecorded)), error('One of the requested subsequences wasn''t recorded or doesn''t exist.'); end 
if (AOff == -1), AOff = ds.burstdur(1); end

spt = anwin(ds.spt(NSub, :), [AOn, AOff]);

%Oude methode ... iteratie ...
%for n = 1:length(NSub)
%    R(n) = 1000 * length(cat(2, spt{n, :})) /(AOff-AOn) /ds.nrep;
%end

R = 1000 * sum(cellfun('length', spt), 2)' /(AOff - AOn) /ds.nrep;
