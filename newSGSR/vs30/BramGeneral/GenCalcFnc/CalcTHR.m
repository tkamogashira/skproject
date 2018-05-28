function S = CalcTHR(DS, varargin)
%CALCTHR   calculate threshold curve
%   S = CALCRATE(DS) calculates threshold curve for dataset DS. A structure
%   S is returned containing the calculated data.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 08-07-2005

%------------------------Default parameters-----------------------
DefParam.isubseqs = 'all'; %The subsequences included in the analysis.
                           %By default all subsequences are included ('all') ...
DefParam.thr      = 10;    %Threshold in dB for the bandwidth and Q-factor ...
DefParam.runav    = 0;     %Number of datapoints used in smoothing the
                           %threshold curve. Smoothing changes the extracted
                           %calculation parameters ...

%-----------------------------------------------------------------
%Checking input parameters ...
if (nargin < 1)
    error('Wrong number of input arguments.'); 
end
if (nargin == 1) & ischar(DS) & strcmpi(DS, 'factory')
    disp('Properties and their default values:');
    disp(DefParam);
    return
end
if ~isa(DS, 'dataset') | ~any(strcmpi(DS.stimtype , {'thr', 'th'}))
    error('First argument should be dataset containing threshold curve.'); 
end

%Checking additional property-list ...
Param = checkproplist(DefParam, varargin{:});
Param = ExpandParam(DS, Param);

%Actual calculation ...
Curve = CalcTHRCurve(DS, Param);    

%Reorganizing output and making sure all fieldnames are lowercase ...
S = struct('calcfunc', mfilename, 'dsinfo', EmptyDataset(DS), 'param', Param, ...
    'curve', lowerFields(Curve));

%-------------------------local functions-------------------------
function Param = ExpandParam(DS, Param)

%For SGSR datasets containing a threshold curve the nsub virtual field contains
%the number of subsequences that where requested, including the extra initial
%subsequence in which the spontaneous activity for the cell or fiber is recorded.
%This isn't the case for EDF datasets with schema SCH008, where nsub stands for
%the subsequences that where requested, excluding the SA collection ...
if strcmpi(DS.fileformat, 'sgsr')
    Nsub = DS.nsub-1;
else
    Nsub = DS.nsub; 
end

if ischar(Param.isubseqs) & strcmpi(Param.isubseqs, 'all')
    Param.isubseqs = 1:Nsub;
elseif ~isnumeric(Param.isubseqs) | ~any(size(Param.isubseqs) == 1) | ~all(ismember(Param.isubseqs, 1:Nsub))
    error('Invalid value for property isubseqs.'); 
else
    Param.isubseqs = Param.isubseqs(:)'; 
end

if ~isnumeric(Param.thr) | (length(Param.thr) ~= 1) | (Param.thr <= 0)
    error('Invalid value for property thr.'); 
end
if ~isnumeric(Param.runav) | (length(Param.runav) ~= 1) | (Param.runav < 0) | (Param.runav > length(Param.isubseqs)) 
    error('Invalid value for property runav.'); 
end

%-----------------------------------------------------------------
function Curve = CalcTHRCurve(DS, Param)

%Calculating CF and threshold at CF ...
Freq = DS.OtherData.thrCurve.freq(Param.isubseqs);
Thr  = DS.OtherData.thrCurve.threshold(Param.isubseqs);
[Freq, idx] = sort(Freq);
Thr = Thr(idx);

%Performing running average on threshold curve before extraction of
%calculation parameters ...
Thr = runav(Thr, Param.runav);

%Extracting CF and minimum threshold ...
[minThr, idx] = min(Thr);
CF = Freq(idx);

%Extracting Spontaneous Rate ...
switch lower(DS.fileformat),
case 'sgsr', 
    spt = DS.spt;
    SR = (length([spt{1,:}])*1000)/(DS.burstdur*length(spt));
case 'edf', 
    SR = DS.StimParam.ThrCurveParam.NSponRec * DS.StimParam.ThrCurveParam.MeanSA / DS.nrep; 
end

%Calculating Q and BW ...
BWThr = minThr + Param.thr;
warning('off','MATLAB:interp1:NaNinY'); %reduce output spam
BWf   = cintersect(Freq, -Thr, -BWThr);
warning('on','MATLAB:interp1:NaNinY'); 
BW    = abs(diff(BWf));
Q     = CF/BW;

Curve = CollectInStruct(Freq, Thr, CF, minThr, SR, BWf, BW, Q);

%-----------------------------------------------------------------