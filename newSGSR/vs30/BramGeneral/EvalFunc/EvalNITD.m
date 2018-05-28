function CalcData = EvalNITD(varargin)
%EVALNITD   evaluate dataset with NITD/NTD-stimulus
%   EVALNITD(dsP, dsN) evaluates NITD/NTD datasets dsP and dsN recorded
%   from an IC cell. dsP should contain responses to delayed noise token
%   with same polarity (designated NITD+), dsN responses to delayed noise
%   token with inversed polarity at one ear (NITD-).
%   EVALNITD(dsP, dsN, dsC) does the same but also plots responses
%   to delayed uncorrelated noise (NITD0).
%   EVALNITD(dsP, dsN, dsNRHO) if an NRHO-dataset is suplied for the cell, a
%   filter approximation can be derived for the binaural cell using the 
%   correlation-rate function.
%   EVALNITD(dsP, dsN, dsC, dsNRHO) combines the two previous syntaxes.
%
%   If an output argument is supplied, extracted data is returned as a 
%   scalar structure.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 08-07-2005

%-----------------------------template--------------------------------------
Template.ds1.filename         = '';  
Template.ds1.icell            = NaN;
Template.ds1.iseq             = NaN;         %Sequence number of noise NTD+ dataset
Template.ds1.seqid            = '';          %Identifier of noise NTD+ dataset
Template.ds2.iseq             = NaN;         %Sequence number of noise NTD- dataset
Template.ds2.seqid            = '';          %Identifier of noise NTD- dataset
Template.ds3.iseq             = NaN;         %Sequence number of NRHO dataset
Template.ds3.seqid            = '';          %Identifier of NRHO dataset
Template.tag                  = 0;           %General purpose tag field
Template.createdby            = mfilename;   %Name of MATLAB function that generated the data
Template.stim.repdur          = NaN;         %Interval duration in ms
Template.stim.burstdur        = NaN;         %Stimulus duration in ms
Template.stim.nrep            = [NaN, NaN];  %Number of repetitions ...
Template.stim.spl1            = [NaN, NaN];  %Recording SPL in dB for noise NTD+ dataset
Template.stim.spl2            = [NaN, NaN];  %Recording SPL in dB for noise NTD- dataset
Template.stim.spl             = NaN;         %Combined recording SPL 
Template.stim.noisestr1       = '';          %Information for noise token of NTD+ dataset
Template.stim.noisestr2       = '';          %Information for noise token of NTD- dataset
Template.stim.effspl1         = [NaN, NaN];  %Effective SPL for noise NTD+ dataset
Template.stim.effspl2         = [NaN, NaN];  %Effective SPL for noise NTD- dataset
Template.stim.effspl          = NaN;         %Combined effective SPL
Template.stim.effsplcf        = NaN;         %Center frequency of filter used for effective SPL computation
Template.stim.effsplbw        = NaN;         %Bandwidth of filter in octaves used for effective SPL computation
Template.nitdp.origmax        = NaN;
Template.nitdp.fitmax         = NaN;
Template.nitdp.origbestitd    = NaN;
Template.nitdp.origbestitdc   = NaN;
Template.nitdp.fitbestitd     = NaN;
Template.nitdp.fitbestitdc    = NaN;
Template.nitdp.secpeaks       = [NaN, NaN];
Template.nitdp.peakratio      = NaN;
Template.nitdp.fft.df         = NaN;
Template.nitdn.origmax        = NaN;
Template.nitdn.fitmax         = NaN;
Template.nitdn.origbestitd    = NaN;
Template.nitdn.origbestitdc   = NaN;
Template.nitdn.fitbestitd     = NaN;
Template.nitdn.fitbestitdc    = NaN;
Template.nitdn.peakratio      = NaN;
Template.nitdn.fft.df         = NaN;
Template.nitdc.origmax        = NaN;
Template.nitdc.origmean       = NaN;
Template.nitdc.fitmax         = NaN;
Template.nitdc.origbestitd    = NaN;
Template.nitdc.origbestitdc   = NaN;
Template.nitdc.fitbestitd     = NaN;
Template.nitdc.fitbestitdc    = NaN;
Template.nitdc.peakratio      = NaN;
Template.nitdc.fft.df         = NaN;
Template.corr.corrcoef        = NaN;
Template.corr.pcorrcoef       = NaN;
Template.corr.pktrratio       = NaN;
Template.corr.ypeak           = NaN;
Template.corr.meanrate        = NaN;
Template.corr.corrindex       = NaN;
Template.diff.max             = NaN;
Template.diff.bestitd         = NaN;
Template.diff.bestitdc        = NaN;
Template.diff.secpeaks        = [NaN, NaN];
Template.diff.hhw             = NaN;
Template.diff.hhwc            = NaN;
Template.diff.envmax          = NaN;
Template.diff.envpeak         = NaN;
Template.diff.envpeakc        = NaN;
Template.diff.scale           = NaN;
Template.diff.fft.res         = NaN;
Template.diff.fft.df          = NaN;
Template.diff.fft.bw          = NaN;
Template.diff.fft.gd          = NaN;
Template.diff.fft.fsd         = NaN;
Template.diff.fft.accfrac     = NaN;
Template.gabor.max            = NaN;
Template.gabor.bestitd        = NaN;
Template.gabor.bestitdc       = NaN;
Template.gabor.secpeaks       = [NaN, NaN];
Template.gabor.hhw            = NaN;
Template.gabor.hhwc           = NaN;
Template.gabor.envmax         = NaN;
Template.gabor.envpeak        = NaN;
Template.gabor.envpeakc       = NaN;
Template.filter.cf            = NaN;
Template.filter.bw            = NaN;
Template.filter.erb           = NaN;
Template.filter.gd            = NaN;
Template.filter.phd           = NaN;
Template.thr.cf               = NaN;         %Characteristic frequency retrieved from threshold curve
Template.thr.sr               = NaN;         %Spontaneous rate retrieved from threshold curve
Template.thr.thr              = NaN;         %Threshold at characteristic frequency
Template.thr.q10              = NaN;         %Q10 retrieved from threshold curve
Template.thr.bw               = NaN;         %Width 10dB above threshold (Hz)
Template.rcn.thr              = NaN;         %Noise threshold (dB) derived from NSPL curve ...

%-------------------------------parameters----------------------------------
%... plot parameters ...
DefParam.plot        = 'yes';         %y(es), n(o), d(iff) or f(ilter) ...
DefParam.plottext    = '';
DefParam.xrange      = [-Inf +Inf];   %in microseconds ...
DefParam.yrange      = [0 +70];       %in spk/sec ...
DefParam.fftxrange   = [0 5000];      %in Hz ...
DefParam.fftyrange   = [-40 10];      %in dB ...
DefParam.diagyrange  = [50 100];      %in % ...  
DefParam.dbscale     = 'no';
%... calculation parameters ...
DefParam.cache       = 'yes';         %'yes' or 'no' ...
DefParam.anwin       = [0 -1];        %in milliseconds ...
DefParam.calcrange   = [-Inf +Inf];   %in microseconds ...
DefParam.samplerate  = 0.5;           %in number of elements per microsecond ...
DefParam.runavunit   = '#';           %fraction of dominant period(#) or microsec(\mus) ...
DefParam.envrunav    = 1;             %in fraction of dominant period or in microsec ...
DefParam.fftrunav    = 100;           %in Hz ...
DefParam.corrsign    = 0.05;          %significance for correlatie coefficient ...
DefParam.anovasign   = Inf;           %significance for ANOVA-test on datasets ...
DefParam.gaborfit    = 'no';
DefParam.fitrange    = [-5000 +5000]; %in microseconds ...
DefParam.calcdf      = NaN;           %in Hz, NaN (automatic), 'cf' or 'df' ...
DefParam.accfracthr  = 25;            %in % ...
DefParam.filterrange = [0, 2000];     %in Hz ...
DefParam.filtersr    = 1;             %in number of elements per Hz ... 
DefParam.diagrange   = 500;           %in Hz ...
DefParam.diagsr      = 10;            %in number of elements per Hz ...
DefParam.effsplcf    = NaN;           %in Hz, NaN (automatic), 'cf' or 'df' ...
DefParam.effsplbw    = 1/3;           %in octaves ... 

%---------------------------------main program------------------------------
%Evaluate input arguments ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    disp('Properties and their factory defaults:')
    disp(DefParam);
    return;
else, [dsP, dsN, dsC, dsNRHO, Info, StimParam, Param] = evalparam(varargin, DefParam); end

%Retrieving data from SGSR server ...
try,
    UD = getuserdata(dsP); if isempty(UD), error('To catch block ...'); end
    %Threshold curve information ...
    if ~isempty(UD.CellInfo) & ~isnan(UD.CellInfo.THRSeq),
        dsTHR = dataset(Info.DataFile, UD.CellInfo.THRSeq);
        [CF, SR, Thr, BW, Q10] = evalTHR(dsTHR, 'plot', 'no');
        Str = {sprintf('\\bfThreshold curve:\\rm'); ...
                sprintf('%s <%s>', dsTHR.FileName, dsTHR.seqID); ...
                sprintf('CF = %s @ %s', Param2Str(CF, 'Hz', 0), Param2Str(Thr, 'dB', 0)); ...
                sprintf('SR = %s', Param2Str(SR, 'spk/sec', 1)); ...
                sprintf('BW = %s', Param2Str(BW, 'Hz', 1)); ...
                sprintf('Q10 = %s', Param2Str(Q10, '', 1))};
        Thr = lowerfields(CollectInStruct(CF, SR, Thr, BW, Q10, Str));
    else, Thr = struct([]); end 
    %Rate curve information ...
    if isfield(UD.CellInfo, 'RCNTHR'), 
        Rcn.thr = UD.CellInfo.RCNTHR;
        Rcn.str = {sprintf('\\bfIntensity curve:\\rm'); ...
                sprintf('THR = %s', Param2Str(UD.CellInfo.RCNTHR, 'dB', 0))};
    else, Rcn = struct([]); end
catch, 
    warning(sprintf('%s\nAdditional information from SGSR server is not included.', lasterr)); 
    [Thr, Rcn] = deal(struct([]));
end

%Always perform standard analysis ...
CalcData = calcSTANDARD(dsP, dsN, dsC, Thr, Param);

%????????????????????NOT UPGRADED????????????????????????
%Calculate filter-approximation if requested ...
if ~isempty(dsNRHO), CalcData.filter = calcFILTER(CalcData, StimParam, Param); 
else, CalcData.filter = struct([]); end
%????????????????????NOT UPGRADED????????????????????????

%Calculating effective SPL ...
FilterBW = Param.effsplbw;    
if isnumeric(Param.effsplcf), 
    if ~isnan(Param.effsplcf), FilterCF = Param.effsplcf;
    elseif ~isempty(Thr) & ~isnan(Thr.cf), FilterCF = Thr.cf;
    elseif ~isempty(CalcData.diff) & ~isnan(CalcData.diff.fft.df), FilterCF = CalcData.diff.fft.df;
    else, FilterCF = CalcData.nitdp.fft.df; end
elseif strcmpi(Param.effsplcf, 'cf'), 
    if ~isempty(Thr), FilterCF = Thr.cf;
    else, FilterCF = NaN; end    
elseif strcmpi(Param.effsplcf, 'df'), 
     if ~isempty(CalcData.diff) & ~isnan(CalcData.diff.fft.df), FilterCF = CalcData.diff.fft.df;
     else, FilterCF = CalcData.nitdp.fft.df; end    
else, FilterCF = NaN; end                

if isnan(FilterCF), 
    warning('Calculating overall effective SPL, because center frequency for filter cannot be extracted.');
    [FilterCF, FilterBW] = deal([]); 
    [StimParam.effsplcf, StimParam.effsplbw] = deal(NaN);
    FilterCFStr = '(overall)';
else, 
    StimParam.effsplcf = FilterCF;
    StimParam.effsplbw = FilterBW;
    FilterCFStr = sprintf('@ %s', Param2Str(FilterCF, 'Hz', 0)); 
end

try, 
    StimParam.effspl1(1) = min(CalcEffSPL(dsP, 'filtercf', FilterCF, 'filterbw', FilterBW, 'channel', 1));
    StimParam.effspl1(2) = min(CalcEffSPL(dsP, 'filtercf', FilterCF, 'filterbw', FilterBW, 'channel', 2));
    EffSPLp = CombineSPLs(StimParam.effspl1);
catch, warning(lasterr); [EffSPLp, StimParam.effspl1(1), StimParam.effspl1(2)] = deal(NaN); end    
if ~isempty(dsN), 
    try, 
        StimParam.effspl2(1) = min(CalcEffSPL(dsN, 'filtercf', FilterCF, 'filterbw', FilterBW, 'channel', 1));
        StimParam.effspl2(2) = min(CalcEffSPL(dsN, 'filtercf', FilterCF, 'filterbw', FilterBW, 'channel', 2));
        EffSPLn = CombineSPLs(StimParam.effspl2);
    catch, warning(lasterr); [EffSPLn, StimParam.effspl2(1), StimParam.effspl2(2)] = deal(NaN); end    
    if ~isnan(EffSPLp) & ~isnan(EffSPLn), StimParam.effspl = CombineSPLs(EffSPLp, EffSPLn);
    elseif ~isnan(EffSPLp), StimParam.effspl = EffSPLp;
    else, StimParam.effspl = EffSPLn; end
        
    StimParam.str = [StimParam.str; {sprintf('EffSPL(NTD+/NTD-) = %s//%s', Param2Str(StimParam.effspl1, '', 0), ...
                Param2Str(StimParam.effspl2, '', 0)); ...
                sprintf('EffSPL = %s %s', Param2Str(StimParam.effspl, 'dB', 0), FilterCFStr)}];
else, 
    [StimParam.effspl2(1), StimParam.effspl2(2)] = deal(NaN); 
    StimParam.effspl = EffSPLp;
    
    if (diff(StimParam.effspl1) == 0),
        StimParam.str = [StimParam.str; {sprintf('EffSPL = %s %s', Param2Str(StimParam.effspl, 'dB', 0), FilterCFStr)}];    
    else,
        StimParam.str = [StimParam.str; {sprintf('EffSPL = %s -> %s %s', Param2Str(StimParam.effspl1, '', 0), ...
                    Param2Str(StimParam.effspl, 'dB', 0), FilterCFStr)}];    
    end
end  

%Plotting data ...
if any(strncmpi(Param.plot, {'y', 'd'}, 1)), plotNITD(CalcData, Info, Thr, Rcn, StimParam, Param); end
%????????????????????NOT UPGRADED????????????????????????
if any(strncmpi(Param.plot, {'y', 'f'}, 1)) & ~isempty(dsNRHO), plotFILTER(CalcData, Info, StimParam, Param); end
%????????????????????NOT UPGRADED????????????????????????

%Return output parameters ...
if (nargout >= 1), 
    [CalcData.ds1, CalcData.ds2, CalcData.ds3, CalcData.stim, CalcData.thr, CalcData.rcn] = ...
        deal(dsP, dsN, dsNRHO, StimParam, Thr, Rcn);
    CalcData = structtemplate(CalcData, Template);
else, clear('CalcData'); end

%---------------------------------local functions---------------------------
function [dsP, dsN, dsC, dsNRHO, Info, StimParam, Param] = evalparam(ParamList, DefParam);

Nargin = length(ParamList); if Nargin < 1, error('Wrong number of input arguments.'); end

idx = min(find(cellfun('isclass', ParamList, 'char')));
if isempty(idx), NrDS = Nargin; else, NrDS = idx - 1; end

[dsP, dsN, dsC, dsNRHO] = deal(struct([]));
switch NrDS
case 0, error('First argument should be NTD-dataset.');    
case 1, dsP = ParamList{1};
case 2, [dsP, dsN] = deal(ParamList{1:2});     
case 3, 
    [dsP, dsN, ds] = deal(ParamList{1:3});
    if isa(ds, 'dataset') & any(strcmpi(ds.StimType, {'NRHO'})), dsNRHO = ds;
    elseif isa(ds, 'dataset'), dsC = ds; else error('Third argument should be NTD or NRHO-dataset.'); end    
case 4, [dsP, dsN, dsC, dsNRHO] = deal(ParamList{1:4});
end

%Retrieving properties and checking their values ...
Param = checkproplist(DefParam, ParamList{idx:end});
Param = checkparam(Param);

%Evaluate datasets ...
if ~CheckDS(dsP, '+'), warning(sprintf('Unknown stimulus type for 1st NTD dataset: ''%s''.', dsP.stimtype)); end
warning off; pP = anovads(dsP); warning on; if pP > Param.anovasign, error('First dataset didn''t pass ANOVA-test.'); end

[DataFile, CellNr] = deal(dsP.FileName, dsP.iCell);
        
if ~isempty(dsN),
    if ~CheckDS(dsN, '-'), warning(sprintf('Unknown stimulus type for second dataset: ''%s''.', dsN.stimtype)); end
    if ~isequal(DataFile, dsN.FileName) | ~isequal(CellNr, dsN.iCell), warning('Datasets aren''t from same cell.'); end
    
    warning off; pN = anovads(dsN); warning on;
    if pN > Param.anovasign, 
        warning('Second dataset didn''t pass ANOVA-test and is discarded.'); 
        pN = []; dsN = [];
    end
end

if ~isempty(dsC),
    if ~CheckDS(dsC, '0'), warning(sprintf('Unknown stimulus type for third dataset: ''%s''.\n Assuming NTD0 dataset.', dsC.stimtype)); end
    if ~isequal(DataFile, dsC.FileName) & ~isequal(CellNr, dsC.iCell), warning('Datasets aren''t from same cell.'); end
end

if ~isempty(dsNRHO),
    if ~isa(dsNRHO, 'dataset') | ~strcmpi(dsNRHO.StimType, 'NRHO'), error('Expecting NRHO dataset.'); end
    if ~isequal(DataFile, dsNRHO.FileName) & ~isequal(CellNr, dsNRHO.iCell), warning('Datasets aren''t from same cell.'); end
end    

%Assemble general information ...
Info.DataFile = DataFile;
Info.CellNr   = CellNr;
[dummy, Info.NITD.TestNrP, Info.NITD.dsIDP] = unraveldsID(dsP.SeqID);
if ~isempty(dsN), [dummy, Info.NITD.TestNrN, Info.NITD.dsIDN] = unraveldsID(dsN.SeqID);
else [Info.NITD.TestNrN, Info.NITD.dsIDN] = deal([]); end   
if ~isempty(dsC), [dummy, Info.NITD.TestNrC, Info.NITD.dsIDC] = unraveldsID(dsC.SeqID);
else [Info.NITD.TestNrC, Info.NITD.dsIDC] = deal([]); end    
if ~isempty(dsNRHO), [dummy, Info.NRHO.TestNr, Info.NRHO.dsID] = unraveldsID(dsNRHO.SeqID);
else Info.NRHO = struct([]); end    

%Format general information ...
if ~isempty(dsN) & ~isempty(dsNRHO),
    Info.idstr = sprintf('%s <%d-%d>, <%d-%d> & <%d-%d-NRHO> ', Info.DataFile, Info.CellNr, ...
        Info.NITD.TestNrP, Info.CellNr, Info.TestNrN, Info.CellNr, Info.NRHO.TestNr);
elseif ~isempty(dsN),
    Info.idstr = sprintf('%s <%d-%d> & <%d-%d>', Info.DataFile, Info.CellNr, ...
        Info.NITD.TestNrP, Info.CellNr, Info.NITD.TestNrN);
else, Info.idstr = sprintf('%s <%d-%d>', Info.DataFile, Info.CellNr, Info.NITD.TestNrP); end
Info.titlestr = {sprintf('\\bfNoise ITD-curves for %s <%d>\\rm', Info.DataFile, Info.CellNr); ...
    sprintf('\\fontsize{7}Created by %s @ %s', upper(mfilename), datestr(now))};

%Assemble stimulus parameters ...
StimParam = AssembleStimParam(dsP, dsN, dsC, dsNRHO);

%Substitution of shortcuts in properties ...
if Param.anwin(2) == -1, Param.anwin(2) = max(StimParam.burstdur); end

%Format parameter information ...
if all(isinf(Param.calcrange)), CalcRangeStr = 'auto';
else, CalcRangeStr = Param2Str(Param.calcrange, '\mus', 0); end
if isnan(Param.effsplcf), EffSPLCFStr = 'auto';
elseif ischar(Param.effsplcf), EffSPLCFStr = lower(Param.effsplcf);
else, EffSPLCFStr = Param2Str(Param.effsplcf, 'Hz', 0); end
if isnan(Param.calcdf), CalcDFStr = 'auto';
elseif ischar(Param.calcdf), CalcDFStr = lower(Param.calcdf);
else, CalcDFStr = Param2Str(Param.calcdf, 'Hz', 0); end
Param.str = {sprintf('\\bfCalculation parameters:\\rm'); ...
        sprintf('AnWin = %s', Param2Str(Param.anwin, 'ms', 0)); ...
        sprintf('CalcRange(SPLINE) = %s', CalcRangeStr); ...
        sprintf('SampleRate(SPLINE) = %s', Param2Str(Param.samplerate, '#/\mus', 1)); ...
        sprintf('RunAv(Env) = %.2f(%s)', Param.envrunav, Param.runavunit); ...
        sprintf('RunAv(Dft) = %s', Param2Str(Param.fftrunav, 'Hz', 0)); ...
        sprintf('Calc. DF = %s', CalcDFStr); ...
        sprintf('CF(EffSPL) = %s', EffSPLCFStr); ...
        sprintf('BW(EffSPL) = %s', Param2Str(Param.effsplbw, 'Oct', 2))};
if strncmpi(Param.gaborfit, 'y', 1),
    Param.str = [Param.str; {sprintf('FitRange(GABOR) = %s', Param2Str(Param.fitrange, '\mus', 0))}];
end
Param.filterstr = {sprintf('\\bfFilter parameters:\\rm'); ...
        sprintf('Threshold = %s', Param2Str(Param.accfracthr, '%', 0)); ...
        sprintf('Range = %s', Param2Str(Param.filterrange, 'Hz', 0)); ...
        sprintf('SampleRate = %s', Param2Str(Param.filtersr, '#/Hz', 0))};

%-----------------------------------------------------------------------------------------------
function Param = checkparam(Param)

if ~any(strncmpi(Param.plot, {'y', 'n', 'd', 'f'}, 1)), error('Plot-property should be yes or no.'); end
if ~any(strncmpi(Param.gaborfit, {'y', 'n'}, 1)), error('Gaborfit-property should be yes or no.'); end
if ~any(strncmpi(Param.runavunit, {'#', '\mus'}, 1)), error('Wrong value for property runavunit.'); end
if ~any(strncmpi(Param.dbscale, {'y','n'}, 1)), error('Wrong value for property dbscale.'); end

if ~ischar(Param.plottext) & ~iscellstr(Param.plottext), error('Plottext-property should be cell-array of strings or character array.'); end

if ~isinrange(Param.xrange, [-Inf +Inf]), error('Invalid value for property xrange.'); end
if ~isinrange(Param.yrange, [-Inf +Inf]), error('Invalid value for property yrange.'); end
if ~isinrange(Param.fftxrange, [0 +Inf]), error('Invalid value for property fftxrange.'); end
if ~isinrange(Param.fftyrange, [-Inf +Inf]), error('Invalid value for property fftyrange.'); end
if ~isinrange(Param.diagyrange, [-Inf, +Inf]), error('Wrong value for property diagyrange.'); end
if ~isinrange(Param.calcrange, [-Inf +Inf]), error('Invalid value for property calcxrange.'); end
if ~isinrange(Param.fitrange, [-Inf +Inf]), error('Invalid value for property fitrange.'); end
if ~isinrange(Param.filterrange, [-Inf, +Inf]), error('Wrong value for property filterrange.'); end

if (length(Param.samplerate) ~= 1) & (Param.samplerate <= 0), error('Invalid value for property samplerate.'); end
if (length(Param.envrunav) ~= 1) & (Param.envrunav < 0), error('Invalid value for property envrunav.'); end
if (length(Param.fftrunav) ~= 1) & (Param.fftrunav < 0), error('Invalid value for property fftrunav.'); end
if (length(Param.anovasign) ~= 1) & (Param.anovasign < 0), error('Invalid value for property anovasign.'); end
if (length(Param.corrsign) ~= 1) & (Param.corrsign < 0), error('Invalid value for property corrsign.'); end
if ~(isnumeric(Param.calcdf) & ((Param.calcdf > 0) | isnan(Param.calcdf))) & ...
        ~(ischar(Param.calcdf) & any(strcmpi(Param.calcdf, {'cf', 'df'}))), 
    error('Property calcdf must be positive integer, NaN, ''cf'' or ''df''.'); 
end
if length(Param.accfracthr) ~= 1 | Param.accfracthr < 0 | Param.accfracthr > 100, error('Wrong value for property accfracthr.'); end
if length(Param.filtersr) ~= 1 | Param.filtersr < 0, error('Wrong value for property filtersr.'); end
if length(Param.diagrange) ~= 1 | Param.diagrange < 0, error('Wrong value for property diagrange.'); end
if length(Param.diagsr) ~= 1 | Param.diagsr < 0, error('Wrong value for property diagsr.'); end
if ~(isnumeric(Param.effsplcf) & ((Param.effsplcf > 0) | isnan(Param.effsplcf))) & ...
        ~(ischar(Param.effsplcf) & any(strcmpi(Param.effsplcf, {'cf', 'df'}))), 
    error('Property effsplcf must be positive integer, NaN, ''cf'' or ''df''.'); 
end
if ~isnumeric(Param.effsplbw) | (length(Param.effsplbw) ~= 1) | (Param.effsplbw <= 0), error('Invalid value for property effsplbw.'); end

%-----------------------------------------------------------------------------------------------
function boolean = CheckDS(ds, Type)

if strcmpi(ds.FileFormat, 'idf/spk') & strcmpi(ds.StimType, 'ntd')
    switch Type
    case '+', boolean = (ds.Rho == +1);
    case '-', boolean = (ds.Rho == -1);
    case '0', boolean = (ds.Rho ==  0); 
    end
elseif strcmpi(ds.FileFormat, 'edf'),
    if isempty(strfind(lower(ds.StimType), 'nitd')), boolean = logical(0);
    else,     
        switch Type
        case '+', boolean = isequal(ds.GWParam.ID{1}, ds.GWParam.ID{2});
        case '-', boolean = strcmpi(ds.StimParam.GWParam.ID{1}, sprintf('%s-', ds.StimParam.GWParam.ID{2})) | ...
                strcmpi(ds.StimParam.GWParam.ID{1}, sprintf('-%s', ds.StimParam.GWParam.ID{2})) | ...
                strcmpi(ds.StimParam.GWParam.ID{2}, sprintf('%s-', ds.StimParam.GWParam.ID{1})) | ...
                strcmpi(ds.StimParam.GWParam.ID{2}, sprintf('-%s', ds.StimParam.GWParam.ID{1}));           
        case '0', boolean = ~isequal(ds.GWParam.ID{1}, ds.GWParam.ID{2}); end
    end
else boolean = logical(0); end

%---------------------------------------------------------------------------
function StimParam = AssembleStimParam(dsP, dsN, varargin)

if isempty(dsN),
    %Time variables ...
    StimParam.repdur   = dsP.repdur(1);
    StimParam.burstdur = unique(dsP.burstdur);
    
    %Number of repetitions ...
    StimParam.nrep = [dsP.nrep, NaN];
    
    %Increment ...
    Inc = unique(diff(denan(dsP.xval)));
    if length(Inc) == 1, StimParam.inc = [Inc, NaN];
    else, StimParam.inc = [NaN, NaN]; end
    
    %SPL ...
    SPLp = GetSPL(dsP); NRec = dsP.nrec;
    SPLp = unique(SPLp(1:NRec, :), 'rows');
    StimParam.spl1 = SPLp;
    StimParam.spl2 = [NaN, NaN];
    StimParam.spl  = CombineSPLs(SPLp(1), SPLp(2));
    
    %Noise ...
    StimParam.noisestr1 = AssembleNoiseStr(dsP);
    StimParam.noisestr2 = '';
else,
    %Time variables ...
    StimParam.repdur = dsP.repdur(1);
    if ~isequal(dsP.repdur(1), dsP.repdur(1)), warning('Repetition duration different for NTD datasets.'); end
    StimParam.burstdur = unique(dsP.burstdur);
    if ~isequal(unique(dsP.burstdur), unique(dsN.burstdur)), warning('Stimulus duration is not equal for NTD datasets.'); end

    %Number of repetitions ...
    StimParam.nrep = [dsP.nrep, dsN.nrep];
    
    %Increment ...
    Inc1 = unique(diff(deNaN(dsP.xval)));
    if length(Inc1) ~= 1, Inc1 = NaN; end
    Inc2 = unique(diff(deNaN(dsN.xval)));
    if length(Inc2) ~= 1, Inc2 = NaN; end
    StimParam.inc = [Inc1, Inc2];
    
    %SPL ...
    SPLp = GetSPL(dsP); NRec = dsP.nrec;
    SPLp = unique(SPLp(1:NRec, :), 'rows');
    StimParam.spl1 = SPLp;
    SPLp = CombineSPLs(SPLp(1), SPLp(2));
    
    SPLn = GetSPL(dsN); NRec = dsN.nrec;
    SPLn = unique(SPLn(1:NRec, :), 'rows');
    StimParam.spl2 = SPLn;
    SPLn = CombineSPLs(SPLn(1), SPLn(2));
    
    if ~isequal(SPLp, SPLn), warning('Recording SPL different for NTD datasets.'); end
    StimParam.spl = CombineSPLs(SPLp, SPLn);
    
    %Noise ...
    StimParam.noisestr1 = AssembleNoiseStr(dsP);
    StimParam.noisestr2 = AssembleNoiseStr(dsN);
end

%Checking other datasets ..
N = length(varargin);
for n = 1:N,
    if isempty(varargin{n}), continue; 
    else,
        if ~isequal(unique(varargin{n}.burstdur), StimParam.burstdur) | ...
           ~isequal(varargin{n}.repdur(1), StimParam.repdur) | ...
           ~isbetween(unique(varargin{n}.SPL), StimParam.spl + [-10, +10]),
            warning('Stimulus parameters are different for datasets.');
        end
    end    
end

%Format stimulus parameters ...
if isempty(dsN),
    if (diff(StimParam.spl1) == 0),
        StimParam.str = {sprintf('\\bfStimulus parameters:\\rm'); ...
                sprintf('Burst/IntDur = %s/%s', Param2Str(StimParam.burstdur, '', 0), Param2Str(StimParam.repdur, 'ms', 0)); ...
                sprintf('#Reps = %s Step = %s', Param2Str(StimParam.nrep(1), '', 0), Param2Str(StimParam.inc(1), '\mus', 0)); ...
                sprintf('Noise = %s', StimParam.noisestr1); ...
                sprintf('SPL = %s', Param2Str(StimParam.spl, 'dB', 0))};
    else,
        StimParam.str = {sprintf('\\bfStimulus parameters:\\rm'); ...
                sprintf('Burst/IntDur = %s/%s', Param2Str(StimParam.burstdur, '', 0), Param2Str(StimParam.repdur, 'ms', 0)); ...
                sprintf('#Reps = %s Step = %s', Param2Str(StimParam.nrep(1), '', 0), Param2Str(StimParam.inc(1), '\mus', 0)); ...
                sprintf('Noise = %s', StimParam.noisestr1); ...
                sprintf('SPL = %s -> %s', Param2Str(StimParam.spl1, '', 0), Param2Str(StimParam.spl, 'dB', 0))};
    end
else,
    StimParam.str = {sprintf('\\bfStimulus parameters:\\rm'); ...
            sprintf('Burst/IntDur = %s/%s', Param2Str(StimParam.burstdur, '', 0), Param2Str(StimParam.repdur, 'ms', 0)); ...
            sprintf('#Reps = %s Step = %s', Param2Str(StimParam.nrep, '', 0), Param2Str(StimParam.inc, '\mus', 0)); ...
            sprintf('Noise(NTD+) = %s', StimParam.noisestr1); ...
            sprintf('Noise(NTD-) = %s', StimParam.noisestr2); ...
            sprintf('SPL(NTD+/NTD-) = %s//%s', Param2Str(StimParam.spl1, '', 0), Param2Str(StimParam.spl2, '', 0)); ...
            sprintf('SPL = %s', Param2Str(StimParam.spl, 'dB', 0))};
end

%---------------------------------------------------------------------------
function Str = AssembleNoiseStr(ds)

if strcmpi(ds.fileformat, 'edf'),
    [dummy, dummy, FileName1] = unravelVMSPath(ds.GWParam.FileName{1});
    [dummy, dummy, FileName2] = unravelVMSPath(ds.GWParam.FileName{2});

    Str = sprintf('%s<%s>/%s<%s>', upper(FileName1), upper(ds.GWParam.ID{1}), upper(FileName2), upper(ds.GWParam.ID{2}));
else,
    BW  = GetNoiseBW(ds);
    Rho = ds.rho;
    Str = sprintf('%.0fHz-%.0fHz (Rho = %d)', BW, Rho);
end

%----------------------------------------------------------------------------
function Str = Param2Str(V, Unit, Prec)

C = num2cell(V);
Sz = size(V);
N  = prod(Sz);

if (N == 1) & isnan(V), Str = 'N/A';
elseif (N == 1) | all(isequal(C{:})), Str = sprintf(['%.'  int2str(Prec) 'f%s'], V(1), Unit);
elseif (N == 2), Str = sprintf(['%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s'], V(1), Unit, V(2), Unit);
elseif any(Sz == 1), 
    Str = sprintf(['%.' int2str(Prec) 'f%s..%.' int2str(Prec) 'f%s'], min(V(:)), Unit, max(V(:)), Unit); 
else, 
    Str = sprintf(['%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s..%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s'], ...
        min(V(:, 1)), Unit, min(V(:, 2)), Unit, max(V(:, 1)), Unit, max(V(:, 2)), Unit); 
end

%----------------------------------------------------------------------------
function CalcData = calcSTANDARD(dsP, dsN, dsC, Thr, Param)

CalcData.nitdp = calcNITD(dsP, Param);

if ~isempty(dsN), 
    CalcData.nitdn = calcNITD(dsN, Param);
    CalcData.diff  = calcDIFF(CalcData.nitdp, CalcData.nitdn, Param);
else, [CalcData.nitdn, CalcData.diff] = deal(struct([])); end

if ~isempty(dsC), CalcData.nitdc = calcNITD(dsC, Param);
else, CalcData.nitdc = struct([]); end

%Recalculate information using requested dominant frequency ...
if isnumeric(Param.calcdf), 
    if ~isnan(Param.calcdf), Freq = Param.calcdf;
    elseif ~isempty(Thr) & ~isnan(Thr.cf), Freq = Thr.cf;
    elseif ~isempty(CalcData.diff) & ~isnan(CalcData.diff.fft.df), Freq = CalcData.diff.fft.df;
    else, Freq = CalcData.nitdp.fft.df; end
elseif strcmpi(Param.calcdf, 'cf'), 
    if ~isempty(Thr), Freq = Thr.cf;
    else, Freq = NaN; end    
elseif strcmpi(Param.calcdf, 'df'), 
    if ~isempty(CalcData.diff) & ~isnan(CalcData.diff.fft.df), Freq = CalcData.diff.fft.df;
    else, Freq = CalcData.nitdp.fft.df; end    
else, Freq = NaN; end                

CalcData.nitdp = calcExtraNITD(CalcData.nitdp, Freq);
if ~isempty(CalcData.nitdn),
    CalcData.nitdn = calcExtraNITD(CalcData.nitdn, Freq);
    CalcData.diff  = calcExtraDIFF(CalcData.diff, Param, Freq);
    CalcData.gabor = calcGABOR(CalcData.diff, Param, Freq);
    CalcData.corr  = calcCORR(CalcData.nitdp, CalcData.nitdn, CalcData.nitdc, CalcData.diff, Param, Freq);
else, [CalcData.corr, CalcData.gabor] = deal(struct([])); end
if ~isempty(CalcData.nitdc), CalcData.nitdc = calcExtraNITD(CalcData.nitdc, Freq); end

%Assemble information ...
CalcData.nitdp.str = AssembleNITDStr(CalcData.nitdp, '\\bfNTD+\\rm');
if ~isempty(CalcData.nitdn),
    CalcData.nitdn.str = AssembleNITDStr(CalcData.nitdn, '\\bfNTD-\\rm');
    CalcData.diff.str  = AssembleDIFFStr(CalcData.diff);
    CalcData.gabor.str = AssembleGABORStr(CalcData.gabor);
    CalcData.corr.str  = AssembleCORRStr(CalcData.corr, Param);
end

%----------------------------------------------------------------------------
function NITD = calcNITD(ds, Param)

Nrec  = ds.nsubrecorded;
Range = [min(ds.indepval) max(ds.indepval)];
if ~isinf(Param.calcrange(1)) & (Param.calcrange(1) > Range(1)) & (Param.calcrange(1) < Range(2)), Range(1) = Param.calcrange(1); end;
if ~isinf(Param.calcrange(2)) & (Param.calcrange(2) < Range(2)), Range(2) = Param.calcrange(2); end;

%Positive ITD always designates a leading contralateral ear ...
if ~CheckBinParam(ds, 'itd'), 
    [X, idx] = sort(-ds.indepval(1:Nrec));
    Y = getrate(ds, idx, Param.anwin(1), Param.anwin(2));
    [Range(1), Range(2)] = swap(-Range(1), -Range(2));
else,
    [X, idx] = sort(ds.indepval(1:Nrec));
    Y = getrate(ds, idx, Param.anwin(1), Param.anwin(2));
end

PP   = spline(X, Y);
XFit = Range(1):1/Param.samplerate:Range(2);
YFit = ppval(PP, XFit);

OrigMax     = max(Y);
OrigMean    = mean(Y);
OrigBestITD = getmaxloc(X, Y, 0, [Range(1), Range(2)])/1000;
FitMax      = max(YFit);
FitMean     = mean(YFit);
FitBestITD  = getmaxloc(XFit, YFit)/1000;

FFT = spectana(XFit, detrend(YFit, 'constant'), 'runavunit', 'Hz', 'runavrange', Param.fftrunav, 'timeunit', 1e-6);
FFT.Res = abs(diff(FFT.Freq([1 2])));

NITD = RecLowerFields(CollectInStruct(X, Y, PP, XFit, YFit, OrigMax, OrigMean, OrigBestITD, ...
    FitMax, FitMean, FitBestITD, FFT));

%----------------------------------------------------------------------------
function NITD = calcExtraNITD(NITD, Freq)

Period = 1000/Freq;

[NITD.peakratio, NITD.xpeaks, NITD.ypeaks] = getpeakratio(NITD.xfit/1000, NITD.yfit, Freq); 
NITD.xpeaks       = NITD.xpeaks*1000;
NITD.origbestitdc = NITD.origbestitd/Period;
NITD.fitbestitdc  = NITD.fitbestitd/Period;
[dummy, dummy, NITD.secpeaks] = getpeaks(NITD.xfit/1000, NITD.yfit, 0, 1000/Freq);

%----------------------------------------------------------------------------
function DIFF = calcDIFF(NITDp, NITDn, Param)

RangeP = [min(NITDp.x), max(NITDp.x)];
RangeN = [min(NITDn.x), max(NITDn.x)];
Range = [ -min(abs([RangeP(1), RangeN(1)])), min([RangeP(2), RangeN(2)])];
if ~isinf(Param.calcrange(1)) & (Param.calcrange(1) > Range(1)) & (Param.calcrange(1) < Range(2)), Range(1) = Param.calcrange(1); end;
if ~isinf(Param.calcrange(2)) & (Param.calcrange(2) < Range(2)), Range(2) = Param.calcrange(2); end;

%Geometrisch gemiddelde van gemiddelden van NITD+ en NITD- als normalisatie gebruiken ...
%Attention! If ND-function is very bad, the arithmetic mean of the sampled cubic spline
%function can sometimes be negative, which results in a complex scale factor. Complex
%values are not allowed in structure-arrays when using STRUCTTOOLS!
YpMean = NITDp.fitmean; YnMean = NITDn.fitmean;
GeoMean = sqrt(YpMean * YnMean);
YpNorm = (NITDp.yfit/YpMean) *GeoMean;
YnNorm = (NITDn.yfit/YnMean) *GeoMean;
%Scaling factor for the ND-function that is scaled up is returned, which is the square 
%root of the ratio of both arithmetical means such that it is always bigger than one:
%       (Yp/Yp(avg))*sqrt(Yp(avg)*Yn(avg)) = Yp*sqrt(Yn(avg)/Yp(avg))
Scale = sqrt(max([YpMean, YnMean])/min([YpMean, YnMean]));

X = Range(1):1/Param.samplerate:Range(2);
Y = YpNorm(find((NITDp.xfit >= Range(1)) & (NITDp.xfit <= Range(2)))) - YnNorm(find((NITDn.xfit >= Range(1)) & (floor(NITDn.xfit) <= Range(2))));

FFT = spectana(X, Y, 'runavunit', 'Hz', 'runavrange', Param.fftrunav, 'timeunit', 1e-6);
FFT.Res = abs(diff(FFT.Freq([1 2])));

DIFF = RecLowerFields(CollectInStruct(X, Y, Scale, Range, FFT));

%----------------------------------------------------------------------------
function DIFF = calcExtraDIFF(DIFF, Param, Freq)

Period = 1000/Freq;

[DIFF.bestitd, DIFF.max, DIFF.secpeaks] = getpeaks(DIFF.x/1000, DIFF.y, 0, Period);
DIFF.bestitdc = DIFF.bestitd/Period;
Peaks = [DIFF.secpeaks, DIFF.bestitd];
[dummy, idx] = min(abs(Peaks));
DIFF.zeropeak = Peaks(idx);

%Evaluate running average parameters on enveloppe ...
if strcmpi(Param.runavunit, '\mus'), %Running average supplied in microseconds ...
    RunAvTsup = Param.envrunav;
    RunAvNsup = round(Param.envrunav*Param.samplerate);
    RunAvN = 2*round(RunAvNsup/2)+1; %Effective number of points overwhich RUNAV.M averages (always odd) ...
else,
    if isnan(Period), RunAvN = 0;
    else,    
        FracPer = Param.envrunav;
        RunAvTsup = 1e3*FracPer*Period; %Period supplied in milliseconds ...
        RunAvNsup  = round(RunAvTsup*Param.samplerate);
        RunAvN = 2*round(RunAvNsup/2)+1; %Effective number of points overwhich RUNAV.M averages (always odd) ...
    end
end
DIFF.env = runav(abs(hilbert(DIFF.y)), RunAvN);
[DIFF.envpeak, DIFF.envmax] = getmaxloc(DIFF.x, DIFF.env); 
DIFF.envpeak = DIFF.envpeak/1000;
DIFF.envpeakc = DIFF.envpeak/Period;
DIFF.intersect = cintersect(DIFF.x, DIFF.env, DIFF.envmax/2); 
DIFF.hhw  = diff(DIFF.intersect)/1000;
DIFF.hhwc = DIFF.hhw/Period;

%----------------------------------------------------------------------------
function CORR = calcCORR(NITDp, NITDn, NITDc, DIFF, Param, Freq)

%Correlation coefficient ...
Xi = intersect(ceil(NITDp.x*10)/10, ceil(NITDn.x*10)/10);
Xi = Xi(find((Xi >= -1000) & (Xi <= +1000)));
if ~isempty(Xi), [pCorrCoef, CorrCoef] = signcorr(NITDp.y(find(ismember(ceil(NITDp.x*10)/10, Xi))), NITDn.y(find(ismember(ceil(NITDn.x*10)/10, Xi))));
else [pCorrCoef, CorrCoef] = deal(NaN); end 

%Peak/Trougher ratio ...
Peak      = NITDp.fitmax;
Trougher  = interp1(NITDn.xfit, NITDn.yfit, NITDp.fitbestitd*1000);
PkTrRatio = min([Peak, Trougher])/max([Peak, Trougher]);

%Calculating correlation index ...
[CorrIndex, MeanRate, Xpeak, Ypeak, Xroots, Yroots] = CalcCorrIndex(NITDp, NITDn, NITDc, DIFF, Freq);

CORR = RecLowerFields(CollectInStruct(CorrCoef, pCorrCoef, Peak, Trougher, PkTrRatio, CorrIndex, ...
    MeanRate, Xpeak, Ypeak, Xroots, Yroots));

%----------------------------------------------------------------------------
function GABOR = calcGABOR(DIFF, Param, Freq)

Period = 1000/Freq;

[X, Y, Env, Constants] = gaborfit(DIFF.x, DIFF.y, Param.fitrange, Param.samplerate); 

[BestITD, Max, SecPeaks] = getpeaks(X/1000, Y, 0, Period);
BestITDc = BestITD/Period;
Peaks = [SecPeaks, BestITD];
[dummy, idx] = min(abs(Peaks));
ZeroPeak = Peaks(idx);

[EnvPeak, EnvMax] = getmaxloc(X, Env); EnvPeak = EnvPeak/1000;
EnvPeakc = EnvPeak/Period;
InterSect = cintersect(X, Env, EnvMax/2); 
HHW  = diff(InterSect)/1000;
HHWc = HHW/Period;

GABOR = RecLowerFields(CollectInStruct(X, Y, Env, Constants, Max, BestITD, BestITDc, ...
        SecPeaks, ZeroPeak, EnvMax, EnvPeak, EnvPeakc, InterSect, HHW, HHWc));

%----------------------------------------------------------------------------
function [CorrIndex, MeanRate, Xpeak, Ypeak, Xroots, Yroots] = CalcCorrIndex(NITDp, NITDn, NITDc, DIFF, DomFreq)

%Get highest peak nearest to zero ...
DomPer     = 1000/DomFreq;
Delay      = abs(diff(NITDp.x([1 end])))*1e-3;
NPeriods   = floor(Delay/DomPer);
StartDelay = -floor(1e-3*abs(NITDp.x(1))/DomPer)*DomPer;
[Xpeaks, Ypeaks] = deal(zeros(1, NPeriods));
for n = 1:NPeriods,
    idx = find((NITDp.x/1000 >= StartDelay+((n-1)*DomPer)) & (NITDp.x/1000 <= StartDelay+(n*DomPer))); 
    [Xpeaks(n), Ypeaks(n)] = GetMaxLoc(NITDp.x(idx), NITDp.y(idx));
end
[dummy, idx] = sort(abs(Xpeaks)); [Xpeaks, Ypeaks] = deal(Xpeaks(idx), Ypeaks(idx));
idx = min(find(diff(Ypeaks) <= 0));
if ~isempty(idx), [Xpeak, Ypeak] = deal(Xpeaks(idx), Ypeaks(idx));
else, [Xpeak, Ypeak] = deal(NaN); end    

%Get uncorrelated mean rate ...
if ~isempty(NITDc), 
    [Xroots, Yroots] = deal(NaN);
    MeanRate = NITDc.origmean;
else,
    Rng(1) = max([NITDp.x(1), NITDn.x(1)]); Rng(2) = min([NITDp.x(end), NITDn.x(end)]);
    X1 = NITDp.x(find(NITDp.x >= Rng(1) & NITDp.x <= Rng(2)));
    X2 = NITDn.x(find(NITDn.x >= Rng(1) & NITDn.x <= Rng(2)));
    X = union(X1, X2); X = X(:)';
    
    Y(1, :) = interp1(NITDp.x, NITDp.y, X);
    Y(2, :) = interp1(NITDn.x, NITDn.y, X);
    
    idx = find(diff(sign(diff(Y, 1, 1))) ~= 0); N = length(idx);
    if (N > 0),
        for n = 1:N,
            Tidx = idx(n)+[0,1];
            Xroots(n) = roots(polyfit(X(Tidx), Y(1, Tidx), 1)-polyfit(X(Tidx), Y(2, Tidx), 1));
        end
        Xroots = Xroots(find(Xroots <= DIFF.intersect(1) | Xroots >= DIFF.intersect(2)));
        Yroots = interp1(NITDp.x, NITDp.y, Xroots);
        if isempty(Yroots), [Xroots, Yroots, MeanRate] = deal(NaN);
        else, MeanRate = mean(Yroots); end    
    else, [Xroots, Yroots, MeanRate] = deal(NaN); end    
end    

%Calculate correlation index ...
CorrIndex = Ypeak/MeanRate;

%----------------------------------------------------------------------------
function Str = AssembleNITDStr(NITD, CaptionStr)

Str = {sprintf(CaptionStr); ...
        sprintf('Max = %s', Param2Str(NITD.origmax, 'spk/sec', 0)); ...
        sprintf('Max(SPLINE) = %s', Param2Str(NITD.fitmax, 'spk/sec', 0)); ...
        sprintf('ITD = %s/%s', Param2Str(NITD.origbestitd, 'ms', 2), Param2Str(NITD.origbestitdc, 'cyc', 2)); ...
        sprintf('ITD(SPLINE) = %s/%s', Param2Str(NITD.fitbestitd, 'ms', 2), Param2Str(NITD.fitbestitdc, 'cyc', 2)); ...
        sprintf('PeakRatio(SPLINE) = %s', Param2Str(NITD.peakratio, '', 2))};

%----------------------------------------------------------------------------
function Str = AssembleDIFFStr(DIFF)

Str = {sprintf('\\bfDIFF\\rm'); ...
        sprintf('\\itGeneral\\rm'); ...
        sprintf('Max = %s', Param2Str(DIFF.max, 'spk/sec', 0)); ...
        sprintf('ITD = %s/%s', Param2Str(DIFF.bestitd, 'ms', 2), Param2Str(DIFF.bestitdc, 'cyc', 2)); ...
        sprintf('HHW = %s/%s', Param2Str(DIFF.hhw, 'ms', 2), Param2Str(DIFF.hhwc, 'cyc', 2)); ...
        sprintf('Peaks = %.2f/%.2f/%.2fms', [DIFF.secpeaks(1), DIFF.zeropeak, DIFF.secpeaks(2)]); ...
        sprintf('ScaleFactor = %s', Param2Str(DIFF.scale, '', 2)); ...
        sprintf('\\itEnveloppe\\rm'); ...
        sprintf('Max = %s', Param2Str(DIFF.envmax, 'spk/sec', 0)); ...
        sprintf('Peak = %s/%s', Param2Str(DIFF.envpeak, 'ms', 2), Param2Str(DIFF.envpeakc, 'cyc', 2))};

%----------------------------------------------------------------------------
function Str = AssembleGABORStr(GABOR)

Str = {sprintf('\\bfGABOR\\rm'); ...
        sprintf('\\itGeneral\\rm'); ...
        sprintf('Max = %s', Param2Str(GABOR.max, 'spk/sec', 0)); ...
        sprintf('ITD = %s/%s', Param2Str(GABOR.bestitd, 'ms', 2), Param2Str(GABOR.bestitdc, 'cyc', 2)); ...
        sprintf('HHW = %s/%s', Param2Str(GABOR.hhw, 'ms', 2), Param2Str(GABOR.hhwc, 'cyc', 2)); ...
        sprintf('Peaks = %.2f/%.2f/%.2fms', [GABOR.secpeaks(1), GABOR.zeropeak, GABOR.secpeaks(2)]); ...
        sprintf('\\itConstants\\rm'); ...
        sprintf('Amp = %s', Param2Str(GABOR.constants.a, 'spk/sec', 0)); ...
        sprintf('EnvMax = %s', Param2Str(GABOR.constants.envmax/1000, 'ms', 2)); ...
        sprintf('EnvWidth = %s', Param2Str(GABOR.constants.envwidth/1000, 'ms', 2)); ...
        sprintf('Freq = %s', Param2Str(GABOR.constants.freq*1e3, 'kHz', 2)); ...
        sprintf('Phase = %s', Param2Str(GABOR.constants.ph/2/pi, 'cyc', 2)); ...
        sprintf('AccFrac = %s', Param2Str(GABOR.constants.accfraction*100, '%', 0)); ... 
        sprintf('\\itEnveloppe\\rm'); ...
        sprintf('Max = %s', Param2Str(GABOR.envmax, 'spk/sec', 0)); ...
        sprintf('Peak = %s/%s', Param2Str(GABOR.envpeak, 'ms', 2), Param2Str(GABOR.envpeakc, 'cyc', 2))};

%----------------------------------------------------------------------------
function Str = AssembleCORRStr(CORR, Param)

if (CORR.pcorrcoef < Param.corrsign), CorrSignStr = 'yes'; else CorrSignStr = 'no'; end

Str = {sprintf('\\bfCORR\\rm'); ...
        sprintf('Coef = %s /p = %s', Param2Str(CORR.corrcoef, '', 3), Param2Str(CORR.pcorrcoef, '', 3)); ...
        sprintf('Sign(\\alpha = %.3f) = %s', Param.corrsign, CorrSignStr); ...
        sprintf('Trough/Peak(<1) = %s', Param2Str(CORR.pktrratio, '', 2)); ...
        sprintf('CI = %s (Avg %s, Pk %s)', Param2Str(CORR.corrindex, '', 2), Param2Str(CORR.meanrate, '', 0), ...
        Param2Str(CORR.ypeak, 'spk/sec', 0))};

%----------------------------------------------------------------------------
function FILTER = calcFILTER(NITDp, NITDn, GABOR, dsNRHO, Param)

FILTER = struct([]);

%Oorspronkelijke gegevens normaliseren ...
Delay = intersect(floor(NITDp.X), floor(NITDn.X)); if size(Delay, 2) > 1, Delay = Delay'; end
idx1 = find(ismember(floor(NITDp.X), Delay)); idx2 = find(ismember(floor(NITDn.X), Delay));
Rate  = NITDp.Y(idx1)' - NITDn.Y(idx2)';

MaxY = max(Rate);
Rate = Rate/MaxY;

%NRHO-dataset analyseren en curve-fitting ...
NRHO = calcNRHO(dsNRHO, Param);
if NRHO.AccFrac < (Param.accfracthr/100), warning('Curve fitting isn''t accurate enough for filter approximation.'); return; end

%Filter met twee parameters, namelijk center frequency (CF) en bandbreedte (BW) passen in deze 
%genormaliseerde data ...
filtermodel('expc', NRHO.FitCnorm);

%Vrijheidsgraden zijn Center Frequency (Hz), BandWidth (Hz), Group Delay (s) and Phase Delay (rad) ...
if GABOR.Constants.AccFraction < (Param.accfracthr/100) | any(isnan([GABOR.Constants.Freq, GABOR.HHW, GABOR.Constants.EnvMax, GABOR.Constants.Ph])), warning('Curve fitting isn''t accurate enough for filter approximation.'); return; end
Freq = GABOR.Constants.Freq*1e6; 
BW   = 1000/GABOR.HHW /2;
GD = -GABOR.Constants.EnvMax/1e6 *2*pi;
PhD = GABOR.Constants.Ph; 
Cstart = [Freq, BW, GD, PhD];

FitC  = lsqcurvefit(@filtermodel, Cstart, Delay, Rate, [0 0 -1.5 -pi], [8000 2000 +1.5 +pi], optimset('display', 'off'));
AccFrac = getaccfrac(@filtermodel, FitC, Delay, Rate);

FIT = CollectInStruct(Delay, Rate, FitC, AccFrac);

if FIT.AccFrac < (Param.accfracthr/100), warning('Filter approximation isn''t accurate enough.'); return; end

%Indien geen range opgegeven is voor de filtercurve, dan is de range -3 SD tot +3SD van het gemiddelde ...
%Indien de samplerate voor de curve niet opgegeven is dan wordt de oorspronkelijke samplerate van de curven
%overgenomen ...
if isnan(Param.filterrange(1)) | Param.filterrange(1) > FitC(1), Param.filterrange(1) = FitC(1) - 3 * FitC(2); end
if isnan(Param.filterrange(2)) | Param.filterrange(2) < FitC(1), Param.filterrange(2) = FitC(1) + 3 * FitC(2); end
if isnan(Param.filtersr), Param.filtersr = 1/(Delay(2)-Delay(1)); end

Freq  = Param.filterrange(1):Param.filtersr:Param.filterrange(2);
Power = normpdf(Freq, FitC(1), FitC(2))*Param.filtersr;
dB    = p2db(Power);
Phase = [polyval(FitC(3:4), Freq); polyval([FitC(3), -FitC(4)], Freq)];

SHAPE = CollectInStruct(Freq, Power, dB, Phase);

DIAGNOSTICS = diagnoseFILTER(FitC, Delay, Rate, Param);

CF = FitC(1); BW = FitC(2) * 2; GD = -FitC(3) * 1000 /2/pi; PhD = FitC(4);
ERB   = 1/max(Power)*Param.filtersr; %Equivalent Rectangular Bandwidth ...

FILTER = RecLowerFields(CollectInStruct(NRHO, FIT, SHAPE, DIAGNOSTICS, CF, BW, GD, PhD, ERB));

%-----------------------------------------------------------------------------------------------
function NRHO = calcNRHO(dsNRHO, Param)

Nrec = dsNRHO.nrec;
[Rho, idx] = sort(dsNRHO.indepval(1:Nrec)');
R = getrate(dsNRHO, idx, Param.anwin(1), Param.anwin(2)); %23-10-2003
%R(2, :) = fliplr(R(1, :));
%R(3, :) = R(1, :) - R(2, :);

FitC = polyfit(Rho, R, 2); %23-10-2003
AccFrac = getaccfrac(inline('polyval(c, x)', 'c', 'x'), FitC, Rho, R);

%YData = polyval(FitC, Rho);
%MaxY = max(YData);
%FitCnorm = FitC/MaxY;

YData = polyval(FitC, Rho); %23-10-2003
MinY = min(YData); MaxY = max(YData);
FitCnorm = [FitC(1:2)/(MaxY-MinY) (FitC(3)-MinY)/(MaxY-MinY)];

%Oude methode ... Fitten van exponentiele functie in de data ...
%[FitC, AccFrac] = expfit(Rho, R);

%Ydata = expfunc(FitC, Rho);
%MinY = min(Ydata); MaxY = max(Ydata);
%FitCnorm = [FitC(1)/(MaxY-MinY) FitC(2:3) (FitC(4)-MinY)/(MaxY-MinY)];

%Nieuwe methode ... Fitten van tweede graads veelterm in de functie ...
%FitC = polyfit(Rho, R, 2);
%AccFrac = getaccfrac(inline('polyval(c, x)', 'c', 'x'), FitC, Rho, R);

%Ydata = polyval(FitC, Rho);
%MinY = min(Ydata); MaxY = max(Ydata);
%FitCnorm = [FitC(1:2)/(MaxY-MinY) (FitC(3)-MinY)/(MaxY-MinY)];

NRHO = CollectInStruct(Rho, R, FitC, FitCnorm, AccFrac);

%-----------------------------------------------------------------------------------------------
function y = expfunc(c, x)

y = c(1) * exp(c(2)*(x-c(3))) + c(4);

%-----------------------------------------------------------------------------------------------
function [FitC, AccFrac] = expfit(Rho, R)

Cstart = [1 1 0 0];
FitC    = lsqcurvefit(@expfunc, Cstart, Rho, R, [], [], optimset('display', 'off'));
AccFrac = getaccfrac(@expfunc, FitC, Rho, R);

%-----------------------------------------------------------------------------------------------
function y = filtermodel(c, x)

persistent expc;

if ischar(c) & strcmpi(c, 'expc'), expc = x; return;
    %elseif ischar(c) & strcmpi(c, 'GD'), GD = x; return;
    %elseif ischar(c) & strcmpi(c, 'PhD'), PhD = x; return;
elseif ischar(c), error('Invalid invocation of function.'); end

if isempty(expc), error('Constants of conversion function not yet set.'); end
%if isempty(GD), error('Group delay not yet set.'); end
%if isempty(PhD), error('Phase delay not yet set.'); end

CF = c(1); BW = c(2); GD = c(3); PhD = c(4);

t = x * 1e-6;
dt = t(2) - t(1); N = length(t);
tmax = N * dt; 

df = 1/tmax;
f =  (0:N-1) * df;

power = repmat(normpdf(f', CF, BW) * df, 1, 2); %Gaussiaans ...
phase = [GD*f'-PhD, GD*f'-PhD+pi];              %lineair ... 
spectrum = power .* exp(phase * i);

%Exponentiele functie ...
%y = expfunc(expc, real(fftshift(ifft(spectrum))) * N);
%Tweede graads veelterm ...
y = real(fftshift(ifft(spectrum))) * N;
y = polyval(expc, y(:, 1)) - polyval(expc, y(:, 2)); %23-10-2003

%-----------------------------------------------------------------------------------------------
function db = p2db(p)

refp = max(p);
db = 10 * log(p/refp);

%-----------------------------------------------------------------------------------------------
function DIAGNOSTICS = diagnoseFILTER(Cfilter, FF, Rfit, Param)

CF = Cfilter(1); BW = Cfilter(2)*2; GD = Cfilter(3); PhD = Cfilter(4);

CFs = max([0, CF-Param.diagrange/2]):Param.diagsr:CF+Param.diagrange/2;
for n = 1:length(CFs), AccFracCF(n) = getaccfrac(@filtermodel, [CFs(n), BW/2, GD, PhD], FF, Rfit); end

BWs = max([0, BW-Param.diagrange/2]):Param.diagsr:BW+Param.diagrange/2;
for n = 1:length(BWs), AccFracBW(n) = getaccfrac(@filtermodel, [CF, BWs(n)/2, GD, PhD], FF, Rfit); end

DIAGNOSTICS = CollectInStruct(CFs, AccFracCF, BWs, AccFracBW);

%----------------------------------------------------------------------------
function plotNITD(CalcData, Info, Thr, Rcn, StimParam, Param)

%Creating figure ...
FigHdl = figure('Name', sprintf('%s: %s', upper(mfilename), Info.idstr), ...
    'NumberTitle', 'off', ...
    'Units', 'normalized', ...
    'OuterPosition', [0 0.025 1 0.975], ... %Maximize figure (not in the MS Windows style!) ...
    'PaperType', 'A4', ...
    'PaperPositionMode', 'manual', ...
    'PaperUnits', 'normalized', ...
    'PaperPosition', [0.05 0.05 0.90 0.90], ...
    'PaperOrientation', 'portrait');

%Plot NTD-curves ...
XData = [CalcData.nitdp.x(:); CalcData.nitdp.xfit(:)];
if ~isempty(CalcData.nitdn), XData = [XData; CalcData.nitdn.x(:); CalcData.nitdn.xfit(:)]; end
if ~isempty(CalcData.nitdc), XData = [XData; CalcData.nitdc.x(:)]; end
[MinX, MaxX, MinY, MaxY] = ConvertLimits(XData, Param);
AxNTD = axes('Position', [0.05, 3*0.05+2*(1-0.20)*1/3, (1-0.15)*3/4, (1-0.20)*1/3], 'Box', 'off', 'fontsize', 7);
LnHdl = line(CalcData.nitdp.x, CalcData.nitdp.y, 'linestyle', '-', 'color', 'b', 'marker', '+', 'tag', 'orignitdpcurve');
LnHdl(end+1) = line(CalcData.nitdp.xfit, CalcData.nitdp.yfit, 'linestyle', ':', 'color', 'b', 'marker', 'none', 'tag', 'fitnitdpcurve'); 
LegendStr = {sprintf('%s-NTD+', Info.NITD.dsIDP), sprintf('%s-NTD+(SPLINE)', Info.NITD.dsIDP)};
line(CalcData.nitdp.fitbestitd([1 1])*1000, [MinY MaxY], 'color', 'k', 'linestyle', ':', 'marker', 'none', 'tag', 'bestnitdpverline');
set(PlotPeakRatio(CalcData.nitdp.xpeaks, CalcData.nitdp.ypeaks, 'k', MinY), 'tag', 'nitdppeakratio');
line(CalcData.nitdp.secpeaks([1 2; 1 2])*1000, [MinY; MaxY], 'Color', 'k', 'LineStyle', ':', 'marker', 'none', 'tag', 'nitdpsecpeakverline');
idx = find(ismember(CalcData.nitdp.xfit, CalcData.nitdp.secpeaks*1000));
if ~isempty(idx) & (length(idx) == 2), 
    line(CalcData.nitdp.secpeaks(1)*1000, CalcData.nitdp.yfit(idx(1)), 'Color', 'k', 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 3, 'tag', 'nitdpleftsecpeakmarker');
    line(CalcData.nitdp.secpeaks(2)*1000, CalcData.nitdp.yfit(idx(2)), 'Color', 'k', 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 3, 'tag', 'nitdprightsecpeakmarker');
end
if ~isempty(CalcData.nitdn), 
    LnHdl(end+1) = line(CalcData.nitdn.x, CalcData.nitdn.y, 'linestyle', '-', 'color', 'r', 'marker', '^', 'tag', 'orignitdncurve');
    LnHdl(end+1) = line(CalcData.nitdn.xfit, CalcData.nitdn.yfit, 'linestyle', ':', 'color', 'r', 'marker', 'none', 'tag', 'fitnitdncurve'); 
    line(CalcData.nitdn.fitbestitd([1 1])*1000, [MinY MaxY], 'color', 'k', 'linestyle', ':', 'marker', 'none', 'tag', 'bestnitdnverline'); 
    set(PlotPeakRatio(CalcData.nitdn.xpeaks, CalcData.nitdn.ypeaks, 'k', MinY), 'tag', 'nitdnpeakratio');
    line(CalcData.corr.xpeak, CalcData.corr.ypeak, 'color', 'k', 'linestyle', 'none', 'marker', 's', 'tag', 'corrindexpeakmarker')
    line(CalcData.corr.xroots, CalcData.corr.yroots, 'color', 'k', 'linestyle', 'none', 'marker', 's', 'tag', 'corrindexintersectmarker')
    LegendStr = [LegendStr, ...
            {sprintf('%s-NTD-', Info.NITD.dsIDN), sprintf('%s-NTD-(SPLINE)', Info.NITD.dsIDN)}];
end
if ~isempty(CalcData.nitdc), 
    LnHdl(end+1) = line(CalcData.nitdc.x, CalcData.nitdc.y, 'linestyle', '-', 'color', 'k', 'marker', 'o', 'tag', 'orignitdccurve');
    LegendStr = [LegendStr, {sprintf('%s-NTD0', Info.NITD.dsIDC)}];
end
title('NTD curves', 'fontsize', 9, 'fontweight', 'bold');
xlabel('Standard ITD(\mus)', 'fontsize', 7); ylabel('Rate (spk/sec)', 'fontsize', 7);
axis([MinX MaxX MinY MaxY]); PlotVerZero(MinY, MaxY); 
LegHdl = legend(LnHdl, LegendStr, 1); set(LegHdl, 'fontsize', 7);
%Plot information on NTD-curves ...
AxNTDINFO = axes('Position', [2*0.05+(1-0.15)*3/4, 3*0.05+2*(1-0.20)*1/3, (1-0.15)*1/4, (1-0.20)*1/3], 'Visible', 'off'); 
InfoStr = CalcData.nitdp.str;
if ~isempty(CalcData.nitdn), InfoStr = [InfoStr; CalcData.nitdn.str; CalcData.corr.str]; end
text(0.0, 0.5, InfoStr, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
    'FontWeight', 'normal', 'FontSize', 8);

%Plot DIFF and GABOR curve ...
if ~isempty(CalcData.diff),
    XData = CalcData.diff.x(:);
    [MinX, MaxX, MinY, MaxY] = ConvertLimits(XData, Param); MinY = -MaxY;
    AxDIFF = axes('Position', [0.05, 2*0.05+1*(1-0.20)*1/3, (1-0.15)*3/4, (1-0.20)*1/3], 'Box', 'off', 'fontsize', 7);
    LnHdl = line(CalcData.diff.x, CalcData.diff.y, 'linestyle', '-', 'color', 'b', 'marker', 'none', 'tag', 'diffcurve');
    if strncmpi(Param.gaborfit, 'n', 1),
        line(CalcData.diff.x, [CalcData.diff.env; -CalcData.diff.env], 'color', 'k', 'linestyle', ':', 'marker', 'none', 'tag', 'diffenvcurve');
        line(CalcData.diff.bestitd([1 1])*1000, [MinY MaxY], 'Color', 'k', 'LineStyle', ':', 'marker', 'none', 'tag', 'bestdiffitdverline');
        line(CalcData.diff.bestitd*1000, CalcData.diff.max, 'Color', 'k', 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 3, 'tag', 'bestdiffitdmarker');
        YInterSect = CalcData.diff.envmax/2; plotcintersect(CalcData.diff.intersect, YInterSect([1 1]), MinY);
        line(CalcData.diff.secpeaks([1 2; 1 2])*1000, [MinY; MaxY], 'Color', 'k', 'LineStyle', ':', 'marker', 'none', 'tag', 'diffsecpeakverline');
        idx = find(ismember(CalcData.diff.x, CalcData.diff.secpeaks*1000));
        if ~isempty(idx) & (length(idx) == 2),
            line(CalcData.diff.secpeaks(1)*1000, CalcData.diff.y(idx(1)), 'Color', 'k', 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 3, 'tag', 'diffleftsecpeakmarker'); 
            line(CalcData.diff.secpeaks(2)*1000, CalcData.diff.y(idx(2)), 'Color', 'k', 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 3, 'tag', 'diffrightsecpeakmarker'); 
        end
        LegendStr = {'DIFF(SPLINE)'}; TitleStr = 'DIFF curve';
    else,
        LnHdl(end+1) = line(CalcData.gabor.x, CalcData.gabor.y, 'color', 'b', 'linestyle', '--', 'marker', 'none', 'tag', 'gaborcurve');
        line(CalcData.gabor.x, [CalcData.gabor.env; -CalcData.gabor.env], 'color', 'k', 'linestyle', ':', 'marker', 'none', 'tag', 'gaborenv');
        line(CalcData.gabor.bestitd([1 1])*1000, [MinY MaxY], 'Color', 'k', 'LineStyle', ':', 'marker', 'none', 'tag', 'bestgaboritdverline');
        line(CalcData.gabor.bestitd*1000, CalcData.gabor.max, 'Color', 'k', 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 3, 'tag', 'bestgaboritdmarker');
        YInterSect = CalcData.gabor.envmax/2; plotcintersect(CalcData.gabor.intersect, YInterSect([1 1]), MinY);
        line(CalcData.gabor.secpeaks([1 2; 1 2])*1000, [MinY; MaxY], 'Color', 'k', 'LineStyle', ':', 'marker', 'none', 'tag', 'gaborsecpeakverline');
        idx = find(ismember(CalcData.gabor.x, CalcData.gabor.secpeaks*1000));
        if ~isempty(idx), 
            line(CalcData.gabor.secpeaks(1)*1000, CalcData.gabor.y(idx(1)), 'Color', 'k', 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 3, 'tag', 'gaborleftsecpeakmarker'); 
            line(CalcData.gabor.secpeaks(2)*1000, CalcData.gabor.y(idx(2)), 'Color', 'k', 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 3, 'tag', 'gaborrightsecpeakmarker'); 
        end
        LegendStr = {'DIFF(SPLINE)', 'DIFF(GABOR)'}; TitleStr = 'DIFF and GABOR curves';
    end
    title(TitleStr, 'fontsize', 9, 'fontweight', 'bold');
    xlabel('Standard ITD (\mus)', 'fontsize', 7); ylabel('Normalized Rate', 'fontsize', 7);
    axis([MinX, MaxX, MinY MaxY]);
    PlotVerZero(MinY, MaxY); PlotHorZero(MinX, MaxX);
    LegHdl = legend(LnHdl, LegendStr, 1); set(LegHdl, 'fontsize', 7);
    %Plot information on these curves ...
    AxDIFFINFO = axes('Position', [2*0.05+(1-0.15)*3/4, 2*0.05+1*(1-0.20)*1/3, (1-0.15)*1/4, (1-0.20)*1/3], 'Visible', 'off'); 
    if strncmpi(Param.gaborfit, 'n', 1), InfoStr = CalcData.diff.str;
    else, InfoStr = CalcData.gabor.str; end
    text(0.0, 0.5, InfoStr, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
        'FontWeight', 'normal', 'FontSize', 8);
else, AxDIFF = CreateEmptyPlot([0.05, 2*0.05+1*(1-0.20)*1/3, (1-0.10), (1-0.20)*1/3]); end

%General information ...
AxINFO = axes('Position', [0.05, 0.05, (1-0.15)*1/2, (1-0.20)*1/3], 'Visible', 'off');
text(0.5, 2/3+0.5*1/3, Info.titlestr, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', ...
    'FontWeight', 'normal', 'FontSize', 10);
FirstColStr = Param.str; 
if ~isempty(Rcn), FirstColStr = [FirstColStr; {''}; Rcn.str]; end   
text(0, 0, FirstColStr, 'Units', 'normalized', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', ...
    'FontWeight', 'normal', 'FontSize', 8);
SecColStr = StimParam.str;
if ~isempty(Thr), SecColStr = [SecColStr; {''}; Thr.str]; end
text(0.5, 0, SecColStr, 'Units', 'normalized', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', ...
    'FontWeight', 'normal', 'FontSize', 8);

%Fourier-analyse in linkeronderhoek plotten ...
MinX = Param.fftxrange(1); MaxX = Param.fftxrange(2);
MinY = Param.fftyrange(1); MaxY = Param.fftyrange(2);
if isempty(CalcData.diff), FFT = CalcData.nitdp.fft; else FFT = CalcData.diff.fft; end
AxFFTM = axes('Position', [2*0.05+(1-0.15)*1/2, 2*0.05+(((1-0.20)*1/3)-0.05)*1/2, (1-0.15)*1/2, (((1-0.20)*1/3)-0.05)*1/2], 'Box', 'on', 'fontsize', 7);
LnHdl(1) = line(FFT.freq, FFT.magn.db(1, :), 'linestyle', '-', 'color', 'b', 'marker', 'none');
LnHdl(2) = line(FFT.freq, FFT.magn.db(2, :), 'LineStyle', ':', 'Marker', 'none', 'Color', 'k');
line(FFT.df([1 1]), [MinY MaxY], 'Color', 'k', 'LineStyle', ':', 'marker', 'none');
plotcintersect(FFT.bwedges, FFT.params.bwcutoff([1 1]), MinY);
title('Spectrum', 'fontsize', 9, 'fontweight', 'bold');
xlabel('Frequency (Hz)', 'fontsize', 7); ylabel('dB', 'fontsize', 7);
axis([MinX MaxX MinY MaxY]); LegHdl = legend(LnHdl, {'FFT', 'RunAv'}); set(LegHdl, 'fontsize', 7);
text(MinX, MaxY, {sprintf('DF = %.0fHz', FFT.df); sprintf('BW = %.0fHz', FFT.bw); sprintf('dF = %.2fHz', FFT.res)}, ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'fontsize', 7);

MinY = min(FFT.ph.rad(find(FFT.freq >= MinX & FFT.freq <= MaxX)));
MaxY = max(FFT.ph.rad(find(FFT.freq >= MinX & FFT.freq <= MaxX)));
AxFFTP = axes('Position', [2*0.05+(1-0.15)*1/2, 0.05, (1-0.15)*1/2, (((1-0.20)*1/3)-0.05)*1/2], 'Box', 'on', 'fontsize', 7);
LnHdl(1) = line(FFT.freq, FFT.ph.rad, 'linestyle', '-', 'color', 'b', 'marker', 'none');
line(FFT.df([1 1]), [MinY FFT.fsd], 'Color', 'k', 'LineStyle', ':', 'marker', 'none');
line([MinX, FFT.df], FFT.fsd([1 1]), 'Color', 'k', 'LineStyle', ':', 'marker', 'none');
a = FFT.gd*2*pi/1000; b = FFT.fsd-a*FFT.df;
LnHdl(2) = line([MinX MaxX], a.*[MinX MaxX]+b, 'LineStyle', ':', 'Color', 'k', 'Marker', 'none');
xlabel('Frequency (Hz)', 'fontsize', 7); ylabel('Rad', 'fontsize', 7);
axis([MinX MaxX MinY MaxY]); LegHdl = legend(LnHdl, {'FFT', 'LinFit'});
text(MinX, MaxY, {sprintf('GD = %.2fms', FFT.gd); sprintf('FsD = %.2frad', FFT.fsd); ...
        sprintf('AccFrac = %.0f%%', FFT.accfrac*100)}, 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'fontsize', 7);

%----------------------------------------------------------------------------
function [MinX, MaxX, MinY, MaxY] = ConvertLimits(XData, Param);

if isinf(Param.xrange(1)), MinX = unique(min(XData(:))); 
else, MinX = Param.xrange(1); end
if isinf(Param.xrange(2)), MaxX = unique(max(XData(:))); 
else, MaxX = Param.xrange(2); end

MinY = Param.yrange(1); 
MaxY = Param.yrange(2);

%----------------------------------------------------------------------------
function Hdl = PlotPeakRatio(XPeaks, YPeaks, Color, MinY)

Hdl = line(XPeaks, YPeaks, 'Color', Color, 'LineStyle', '-', 'Marker', 'o', 'MarkerSize', 3, 'tag', 'peakratioline'); 

%----------------------------------------------------------------------------
function Hdl = PlotVerZero(MinY, MaxY)

Hdl = line([0, 0], [MinY, MaxY], 'Color', [0 0 0], 'LineStyle', ':', 'tag', 'verzeroline');

%----------------------------------------------------------------------------
function Hdl = PlotHorZero(MinX, MaxX)

Hdl = line([MinX, MaxX], [0, 0], 'Color', [0 0 0], 'LineStyle', ':', 'tag', 'horzeroline');

%----------------------------------------------------------------------------
function AxHdl = CreateEmptyPlot(Pos)

AxHdl = axes('Position', Pos, 'Box', 'on', 'Color', [0.8 0.8 0.8], 'Units', 'normalized', ...
    'YTick', [], 'YTickLabel', [], 'XTick', [], 'XTickLabel', []);
TxtHdl = text(0.5, 0.5, sprintf('No plot to be\ngenerated'), 'VerticalAlignment', 'middle', ...
    'HorizontalAlignment', 'center', 'Color', 'k', 'FontSize', 8, 'FontWeight', 'bold');

%----------------------------------------------------------------------------
function plotFILTER(NITDp, NITDn, FILTER, CellInfo, StimParam, Param)

TitleTxt = sprintf('NITD-curves for %s <%d>', CellInfo.DataFile, CellInfo.CellNr);

Interface = figure('Name', ['EvalNITD: Filter approximation on ' TitleTxt], ...
    'Units','normalized', ...
    'NumberTitle','off', ...
    'PaperUnits','normalized', ...
    'PaperPosition',[0 0 1 1], ...
    'PaperOrientation', 'landscape');

%Originele rate-curven weergeven ...
Ax_Original = axes('Position', [0.10 0.55 0.20 0.35], 'Box', 'on'); 
line(NITDp.X, NITDp.Y, 'LineStyle', '-', 'Marker', '.', 'Color', 'b');
line(NITDn.X, NITDn.Y, 'LineStyle', '-', 'Marker', '.', 'Color', 'r');

title('Original Data', 'fontsize', 12);
xlabel('Delay (\mus)'); ylabel('Rate (spk/sec)');

%NRHO-curve en fit weergeven ...
Ax_NRHOFit = axes('Position', [0.40 0.55 0.20 0.35], 'Box', 'on'); 
Hdl(1) = line(FILTER.NRHO.Rho, FILTER.NRHO.R, 'LineStyle', '-', 'Marker', '.', 'Color', 'b');
%Hdl(2) = line(FILTER.NRHO.Rho, FILTER.NRHO.R(2, :), 'LineStyle', '-', 'Marker', '.', 'Color', 'r');
%Hdl(3) = line(FILTER.NRHO.Rho, FILTER.NRHO.R(3, :), 'LineStyle', '-', 'Marker', '.', 'Color', 'g');
%Exponentiele functie ...
%line(FILTER.NRHO.Rho, expfunc(FILTER.NRHO.FitC, FILTER.NRHO.Rho), 'LineStyle', ':', 'Marker', 'none', 'Color', 'k');
Hdl(2) = line(FILTER.NRHO.Rho, polyval(FILTER.NRHO.FitC, FILTER.NRHO.Rho), 'LineStyle', ':', 'Marker', 'none', 'Color', 'k');

title('Correlation-Rate Function', 'fontsize', 12);
xlabel('Correlation'); ylabel('Rate (spk/sec)');
legend(Hdl, {'NRHO', 'FIT'}, 4); %23-10-2003

%Extra informatie weergeven ...
InfoTxt = {sprintf('\\fontsize{12}%s <%s> & <%s>', CellInfo.DataFile, CellInfo.NITD.dsIDP, CellInfo.NITD.dsIDN); ...
        sprintf('(NRHO : <%s>)\\fontsize{9}', CellInfo.NRHO.dsID); ...
        sprintf(''); ...
        sprintf('\\fontsize{10}Calculation Parameters\\fontsize{9}'); ...
        sprintf('Analysis Window = %dms-%dms', Param.anwin); ...
        sprintf(''); ...
        sprintf('\\fontsize{10}Stimulus Parameters\\fontsize{9}'); ...
        sprintf('Stim./Rep. Dur. = %.0fms/%.0fms', StimParam.burstdur, StimParam.repdur); ...
        sprintf('SPL = %ddB', StimParam.spl)};              

PrintInfo([0.70 0.55 0.20 0.35], InfoTxt);

%Filter fit curven weergeven ...
MinX = min(FILTER.FIT.Delay); MaxX = max(FILTER.FIT.Delay);
MinY = min(FILTER.FIT.Rate(:)); MaxY = max(FILTER.FIT.Rate(:));

Ax_FILTERFit = axes('Position', [0.10 0.10 0.20 0.35], 'Box', 'on');
line(FILTER.FIT.Delay, FILTER.FIT.Rate, 'LineStyle', '-', 'Color', 'b', 'Marker', '.');
line(FILTER.FIT.Delay, filtermodel(FILTER.FIT.FitC, FILTER.FIT.Delay), 'LineStyle', ':', 'Color', 'k', 'Marker', 'none');

title('Filter Approximation on DIFFCOR', 'fontsize', 12);
xlabel('Delay  (\mus)'); ylabel('Norm Rate');
axis([MinX MaxX MinY MaxY]);

text(MinX, MaxY, sprintf('AccFrac = %.0f%%', FILTER.FIT.AccFrac * 100), ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

%De filtershape plotten ...
MinX = min(FILTER.SHAPE.Freq); MaxX = max(FILTER.SHAPE.Freq);
if strncmpi(Param.dbscale, 'y', 1), MinY = -30; MaxY = max(FILTER.SHAPE.dB);
else MinY = 0; MaxY = max(FILTER.SHAPE.Power); end

Ax_FILTER_Power = axes('Position', [0.40 0.30 0.20 0.15], 'Box', 'on');
patch([FILTER.CF-FILTER.ERB/2 FILTER.CF-FILTER.ERB/2 FILTER.CF+FILTER.ERB/2 FILTER.CF+FILTER.ERB/2], [MinY MaxY MaxY MinY], [0.95 0.95 0.95], 'LineStyle', ':');
if strncmpi(Param.dbscale, 'y', 1), line(FILTER.SHAPE.Freq, FILTER.SHAPE.dB, 'LineStyle', '-', 'Color', 'b', 'Marker', 'none');
else line(FILTER.SHAPE.Freq, FILTER.SHAPE.Power, 'LineStyle', '-', 'Color', 'b', 'Marker', 'none'); end
line(FILTER.CF([1 1]), [MinY MaxY], 'LineStyle', ':', 'Marker', 'none', 'Color', 'k');

title('Filter Shape', 'fontsize', 12)
xlabel('Frequency (Hz)'); 
if strncmpi(Param.dbscale, 'y', 1), ylabel('Power (dB)');
else ylabel('Norm. Power'); end
axis([MinX MaxX MinY MaxY]);

text(MinX, MaxY,{sprintf('CF = %.0fHz', FILTER.CF); ...
        sprintf('BW = %.0fHz', FILTER.BW); ...
        sprintf('ERB = %.0fHz', FILTER.ERB)}, ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

MinY = min(FILTER.SHAPE.Phase(:)); MaxY = max(FILTER.SHAPE.Phase(:));

Ax_FILTER_Phase = axes('Position', [0.40 0.10 0.20 0.15], 'Box', 'on');
line(FILTER.SHAPE.Freq, FILTER.SHAPE.Phase(1, :), 'LineStyle', '-', 'Color', 'b', 'Marker', 'none');
line(FILTER.SHAPE.Freq, FILTER.SHAPE.Phase(2, :), 'LineStyle', '-', 'Color', 'r', 'Marker', 'none');

xlabel('Frequency (Hz)'); ylabel('Phase (rad)');
axis([MinX MaxX MinY MaxY]);

text(MinX, MaxY,{sprintf('GD = %.2fms ', FILTER.GD); ...
        sprintf('PhD = %.2f \\pi(blue) %.2f \\pi(red)', FILTER.PhD/pi, -FILTER.PhD/pi)}, ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

%Diagnostische gegevens over de filter plotten ...
MinX = min(FILTER.DIAGNOSTICS.CFs); MaxX = max(FILTER.DIAGNOSTICS.CFs);
MinY = Param.diagyrange(1); MaxY = Param.diagyrange(2);

Ax_DIAGNOSTICSCF = axes('Position', [0.70 0.30 0.20 0.15], 'Box', 'on');
line(FILTER.DIAGNOSTICS.CFs, FILTER.DIAGNOSTICS.AccFracCF * 100, 'LineStyle', '-', 'Marker', 'none', 'Color', 'b');
line(FILTER.CF([1 1]), [MinY MaxY], 'LineStyle', ':', 'Marker', 'none', 'Color', 'k');

title('Filter Diagnostics', 'fontsize', 12);
xlabel('Center Frequency (Hz)'); ylabel('Fraction of Variance Accounted For (%)', 'Units', 'normalized', 'Position', [-0.15 -0.15 0]);
axis([MinX MaxX MinY MaxY]);

text(MinX, MaxY, sprintf('CF = %0.0fHz', FILTER.CF), 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

MinX = min(FILTER.DIAGNOSTICS.BWs); MaxX = max(FILTER.DIAGNOSTICS.BWs);

Ax_DIAGNOSTICSBW = axes('Position', [0.70 0.10 0.20 0.15], 'Box', 'on');
line(FILTER.DIAGNOSTICS.BWs, FILTER.DIAGNOSTICS.AccFracBW * 100, 'LineStyle', '-', 'Marker', 'none', 'Color', 'b');
line(FILTER.BW([1 1]), [MinY MaxY], 'LineStyle', ':', 'Marker', 'none', 'Color', 'k');

xlabel('BandWidth (Hz)');
axis([MinX MaxX MinY MaxY]);

text(MinX, MaxY, sprintf('BW = %0.0fHz', FILTER.BW), 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

%----------------------------------------------------------------------------
function S = RecLowerFields(S)

FNames  = fieldnames(S);
NFields = length(FNames);
for n = 1:NFields,
    Val = getfield(S, FNames{n});
    S = rmfield(S, FNames{n});
    if isstruct(Val), S = setfield(S, lower(FNames{n}), RecLowerFields(Val));  %Recursive ...
    else, S = setfield(S, lower(FNames{n}), Val); end
end

%----------------------------------------------------------------------------