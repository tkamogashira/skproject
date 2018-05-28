function S = CalcPSTH(ArgIn, varargin)
%CALCPSTH    calculate PST Histogram
%   S = CALCPSTH(DS) calculates Post-Stimulus Time Histograms for the 
%   subsequences of dataset DS. A structure S is returned containing
%   the calculated data.
%
%   S = CALCPSTH(Spt) calculates PST-histogram for a cell-array of spike-
%   trains. Attention! The property 'anwin' must be fully defined.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.
%
%
%B. Van de Sande 02-08-2005

%------------------------Default parameters-----------------------
DefParam.isubseqs    = 'all';        %The subsequences included in the analysis.
                                     %By default all subsequences are included ('all') ...
DefParam.ireps       = 'all';        %The repetitions for the subsequences included 
                                     %in the analysis. By default all repetitions
                                     %are included ('all'). For multiple subsequences
                                     %this can be a cell-array with each element a
                                     %numerical vector representing the repetition
                                     %numbers to include for a particular subsequence ...
DefParam.anwin = 'repdur';
%edit P: standard the repdur has to be taken, to take all spikes into account
%DefParam.anwin       = 'burstdur';   %Analysis window in ms. This must be
                                     %a vector with an even number of elements.
                                     %Each pair of this vector designates a time-
                                     %interval included in the calculation. By default
                                     %this is from 0 to stimulus duration ('burstdur') ...
DefParam.viewport    = 'auto';       %Viewport, i.e. the actual view on the histogram (in ms) ...
DefParam.nbin        = 64;           %Number of bins in the requested viewport ...
DefParam.binscale    = 'lin';        %The binning scale used, can be 'lin' or 'log' ...
DefParam.runav       = 0;            %Number of bins used in smoothing the histogram ...
DefParam.minisi      = 0;            %Minimum interspike interval in ms ...
DefParam.timesubtr   = 0;            %Subtraction of a constant time in ms from
                                     %all spiketimes ...
DefParam.poolsubseqs = 'no';         %Pool the histograms for the different 
                                     %subsequences to a single histogram ('yes'
                                     %or 'no') ...
%-----------------------------------------------------------------
%Checking input parameters ...
if (nargin < 1)
    error('Wrong number of input arguments.');
end
if (nargin == 1) && ischar(ArgIn) && strcmpi(ArgIn, 'factory')
    disp('Properties and their default values:');
    disp(DefParam);
    return;
end

if isa(ArgIn, 'dataset')
    ds = FillDataset(ArgIn);
    Spt = ds.spt; %Make sure that dataset contains spiketime data ...
elseif iscell(ArgIn) && all(cellfun('isclass', ArgIn, 'double'))
    ds = dataset;
    Spt = ArgIn;
else
    error('First argument should be dataset or cell-array of spiketrains.');
end

%Checking additional property-list ...
Param = checkproplist(DefParam, varargin{:});
Param = ExpandParam(ArgIn, Param);

%Actual calculation ...
NSubSeqs = length(Param.isubseqs);
for n = 1:NSubSeqs
    Hist(n) = CalcPSTHistogram(Spt(Param.isubseqs(n), Param.ireps{n}), Param); 
end    
if strcmpi(Param.poolsubseqs, 'yes')
    Hist = PoolPSTHistograms(Hist); 
end    

%Reorganizing output and making sure all fieldnames are lowercase ...
MaxN = max([Hist.N]); MaxRate = max([Hist.Rate]);
S = struct('calcfunc', mfilename, 'dsinfo', EmptyDataset(ds), 'param', Param, ...
    'hist', lowerFields(Hist), 'maxn', MaxN, 'maxrate', MaxRate);

%-------------------------local functions-------------------------
function Param = ExpandParam(ArgIn, Param)

Param.isubseqs = ExpandiSubSeqs(ArgIn, Param.isubseqs); 
if isempty(Param.isubseqs)
    error('Invalid value for property isubseqs.');
end
Param.ireps = ExpandiReps(ArgIn, Param.isubseqs, Param.ireps);
if isempty(Param.ireps)
    error('Invalid value for property ireps.');
end
Param.anwin = ExpandAnWin(ArgIn, Param.anwin);
if isempty(Param.anwin)
    error('Invalid value for property anwin.');
end
Param.viewport = ExpandViewPort(Param.viewport, Param.anwin);
if isempty(Param.viewport)
    error('Invalid value for property viewport.');
end
if ~isnumeric(Param.nbin) || (length(Param.nbin) ~= 1) || (Param.nbin <= 0)
    error('Invalid value for property nbin.');
end
if ~ischar(Param.binscale) || ~any(strcmpi(Param.binscale, {'lin', 'log'}))
    error('Property binscale must be ''lin'' or ''log''.');
end
if ~isnumeric(Param.runav) || (length(Param.runav) ~= 1) || ...
        (Param.runav < 0) || (Param.runav > Param.nbin)
    error('Invalid value for property runav.');
end
if ~isnumeric(Param.minisi) || (length(Param.minisi) ~= 1) || ...
        (Param.minisi < 0)
    error('Invalid value for property minisi.');
end
if ~isnumeric(Param.timesubtr) || (length(Param.timesubtr) ~= 1) || ...
        (Param.timesubtr < 0)
    error('Invalid value for property timesubtr.');
end
if ~ischar(Param.poolsubseqs) || ~any(strcmpi(Param.poolsubseqs, {'yes', 'no'}))
    error('Property poolsubseqs must be ''yes'' or ''no''.');
end

%-----------------------------------------------------------------
function Hist = CalcPSTHistogram(Spt, Param)

%Subtraction of time constant from spiketimes must be done first ...
Spt = ApplyTimeSubtr(Spt, Param.timesubtr);
Spt = ApplyMinISI(Spt, Param.minisi);
%-!!!!!!-!!!!!-!!!!!-!!!!!
%Spt = ApplyAnWin(Spt, Param.anwin);

NRep = length(Spt); Spt = cat(2, Spt{:});

if strcmpi(Param.binscale, 'lin')
    BinEdges = linspace(Param.viewport(1), Param.viewport(2), Param.nbin+1); 
else
    BinEdges = logspace(log10(Param.viewport(1)), log10(Param.viewport(2)), Param.nbin+1); 
end

BinWidths = diff(BinEdges);
BinCenters = BinEdges(1:(end-1))+(BinWidths/2);

if isempty(Spt)
    Spt = Inf; 
end %To avoid crash dump but still use histc ...

N = histc(Spt, BinEdges); 
N(end) = []; %Remove last garbage bin ...
Rate = 1e3*N./BinWidths/NRep;
%The average binwidth is taken. For a linear binning scale all binwidths are equal
%thus the average is equal to this value ...
BinWidth = mean(BinWidths);
%The Frac-field gives the fraction of spikes in a bin to the total number of spikes
%in the current viewport (in percent) ...
NTotal = sum(N); 
if (NTotal ~= 0)
    Frac = 100*N/NTotal; 
else
    Frac = N; 
end

%Performing running average on histogram ...
N    = runav(N, Param.runav);
Rate = runav(Rate, Param.runav);
Frac = runav(Frac, Param.runav);

Hist = CollectInStruct(BinEdges, BinCenters, N, Rate, Frac, BinWidth);

%-----------------------------------------------------------------
function PoolHist = PoolPSTHistograms(Hist)

PoolHist = Hist(1); PoolHist.N = 0; PoolHist.Rate = 0; 
NHist = length(Hist);
for n = 1:NHist,
    PoolHist.N = PoolHist.N + Hist(n).N;
    PoolHist.Rate = PoolHist.Rate + Hist(n).Rate/NHist;
end
   
%-----------------------------------------------------------------