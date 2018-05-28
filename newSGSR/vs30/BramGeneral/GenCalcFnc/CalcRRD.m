function S = CalcRRD(ArgIn, varargin)
%CALCRRD    calculate repetition rate distribution
%   S = CALCRRD(DS) calculates repetition rate distribution for subsequences
%   of dataset DS. A structure S is returned containing the calculated data.
%
%   S = CALCRRD(Spt) calculates repetition rate distribution for a cell-array
%   of spiketrains. Attention! The properties 'anwin' must be fully defined.
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
DefParam.runav       = 0;            %Number of bins used in smoothing the curve.
                                     %Smoothing changes the extracted calculation parameters ...
DefParam.minisi      = 0;            %Minimum interspike interval in ms ...
DefParam.timesubtr   = 0;            %Subtraction of a constant time in ms from
                                     %all spiketimes ...
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
for n = 1:NSubSeqs, Distr(n) = CalcRRDistribution(Spt(Param.isubseqs(n), Param.ireps{n}), Param.ireps{n}, Param); end    

%Reorganizing output and making sure all fieldnames are lowercase ...
MaxN = max([Distr.N]); MaxRate = max([Distr.Rate]);
S = struct('calcfunc', mfilename, 'dsinfo', emptydataset(ds), 'param', Param, ...
    'distr', lowerfields(Distr), 'maxn', MaxN, 'maxrate', MaxRate);

%-------------------------local functions-------------------------
function Param = ExpandParam(ArgIn, Param)

Param.isubseqs = ExpandiSubSeqs(ArgIn, Param.isubseqs); 
if isempty(Param.isubseqs), error('Invalid value for property isubseqs.'); end

Param.ireps = ExpandiReps(ArgIn, Param.isubseqs, Param.ireps);
if isempty(Param.ireps), error('Invalid value for property ireps.'); end

Param.anwin = ExpandAnWin(ArgIn, Param.anwin);
if isempty(Param.anwin), error('Invalid value for property anwin.'); end

if ~isnumeric(Param.minisi) | (length(Param.minisi) ~= 1) | (Param.minisi < 0), error('Invalid value for property minisi.'); end
if ~isnumeric(Param.runav) | (length(Param.runav) ~= 1) | (Param.runav < 0) | (Param.runav > min(cellfun('prodofsize', Param.ireps))), 
    error('Invalid value for property runav.'); 
end
if ~isnumeric(Param.timesubtr) | (length(Param.timesubtr) ~= 1) | (Param.timesubtr < 0), error('Invalid value for property timesubtr.'); end

%-----------------------------------------------------------------
function Distr = CalcRRDistribution(Spt, RepNr, Param)

%Subtraction of time constant from spiketimes must be done first ...
Spt = ApplyTimeSubTr(Spt, Param.timesubtr);
Spt = ApplyMinISI(Spt, Param.minisi);
Spt = ApplyAnWin(Spt, Param.anwin);

WinDur = GetAnWinDur(Param.anwin);
N      = cellfun('length', Spt);
Rate   = N/WinDur;

%Performing running average on curves before extraction of parameters ...
N    = runav(N, Param.runav);
Rate = runav(Rate, Param.runav);

[AvgN, StdN] = deal(mean(N), std(N));
[AvgRate, StdRate] = deal(mean(Rate), std(Rate));

Distr = collectInStruct(RepNr, N, Rate, AvgN, StdN, AvgRate, StdRate);

%-----------------------------------------------------------------