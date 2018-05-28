function S = CalcRATE(ArgIn, varargin)
%CALCRATE   calculate rate versus indep. variable
%   S = CALCRATE(DS) calculates rate in spikes/sec versus independent variable
%   for dataset DS. A structure S is returned containing the calculated data.
%
%   S = CALCRATE(Spt) calculates rate versus subsequence number for a cell-array
%   of spiketrains. Attention! The property 'anwin' must be fully defined.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 26-07-2005

%% ---------------- CHANGELOG -----------------------
%  Thu Apr 21 2011  Abel   
%  - Added return DefParam on nargin<1


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
DefParam.runav       = 0;            %Number of datapoints used in smoothing the rate 
                                     %curve. Smoothing changes the extracted calculation
                                     %parameters ...
DefParam.minisi      = 0;            %Minimum interspike interval in ms ...
DefParam.timesubtr   = 0;            %Subtraction of a constant time in ms from
                                     %all spiketimes ...
DefParam.sort        = 'yes';        % This was the default behavior, we keep it this
                                     % way to not break existing programs
                                     
%-----------------------------------------------------------------
%Checking input parameters ...
if (nargin < 1)
	S = DefParam;
	return;
end

if (nargin == 1) && ischar(ArgIn) && strcmpi(ArgIn, 'factory'),
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

%Extract values of independent variable and sort requested subsequences in ascending order
%according to those values ...
if isa(ArgIn, 'dataset'), IndepVal = ExtractIndepVal(ds, Param.isubseqs);
else, IndepVal = Param.isubseqs; end

if (strcmpi(Param.sort, 'yes'))
    [IndepVal, idx] = sort(IndepVal);
    Param.isubseqs = Param.isubseqs(idx);
    Param.ireps = Param.ireps(idx);
end

%Actual calculation ...
Curve = CalcRATECurve(Spt, IndepVal, Param);    

%Reorganizing output and making sure all fieldnames are lowercase ...
S = struct('calcfunc', mfilename, 'dsinfo', EmptyDataset(ds), 'param', Param, ...
    'curve', lowerFields(Curve));

%-------------------------local functions-------------------------
function Param = ExpandParam(ArgIn, Param)

Param.isubseqs = ExpandiSubSeqs(ArgIn, Param.isubseqs); 
if isempty(Param.isubseqs), error('Invalid value for property isubseqs.'); end

Param.ireps = ExpandiReps(ArgIn, Param.isubseqs, Param.ireps);
if isempty(Param.ireps), error('Invalid value for property ireps.'); end

Param.anwin = ExpandAnWin(ArgIn, Param.anwin);
if isempty(Param.anwin), error('Invalid value for property anwin.'); end

if ~isnumeric(Param.runav) | (length(Param.runav) ~= 1) | (Param.runav < 0) | (Param.runav > length(Param.isubseqs)), 
    error('Invalid value for property runav.'); 
end

if ~isnumeric(Param.minisi) | (length(Param.minisi) ~= 1) | (Param.minisi < 0), error('Invalid value for property minisi.'); end
if ~isnumeric(Param.timesubtr) | (length(Param.timesubtr) ~= 1) | (Param.timesubtr < 0), error('Invalid value for property timesubtr.'); end

%-----------------------------------------------------------------
function Curve = CalcRATECurve(Spt, IndepVal, Param)

NSubSeqs = length(Param.isubseqs); 
[N, Avg, StDev, SEM, Rate, SEMRate] = deal(zeros(1, NSubSeqs));
for n = 1:NSubSeqs,
    SpkTr = Spt(Param.isubseqs(n), Param.ireps{n});
    %Subtraction of time constant from spiketimes must be done first ...
    SpkTr = ApplyTimeSubtr(SpkTr, Param.timesubtr);
    SpkTr = ApplyMinISI(SpkTr, Param.minisi);
    SpkTr = ApplyAnWin(SpkTr, Param.anwin);
    WinDur = GetAnWinDur(Param.anwin);
    
    %In the calculation of the standard error of the mean(SEM) for each
    %subsequence, the number of repetition is considered as the number of
    %samples and the number of spikes in each repetition are the actual 
    %samples ...
    NRep = length(SpkTr); sampleNs = cellfun('length', SpkTr);
    N(n) = sum(sampleNs); Avg(n) = N(n)/NRep; 
    %Using NRep-1 in the calculation of the sample standard deviation because
    %then this standard deviation is an unbiased estimator for the standard
    %deviation of the underlying population which is necessary for the 
    %subsequent calculation of the SEM ...
    if NRep > 1
        quot = NRep -1;
    else
        quot = NRep;
    end
    StDev(n) = sqrt(sum((Avg(n)-sampleNs).^2)/quot);
    %The standard error of the mean(SEM) is calculated as the standard deviation
    %of the population (here estimated by the sample standard deviation) divided
    %by the square root of the number of samples ...
    SEM(n) = StDev(n)/sqrt(NRep);
    %Rate is calulated as a constant fraction of the average number of spikes. 
    %This also applies for the calculation of the SEM in rate, because 
    %Var(aX) = (a^2)*Var(X) implies StDev(aX) = a*StDev(X) where X is a stochastic
    %variable ...
    Rate(n) = Avg(n)*(1e3/WinDur); SEMRate(n) = SEM(n)*(1e3/WinDur);
    
    %Old, replaced on 16-07-2005 ...
    %NRep = length(SpkTr); SpkTr = cat(2, SpkTr{:}); 
    %N(n) = length(SpkTr); Rate(n) = N(n)*1e3/WinDur/NRep;
end

%Performing running average on rate curve before extraction of
%calculation parameters ...
N    = runav(N, Param.runav);
Rate = runav(Rate, Param.runav);

[MaxN, idx] = max(N); MaxRate = max(Rate);
ValatMax = IndepVal(idx);

Curve = CollectInStruct(IndepVal, N, SEM, Rate, SEMRate, MaxN, MaxRate, ValatMax);

%-----------------------------------------------------------------