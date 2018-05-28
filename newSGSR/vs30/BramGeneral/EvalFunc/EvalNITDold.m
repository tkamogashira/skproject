function CalcData = EvalNITD(varargin)
%EVALNITD   evaluate data with NITD-stimulus
%   EVALNITD(dsP, dsN, dsNRHO) evaluates NITD/NTD datasets dsP and dsN recorded from an IC cell. dsP should contain
%   responses to delayed noise token with same polarity (designated NITD+), dsN responses to delayed noise token 
%   with inversed polarity at one ear (NITD-).
%   If an NRHO-dataset is present for the cell, a filter approximation can be derived for the binaural
%   cell using the correlation-rate function.
%
%   EVALNITD(dsP, dsN, dsC, dsNRHO) does the same but also plots responses to delayed uncorrelated noise (NITD0).
%
%   If an output argument is supplied, extracted data is returned as a scalar structure.
%
%   Optional properties and their values can be given as a comma-separated list. To view list
%   of all possible properties and their default values, use 'list' as only property.

%B. Van de Sande 16-02-2004, Version for new scatterplot system ...

%----------------------------------------------template------------------------------------------------------------
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
Template.ds1.spl              = NaN;         %SPL at which was recorded
Template.nitdp.origmax        = NaN;
Template.nitdp.fitmax         = NaN;
Template.nitdp.origbestitd    = NaN;
Template.nitdp.origbestitdc   = NaN;
Template.nitdp.fitbestitd     = NaN;
Template.nitdp.fitbestitdc    = NaN;
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
Template.corr.corrcoef        = NaN;
Template.corr.pcorrcoef       = NaN;
Template.diff.max             = NaN;
Template.diff.bestitd         = NaN;
Template.diff.bestitdc        = NaN;
Template.diff.hhw             = NaN;
Template.diff.hhwc            = NaN;
Template.diff.envpeak         = NaN;
Template.diff.envpeakc        = NaN;
Template.diff.scale           = NaN;
Template.diff.fft.df          = NaN;
Template.diff.fft.bw          = NaN;
Template.diff.fft.gd          = NaN;
Template.diff.fft.fsd         = NaN;
Template.diff.fft.accfrac     = NaN;
Template.gabor.max            = NaN;
Template.gabor.bestitd        = NaN;
Template.gabor.bestitdc       = NaN;
Template.gabor.hhw            = NaN;
Template.gabor.hhwc           = NaN;
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

%-----------------------------------------hoofd programma--------------------------------------------------------
%Lijst van default-parameters ...
%Plot parameters ...
DefParam.plot        = 'yes';         %y(es), n(o), d(iff) or f(ilter) ...
DefParam.plottext    = '';
DefParam.xrange      = [-Inf +Inf];   %in microseconden ...
DefParam.yrange      = [-60 +60];     %in spk/sec ...
DefParam.fftxrange   = [0 5000];      %in Hz ...
DefParam.fftyrange   = [-40 10];      %in dB ...
DefParam.diagyrange  = [50 100];      %in % ...  
DefParam.dbscale     = 'no';
%Calculatie parameters ...
DefParam.anwin       = [0 -1];        %in milliseconden ...
DefParam.calcrange   = [-Inf +Inf];   %in microseconden ...
DefParam.samplerate  = 0.5;           %in aantal punten per microseconde ...
DefParam.runavunit   = 's';           %aantal elementen (#) of microsec (s) ...
DefParam.envrunav    = 1000;          %in microsec of aantal elementen ...
DefParam.fftrunav    = 250;           %in Hz ...
DefParam.corrsign    = 0.05;          %significantie voor Correlatie coefficient ...
DefParam.anovasign   = 0.001;         %significantie voor ANOVA-test op datasets ...
DefParam.gaborfit    = 'no';
DefParam.fitrange    = [-5000 +5000]; %in microseconden ...
DefParam.accfracthr  = 25;            %in procent ...
DefParam.filterrange = [0, 2000];     %in Hz ...
DefParam.filtersr    = 1;             %in elementen per Hz ... 
DefParam.diagrange   = 500;           %in Hz ...
DefParam.diagsr      = 10;            %in elementen per Hz ...

%-----------------------------------------------------------------------------------------------
%Parameters evalueren ...
[dsP, dsN, dsC, dsNRHO, CellInfo, StimParam, Param] = evalparam(varargin, DefParam);

%Standaard-analyse...
[NITDp, NITDn, NITDc, CORR, DIFF, GABOR] = calcSTANDARD(dsP, dsN, dsC, StimParam, Param);

%Filter-approximatie ...
if ~isempty(dsNRHO), FILTER = calcFILTER(NITDp, NITDn, GABOR, dsNRHO, StimParam, Param); else FILTER = struct([]); end

%Retrieving data from SGSR server ...
try,
    UD = getuserdata(dsP); if isempty(UD), error('To catch block ...'); end
    if ~isempty(UD.CellInfo) & ~isnan(UD.CellInfo.THRSeq),
        dsTHR = dataset(CellInfo.DataFile, UD.CellInfo.THRSeq);
        [CF, SR, Thr, BW, Q10] = evalTHR(dsTHR, 'plot', 'no');
        THR = CollectInStruct(CF, SR, Thr, BW, Q10);
    else, THR = struct([]); end    
catch, 
    warning('Could not make connection to SGSR server. Additional information is not included.'); 
    THR = struct([]); 
end

%Gegevens plotten ...
if any(strncmpi(Param.plot, {'y', 'd'}, 1)), plotNITD(NITDp, NITDn, NITDc, CORR, DIFF, GABOR, THR, CellInfo, StimParam, Param); end
if any(strncmpi(Param.plot, {'y', 'f'}, 1)) & ~isempty(FILTER), plotFILTER(NITDp, NITDn, FILTER, CellInfo, StimParam, Param); end

%Gegevens teruggeven indien gevraagd ...
if nargout == 1, 
    DS1 = emptyDataSet(dsP);
    if ~isempty(dsN),    DS2 = emptyDataSet(dsN);    else DS2 = struct([]); end
    if ~isempty(dsNRHO), DS3 = emptyDataSet(dsNRHO); else DS3 = struct([]); end

    CalcData = RecLowerFields(CollectInStruct(DS1, DS2, DS3, NITDp, NITDn, NITDc, CORR, DIFF, GABOR, FILTER, THR)); 
    CalcData = structtemplate(CalcData, Template);
end

%---------------------------------------lokale functies--------------------------------------------------------
function [dsP, dsN, dsC, dsNRHO, CellInfo, StimParam, Param] = evalparam(ParamList, DefParam);

Nargin = length(ParamList); if Nargin < 1, error('Wrong number of input arguments.'); end

idx = min(find(cellfun('isclass', ParamList, 'char')));
if isempty(idx), NrDS = Nargin; else, NrDS = idx - 1; end

[dsP, dsN, dsC, dsNRHO] = deal([]);
switch NrDS
case 0, error('First argument should be NITD-dataset.');    
case 1, dsP = ParamList{1};
case 2, [dsP, dsN] = deal(ParamList{1:2});     
case 3, 
    [dsP, dsN, ds] = deal(ParamList{1:3});
    if isa(ds, 'dataset') & any(strcmpi(ds.StimType, {'NRHO'})), dsNRHO = ds;
    elseif isa(ds, 'dataset'), dsC = ds; else error('Third argument should be NITD or NRHO-dataset.'); end    
case 4, [dsP, dsN, dsC, dsNRHO] = deal(ParamList{1:4});
end

%Property-value lijst nagaan ...
Param = checkproplist(DefParam, ParamList{idx:end});
Param = checkparam(Param);

%Datasets evalueren ...
if ~checkds(dsP, '+'), warning(sprintf('Unknown stimulus type for first dataset: ''%s''.', dsP.stimtype)); end
pP = anovads(dsP); if pP > Param.anovasign, error('First dataset didn''t pass ANOVA-test.'); end
if strcmpi(dsP.FileFormat, 'IDF/SPK'), dsP = flipitd(dsP); end
[DataFile, CellNr] = deal(dsP.FileName, dsP.iCell);
        
if ~isempty(dsN),
    if ~checkds(dsN, '-'), warning(sprintf('Unknown stimulus type for second dataset: ''%s''.', dsN.stimtype)); end
    if ~isequal(DataFile, dsN.FileName) | ~isequal(CellNr, dsN.iCell), error('Datasets aren''t from same cell.'); end
    if strcmpi(dsN.FileFormat, 'IDF/SPK'), dsN = flipitd(dsN); end
    
    pN = anovads(dsN); 
    if pN > Param.anovasign, 
        warning('Second dataset didn''t pass ANOVA-test and is discarded.'); 
        pN = []; dsN = [];
    end
end

if ~isempty(dsC),
    if ~checkds(dsC, '0'), warning(sprintf('Unknown stimulus type for third dataset: ''%s''.\n Assuming NITD0 dataset.', dsC.stimtype)); end
    if ~isequal(DataFile, dsC.FileName) & ~isequal(CellNr, dsC.iCell), error('Datasets aren''t from same cell.'); end
    if strcmpi(dsC.FileFormat, 'IDF/SPK'), dsC = flipitd(dsC); end
end

if ~isempty(dsNRHO),
    if ~isa(dsNRHO, 'dataset') | ~strcmpi(dsNRHO.StimType, 'NRHO'), error('Expecting NRHO dataset.'); end
    if ~isequal(DataFile, dsNRHO.FileName) & ~isequal(CellNr, dsNRHO.iCell), error('Datasets aren''t from same cell.'); end
end    

%Cell gegevens samenstellen ...
CellInfo.DataFile = DataFile;
CellInfo.CellNr   = CellNr;
[dummy, CellInfo.NITD.TestNrP, CellInfo.NITD.dsIDP] = unraveldsID(dsP.SeqID);
if ~isempty(dsN), [dummy, CellInfo.NITD.TestNrN, CellInfo.NITD.dsIDN] = unraveldsID(dsN.SeqID);
else [CellInfo.NITD.TestNrN, CellInfo.NITD.dsIDN] = deal([]); end   
if ~isempty(dsC), [dummy, CellInfo.NITD.TestNrC, CellInfo.NITD.dsIDC] = unraveldsID(dsC.SeqID);
else [CellInfo.NITD.TestNrC, CellInfo.NITD.dsIDC] = deal([]); end    
if ~isempty(dsNRHO), [dummy, CellInfo.NRHO.TestNr, CellInfo.NRHO.dsID] = unraveldsID(dsNRHO.SeqID);
else CellInfo.NRHO = struct([]); end    

%Stimulus parameters samenstellen ...
StimParam = checkstimparam(dsP, dsN, dsC, dsNRHO);

%Indien einde van analyse-window overeenkomt met -1 dan betekent dit de stimulusduur ...
if Param.anwin(2) == -1, Param.anwin(2) = StimParam.burstdur; end

%-----------------------------------------------------------------------------------------------
function Param = checkparam(Param)

if ~any(strncmpi(Param.plot, {'y', 'n', 'd', 'f'}, 1)), error('Plot-property should be yes or no.'); end
if ~any(strncmpi(Param.gaborfit, {'y', 'n'}, 1)), error('Gaborfit-property should be yes or no.'); end
if ~any(strncmpi(Param.runavunit, {'#', 's'}, 1)), error('Wrong value for property runavunit.'); end
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
if (length(Param.envrunav) ~= 1) & (Param.envrunavr < 0), error('Invalid value for property envrunav.'); end
if (length(Param.fftrunav) ~= 1) & (Param.fftrunav < 0), error('Invalid value for property fftrunav.'); end
if (length(Param.anovasign) ~= 1) & (Param.anovasign < 0), error('Invalid value for property anovasign.'); end
if (length(Param.corrsign) ~= 1) & (Param.corrsign < 0), error('Invalid value for property corrsign.'); end
if length(Param.accfracthr) ~= 1 | Param.accfracthr < 0 | Param.accfracthr > 100, error('Wrong value for property accfracthr.'); end
if length(Param.filtersr) ~= 1 | Param.filtersr < 0, error('Wrong value for property filtersr.'); end
if length(Param.diagrange) ~= 1 | Param.diagrange < 0, error('Wrong value for property diagrange.'); end
if length(Param.diagsr) ~= 1 | Param.diagsr < 0, error('Wrong value for property diagsr.'); end

%-----------------------------------------------------------------------------------------------
function boolean = checkds(ds, Type)

if strcmp(ds.FileFormat, 'IDF/SPK') & strcmp(ds.StimType, 'NTD')
    switch Type
    case '+', boolean = (ds.Rho == +1);
    case '-', boolean = (ds.Rho == -1);
    case '0', boolean = (ds.Rho ==  0); 
    end
elseif strcmp(ds.FileFormat, 'EDF'),
    if isempty(strfind(ds.StimType, 'NITD')), boolean = logical(0);
    else,     
        switch Type
        case '+', boolean = isequal(ds.StimParam.GWParam.ID{1}, ds.StimParam.GWParam.ID{2});
        case '-', boolean = strcmpi(ds.StimParam.GWParam.ID{1}, sprintf('%s-', ds.StimParam.GWParam.ID{2})) | ...
                strcmpi(ds.StimParam.GWParam.ID{1}, sprintf('-%s', ds.StimParam.GWParam.ID{2})) | ...
                strcmpi(ds.StimParam.GWParam.ID{2}, sprintf('%s-', ds.StimParam.GWParam.ID{1})) | ...
                strcmpi(ds.StimParam.GWParam.ID{2}, sprintf('-%s', ds.StimParam.GWParam.ID{1}));           
        case '0', boolean = ~isequal(ds.StimParam.GWParam.ID{1}, ds.StimParam.GWParam.ID{2}); end
    end
else boolean = logical(0); end

%-----------------------------------------------------------------------------------------------
function StimParam = checkstimparam(varargin)

%Eerste dataset moet NITD-type dataset zijn ...
StimParam = struct('burstdur', varargin{1}.burstdur(1), 'repdur', varargin{1}.repdur(1), 'spl', varargin{1}.SPL(1));

N = length(varargin);
for n = 2:N
    if isempty(varargin{n}), continue; end
    switch varargin{n}.StimType
    case {'NITD', 'NTD'}    
        if ~isbetween(varargin{n}.burstdur(1), [StimParam.burstdur-200 StimParam.burstdur+200]) | ...
           ~isbetween(varargin{n}.repdur(1), [StimParam.repdur-200 StimParam.repdur+200]) | ...
           ~isbetween(varargin{n}.SPL(1), [StimParam.spl-10, StimParam.spl+10])
            error('Stimulus parameters are different for the datasets.');
        end
    case 'NRHO'
        if ~isbetween(varargin{n}.burstdur(1), [StimParam.burstdur-200 StimParam.burstdur+200]) | ...
           ~isbetween(varargin{n}.repdur(1), [StimParam.repdur-200 StimParam.repdur+200]) | ...
           ~isbetween(varargin{n}.SPL(1), [StimParam.spl-10, StimParam.spl+10])
             warning('Stimulus-parameters are different for NRHO and NITD-datasets.');
        end
    end    
end

%-----------------------------------------------------------------------------------------------
function [NITDp, NITDn, NITDc, CORR, DIFF, GABOR] = calcSTANDARD(dsP, dsN, dsC, StimParam, Param);

[NITDp, NITDn, NITDc, CORR, DIFF, GABOR] = deal(struct([]));

NITDp = calcNITD(dsP, Param);

if ~isempty(dsN), 
    NITDn = calcNITD(dsN, Param);
    DIFF  = calcDIFF(NITDp, NITDn, Param);
    
    %Dominante frequentie van diffcor gebruiken om peakratio te berekenen ...
    DomFreq = DIFF.FFT.DF;
    [NITDp.PeakRatio, NITDp.XPeaks, NITDp.YPeaks] = getpeakratio(NITDp.XFit/1000, NITDp.YFit, DomFreq); NITDp.XPeaks = NITDp.XPeaks*1000;
    [NITDn.PeakRatio, NITDn.XPeaks, NITDn.YPeaks] = getpeakratio(NITDn.XFit/1000, NITDn.YFit, DomFreq); NITDn.XPeaks = NITDn.XPeaks*1000;
    
    %BestITD van alle voorgaande curven uitrekenen in cycli ...
    Period = 1000/DomFreq; %Periode in ms ...
    NITDp.OrigBestITDc = NITDp.OrigBestITD/Period;
    NITDp.FitBestITDc  = NITDp.FitBestITD/Period;
    NITDn.OrigBestITDc = NITDn.OrigBestITD/Period;
    NITDn.FitBestITDc  = NITDn.FitBestITD/Period;
    if ~isempty(NITDc),
        NITDc.OrigBestITDc = NITDc.OrigBestITD/Period;
        NITDc.FitBestITDc  = NITDc.FitBestITD/Period;
    end
    
    CORR = calcCORR(NITDp, NITDn, Param);
    GABOR = calcGABOR(DIFF, Param);
else,
    %BestITD van NITD+curve uitrekenen in cycli ...
    Period = 1000/NITDp.FFT.DF; %Periode in ms ...
    NITDp.OrigBestITDc = NITDp.OrigBestITD/Period;
    NITDp.FitBestITDc  = NITDp.FitBestITD/Period;
end

if ~isempty(dsC), NITDc = calcNITD(dsC, Param); end

%-----------------------------------------------------------------------------------------------
function NITD = calcNITD(ds, Param)

Nrec  = ds.nsubrecorded;
Range = [min(ds.indepval) max(ds.indepval)];
if ~isinf(Param.calcrange(1)) & (Param.calcrange(1) > Range(1)) & (Param.calcrange(1) < Range(2)), Range(1) = Param.calcrange(1); end;
if ~isinf(Param.calcrange(2)) & (Param.calcrange(2) < Range(2)), Range(2) = Param.calcrange(2); end;

[X, idx] = sort(ds.indepval(1:Nrec));
Y = getrate(ds, idx, Param.anwin(1), Param.anwin(2));

PP   = spline(X, Y);
XFit = Range(1):1/Param.samplerate:Range(2);
YFit = ppval(PP, XFit);

OrigMax = max(Y);
FitMax  = max(YFit);
FitMean = mean(YFit);
OrigBestITD = getmaxloc(X, Y, 0, [Range(1), Range(2)])/1000;
FitBestITD  = getmaxloc(XFit, YFit)/1000;

FFT = spectana(XFit, YFit-FitMean, 'runavunit', 'Hz', 'runavrange', Param.fftrunav, 'timeunit', 1e-6);
[PeakRatio, XPeaks, YPeaks] = getpeakratio(XFit/1000, YFit, FFT.DF); XPeaks = XPeaks*1000;

NITD = CollectInStruct(X, Y, PP, XFit, YFit, OrigMax, FitMax, FitMean, OrigBestITD, FitBestITD, PeakRatio, XPeaks, YPeaks, FFT);

%-----------------------------------------------------------------------------------------------
function DIFF = calcDIFF(NITDp, NITDn, Param)

RangeP = [min(NITDp.X), max(NITDp.X)];
RangeN = [min(NITDn.X), max(NITDn.X)];
Range = [ -min(abs([RangeP(1), RangeN(1)])), min([RangeP(2), RangeN(2)])];
if ~isinf(Param.calcrange(1)) & (Param.calcrange(1) > Range(1)) & (Param.calcrange(1) < Range(2)), Range(1) = Param.calcrange(1); end;
if ~isinf(Param.calcrange(2)) & (Param.calcrange(2) < Range(2)), Range(2) = Param.calcrange(2); end;

%Geometrisch gemiddelde van gemiddelden van NITD+ en NITD- als normalisatie gebruiken ...
YpMean = NITDp.FitMean; YnMean = NITDn.FitMean;
GeoMean = sqrt(YpMean * YnMean);
YpNorm = (NITDp.YFit/YpMean) *GeoMean;
YnNorm = (NITDn.YFit/YnMean) *GeoMean;
Scale = GeoMean; %Scaling factor is the geometrical mean ...

X = Range(1):1/Param.samplerate:Range(2);
Y = YpNorm(find((NITDp.XFit >= Range(1)) & (NITDp.XFit <= Range(2)))) - YnNorm(find((NITDn.XFit >= Range(1)) & (floor(NITDn.XFit) <= Range(2))));

FFT = spectana(X, Y, 'runavunit', 'Hz', 'runavrange', Param.fftrunav, 'timeunit', 1e-6);
if (FFT.DF ~= 0), Period = 1000/FFT.DF; else FFT.DF = NaN; Period = NaN; end

[BestITD, Max, SecPeaks] = getpeaks(X/1000, Y, 0, Period);
BestITDc = BestITD/Period;

Peaks = [SecPeaks, BestITD];
[dummy, idx] = min(abs(Peaks));
ZeroPeak = Peaks(idx);

if strncmpi(Param.runavunit, 's', 1), RunAvN = Param.envrunav * Param.samplerate;
else, RunAvN = Param.envrunav; end    
    
Env = runav(abs(hilbert(Y)), RunAvN);
    
InterSect = cintersect(X, Env, Max/2); 
HHW  = (InterSect(2) - InterSect(1))/1000;
HHWc = HHW/Period;
EnvPeak  = getmaxloc(X, Env)/1000;
EnvPeakc = EnvPeak/Period;
    
DIFF = CollectInStruct(X, Y, Env, Max, BestITD, BestITDc, SecPeaks, ZeroPeak, InterSect, HHW, HHWc, EnvPeak, EnvPeakc, Scale, FFT);

%-----------------------------------------------------------------------------------------------
function CORR = calcCORR(NITDp, NITDn, Param)

Xi = intersect(ceil(NITDp.X*10)/10, ceil(NITDn.X*10)/10);
Xi = Xi(find((Xi >= -1000) & (Xi <= +1000)));
if ~isempty(Xi), [pCorrCoef, CorrCoef] = signcorr(NITDp.Y(find(ismember(ceil(NITDp.X*10)/10, Xi))), NITDn.Y(find(ismember(ceil(NITDn.X*10)/10, Xi))));
else [pCorrCoef, CorrCoef] = deal(NaN); end 

CORR = CollectInStruct(CorrCoef, pCorrCoef);

%-----------------------------------------------------------------------------------------------
function GABOR = calcGABOR(DIFF, Param)

[X, Y, Env, Constants] = gaborfit(DIFF.X, DIFF.Y, Param.fitrange, Param.samplerate); 

Period = 1/(Constants.Freq*1000);
if ~isnan(Period), [BestITD, Max, SecPeaks] = getpeaks(X/1000, Y, 0, Period);
else [BestITD, Max, SecPeaks] = deal(NaN); end    

BestITDc = BestITD/Period;
InterSect = cintersect(X, Env, Max/2); 
HHW  = (InterSect(2) - InterSect(1))/1000;
HHWc = HHW/Period;
EnvPeak  = getmaxloc(X, Env)/1000;
EnvPeakc = EnvPeak/Period;

Peaks = [SecPeaks, BestITD];
[dummy, idx] = min(abs(Peaks));
ZeroPeak = Peaks(idx);

GABOR = CollectInStruct(X, Y, Env, Constants, Max, BestITD, BestITDc, SecPeaks, ZeroPeak, EnvPeak, EnvPeakc, InterSect, HHW, HHWc);

%-----------------------------------------------------------------------------------------------
function FILTER = calcFILTER(NITDp, NITDn, GABOR, dsNRHO, StimParam, Param)

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

FILTER = CollectInStruct(NRHO, FIT, SHAPE, DIAGNOSTICS, CF, BW, GD, PhD, ERB);

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

%-----------------------------------------------------------------------------------------------
function plotNITD(NITDp, NITDn, NITDc, CORR, DIFF, GABOR, THR, CellInfo, StimParam, Param)

TitleTxt = sprintf('Noise ITD-curves for %s <%d>', CellInfo.DataFile, CellInfo.CellNr);

Interface = figure('Name', ['EvalNITD: ' TitleTxt], ...
                   'Units','normalized', ...
                   'NumberTitle','off', ...
                   'PaperPositionMode', 'manual', ...
                   'PaperType', 'A4', ...
                   'PaperUnits','normalized', ...
                   'PaperPosition',[0.0725 0 0.8275 1], ...
                   'PaperOrientation', 'portrait');
               
%XRange waarden nagaan ...
if ~isempty(NITDn)
    if isinf(Param.xrange(1)), Param.xrange(1) = unique(min([NITDp.X(:)', NITDn.X(:)'])); end
    if isinf(Param.xrange(2)), Param.xrange(2) = unique(max([NITDp.X(:)', NITDn.X(:)'])); end
else
    if isinf(Param.xrange(1)), Param.xrange(1) = unique(min(NITDp.X)); end
    if isinf(Param.xrange(2)), Param.xrange(2) = unique(max(NITDp.X)); end
end    
               
%Eerst oorspronkelijke curven en hun cubic-spline interpolatie plotten ...
MinY = max([0, Param.yrange(1)]); MaxY = Param.yrange(2);
MinX = Param.xrange(1); MaxX = Param.xrange(2);

Ax_NITD = axes('Position', [0.05 0.625 0.75 0.275], 'Box', 'off', 'NextPlot', 'add');

Hdl = plot(NITDp.X, NITDp.Y, 'b+-');
if ~isempty(NITDn), Hdl(end+1) = plot(NITDn.X, NITDn.Y, 'g^-'); end
if ~isempty(NITDc), Hdl(end+1) = plot(NITDc.X, NITDc.Y, 'ko-'); end
Hdl(end+1) = plot(NITDp.XFit, NITDp.YFit, 'b:');
if ~isempty(NITDn), Hdl(end+1) = plot(NITDn.XFit, NITDn.YFit, 'g:'); end

title(TitleTxt, 'FontSize', 12);
xlabel('Delay (\mus)'); ylabel('Rate (spk/sec)');
axis([MinX MaxX MinY MaxY]);

line([0, 0], [MinY, MaxY], 'Color', [0 0 0], 'LineStyle', ':'); %Verticale nullijn
line([NITDp.FitBestITD*1000, NITDp.FitBestITD*1000], [MinY MaxY], 'Color', [0 0 0], 'LineStyle', ':'); %BestITD lijnen ...
if ~isempty(NITDn), line([NITDn.FitBestITD*1000, NITDn.FitBestITD*1000], [MinY MaxY], 'Color', [0 0 0], 'LineStyle', ':'); end
line(NITDp.XPeaks, NITDp.YPeaks, 'Color', 'b', 'LineStyle', ':', 'Marker', 'o'); 
if ~isempty(NITDn), line(NITDn.XPeaks, NITDn.YPeaks, 'Color', 'g', 'LineStyle', ':', 'Marker', 'o'); end

if ~isempty(NITDn) & (CORR.pCorrCoef < Param.corrsign), CorrSignTxt = 'YES'; else CorrSignTxt = 'NO'; end
if ~isempty(NITDn),
    InfoTxt = {sprintf('\\fontsize{10}NITD+\\fontsize{7}'); ...
            sprintf('OrigMax(i/s):%5.0f', NITDp.OrigMax); ...
            sprintf('FitMax(i/s): %5.0f', NITDp.FitMax); ...
            sprintf('OrigITD(ms): %3.2f', NITDp.OrigBestITD); ...
            sprintf('OrigITD(c):  %3.2f', NITDp.OrigBestITDc); ...
            sprintf('FitITD(ms):  %3.2f', NITDp.FitBestITD); ...
            sprintf('FitITD(c):   %3.2f', NITDp.FitBestITDc); ...
            sprintf('PeakRatio:   %3.2f', NITDp.PeakRatio); ...
            sprintf('\\fontsize{10}NITD-\\fontsize{7}'); ...
            sprintf('OrigMax(i/s):%5.0f', NITDn.OrigMax); ...
            sprintf('FitMax(i/s): %5.0f', NITDn.FitMax); ...
            sprintf('OrigITD(ms): %3.2f', NITDn.OrigBestITD); ...
            sprintf('OrigITD(c):  %3.2f', NITDn.OrigBestITDc); ...
            sprintf('FitITD(ms):  %3.2f', NITDn.FitBestITD); ...
            sprintf('FitITD(c):   %3.2f', NITDn.FitBestITDc); ...
            sprintf('PeakRatio:   %3.2f', NITDn.PeakRatio); ...
            sprintf('\\fontsize{10}CORRELATION\\fontsize{7}'); ...
            sprintf('Coef:        %1.3f', CORR.CorrCoef); ...
            sprintf('p:           %1.3f', CORR.pCorrCoef); ...
            sprintf('Sign(\\alpha = %.2f): %s', Param.corrsign, CorrSignTxt)};
else
    InfoTxt = {sprintf('\\fontsize{10}NITD+\\fontsize{7}'); ...
            sprintf('OrigMax(i/s):%5.0f', NITDp.OrigMax); ...
            sprintf('FitMax(i/s): %5.0f', NITDp.FitMax); ...
            sprintf('OrigITD(ms): %3.2f', NITDp.OrigBestITD); ...
            sprintf('OrigITD(c):  %3.2f', NITDp.OrigBestITDc); ...
            sprintf('FitITD(ms):  %3.2f', NITDp.FitBestITD); ...
            sprintf('FitITD(c):   %3.2f', NITDp.FitBestITDc); ...
            sprintf('PeakRatio:   %3.2f', NITDp.PeakRatio)};
end

if ~isempty(NITDc) & ~isempty(NITDn),
    LegendTxt = {sprintf('%s-NITD+', CellInfo.NITD.dsIDP), ...
            sprintf('%s-NITD-', CellInfo.NITD.dsIDN), ...
            sprintf('%s-NITD0', CellInfo.NITD.dsIDC), ...
            sprintf('%s-NITD+(SPLINE)', CellInfo.NITD.dsIDP), ...
            sprintf('%s-NITD-(SPLINE)', CellInfo.NITD.dsIDN)};
elseif isempty(NITDc) & ~isempty(NITDn)
    LegendTxt= {sprintf('%s-NITD+', CellInfo.NITD.dsIDP), ...
            sprintf('%s-NITD-', CellInfo.NITD.dsIDN), ...
            sprintf('%s-NITD+(SPLINE)', CellInfo.NITD.dsIDP), ...
            sprintf('%s-NITD-(SPLINE)', CellInfo.NITD.dsIDN)};
elseif isempty(NITDc) & isempty(NITDn)
    LegendTxt = {sprintf('%s-NITD+', CellInfo.NITD.dsIDP), ...
            sprintf('%s-NITD+(SPLINE)', CellInfo.NITD.dsIDP)};
end

%Gegevens van deze curven weergeven ...
Hdl_Lgd = legend(LegendTxt);
PrintInfo([0.8125 0.625 0.1725 0.275], InfoTxt, Interface, 'fontname', 'courier');

%Daarna diffcor en enveloppe plotten en eventueel gaborfir plotten ...
MinX = Param.xrange(1); MaxX = Param.xrange(2);

Ax_DIFF = axes('Position', [0.05 0.25 0.75 0.275], 'Box', 'off', 'NextPlot', 'add');

if ~isempty(DIFF),
    Hdl = plot(DIFF.X, DIFF.Y, 'b-');
    if strncmpi(Param.gaborfit, 'n', 1),
        Hdl([end+1, end+2]) = plot(DIFF.X, [DIFF.Env; -DIFF.Env], 'k:');
    else,
        Hdl(end+1) = plot(GABOR.X, GABOR.Y, 'b--');
        Hdl([end+1, end+2]) = plot(GABOR.X, [GABOR.Env; -GABOR.Env], 'k:');
    end
    
    title(sprintf('DiffCor Curve for %s <%d>', CellInfo.DataFile, CellInfo.CellNr), 'FontSize', 12);
    xlabel('Delay (\mus)'); ylabel('Normalized Rate');
    YLim = get(Ax_DIFF, 'YLim');
    xlim([MinX, MaxX]);
    MinY = YLim(1); MaxY = YLim(2);
    
    line([0, 0], [MinY, MaxY], 'Color', [0 0 0], 'LineStyle', ':');                              %Verticale nullijn 
    line([MinX, MaxX], [0, 0], 'Color', [0 0 0], 'LineStyle', ':');                              %Horizontale nullijn
    if strncmpi(Param.gaborfit, 'n', 1)
        line([DIFF.BestITD*1000, DIFF.BestITD*1000], [MinY MaxY], 'Color', [0 0 0], 'LineStyle', ':'); %BestITD lijn
        line(DIFF.BestITD*1000, DIFF.Max, [MinY MaxY], 'Color', [0 0 0], 'LineStyle', 'none', 'Marker', 'o');
        YInterSect = DIFF.Max/2;
        plotcintersect(DIFF.InterSect, YInterSect([1 1]), MinY);
        line(repmat(DIFF.SecPeaks(1), 1, 2)*1000, [MinY MaxY], 'Color', [0 0 0], 'LineStyle', ':');
        line(repmat(DIFF.SecPeaks(2), 1, 2)*1000, [MinY MaxY], 'Color', [0 0 0], 'LineStyle', ':');
        idx = find(ismember(DIFF.X, DIFF.SecPeaks*1000));
        if ~isempty(idx), line(DIFF.SecPeaks*1000, DIFF.Y(idx), 'Color', [0 0 0], 'LineStyle', 'none', 'Marker', 'o'); end
    else
        line([GABOR.BestITD*1000, GABOR.BestITD*1000], [MinY MaxY], 'Color', [0 0 0], 'LineStyle', ':'); %BestITD lijn
        line(GABOR.BestITD*1000, GABOR.Max, [MinY MaxY], 'Color', [0 0 0], 'LineStyle', 'none', 'Marker', 'o');
        YInterSect = GABOR.Max/2;
        plotcintersect(GABOR.InterSect, YInterSect([1 1]), MinY);
        line(repmat(GABOR.SecPeaks(1), 1, 2)*1000, [MinY MaxY], 'Color', [0 0 0], 'LineStyle', ':');
        line(repmat(GABOR.SecPeaks(2), 1, 2)*1000, [MinY MaxY], 'Color', [0 0 0], 'LineStyle', ':');
        idx = find(ismember(GABOR.X, GABOR.SecPeaks*1000));
        if ~isempty(idx), line(GABOR.SecPeaks*1000, GABOR.Y(idx), 'Color', [0 0 0], 'LineStyle', 'none', 'Marker', 'o'); end
    end    
    
    if strncmpi(Param.gaborfit, 'y', 1),
        legend(Hdl, {'DIFF(SPLINE)', ...
                'DIFF(GABOR)'});
        InfoTxt = {sprintf('\\fontsize{10}GABOR\\fontsize{7}'); ...
                sprintf('Max(i/s):    %5.0f', GABOR.Max); ...
                sprintf('ITD(ms):     %3.2f', GABOR.BestITD); ...
                sprintf('ITD(c):      %3.2f', GABOR.BestITDc); ...
                sprintf('HHW(ms):     %3.2f', GABOR.HHW); ...
                sprintf('HHW(c):      %3.2f', GABOR.HHWc); ...
                sprintf('SecPeaks(ms): %3.2f/%3.2f', GABOR.SecPeaks); ...
                sprintf('ZeroPeak(ms): %3.2f', GABOR.ZeroPeak); ...
                sprintf('\\fontsize{10}CONSTANTS\\fontsize{7}'); ...
                sprintf('Amp(i/s):    %5.0f', GABOR.Constants.A); ...
                sprintf('EnvMax(ms):  %3.2f', GABOR.Constants.EnvMax/1000); ...
                sprintf('EnvWidth(ms):%3.2f', GABOR.Constants.EnvWidth/1000); ...
                sprintf('Freq(kHz):   %3.2f', GABOR.Constants.Freq*1e3); ...
                sprintf('Phase(c):    %3.2f', GABOR.Constants.Ph/2/pi); ...
                sprintf('AccFraction: %3.2f', GABOR.Constants.AccFraction); ... 
                sprintf('\\fontsize{10}ENVELOPPE\\fontsize{7}'); ...
                sprintf('Peak(ms):    %3.2f', GABOR.EnvPeak); ...
                sprintf('Peak(c):     %3.2f', GABOR.EnvPeakc)};
    else, 
        legend(Hdl, {'DIFF(SPLINE)'}); 
        InfoTxt = {sprintf('\\fontsize{10}DIFFCOR\\fontsize{7}'); ...
                sprintf('Max(i/s): %5.0f', DIFF.Max); ...
                sprintf('ITD(ms):  %3.2f', DIFF.BestITD); ...
                sprintf('ITD(c):   %3.2f', DIFF.BestITDc); ...
                sprintf('HHW(ms):  %3.2f', DIFF.HHW); ...
                sprintf('HHW(c):   %3.2f', DIFF.HHWc); ...
                sprintf('SecPeaks(ms): %3.2f/%3.2f', DIFF.SecPeaks); ...
                sprintf('ZeroPeak(ms): %3.2f', DIFF.ZeroPeak); ...
                sprintf('ScaleFactor:  %3.2f', DIFF.Scale); ...
                sprintf('\\fontsize{10}ENVELOPPE\\fontsize{7}'); ...
                sprintf('Peak(ms): %3.2f', DIFF.EnvPeak); ...
                sprintf('Peak(c):  %3.2f', DIFF.EnvPeakc)};
    end
else, 
    Ax_DIFF = PrintInfo([0.05 0.25 0.75 0.275], sprintf('DIFFCOR not calculated.'), Interface, 'boxcolor', [0.9 0.9 0.9], 'fontsize', 12);
    InfoTxt = cell(0); 
end

%Gegevens van deze curven weergeven ...
PrintInfo([0.8125 0.25 0.1725 0.275], InfoTxt, Interface, 'fontname', 'courier');

%Fourier-analyse in linkeronderhoek plotten ...
Ax_FFT_Magn = axes('Position', [0.05 0.05 0.35 0.10], 'Box', 'on', 'NextPlot', 'add');

MinX = Param.fftxrange(1); MaxX = Param.fftxrange(2);
MinY = Param.fftyrange(1); MaxY = Param.fftyrange(2);

if isempty(DIFF), FFT = NITDp.FFT;
else FFT = DIFF.FFT; end

Hdl = plot(FFT.Freq, FFT.Magn.dB, 'b-');
set(Hdl(2), 'LineStyle', ':', 'Marker', 'none', 'Color', 'k');

xlabel('Frequency (Hz)'); ylabel('dB');
axis([MinX MaxX MinY MaxY]);

line([FFT.DF, FFT.DF], [MinY MaxY], 'Color', [0 0 0], 'LineStyle', ':');
plotcintersect(FFT.BWedges, FFT.Params.bwcutoff([1 1]), MinY);
 
legend(Hdl, {'FFT', 'RunAv'});

text(MinX, MaxY, {sprintf('DF: %.0fHz', FFT.DF); ...
                  sprintf('BW: %.0fHz', FFT.BW)
              }, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

Ax_FFT_Ph = axes('Position', [0.45 0.05 0.35 0.10], 'Box', 'on', 'NextPlot', 'add');

Hdl(1) = plot(FFT.Freq, FFT.Ph.Rad, 'b-');

xlabel('Frequency (Hz)'); ylabel('Rad');
MinY = min(FFT.Ph.Rad(find(FFT.Freq >= MinX & FFT.Freq <= MaxX))); MaxY = max(FFT.Ph.Rad(find(FFT.Freq >= MinX & FFT.Freq <= MaxX)));
axis([MinX MaxX MinY MaxY]);

line([FFT.DF, FFT.DF], [MinY FFT.FsD], 'Color', [0 0 0], 'LineStyle', ':');
line([MinX, FFT.DF], [FFT.FsD FFT.FsD], 'Color', [0 0 0], 'LineStyle', ':');

a = FFT.GD *2 *pi /1000;
b = FFT.FsD - a * FFT.DF;
Hdl(2) = line([MinX MaxX], a.*[MinX MaxX]+b, 'LineStyle', ':', 'Color', [0 0 0], 'Marker', 'none');

legend(Hdl, {'FFT', 'LinFit'});
 
text(MinX, MaxY, {sprintf('GD: %.2fms', FFT.GD); ...
                  sprintf('FsD: %.2frad', FFT.FsD); ...
                  sprintf('AccFrac: %.0f%%', FFT.AccFrac*100)
              }, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

%Extra inforamtie plotten ...
if (Param.anwin ~= -1), s1 = sprintf('AnWin : [%dms-%dms]', Param.anwin);
else s1 = sprintf('AnWin : [%dms-SD]', Param.anwin(1)); end

if isinf(Param.calcrange(1)) & isinf(Param.calcrange(2)), s2 = sprintf('CalcRange : [N/A-N/A]'); 
elseif isinf(Param.calcrange(1)), s2 = sprintf('CalcRange : [N/A-%.2fms]', Param.calcrange(2)/1000);
elseif isinf(Param.calcrange(2)), s2 = sprintf('CalcRange : [%.2fms-N/A]', Param.calcrange(1)/1000);    
else s2 = sprintf('CalcRange : [%.2fms-%.2fms]', Param.calcrange(1)/1000, Param.calcrange(2)/1000); end 

if ~isempty(THR), THRTxt = {'\fontsize{10}THRESHOLD DATA\fontsize{7}'; sprintf('CF : %.0fHz', THR.CF); sprintf('SR : %.1fspk/sec', THR.SR)};
else, THRTxt = {'\fontsize{10}THR data not present\fontsize{7}'}; end

if ~iscellstr(Param.plottext), Param.plottext = { Param.plottext }; end
PrintInfo([0.8125 0.05 0.1725 0.10], cat(1, Param.plottext, {'\fontsize{10}CALCULATION PARAMETERS\fontsize{7}'}, {s1}, {s2}, {''}, THRTxt), Interface, 'fontname', 'courier', 'fontsize', 7);

%-----------------------------------------------------------------------------------------------
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

%---------------------------------------------------------------------------------------------
function S = RecLowerFields(S)

FNames  = fieldnames(S);
NFields = length(FNames);
for n = 1:NFields,
    Val = getfield(S, FNames{n});
    S = rmfield(S, FNames{n});
    if isstruct(Val), S = setfield(S, lower(FNames{n}), RecLowerFields(Val));  %Recursive ...
    else, S = setfield(S, lower(FNames{n}), Val); end
end