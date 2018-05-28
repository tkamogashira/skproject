function S = CalcRAS(ArgIn, varargin)
%CALCRAS    assemble Dot Raster
%   S = CALCRAS(DS) assembles a Dot Raster for subsequences of dataset
%   DS. A structure S is returned containing the reassembled data.
%
%   S = CALCRAS(Spt) assembles a Dot Raster for a cell-array of spike-
%   trains. Attention! The property 'anwin' must be fully defined.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 22-07-2004

%------------------------Default parameters-----------------------
DefParam.isubseqs    = 'all';        %The subsequences included in the analysis.
                                     %By default all subsequences are included ('all') ...
DefParam.ireps       = 'all';        %The repetitions for the subsequences included 
                                     %in the analysis. By default all repetitions
                                     %are included ('all'). For multiple subsequences
                                     %this can be a cell-array with each element a
                                     %numerical vector representing the repetition
                                     %numbers to include for a particular subsequence ...
DefParam.anwin       = 'burstdur';   %Analysis window in ms. This must be
                                     %a vector with an even number of elements.
                                     %Each pair of this vector designates a time-
                                     %interval included in the calculation. By default
                                     %this is from 0 to stimulus duration ('burstdur') ...
DefParam.minisi      = 0;            %Minimum interspike interval in ms ...
DefParam.timesubtr   = 0;            %Subtraction of a constant time in ms from
                                     %all spiketimes ...
DefParam.binwidth    = Inf;          %The binwidth in ms used for tagging the spikepairs
                                     %that contribute to the peak of the autocorrelogram
                                     %of a subsequence, i.e. spikepairs with an interval
                                     %smaller than the supplied binwidth will be tagged.
                                     %By default the binwidth is Inf and thus tagging is 
                                     %turned off ...
DefParam.poolsubseqs = 'no';         %Pool the rasters for the different subsequences to
                                     %a single raster ('yes' or 'no') ...

%-----------------------------------------------------------------
%Checking input parameters ...
if (nargin < 1), error('Wrong number of input arguments.'); end
if (nargin == 1) & ischar(ArgIn) & strcmpi(ArgIn, 'factory'),
    disp('Properties and their default values:');
    disp(DefParam);
    return;
end
if isa(ArgIn, 'dataset'), ds = filldataset(ArgIn); Spt = ds.spt; %Make sure that dataset contains spiketime data ...
elseif iscell(ArgIn) & all(cellfun('isclass', ArgIn, 'double')), ds = dataset; Spt = ArgIn;    
else, error('First argument should be dataset or cell-array of spiketrains.'); end

%Checking additional list of properties ...
Param = checkproplist(DefParam, varargin{:});
Param = ExpandParam(ArgIn, Param);

%Actual calculation ...
NSubSeqs = length(Param.isubseqs);
for n = 1:NSubSeqs, Ras(n) = CalcDotRaster(Spt(Param.isubseqs(n), Param.ireps{n}), Param); end
if strcmpi(Param.poolsubseqs, 'yes'), Ras = PoolDotRaster(Ras); end    

%Reorganizing output and making sure all fieldnames are lowercase ...
S = struct('calcfunc', mfilename, 'dsinfo', emptydataset(ds), 'param', Param, ...
    'ras', lowerfields(Ras));

%-------------------------local functions-------------------------
function Param = ExpandParam(ArgIn, Param)

Param.isubseqs = ExpandiSubSeqs(ArgIn, Param.isubseqs); 
if isempty(Param.isubseqs), error('Invalid value for property isubseqs.'); end

Param.ireps = ExpandiReps(ArgIn, Param.isubseqs, Param.ireps);
if isempty(Param.ireps), error('Invalid value for property ireps.'); end

Param.anwin = ExpandAnWin(ArgIn, Param.anwin);
if isempty(Param.anwin), error('Invalid value for property anwin.'); end

if ~isnumeric(Param.minisi) | (length(Param.minisi) ~= 1) | (Param.minisi < 0), error('Invalid value for property minisi.'); end
if ~isnumeric(Param.timesubtr) | (length(Param.timesubtr) ~= 1) | (Param.timesubtr < 0), error('Invalid value for property timesubtr.'); end

if ~isnumeric(Param.binwidth) | (length(Param.binwidth) ~= 1) | (Param.binwidth < 0), error('Invalid value for property binwidth.'); end
if ~ischar(Param.poolsubseqs) | ~any(strcmpi(Param.poolsubseqs, {'yes', 'no'})), error('Property poolsubseqs must be ''yes'' or ''no''.'); end

%-----------------------------------------------------------------
function Raster = CalcDotRaster(Spt, Param)

%Subtraction of time constant from spiketimes must be done first ...
Spt = ApplyTimeSubTr(Spt, Param.timesubtr);
Spt = ApplyMinISI(Spt, Param.minisi);
Spt = ApplyAnWin(Spt, Param.anwin);

%Assembling Raster ...
NRep  = size(Spt, 2);
NSpks = cellfun('length', Spt); NSpk = sum(NSpks);
NCoSpk = 0; X = []; Y = []; Xac = []; Yac = [];
YSpacing = 0.5:1:NRep+0.5;
for n = 1:NRep,
    Spks = Spt{n};
    if (NSpks(n) > 0),
        if isinf(Param.binwidth),
            X = [X, vectorzip(Spks, Spks, repmat(NaN, 1, NSpks(n)))];
            Y1 = repmat(YSpacing(n), 1, NSpks(n)); Y2 = repmat(YSpacing(n+1), 1, NSpks(n));
            Y = [Y, vectorzip(Y1, Y2, Y2)];
        else,
            %Attention! Extremely slow implementation ...
            OtherSpks = cat(2, Spt{setdiff(1:NRep, n)});
            for i = 1:NSpks(n),
                Df = OtherSpks-Spks(i); N = sum((Df >= -Param.binwidth/2) & (Df <= +Param.binwidth/2)); NCoSpk = NCoSpk + N;
                if (N > 0), Xac = [Xac, Spks([i, i]), NaN]; Yac = [Yac, YSpacing([n, n+1, n+1])];
                else, X = [X, Spks([i, i]), NaN]; Y = [Y, YSpacing([n, n+1, n+1])]; end
            end
        end    
    end
end

Raster = collectInStruct(X, Y, Xac, Yac, NRep, NSpk, NCoSpk);

%-----------------------------------------------------------------
function Ras = PoolDotRaster(Ras)

N = length(Ras); NReps = cat(2, Ras.NRep);
Ras(1).Y   = ((Ras(1).Y-0.5)*0.8/NReps(1))+1-0.4;
Ras(1).Yac = ((Ras(1).Yac-0.5)*0.8/NReps(1))+1-0.4;
for n = 2:N, 
    Ras(1).X   = [Ras(1).X, Ras(n).X];
    Ras(1).Y   = [Ras(1).Y, ((Ras(n).Y-0.5)*0.8/NReps(n))+n-0.4];
    Ras(1).Xac = [Ras(1).Xac, Ras(n).Xac];
    Ras(1).Yac = [Ras(1).Yac, ((Ras(n).Yac-0.5)*0.8/NReps(n))+n-0.4];
end
Ras(1).NRep = sum(NReps);
Ras(1).NSpk = sum(cat(2, Ras.NSpk));
Ras(2:end) = [];

%-----------------------------------------------------------------