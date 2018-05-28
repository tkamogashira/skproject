function S = CalcRGLH(ArgIn, varargin)
%CALCRGLH   calculate regularity analysis
%   S = CALCRGLH(DS) analyse the regularity over different repetitions for
%   the subsequences of dataset DS. A structure S is returned containing
%   the calculated data.
%
%   S = CALCRGLH(Spt) analyse the regularity for a cell-array of spike-
%   trains. Attention! The property 'anwin' must be fully defined.
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
DefParam.viewport    = 'auto';       %Viewport, i.e. the actual view on the histogram (in ms) ...
DefParam.nbin        = 64;           %Number of bins in the requested viewport ...
DefParam.runav       = 0;            %Number of bins used in smoothing the histogram.
                                     %Smoothing changes the extracted calculation parameters ...
DefParam.minnint     = 3;            %Mininum number of intervals in a specific bin ...
DefParam.minisi      = 0;            %Minimum interspike interval in ms ...
DefParam.timesubtr   = 0;            %Subtraction of a constant time in ms from
                                     %all spiketimes ...
DefParam.avgwin      = 'auto';       %Averaging window in ms ...
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

%Checking additional property-list ...
Param = checkproplist(DefParam, varargin{:});
Param = ExpandParam(ArgIn, Param);

%Actual calculation ...
NSubSeqs = length(Param.isubseqs);
for n = 1:NSubSeqs, Hist(n) = AnalyseRGL(Spt(Param.isubseqs(n), Param.ireps{n}), Param); end    

%Reorganizing output and making sure all fieldnames are lowercase ...
MaxMean = max([Hist.Mean]); MaxStd = max([Hist.Std]); MaxCV = max([Hist.CV]);
S = struct('calcfunc', mfilename, 'dsinfo', emptydataset(ds), 'param', Param, ...
    'hist', lowerfields(Hist), 'maxmean', MaxMean, 'maxstd', MaxStd, 'maxcv', MaxCV);

%-------------------------local functions-------------------------
function Param = ExpandParam(ArgIn, Param)

Param.isubseqs = ExpandiSubSeqs(ArgIn, Param.isubseqs); 
if isempty(Param.isubseqs), error('Invalid value for property isubseqs.'); end

Param.ireps = ExpandiReps(ArgIn, Param.isubseqs, Param.ireps);
if isempty(Param.ireps), error('Invalid value for property ireps.'); end

Param.anwin = ExpandAnWin(ArgIn, Param.anwin);
if isempty(Param.anwin), error('Invalid value for property anwin.'); end

Param.viewport = ExpandViewPort(Param.viewport, Param.anwin);
if isempty(Param.viewport), error('Invalid value for property viewport.'); end

if ~isnumeric(Param.nbin) | (length(Param.nbin) ~= 1) | (Param.nbin <= 0), error('Invalid value for property nbin.'); end
if ~isnumeric(Param.runav) | (length(Param.runav) ~= 1) | (Param.runav < 0) | (Param.runav > Param.nbin), error('Invalid value for property runav.'); end
if ~isnumeric(Param.minnint) | (length(Param.minnint) ~= 1) | (Param.minnint <= 0), error('Invalid value for property minnint.'); end
if ~isnumeric(Param.minisi) | (length(Param.minisi) ~= 1) | (Param.minisi < 0), error('Invalid value for property minisi.'); end
if ~isnumeric(Param.timesubtr) | (length(Param.timesubtr) ~= 1) | (Param.timesubtr < 0), error('Invalid value for property timesubtr.'); end

if ischar(Param.avgwin) & strcmpi(Param.avgwin, 'auto'), Param.avgwin = Param.anwin([1, end]);
elseif ~isnumeric(Param.avgwin) | ~isequal(sort(size(Param.avgwin)), [1, 2]) | any(Param.avgwin < 0) | ...
       (diff(Param.avgwin) < 0), 
   error('Invalid value for property avgwin.');
else, Param.avgwin = Param.avgwin(:)'; end

%-----------------------------------------------------------------
function Hist = AnalyseRGL(Spt, Param)

%Subtraction of time constant from spiketimes must be done first ...
Spt = ApplyTimeSubTr(Spt, Param.timesubtr);
Spt = ApplyMinISI(Spt, Param.minisi);
Spt = ApplyAnWin(Spt, Param.anwin);

%Bin post stimulus time and distribute intervals ...
Edges = linspace(Param.viewport(1), Param.viewport(2), Param.nbin+1); BinWidth = Edges(2)-Edges(1);
%BinCenters = (Param.viewport(1)+BinWidth/2):BinWidth:(Param.viewport(2)-BinWidth/2);
BinCenters = Edges(1:(end-1))+(BinWidth/2);
NRep = length(Spt); Intervals = cell(1, Param.nbin);
for nRep = 1:NRep,
    SpkTrain = Spt{nRep}; NSpk = length(SpkTrain);
    for nSpk = 1:(NSpk-1), 
        idx = find(histc(SpkTrain(nSpk), Edges));
        if (idx <= Param.nbin), Intervals{idx} = [Intervals{idx}, diff(SpkTrain([nSpk, nSpk+1]))]; end
    end
end

%Calculating mean and standard deviation for each bin ...
[Mean, Std] = deal(repmat(NaN, 1, Param.nbin));
N = cellfun('length', Intervals); NBins = find(N >= Param.minnint);
for n = NBins, [Mean(n), Std(n)] = deal(mean(Intervals{n}), std(Intervals{n})); end
N = sum(N); %Total number of intervals ...
%Calculation of coefficient of variation ...
CV = Mean./Std;

%Performing running average on histogram before extraction of parameters ...
Mean = runav(Mean, Param.runav);
Std  = runav(Std, Param.runav);
CV   = runav(CV, Param.runav);

%Calculation of average Mean, standard deviation and CV over averaging window ...
AvgWindow = round(Param.avgwin/BinWidth)*BinWidth;
idx = find((Edges(1:end-1) >= AvgWindow(1)) & (Edges(1:end-1) < AvgWindow(2)));
AvgMean = mean(deNaN(Mean(idx)));
AvgStd  = mean(deNaN(Std(idx)));
AvgCV   = mean(deNaN(CV(idx)));

Hist = collectInStruct(BinCenters, Mean, Std, CV, BinWidth, N, AvgMean, AvgStd, AvgCV);

%-----------------------------------------------------------------