function ArgOut = EvalRC(varargin)
%EVALRC evaluate rate-level curve.
%   EVALRC(DS) evaluate rate-level curve for the supplied dataset. If an output argument
%   is supplied, then the calculated data is returned as a structure.
%
%   Optional properties and their values can be given as a comma-separated list.
%   To view list of all possible properties and their default value, use 'factory' as
%   only input argument.

% B. Van de Sande 01-08-2005

%After MURRAY B. SACHS, RAIMOND L. WINSLOW and BERND H.A. SOKOLOWSKI, "A Computational Model
%for Rate-Level Functions from Cat Auditory-Nerve Fibers", HEARING RESEARCH, 41 (1989) 61-70
%and ANNETTE M. TABERNER and M. CHARLES LIBERMAN, "Response Properties of Single Auditory
%Nerve Fibers in the Mouse", J. NEUROPHYSIOL 93 (2005) 557-569

%Attention! Extra exponential free parameter suggested in the article by Liberman is not
%implemented yet, because this free parameter compensates the effects of the compression
%threshold. 

%Datasets for testing:
%   ds1 = dataset('M0541B', '38-2-SPL');  EvalRC(ds1);
%   ds2 = dataset('M0541C', '59-2-SPL');  EvalRC(ds2);
%   ds3 = dataset('M0541C', '84-2-SPL');  EvalRC(ds3);
%   ds4 = dataset('M0541C', '111-3-SPL'); EvalRC(ds4);
%   ds5 = dataset('M0314',  '47-4-SPL');  EvalRC(ds5, 'halfmaxbmdval', 300);
%   ds6 = dataset('M0314',  '51-4-SPL');  EvalRC(ds6, 'isubseqs', 1:ds6.nrec-1, 'halfmaxbmdval', 2000);

%---------------------------------template--------------------------------------
Template.ds1.filename      = ''; 
Template.ds1.seqid         = '';
Template.ds1.icell         = NaN;
Template.ds1.iseq          = NaN;  
Template.tag               = 0;         %General purpose tag field
Template.createdby         = mfilename; %Name of MATLAB function that generated the data
Template.stim.burstdur     = NaN;       %Stimulus duration in ms ...
Template.stim.repdur       = NaN;       %Repetition duration in ms ...
Template.stim.modfreq      = NaN;       %Modulation frequency in Hz ...
Template.rc.db             = NaN;       %Intensity level in dB ...
Template.rc.rate           = NaN;       %Rate in spk/s ...
Template.rc.min            = NaN;       %Minimum rate in spk/s ...
Template.rc.dbatmin        = NaN;       %Sound pressure level in dB SPL at minimum rate ...
Template.rc.max            = NaN;       %Maximum rate in spk/s ...
Template.rc.dbatmax        = NaN;       %Sound pressure level in dB SPL at maximum rate ...
Template.rc.fit.accfrac    = NaN;       %Fraction of variance accounted for ...
Template.rc.fit.rmserr     = NaN;       %Root-mean-square error between the response data and the
                                        %best-fit curve in spk/s ...
Template.rc.fit.halfmaxbmd = NaN;       %Basilar membrane displacement at which driven rate
                                        %reaches one half of its maximum value ...
Template.rc.fit.compthr    = NaN;       %Compression threshold ...                                        
Template.rc.fit.compthrdb  = NaN;       %Compression threshold in dB SPL ...
Template.rc.fit.sponrate   = NaN;       %Spontaneous rate in spk/s ...
Template.rc.fit.satrate    = NaN;       %Driven saturation rate in spk/s ...
Template.rc.fit.expfactor  = NaN;       %Exponential factor on input to saturating nonlinearity ...
Template.rc.fit.db         = NaN;       %Intensity level in dB ...
Template.rc.fit.rate       = NaN;       %Rate in spk/s ...
Template.rc.fit.dynrange   = NaN;       %Dynamic range in db SPL ...
Template.rc.fit.dynrangex  = [NaN, NaN];%Abcissa values of dynamic range in db SPL ...
Template.thr.cf            = NaN;       %Characteristic frequency retrieved from threshold curve
Template.thr.sr            = NaN;       %Spontaneous rate retrieved from threshold curve
Template.thr.thr           = NaN;       %Threshold at characteristic frequency
Template.thr.q10           = NaN;       %Q10 retrieved from threshold curve
Template.thr.bw            = NaN;       %Width 10dB above threshold (Hz)

%-----------------------------default parameters------------------------------
%Calculation parameters 
DefParam.isubseqs     = 'all';     %The subsequences included in the analysis ... 
DefParam.anwin        = 'stimdur'; %The analysis window ...
DefParam.fit          = 'yes';     %'yes' or 'no' ...
DefParam.compfactor   = 1/3;       %The compression factor, should be between 0 and 1 ...
DefParam.samplefactor = 10;        %The factor used in oversampling the best-fit curve ...
DefParam.halfmaxbmdval= 'def';     %'def'(ault) or actual value ...
DefParam.compthrval   = 'def';     %'def'(ault) or actual value ...
DefParam.sponrateval  = 'def';     %'def'(ault) or actual value ...
DefParam.satrateval   = 'def';     %'def'(ault) or actual value ...
%Plot parameters 
DefParam.plot         = 'yes';     %'yes' or 'no' ...

%--------------------------------main program---------------------------------
%Parsing input arguments ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    if (nargout == 0), disp('Properties and their factory defaults:'); disp(DefParam);
    else, ArgOut = DefParam; end
    return;
else, [ds, Info, StimParam, Param] = ParseArgs(DefParam, varargin{:}); end

%Retrieve and calculate threshold curve information ...
Thr = RetrieveThrInfo(Info.ds1.filename, Info.ds1.icell);

%Extract rate curve information ...
RC = CalcRC(ds, Param);

%Display data ...
if strcmpi(Param.plot, 'yes'), PlotData(Thr, RC, Info, StimParam, Param); end

%Return output if requested ...
if (nargout > 0), 
    CalcData = Info; 
    [CalcData.stim, CalcData.rc, CalcData.thr] = deal(StimParam, RC, Thr);
    ArgOut = structtemplate(CalcData, Template, 'reduction', 'off');
end

%----------------------------------------------------------------------------
function [ds, Info, StimParam, Param] = ParseArgs(DefParam, varargin)

%Checking input arguments ...
NArgs = length(varargin);
if (NArgs < 1), error('Wrong number of input arguments.'); end
ds = varargin{1}; 
if ~isa(ds, 'dataset') & ~isa(ds, 'EDFdataset'), error('First argument should be dataset.'); end
if ~strcmpi(ds.indepname, 'Intensity'), error('Wrong type of dataset.'); end

%Retrieving properties and checking their values ...
Param = checkproplist(DefParam, varargin{2:end});
Param = CheckParam(ds, Param);

%Assembling dataset information ...
Info.ds1.filename  = lower(ds.filename);
Info.ds1.seqid     = lower(ds.seqid);
Info.ds1.icell     = ds.icell;
Info.ds1.iseq      = ds.iseq;
Info.idstr = sprintf('%s <%s>(#%d)', Info.ds1.filename, Info.ds1.seqid, Info.ds1.iseq);

%Collecting and reorganizing stimulus parameters ...
StimParam = GetStimParam(ds);

%Format parameter information ...
s = sprintf('AnWin = %s', Param2Str(Param.anwin, 'ms', 0));
s = strvcat(s, sprintf('CompFactor = %s', Param2Str(Param.compfactor, '', 2)));
s = strvcat(s, sprintf('iSubSeqs = %s', Param2Str(Param.isubseqs, '', 0)));
s = strvcat(s, sprintf('SampleFactor = %s', Param2Str(Param.samplefactor, '', 0)));
Param.str = s;

%----------------------------------------------------------------------------
function Param = CheckParam(ds, Param)

%Calculation parameters ...
Param.isubseqs = ExpandiSubSeqs(ds, Param.isubseqs);
if isempty(Param.isubseqs), error('Invalid value for property ''isubseqs''.'); end
Param.anwin = ExpandAnWin(ds, Param.anwin);
if isempty(Param.anwin), error('Invalid value for property ''anwin''.'); end
if ~any(strcmpi(Param.fit, {'yes', 'no'})), error('Property ''fit'' must be ''yes'' or ''no''.'); end
if ~isnumeric(Param.compfactor) | (length(Param.compfactor) ~= 1) | (Param.compfactor <= 0) | ...
        (Param.compfactor >= 1),
    error('Invalid value for property ''compfactor''.');
end 
if ~isnumeric(Param.samplefactor) | (length(Param.samplefactor) ~= 1) | (Param.samplefactor <= 0),
    error('Invalid value for property ''samplefactor''.');
end 
if ~strcmpi(Param.halfmaxbmdval, 'def') & ~(isnumeric(Param.halfmaxbmdval) & (length(Param.halfmaxbmdval) == 1)),
    error('Invalid value for property ''halfmaxbmd''.');
end
if ~strcmpi(Param.compthrval, 'def') & ~(isnumeric(Param.compthrval) & (length(Param.compthrval) == 1)),
    error('Invalid value for property ''compthrval''.');
end
if ~strcmpi(Param.sponrateval, 'def') & ~(isnumeric(Param.sponrateval) & (length(Param.sonrateval) == 1)),
    error('Invalid value for property ''sponrateval''.');
end
if ~strcmpi(Param.satrateval, 'def') & ~(isnumeric(Param.satrateval) & (length(Param.satrateval) == 1)),
    error('Invalid value for property ''satrateval''.');
end

%Plot parameters ...
if ~any(strcmpi(Param.plot, {'yes', 'no'})), error('Property ''plot'' must be ''yes'' or ''no''.'); end

%----------------------------------------------------------------------------
function StimParam = GetStimParam(ds)

StimParam.burstdur = min(ds.burstdur);
StimParam.repdur   = min(ds.repdur);
StimParam.nrep     = min(ds.nrep);
StimParam.modfreq  = ExtractFreqParam(ds, 'fmod');

%Format stimulus parameters ...
s = sprintf('BurstDur = %s ms', mat2str(StimParam.burstdur));
s = strvcat(s, sprintf('IntDur = %s ms', mat2str(StimParam.repdur)));
s = strvcat(s, sprintf('#Reps = %s', mat2str(StimParam.nrep)));
StimParam.str = s;

%----------------------------------------------------------------------------
function Str = Param2Str(V, Unit, Prec)

C = num2cell(V);
Sz = size(V);
N  = prod(Sz);

if (N == 1) | all(isequal(C{:})), Str = sprintf(['%.'  int2str(Prec) 'f%s'], V(1), Unit);
elseif (N == 2), Str = sprintf(['%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s'], V(1), Unit, V(2), Unit);
elseif any(Sz == 1), 
    Str = sprintf(['%.' int2str(Prec) 'f%s..%.' int2str(Prec) 'f%s'], min(V(:)), Unit, max(V(:)), Unit); 
else, 
    Str = sprintf(['%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s..%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s'], ...
        min(V(:, 1)), Unit, min(V(:, 2)), Unit, max(V(:, 1)), Unit, max(V(:, 2)), Unit); 
end

%----------------------------------------------------------------------------
function Thr = RetrieveThrInfo(FileName, iCell)

Thr = struct('cf', NaN, 'sr', NaN, 'thr', NaN, 'bw', NaN, 'q10', NaN, 'str', sprintf('No threshold\ninformation present.'));

try, %Retrieving data from SGSR server ...
    UD = getuserdata(FileName, iCell); if isempty(UD), error('To catch block ...'); end
    if ~isempty(UD.CellInfo) & ~isnan(UD.CellInfo.THRSeq),
        dsTHR = dataset(FileName, UD.CellInfo.THRSeq);
        [CF, SR, Thr, BW, Q10] = evalTHR(dsTHR, 'plot', 'no');
        s = sprintf('%s <%s>', dsTHR.FileName, dsTHR.seqID);
        s = strvcat(s, sprintf('CF = %s @ %s', Param2Str(CF, 'Hz', 0), Param2Str(Thr, 'dB', 0)));
        s = strvcat(s, sprintf('SR = %s', Param2Str(SR, 'spk/sec', 1)));
        s = strvcat(s, sprintf('BW = %s', Param2Str(BW, 'Hz', 1)));
        s = strvcat(s, sprintf('Q10 = %s', Param2Str(Q10, '', 1)));
        Str = s;
        Thr = lowerfields(CollectInStruct(CF, SR, Thr, BW, Q10, Str));
    end
catch, warning(sprintf('%s\nAdditional information from SGSR server is not included.', lasterr)); end

%----------------------------------------------------------------------------
function RC = CalcRC(ds, Param)

%Calculating rate level function ...
S = CalcRATE(ds, 'isubseqs', Param.isubseqs, 'anwin', Param.anwin);
RC.db      = S.curve.indepval;
RC.a       = DB2A(S.curve.indepval);
RC.n       = S.curve.n;
RC.rate    = S.curve.rate;
[RC.dbatmin, RC.min] = getmaxloc(RC.db, -RC.rate); RC.min = -RC.min;
RC.max     = S.curve.maxrate;
RC.dbatmax = S.curve.valatmax;

%Unconstrained minimization of the sum of squares function ...
try, 
    %When only one datapoint was collected ...
    if (ds.nrec <= 1) | strcmpi(Param.fit, 'no'), error('To catch block ...'); end
    %Fitting the model and find appropriate values for the free parameters ...
    Cstart = GetInitValues(RC, Param);
    CurWarn = warning; warning('off');
    C = fminsearch(@SSq, Cstart, optimset('display', 'off', 'largescale', 'off'), RC.a, RC.rate, Param);
    warning(CurWarn);
    [RC.fit.halfmaxbmd, RC.fit.compthr, RC.fit.compthrdb, RC.fit.sponrate, RC.fit.satrate] = ...
        deal(C(1), C(2), A2DB(C(2)), C(3), C(4));
    %Checking the goodness of fit ...
    [RC.fit.accfrac, RC.fit.rmserr] = CheckGoodnessOfFit(C, RC.a, RC.rate, Param);
    %Calculating the dynamic range ...
    %Attention! Inverse interpolation is used ...
    dynRngRates   = RC.fit.sponrate+[0.10,0.90].*RC.fit.satrate;
    dynRngLvlsEst = invInterpolate(runav(RC.rate, LvlRng2N(40, RC.db)), RC.db, dynRngRates); %Initial estimate ...
    RC.fit.db     = linspace(min([dynRngLvlsEst(1), RC.db(1)]), max([dynRngLvlsEst(2), RC.db(end)]), Param.samplefactor*length(RC.db));
    RC.fit.rate   = FitFunc(C, DB2A(RC.fit.db), Param.compfactor);
    RC.fit.dynrangex = invInterpolate(RC.fit.rate, RC.fit.db, dynRngRates);
    RC.fit.dynrangey = FitFunc(C, DB2A(RC.fit.dynrangex), Param.compfactor);
    RC.fit.dynrange  = diff(RC.fit.dynrangex);
catch,
    [RC.fit.accfrac, RC.fit.rmserr, RC.fit.halfmaxbmd, RC.fit.compthr, RC.fit.compthrdb, ...
       RC.fit.sponrate, RC.fit.satrate, RC.fit.db, RC.fit.rate, RC.fit.dynrange] = deal(NaN);
    [RC.fit.dynrangex, RC.fit.dynrangey] = deal([NaN, NaN]);
end

s = sprintf('Min = %s @ %s', Param2Str(RC.min, 'spk/s', 0), Param2Str(RC.dbatmin, 'dB', 0));
s = strvcat(s, sprintf('Max = %s @ %s', Param2Str(RC.max, 'spk/s', 0), Param2Str(RC.dbatmax, 'dB', 0)));
s = strvcat(s, sprintf('AccFrac = %s', Param2Str(RC.fit.accfrac*100, '%', 1)));
s = strvcat(s, sprintf('RMSerror = %s', Param2Str(RC.fit.rmserr, 'spk/s', 0)));
s = strvcat(s, sprintf('SponRate = %s', Param2Str(RC.fit.sponrate, 'spk/s', 1)));
s = strvcat(s, sprintf('SatRate = %s', Param2Str(RC.fit.satrate, 'spk/s', 1)));
s = strvcat(s, sprintf('CompThr = %s', Param2Str(RC.fit.compthrdb, 'dB', 0)));
s = strvcat(s, sprintf('HalfMaxBMd = %s', Param2Str(RC.fit.halfmaxbmd, '', 0)));
s = strvcat(s, sprintf('ExpFactor = %s', Param2Str(NaN, '', 0)));
s = strvcat(s, sprintf('DynRange = %s', Param2Str(RC.fit.dynrange, 'dB', 0)));
RC.str = s;

%-----------------------------------------------------------------------------
function Cstart = GetInitValues(RC, Param)

%Compression threshold should be set to mininum amplitude as initial value ...
if strcmpi(Param.compthrval, 'def'), CompThr = DB2A(RC.dbatmin);
else, CompThr = Param.compthrval; end

if strcmpi(Param.sponrateval, 'def'), SponRate = RC.min;
else, SponRate = Param.sponrateval; end

if strcmpi(Param.satrateval, 'def'), SatRate = RC.max-RC.min;;
else, SatRate = Param.satrateval; end

if strcmpi(Param.halfmaxbmdval, 'def'), 
    HalfMaxBMd = P2BMd(invInterpolate(RC.rate-SponRate, RC.a, SatRate/2), CompThr, Param.compfactor);
else, HalfMaxBMd = Param.halfmaxbmdval; end

Cstart = [HalfMaxBMd, CompThr, SponRate, SatRate];

%-----------------------------------------------------------------------------
function R = FitFunc(C, P, CompFactor)
%Input      : sound pressure level (dB SPL)
%Output     : respons (spk/s)
%Parameters :
HalfMaxBMd = C(1); %Basilar membrane displacement at which driven rate
                   %reaches one half of its maximum value ...
CompThr    = C(2); %Compression threshold in dB SPL ...
SponRate   = C(3); %Spontaneous rate in spk/s ...
SatRate    = C(4); %Driven saturation rate in spk/s ...

%Sound pressure to basilar membrane displacement ...
BMd = P2BMd(P, CompThr, CompFactor);

%Basilar membrane displacement to rate ...
Tmp = (BMd./HalfMaxBMd).^1.77;
R = SponRate + SatRate*(Tmp./(1+Tmp));

%-----------------------------------------------------------------------------
function BMd = P2BMd(P, CompThr, CompFactor)

%Sound pressure to basilar membrane displacement ...
BMd = P.*((1./(1+(P./CompThr).^2)).^CompFactor);

%-----------------------------------------------------------------------------
function Y = SSq(X, XData, YData, Param)
%Sum of square function for the function to be fit ...
Y = sum((YData-FitFunc(X, XData, Param.compfactor)).^2);

%-----------------------------------------------------------------------------
function [Fr, RMS] = CheckGoodnessOfFit(C, XData, YData, Param)
%Calculate fraction of variance accounted for, and RootMeanSquare of the
%error ...
Res = SSq(C, XData, YData, Param);
Var = sum((YData-mean(YData)).^2);

Fr = 1-(Res/Var);
N = length(YData); RMS = sqrt(Res/N);

%----------------------------------------------------------------------------
function N = LvlRng2N(Rng, Lvls)

N = Rng/mean(diff(Lvls));

%----------------------------------------------------------------------------
function Xi = invInterpolate(Y, X, Yi)

NY = numel(Y); minY = min(Y); maxY = max(Y);
N = numel(Yi); Xi = zeros(size(Yi));
for n = 1:N,
    if (Yi(n) >= maxY), idx = NY - [1,0];
    elseif (Yi(n) <= minY), idx = [1,2];
    else, idx = [max(find(Y < Yi(n))), min(find(Y > Yi(n)))]; end
    Xi(n) = interp1(Y(idx), X(idx), Yi(n), 'linear', 'extrap');
end

%----------------------------------------------------------------------------
function PlotData(Thr, RC, Info, StimParam, Param)

%Creating figure ...
FigHdl = figure('Name', sprintf('%s: %s', upper(mfilename), upper(Info.idstr)), ...
    'NumberTitle', 'off', ...
    'Units', 'normalized', ...
    'OuterPosition', [0 0.025 1 0.975], ... %Maximize figure (not in the MS Windows style!) ...
    'PaperType', 'A4', ...
    'PaperPositionMode', 'manual', ...
    'PaperUnits', 'normalized', ...
    'PaperPosition', [0.05 0.05 0.90 0.90], ...
    'PaperOrientation', 'portrait');

%Plot header ...
Str = { upper(Info.idstr), sprintf('\\rm\\fontsize{9}Created by %s @ %s', upper(mfilename), datestr(now))};
AxHDR = axes('Position', [0.40 0.90 0.15 0.10], 'Visible', 'off');
text(0.5, 0.5, Str, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', ...
    'FontWeight', 'bold', 'FontSize', 12);

%Plotting rate-level curve ...
PlotCurve([0.10, 0.10, 0.65, 0.80], RC, Thr, Param);

%Plotting information ...
AxCALC = axes('Position', [0.80 0.80 0.15 0.10], 'Visible', 'off');
text(0.5, 0.5, RC.str, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center');
AxPARAM = axes('Position', [0.80 0.60 0.15 0.10], 'Visible', 'off');
text(0.5, 0.5, Param.str, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center');
AxTHR = axes('Position', [0.80 0.20 0.15 0.10], 'Visible', 'off');
text(0.5, 0.5, Thr.str, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center');

%----------------------------------------------------------------------------
function PlotCurve(Pos, RC, Thr, Param)

%Setting up axes ...
[MinX, MaxX, MinY, MaxY] = GetAxLimits([RC.fit.db(:); RC.db(:)], [RC.fit.rate(:); RC.rate(:)]);
AxRC = axes('Position', Pos, 'Box', 'off', 'TickDir', 'out', 'xlim', [MinX, MaxX], 'ylim', [MinY, MaxY]);
xlabel('Intensity (db SPL)'); ylabel('Rate (spk/s)');

%Plotting original curve ...
line(RC.db, RC.rate, 'linestyle', '-', 'color', 'b', 'marker', '.');
%Plotting fit function ...
line(RC.fit.db, RC.fit.rate, 'linestyle', ':', 'color', 'k', 'marker', 'none');
%Plotting dynamic range ...
line(RC.fit.dynrangex, RC.fit.dynrangey, 'linestyle', 'none', 'marker', 'x', 'color', 'r');
line(RC.fit.dynrangex([1 1]), [MinY, MaxY], 'linestyle', ':', 'marker', 'none', 'color', 'r');
line(RC.fit.dynrangex([2 2]), [MinY, MaxY], 'linestyle', ':', 'marker', 'none', 'color', 'r');
%Plotting compression threshold ...
line(RC.fit.compthrdb([1 1]), [MinY, MaxY], 'linestyle', '-.', 'marker', 'none', 'color', 'k');

%----------------------------------------------------------------------------
function [MinX, MaxX, MinY, MaxY] = GetAxLimits(XData, YData)

MinX = min(deNaN(XData));
MaxX = max(deNaN(XData));
MinY = min(deNaN([YData(:); 0]));
MaxY = max(deNaN(YData))*1.05;

%----------------------------------------------------------------------------