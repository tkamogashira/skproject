function S = CalcPKL(ArgIn, varargin)
%CALCPKL    calculate Peak Latency curve.
%   S = CALCPKL(DS) calculates peak latency in ms versus independent variable
%   for dataset DS. A structure S is returned containing the calculated data.
%
%   S = CALCPKL(Spt) calculates peak latency versus subsequence number for a
%   cell-array of spiketrains. Attention! The property 'anwin' must be fully
%   defined.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 24-06-2004

%After PHILIP X. JORIS and PHILIP H. SMITH, "Temporal and Binaural Properties in
%Dorsal Cochlear Nucleus and Its Output Tract", JOURNAL OF NEUROSCIENCE, December 1,
%1998, 18(23):10157-10170

%------------------------Default parameters-----------------------
DefParam.isubseqs    = 'all';        %The subsequences included in the analysis.
                                     %By default all subsequences are included ('all') ...
DefParam.ireps       = 'all';        %The repetitions for the subsequences included 
                                     %in the analysis. By default all repetitions
                                     %are included ('all'). For multiple subsequences
                                     %this can be a cell-array with each element a
                                     %numerical vector representing the repetition
                                     %numbers to include for a particular subsequence ...
DefParam.srwin       = 'nostim';     %Spontaneous rate window in ms. This must be
                                     %a vector with two elements designating the window
                                     %in the post stimulus time that can be used to extract
                                     %spontaneous rate information. By default this is
                                     %from stimulus duration to repetition duration ('nostim') ...
DefParam.pkwin       = 'burstdur';   %Peak window in ms. This must be two-element vector 
                                     %designating a time-interval in which the onset peak
                                     %can be found. By default this is from 0 to stimulus
                                     %duration ('burstdur') ...
DefParam.binwidth    = 0.04;         %Binwidth in ms used in the Post-Stimulus-Time histogram ...
DefParam.runav       = 3;            %Number of bins used in smoothing the histogram ...
DefParam.minisi      = 0;            %Minimum interspike interval in ms ...
DefParam.timesubtr   = 0;            %Subtraction of a constant time in ms from
                                     %all spiketimes ...
DefParam.rateinc     = 20;           %Change in rate needed to account for beginning of peak.
                                     %Given in percent of driven rate of peak ...

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

%Extract values of independent variable and sort requested subsequences in ascending order
%according to those values ...
if isa(ArgIn, 'dataset'), IndepVal = ExtractIndepVal(ds, Param.isubseqs);
else, IndepVal = Param.isubseqs; end

[IndepVal, idx] = sort(IndepVal);
Param.isubseqs = Param.isubseqs(idx);
Param.ireps = Param.ireps(idx);

%Actual calculation ...
Curve = CalcPKLCurve(Spt, IndepVal, Param);    

%Reorganizing output and making sure all fieldnames are lowercase ...
S = struct('calcfunc', mfilename, 'dsinfo', emptydataset(ds), 'param', Param, ...
    'curve', lowerfields(Curve));

%-------------------------local functions-------------------------
function Param = ExpandParam(ArgIn, Param)

Param.isubseqs = ExpandiSubSeqs(ArgIn, Param.isubseqs); 
if isempty(Param.isubseqs), error('Invalid value for property isubseqs.'); end

Param.ireps = ExpandiReps(ArgIn, Param.isubseqs, Param.ireps);
if isempty(Param.ireps), error('Invalid value for property ireps.'); end

Param.srwin = ExpandAnWin(ArgIn, Param.srwin);
if (length(Param.srwin) ~= 2), error('Invalid value for property srwin.'); end
Param.pkwin = ExpandAnWin(ArgIn, Param.pkwin);
if (length(Param.pkwin) ~= 2), error('Invalid value for property pkwin.'); end

%To avoid inaccuracies introduced by the conversion of binwidth to number of
%bins, the offset of the peak window is adjusted to make the interval an integral
%number of bins ...
WinDur = abs(diff(Param.pkwin)); Param.nbin = floor(WinDur/Param.binwidth);
Param.pkwin = [Param.pkwin(1), Param.pkwin(1)+(Param.binwidth*Param.nbin)];

if ~isnumeric(Param.binwidth) | (length(Param.binwidth) ~= 1) | (Param.binwidth <= 0), error('Invalid value for property binwidth.'); end
if ~isnumeric(Param.runav) | (length(Param.runav) ~= 1) | (Param.runav < 0) | (Param.runav > Param.nbin), error('Invalid value for property runav.'); end
if ~isnumeric(Param.minisi) | (length(Param.minisi) ~= 1) | (Param.minisi < 0), error('Invalid value for property minisi.'); end
if ~isnumeric(Param.timesubtr) | (length(Param.timesubtr) ~= 1) | (Param.timesubtr < 0), error('Invalid value for property timesubtr.'); end
if ~isnumeric(Param.rateinc) | (length(Param.rateinc) ~= 1) | (Param.rateinc < 0) | (Param.rateinc > 100), error('Invalid value for property rateinc.'); end

%-----------------------------------------------------------------
function Curve = CalcPKLCurve(Spt, IndepVal, Param)

%Subtraction of time constant from spiketimes must be done first ...
Spt = ApplyTimeSubTr(Spt, Param.timesubtr);
Spt = ApplyMinISI(Spt, Param.minisi);

%Calculate Post-Stimulus-Time histogram of the peak window using CalcPSTH ...
PSTH = CalcPSTH(Spt, 'isubseqs', Param.isubseqs, 'ireps', Param.ireps, 'anwin', Param.pkwin, ...
    'nbin', Param.nbin, 'runav', Param.runav, 'minisi', 0, 'timesubtr', 0);

%Calculate spontaneous rate estimate ...
SRDur = abs(diff(Param.srwin));
SR = mean(cellfun('length', anwin(Spt, Param.srwin)), 2)'/SRDur;

%Extract the peak latency ...
NPST = length(PSTH.hist); [MaxRate, ThrRate, PkLat] = deal(repmat(NaN, 1, NPST));
for n = 1:NPST,
    %Calculate threshold rate ...
    [MaxRate(n), idx] = max(PSTH.hist(n).rate);
    PkTime = PSTH.hist(n).bincenters(idx);
    ThrRate(n) = SR(n) + (MaxRate(n)-SR(n))*(Param.rateinc/100);
    
    %Extract peak latency ...
    X = PSTH.hist(n).bincenters; Y = PSTH.hist(n).rate; N = length(X);
    idx = max(find(Y <= ThrRate(n) & X <= PkTime));
    if ~isempty(idx) & all(ismember(idx, 1:N)) & (diff(Y(idx+[0, 1])) ~= 0), 
        PkLat(n) = interp1(Y(idx + [0, 1]), X(idx + [0, 1]), ThrRate(n)); %Inverse interpolation ...
    end 
end    

Curve = collectInStruct(IndepVal, SR, MaxRate, ThrRate, PkLat);

%-----------------------------------------------------------------