function S = CalcPRDH(ArgIn, varargin)
%CALCPRDH    calculate Period Histogram
%   S = CALCPRDH(DS) calculates Period Histograms for subsequences of dataset
%   DS. A structure S is returned containing the calculated data.
%
%   S = CALCPRDH(Spt) calculates Period Histograms for a cell-array of spike-
%   trains. Attention! The properties 'anwin' and 'binfreq' must be fully defined.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 24-06-2004

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
DefParam.viewport    = 'auto';       %Viewport, i.e. the actual view on the histogram.
                                     %The viewport is given in cycles and by default 
                                     %[0 1] ('auto') ...
DefParam.nbin        = 64;           %Number of bins in the requested viewport ...
DefParam.runav       = 0;            %Number of bins used in smoothing the histogram.
                                     %Smoothing does not change the extracted calculation
                                     %parameters ...
DefParam.minisi      = 0;            %Minimum interspike interval in ms ...
DefParam.timesubtr   = 0;            %Subtraction of a constant time in ms from
                                     %all spiketimes ...
DefParam.binfreq     = 'auto';       %The binning frequency in Hz. This can be a constant or
                                     %a numerical vector with the same length as the number
                                     %of subsequences to analyse. The following shortcuts are
                                     %included: 'carrier' (the frequency of the carrier), 
                                     %'modulation' (the frequency of the modulation). For bin-
                                     %aural datasets an optional suffix can be given to select
                                     %the frequency of which channel: 'binbeat', 'left' or 'right'.
                                     %By default this depends on the type of dataset ('auto') 
                                     %and is chosen according to the following decreasing relative
                                     %priorities:
                                     %       binbeat > left or right
                                     %       modulation > carrier
DefParam.intncycles  = 'no';         %Use an integer number of cycles for the 
                                     %calculation of the periodhistogram ('yes' or 'no') ...
%-----------------------------------------------------------------
%Checking input parameters ...
if (nargin < 1)
    error('Wrong number of input arguments.'); 
end
if (nargin == 1) & ischar(ArgIn) & strcmpi(ArgIn, 'factory')
    disp('Properties and their default values:');
    disp(DefParam);
    return;
end
if isa(ArgIn, 'dataset')
    ds = FillDataset(ArgIn); 
    Spt = ds.spt; %Make sure that dataset contains spiketime data ...
elseif iscell(ArgIn) & all(cellfun('isclass', ArgIn, 'double'))
    ds = dataset; Spt = ArgIn;    
else
    error('First argument should be dataset or cell-array of spiketrains.'); 
end

%Checking additional list of properties ...
Param = checkproplist(DefParam, varargin{:});
Param = ExpandParam(ArgIn, Param);

%Actual calculation ...
NSubSeqs = length(Param.isubseqs);
for n = 1:NSubSeqs
    Hist(n) = CalcPRDHistogram(Spt(Param.isubseqs(n), Param.ireps{n}), Param.binfreq(n), Param); 
end    

%Reorganizing output and making sure all fieldnames are lowercase ...
MaxN = max([Hist.N]); 
MaxRate = max([Hist.Rate]);
S = struct('calcfunc', mfilename, 'dsinfo', EmptyDataset(ds), 'param', Param, ...
    'hist', lowerFields(Hist), 'maxn', MaxN, 'maxrate', MaxRate);

%-------------------------local functions-------------------------
function Param = ExpandParam(ArgIn, Param)

Param.isubseqs = ExpandiSubSeqs(ArgIn, Param.isubseqs); 
if isempty(Param.isubseqs), error('Invalid value for property isubseqs.'); end

Param.ireps = ExpandiReps(ArgIn, Param.isubseqs, Param.ireps);
if isempty(Param.ireps), error('Invalid value for property ireps.'); end

Param.anwin = ExpandAnWin(ArgIn, Param.anwin);
if isempty(Param.anwin), error('Invalid value for property anwin.'); end

Param.viewport = ExpandViewPort(Param.viewport, [0 1]);
if isempty(Param.viewport) | any(Param.viewport > 1), error('Invalid value for property viewport.'); end

if ~isnumeric(Param.nbin) | (length(Param.nbin) ~= 1) | (Param.nbin <= 0), error('Invalid value for property nbin.'); end
if ~isnumeric(Param.runav) | (length(Param.runav) ~= 1) | (Param.runav < 0) | (Param.runav > Param.nbin), error('Invalid value for property runav.'); end
if ~isnumeric(Param.minisi) | (length(Param.minisi) ~= 1) | (Param.minisi < 0), error('Invalid value for property minisi.'); end
if ~isnumeric(Param.timesubtr) | (length(Param.timesubtr) ~= 1) | (Param.timesubtr < 0), error('Invalid value for property timesubtr.'); end

Param.binfreq = abs(ExpandBinFreq(ArgIn, Param.binfreq, Param.isubseqs));
if isempty(Param.binfreq), error('Invalid value for property binfreq.'); end

if ~ischar(Param.intncycles) | ~any(strcmpi(Param.intncycles, {'yes', 'no'})), error('Property intncycles must be ''yes'' or ''no''.'); end

%-----------------------------------------------------------------
function Hist = CalcPRDHistogram(Spt, BinFreq, Param)

if strcmpi(Param.intncycles, 'yes')
    AnWin = ApplyIntNCycles(Param.anwin, BinFreq); 
else
    AnWin = Param.anwin; 
end

%Subtraction of time constant from spiketimes must be done first ...
Spt = ApplyTimeSubtr(Spt, Param.timesubtr);
Spt = ApplyMinISI(Spt, Param.minisi);
Spt = ApplyAnWin(Spt, AnWin);

NRep = length(Spt); Spt = cat(2, Spt{:});
Edges = linspace(Param.viewport(1), Param.viewport(2), Param.nbin+1); BinWidth = Edges(2)-Edges(1);
%BinCenters = (Param.viewport(1)+BinWidth/2):BinWidth:(Param.viewport(2)-BinWidth/2);
BinCenters = Edges(1:(end-1))+(BinWidth/2);
BinPeriod = 1e3/BinFreq;
NCyc = abs(GetAnWinDur(AnWin))/BinPeriod; %Number of cycles in analysis window ...
WrapSpt = rem(Spt, BinPeriod)/BinPeriod;
if isempty(WrapSpt)
    WrapSpt = Inf; 
end; %To avoid crash dump but still use histc ...
N = histc(WrapSpt, Edges); N(end) = []; %Remove last garbage bin ...
BinDur = 1e-3*BinWidth*BinPeriod; %Duration of bin in s (also valid for different viewports) ...
Rate = N/NRep/NCyc/BinDur;
%The Frac-field gives the fraction of spikes in a bin to the total number of spikes
%in the current viewport (in percent) ...
NTotal = sum(N); if (NTotal ~= 0), Frac = 100*N/NTotal; else, Frac = N; end

%Performing running average on histogram ...
N    = runav(N, Param.runav);
Rate = runav(Rate, Param.runav);
Frac = runav(Frac, Param.runav);

NSpk = length(Spt);
[R, RaySign] = VectorStrength(Spt, BinFreq);
[R, Ph] = deal(abs(R), mod(angle(R), 2*pi)/2/pi);

Hist = CollectInStruct(BinCenters, N, Rate, Frac, BinWidth, NCyc, BinDur, R, Ph, RaySign, NSpk);

%-----------------------------------------------------------------