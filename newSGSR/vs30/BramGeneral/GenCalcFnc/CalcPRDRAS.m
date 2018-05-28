function S = CalcPRDRAS(ArgIn, varargin)
%CALCPRDRAS    calculate Period Dot Raster
%   S = CALCPRDRAS(DS) calculates Period Dot Raster for subsequences of dataset
%   DS. A structure S is returned containing the calculated data.
%
%   S = CALCPRDRAS(Spt) calculates Period Dot Raster for a cell-array of spike-
%   trains. Attention! The properties 'anwin' and 'binfreq' must be fully defined.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 26-07-2005

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
for n = 1:NSubSeqs, Ras(n) = CalcPRDDotRaster(Spt(Param.isubseqs(n), Param.ireps{n}), Param.binfreq(n), Param); end    

%Reorganizing output and making sure all fieldnames are lowercase ...
MaxNCyc = max([Ras.NCyc]);
S = struct('calcfunc', mfilename, 'dsinfo', emptydataset(ds), 'param', Param, ...
    'ras', lowerfields(Ras), 'maxncyc', MaxNCyc);

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

Param.binfreq = abs(ExpandBinFreq(ArgIn, Param.binfreq, Param.isubseqs));
if isempty(Param.binfreq), error('Invalid value for property binfreq.'); end

if ~ischar(Param.intncycles) | ~any(strcmpi(Param.intncycles, {'yes', 'no'})), error('Property intncycles must be ''yes'' or ''no''.'); end

%-----------------------------------------------------------------
function Raster = CalcPRDDotRaster(Spt, BinFreq, Param)

if strcmpi(Param.intncycles, 'yes'), AnWin = ApplyIntNCycles(Param.anwin, BinFreq); 
else, AnWin = Param.anwin; end

%Subtraction of time constant from spiketimes must be done first ...
Spt = ApplyTimeSubTr(Spt, Param.timesubtr);
Spt = ApplyMinISI(Spt, Param.minisi);

Spt = cat(2, Spt{:}); BinPeriod = 1e3/BinFreq;
N = length(AnWin); [CycNr, Phase] = deal([]); NCyc = 0;
for n = 1:2:N,
    Spks = Spt(find(Spt >=  AnWin(n) & Spt < AnWin(n+1))); 
    CycNr = [CycNr, NCyc+fix((Spks-AnWin(n))/BinPeriod)+1];
    Phase = [Phase, rem(Spks, BinPeriod)/BinPeriod];
    %BUG: fixed on 26-07-2005: NCyc = max(CycNr); should be:
    NCyc = NCyc + diff(AnWin([0, 1]+n))./BinPeriod;
end
%The theoretical maximum number of cycles is the duration of the analysis
%window divided by the binning period. But the variable NCyc contains this
%value after completion of the for-loop so recalculation isn't necessary.
%WinDur = GetAnWinDur(AnWin); NCyc = WinDur./BinPeriod;

Raster = collectInStruct(Phase, CycNr, NCyc);

%-----------------------------------------------------------------