function S = CalcVSPH(ArgIn, varargin)
%CALCVSPH   calculate Vector Strength and Phase versus indep. variable
%   S = CALCVSPH(DS) calculates Vector Strength and Phase versus indep-
%   endent variable for dataset DS. A structure S is returned containing
%   the calculated data.
%
%   S = CALCVSPH(Spt) calculates Vector Strength and Phase versus sub-
%   sequence number for a cell-array of spiketrains. Attention! The 
%   properties 'anwin' and 'binfreq' must be fully defined.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 26-07-2005

%% ---------------- CHANGELOG -----------------------
%  Tue May 31 2011  Abel   
%   Added DefParam = CalcVSPH() support

%% Default parameters
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
DefParam.binfreq     = 'auto';       %see help expandBinFreq for the possibilities
DefParam.intncycles  = 'no';         %Use an integer number of cycles for the 
                                     %calculation of the periodhistogram ('yes' or 'no') ...
DefParam.raycrit     = 0.001;        %Criterion for rayleigh significance ...                                     
DefParam.compdelay   = 0;            %Compensating delay in ms ...
DefParam.phaseconv   = 'lag';        %Phase convention can be 'lead' or 'lag' ...
DefParam.phaselinreg = 'normal';     %'normal' or 'weigthed' linear regression of phase versus 
                                     %independent variable curve. If weighted regression is 
                                     %requested, then the weight of each datapoint is determined
                                     %by the sunchronicity rate (= vector strength multiplied by
                                     %rate) ...
DefParam.runav       = 0;            %Number of datapoints used in smoothing the curves. Smoothing
                                     %changes the extracted calculation parameters ...
DefParam.cutoffthr   = 3;            %Threshold for cutoff frequency estimation when synchronicity
                                     %curve is interpreted as a transfer function. By default, the
                                     %threshold is 3dB below the maximum synchronisation ...
DefParam.sort        = 'yes';        % This was the default behavior, we keep it this
                                     % way to not break existing programs

%% Program
%Checking input parameters ...
if (nargin < 1)
	S = DefParam;
	return;
end
if (nargin == 1) && ischar(ArgIn) && strcmpi(ArgIn, 'factory')
    disp('Properties and their default values:');
    disp(DefParam);
	S = DefParam;
    return;
end
if isa(ArgIn, 'dataset') %Make sure that dataset contains spiketime data ...
    ds = FillDataset(ArgIn);
    Spt = ds.spt;
elseif iscell(ArgIn) && all(cellfun('isclass', ArgIn, 'double'))
    ds = dataset;
    Spt = ArgIn;    
else
    error('First argument should be dataset or cell-array of spiketrains.');
end

%Checking additional property-list ...
Param = checkproplist(DefParam, varargin{:});
Param = CalcVSPH_ExpandParam(ArgIn, Param);

%Extract values of independent variable and sort requested subsequences in ascending order
%according to those values ...
if isa(ArgIn, 'dataset')
    IndepVal = ExtractIndepVal(ds, Param.isubseqs);
else
    IndepVal = Param.isubseqs;
end

if (strcmpi(Param.sort, 'yes'))
    [IndepVal, idx] = sort(IndepVal);
    Param.isubseqs = Param.isubseqs(idx);
    Param.ireps = Param.ireps(idx);
    Param.binfreq = Param.binfreq(idx);
end

%Actual calculation ...
Curve = CalcVSPHCurve(Spt, IndepVal, Param);    

%Reorganizing output and making sure all fieldnames are lowercase ...
S = struct('calcfunc', mfilename, 'dsinfo', EmptyDataset(ds), 'param', Param, ...
    'curve', lowerFields(Curve));
