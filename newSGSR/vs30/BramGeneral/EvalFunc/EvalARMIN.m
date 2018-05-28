function CalcData = EvalARMIN(varargin)
%EVALARMIN evaluate ARMIN-datasets
%   EVALARMIN('IC', dsARMIN+, dsARMIN-, ...)
%   EVALARMIN('IC', dsARMIN+, dsARMIN-, dsNRHO, ...)
%   evaluates ARMIN datasets dsARMIN+ and dsARMIN- recorded from an
%   IC cell. One of these datasets must contain responses to A+ and
%   various flip frequencies, the other responses of that same cell
%   for A- and the same flip frequencies. If an NRHO-dataset is present
%   for the cell, a filter approximation can be derived for the binaural
%   cell using the correlation-rate function.
%
%   EVALARMIN('AN', dsARMIN, ...)
%   EVALARMIN('AN', dsARMIN, dsNRHO, ...)
%   evaluates ARMIN-dataset collected from a AN fiber. This ARMIN-dataset
%   needs to be of version 3, i.e. in addition to the requested flip
%   frequencies, the responses to two extra flip frequencies were also
%   recorded. These are the edge frequencies of the noise bandwidth.
%   If an NRHO-dataset is present for that fiber, a filter approximation
%   can be derived for a simulated coincidence detector using the
%   correlation-rate function.
%
%   EVALARMIN('ANOLD', dsA+, dsA-, dsFF, ...) 
%   EVALARMIN('ANOLD', dsA+, dsA-, dsFF, dsNRHO, ...)
%   evaluates ARMIN-datasets collected from a AN fiber, where dsA+
%   should contain the response of the fiber to the original noise
%   token, dsA- the response to the phase-inverted noise token and
%   dsFF the response to different ARMIN-noise stimuli. If an 
%   NRHO-dataset is present for that fiber, a filter approximation can
%   be derived for a simulated coincidence detector using the correlation-rate
%   function.
%
%   If an output argument is supplied, extracted data is returned as
%   a scalar structure.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default values,
%   use 'list' as only property.

%B. Van de Sande 08-12-2004

%-----------------------------------------hoofd programma--------------------------------------------------------
%Template toegepast op de gegevens die teruggevraagd worden ...
Template.DSP.FileName   = '';  %Identificatie ...
Template.DSP.iCell      = NaN; 
Template.DSP.SeqID      = '';
Template.DSN.SeqID      = '';
Template.DSFF.SeqID     = '';
Template.DSNRHO.SeqID   = '';

Template.DSP.SPL        = NaN; %Stimulus parameters ...

Template.ARMIN.CF       = NaN; %Berekende gegevens ...
Template.ARMIN.HHW      = NaN;

Template.DIFF.CF        = NaN;
Template.DIFF.HHW       = NaN;

Template.FILTER.CF      = NaN;
Template.FILTER.BW      = NaN;
Template.FILTER.ERB     = NaN;

%Standaard parameterlijst ...
%... Plot Parameters ...
DefParam.plot        = 'yes';      %gegevens plotten of enkel berekenen ...
DefParam.xrange      = [NaN, NaN]; %in Hz ...
DefParam.yrange      = [NaN, NaN]; %in spk/sec ...
DefParam.diagyrange  = [50 100];   %in % ...  
DefParam.dbscale     = 'no';       %filter functie in genormaliseerde power (som onder curve is 1) of in dB tov
                                   %maximum ...
                                   
%... Calculatie Parameters ...
DefParam.anwin       = [0, -1];    %in ms ...
DefParam.cowin       = 0.050;      %in ms ...
DefParam.runavrange  = 20;         %in aantal elementen of in Hz ...
DefParam.runavunit   = '#';        %aantal elementen '#' of in Hz 'Hz' ...

DefParam.accfracthr  = 30;         %in procent ...
DefParam.filterrange = [0, 2000];  %in Hz ...
DefParam.filtersr    = 1;          %in elementen per Hz ... 
DefParam.ratecomp    = 'no';       %al of niet correctie voor poisson-distributie van rate-curven ...

DefParam.diagrange    = 500;       %in Hz ...
DefParam.diagsr       = 10;        %in elementen per Hz ...

%Parameters evalueren ...
[DSP, DSN, DSFF, DSNRHO, FF1, R1, FF2, R2, Rho, R, CellInfo, StimParam, Param] = evalparam(varargin, DefParam);

%Bererkeningen uitvoeren ...
[ARMIN, DIFF, NRHO] = calcARMIN(FF1, R1, FF2, R2, Rho, R, Param);

%Filter approximatie uitvoeren indien NRHO-gegevens meegegeven werden ...
if ~isempty(NRHO), FILTER = calcFILTER(ARMIN, NRHO, StimParam, Param);
else FILTER = struct([]); end

%Gegevens weergeven indien gevraagd ...
if strncmpi(Param.plot, 'y', 1), plotARMIN(ARMIN, DIFF, NRHO, FILTER, CellInfo, StimParam, Param); end

%Output parameters nagaan ...
if nargout == 1, CalcData = structtemplate(CollectInStruct(DSP, DSN, DSFF, DSNRHO, ARMIN, DIFF, NRHO, FILTER), Template); end

%------------------------------------------locale functies---------------------------------------------------
function [DSP, DSN, DSFF, DSNRHO, FF1, R1, FF2, R2, Rho, R, CellInfo, StimParam, Param] = evalparam(ParamList, DefParam)

[DSP, DSN, DSFF, DSNRHO] = deal(struct([]));

Nargin = length(ParamList);

if Nargin < 1, error('Wrong number of input parameters.'); end
if ~ischar(ParamList{1}) | ~any(strcmpi(ParamList{1}, {'ic', 'an', 'annew', 'anold'})), error('Wrong mode, should be ''an'', ''annew'', ''anold'' or ''ic''.'); end
Mode = lower(ParamList{1});

switch Mode
case {'an', 'annew'} %Auditory Nerve ... ARMIN-datasets of version 3 ...
    %EVALARMIN('AN', dsARMIN, ...)
    %EVALARMIN('AN', dsARMIN, dsNRHO, ...)
    if Nargin < 2, error('Wrong number of input arguments.'); end
    
    dsARMIN = ParamList{2};
    if ~isa(dsARMIN, 'dataset') | ~strcmpi(dsARMIN.stimtype, 'armin'), error('Second argument should be ARMIN-dataset.'); end
    if dsARMIN.stimparam.AKversion ~= 3, error('If only one ARMIN-dataset is supplied in ''an''-mode, it needs to be of version 3.'); end
        
    if Nargin == 2, dsNRHO = []; PLidx = 3;
    elseif Nargin == 3, dsNRHO = ParamList{3}; PLidx = 4;
    elseif isa(ParamList{3}, 'dataset'), dsNRHO = ParamList{3}; PLidx = 4;
    else, dsNRHO = []; PLidx = 3; end    
    
    if ~isempty(dsNRHO) & (~isa(dsNRHO, 'dataset') | ~strcmpi(dsNRHO.stimtype, 'nrho')), error('Third argument should be NRHO-dataset.'); end
    if ~isempty(dsNRHO) & ~isequal(dsARMIN.FileName, dsNRHO.FileName), error('Datasets should be of same datafile.'); end
    if ~isempty(dsNRHO) & ~isequal(dsARMIN.iCell, dsNRHO.iCell), error('Datasets should contain responses from the same cell.'); end
        
    %Gegevens over dataset achterhalen ...
    CellInfo.Mode     = 'an';
    CellInfo.DataFile = dsARMIN.FileName;
    CellInfo.CellNr   = dsARMIN.iCell;
    [dummy, CellInfo.ARMIN.TestNrs, CellInfo.ARMIN.dsIDs{1}] = unraveldsID(dsARMIN.SeqID);
    if isempty(dsNRHO), CellInfo.NRHO = struct([]);
    else [dummy, CellInfo.NRHO.TestNr, CellInfo.NRHO.dsID] = unraveldsID(dsNRHO.SeqID); end
        
    %Stimulus parameters nagaan ...
    StimParam = checkstimparam(dsARMIN, dsNRHO);
        
    %Extra properties nagaan ... 
    Param = checkproplist(DefParam, ParamList{PLidx:end});
    Param = checkparam(Param, StimParam);
    
    %Enkel rate-curven overhouden ...
    Nrec = dsARMIN.nrec;
    [FF, idx] = unique(dsARMIN.indepval(1:Nrec)');
    SubSeqP = idx(1); SubSeqN = idx(end);
    if FF(1) ~= dsARMIN.flow | FF(end) ~= dsARMIN.fhigh, error('One of the subsequenties with FF at the bandwitdh-edges wasn''t recorded.'); end
    %if dsARMIN.polaconst ~= dsARMIN.polahigh, [SubSeqP, SubSeqN] = swap(SubSeqP, SubSeqN); end
    
    FF1 = FF([2:end-1]);
    R1 = spktrco(anwin(dsARMIN.spt(SubSeqP, :), Param.anwin), anwin(dsARMIN.spt(idx(2:end-1), :), Param.anwin), StimParam.burstdur, Param.cowin);
    
    FF2 = FF1;
    R2 = spktrco(anwin(dsARMIN.spt(SubSeqN, :), Param.anwin), anwin(dsARMIN.spt(idx(2:end-1), :), Param.anwin), StimParam.burstdur, Param.cowin);
    
    if isempty(dsNRHO), [Rho, R] = deal([]);
    else, [Rho, R] = calcANNRHO(dsNRHO, dsARMIN, SubSeqP, dsARMIN, SubSeqN, StimParam, Param); end
    
    %Dataset-gegevens uniformiseren ...
    DSP = emptyDataSet(dsARMIN);
    if ~isempty(dsNRHO), DSNRHO = emptyDataSet(dsNRHO); end
case 'anold' %Auditory Nerve ... ARMIN-datasets with version less then 3 ...
    %EVALARMIN('ANOLD', dsA+/-, dsA-/+, dsFF, ...) 
    %EVALARMIN('ANOLD', dsA+/-, dsA-/+, dsFF, dsNRHO, ...)
    if Nargin < 4, error('Wrong number of input arguments.'); end

    [dsARMIN1, dsARMIN2, dsFF] = deal(ParamList{2:4});
    if ~isa(dsARMIN1, 'dataset') | ~isa(dsARMIN2, 'dataset') | ~isa(dsFF, 'dataset'), error('Second, third and fourth arguments should be dataset objects.'); end
    if ~all(strcmpi({dsARMIN1.StimType, dsARMIN2.StimType, dsFF.StimType}, 'armin')), error('Second, third and fourth datasets should contain responses to ARMIN stimulus.'); end
    if ~isequal(dsARMIN1.FileName, dsARMIN2.FileName, dsFF.FileName), error('Datasets should be of same datafile.'); end
    if ~isequal(dsARMIN1.iCell, dsARMIN2.iCell, dsFF.iCell), error('Datasets should contain responses from the same cell.'); end
    
    if Nargin == 4, dsNRHO = []; PLidx = 5;
    elseif Nargin == 5, dsNRHO = ParamList{5}; PLidx = 6;
    elseif isa(ParamList{5}, 'dataset'), dsNRHO = ParamList{5}; PLidx = 6;
    else, dsNRHO = []; PLidx = 5; end
    
    if ~isempty(dsNRHO) & ~strcmpi(dsNRHO.StimType, 'nrho'), error('Optional third argument should contain responses to NRHO stimulus.'); end
    if ~isempty(dsNRHO) & ~isequal(dsARMIN1.FileName, dsNRHO.FileName), error('Datasets should be of same datafile.'); end
    if ~isempty(dsNRHO) & ~isequal(dsARMIN1.iCell, dsNRHO.iCell), error('Datasets should contain responses from the same cell.'); end
    
    %Nagaan of ARMIN-datasets wel juist gegeven zijn, anders veranderen ...
    if length(dsFF.indepval) == 1 | dsFF.varear ~= 1,
        error('Fourth argument should be ARMIN-dataset with responses to noise tokens with different flipfrequencies.');
    end    
    
    if length(dsARMIN1.indepval) ~= 1 | dsARMIN1.constear ~= 1 | dsARMIN1.polaconst ~= +1,
        error('Second argument should be ARMIN-dataset with responses to original noise token (A+).');
    end    
    
    if length(dsARMIN2.indepval) ~= 1 | dsARMIN2.constear ~= 1 | dsARMIN2.polaconst ~= -1, 
        error('Third argument should be ARMIN-dataset with responses to inverted noise token (A-).');
    end    
    
    %Gegevens over dataset achterhalen ...
    CellInfo.Mode     = 'ic';
    CellInfo.DataFile = dsARMIN1.FileName;
    CellInfo.CellNr   = dsARMIN1.iCell;
    [dummy, CellInfo.ARMIN.TestNrs(1), CellInfo.ARMIN.dsIDs{1}] = unraveldsID(dsARMIN1.SeqID);
    [dummy, CellInfo.ARMIN.TestNrs(2), CellInfo.ARMIN.dsIDs{2}] = unraveldsID(dsARMIN2.SeqID);
    [dummy, CellInfo.ARMIN.TestNrs(3), CellInfo.ARMIN.dsIDs{3}] = unraveldsID(dsFF.SeqID);
    if ~isempty(dsNRHO), [dummy, CellInfo.NRHO.TestNr, CellInfo.NRHO.dsID] = unraveldsID(dsNRHO.SeqID);
    else CellInfo.NRHO = struct([]); end
    
    %Stimulus parameters nagaan ...
    StimParam = checkstimparam(dsARMIN1, dsARMIN2, dsFF, dsNRHO);
    
    %Extra properties nagaan ... 
    Param = checkproplist(DefParam, ParamList{PLidx:end});
    Param = checkparam(Param, StimParam);
    
    %Berekenen van ratecurven ...
    Nrec = dsFF.nrec; FFidx = 1:Nrec;
    if dsFF.polahigh < dsFF.polalow, FFidx = fliplr(FFidx); end
    [FF1, idx] = sort(dsFF.indepval(1:Nrec)');
    R1 = spktrco(anwin(dsARMIN1.spt(1, :), Param.anwin), anwin(dsFF.spt(FFidx, :), Param.anwin), StimParam.burstdur, Param.cowin);
    R1 = R1(idx);
    
    FF2 = FF1;
    R2 = spktrco(anwin(dsARMIN2.spt(1, :), Param.anwin), anwin(dsFF.spt(FFidx, :), Param.anwin), StimParam.burstdur, Param.cowin);
    R2 = R2(idx);
    
    if isempty(dsNRHO), [Rho, R] = deal([]);
    else, [Rho, R] = calcANNRHO(dsNRHO, dsARMIN1, 1, dsARMIN2, 1, StimParam, Param); end
    
    %Dataset-gegevens uniformiseren ...
    DSP = emptyDataSet(dsARMIN1);
    DSN = emptyDataSet(dsARMIN2);
    DSFF = emptyDataSet(dsFF);
    if ~isempty(dsNRHO), DSNRHO = emptyDataSet(dsNRHO); end
case 'ic' %Inferior Colliculus ...
    %EVALARMIN('IC', dsARMIN+/-, dsARMIN-/+, ...)
    %EVALARMIN('IC', dsARMIN+/-, dsARMIN-/+, dsNRHO, ...)
    if Nargin < 3, error('Wrong number of input arguments.'); end
    
    [dsARMIN1, dsARMIN2] = deal(ParamList{2:3});
    if ~isa(dsARMIN1, 'dataset') | ~isa(dsARMIN2, 'dataset'), error('Second and third arguments should be dataset objects.'); end
    if ~all(strcmpi({dsARMIN1.StimType, dsARMIN2.StimType}, 'armin')), error('First two datasets should contain responses to ARMIN stimulus.'); end
    if ~isequal(dsARMIN1.FileName, dsARMIN2.FileName), error('Datasets should be of same datafile.'); end
    if ~isequal(dsARMIN1.iCell, dsARMIN2.iCell), error('Datasets should contain responses from the same cell.'); end
    
    if Nargin == 3, dsNRHO = []; PLidx = 4;
    elseif Nargin == 4, dsNRHO = ParamList{4}; PLidx = 5;
    elseif isa(ParamList{4}, 'dataset'), dsNRHO = ParamList{4}; PLidx = 5;
    else, dsNRHO = []; PLidx = 4; end
    
    if ~isempty(dsNRHO) & ~strcmpi(dsNRHO.StimType, 'nrho'), error('Optional third argument should contain responses to NRHO stimulus.'); end
    if ~isempty(dsNRHO) & ~isequal(dsARMIN1.FileName, dsNRHO.FileName), error('Datasets should be of same datafile.'); end
    if ~isempty(dsNRHO) & ~isequal(dsARMIN1.iCell, dsNRHO.iCell), error('Datasets should contain responses from the same cell.'); end
    
    %Polariteit van aangeboden stimulus nagaan ...
    if isequal([dsARMIN1.polalow, dsARMIN1.polahigh], [dsARMIN2.polalow, dsARMIN2.polahigh]), error('ARMIN datasets have same polarity.'); end
    if ~isequal(dsARMIN1.delay, dsARMIN2.delay), error('ARMIN-datasets were not recorded at same ITD.'); end
    if dsARMIN1.polalow == +1, warning('Assuming cell must be a througher, first ARMIN-dataset contains response to A-, the second to A+.'); end    
    
    %Gegevens over dataset achterhalen ...
    CellInfo.Mode     = 'ic';
    CellInfo.DataFile = dsARMIN1.FileName;
    CellInfo.CellNr   = dsARMIN1.iCell;
    [dummy, CellInfo.ARMIN.TestNrs(1), CellInfo.ARMIN.dsIDs{1}] = unraveldsID(dsARMIN1.SeqID);
    [dummy, CellInfo.ARMIN.TestNrs(2), CellInfo.ARMIN.dsIDs{2}] = unraveldsID(dsARMIN2.SeqID);
    if ~isempty(dsNRHO), [dummy, CellInfo.NRHO.TestNr, CellInfo.NRHO.dsID] = unraveldsID(dsNRHO.SeqID);
    else CellInfo.NRHO = struct([]); end
    
    %Stimulus parameters nagaan ...
    StimParam = checkstimparam(dsARMIN1, dsARMIN2, dsNRHO);
    
    %Extra properties nagaan ... 
    Param = checkproplist(DefParam, ParamList{PLidx:end});
    Param = checkparam(Param, StimParam);
    
    %Berekenen van ratecurven ...
    Nrec = dsARMIN1.nrec;
    [FF1, idx] = sort(dsARMIN1.indepval(1:Nrec)');
    R1 = getrate(dsARMIN1, 1:Nrec, Param.anwin(1), Param.anwin(2));
    R1 = R1(idx);
    
    Nrec = dsARMIN2.nrec;
    [FF2, idx] = sort(dsARMIN2.indepval(1:Nrec)');
    R2 = getrate(dsARMIN2, 1:Nrec, Param.anwin(1), Param.anwin(2));
    R2 = R2(idx);
    
    %Bij versie 3 van ARMIN stimulus worden naast de gevraagde flip frequenties ook de frequenties die overeenkomen
    %met de grenzen van de noise-bandbreedte aangeboden ... deze zijn te interpreteren als de asymptotische waarden
    %maar worden voor dit programma verwijderd ...
    if StimParam.version == 3,
        FF1([1, end]) = []; R1([1, end]) = [];
        FF2([1, end]) = []; R2([1, end]) = [];
    end

    if ~isempty(dsNRHO),
        Nrec = dsNRHO.nrec;
        [Rho, idx] = sort(dsNRHO.indepval(1:Nrec)');
        R = getrate(dsNRHO, 1:Nrec, Param.anwin(1), Param.anwin(2));
        R = R(idx);
        
        %Indien NRHO-dataset gerecord is thv een dal op de NITD-curve, dan curve omkeren ...
        if R(1) > R(end), R = fliplr(R); end
    else, [Rho, R] = deal([]); end
    
    %Dataset-gegevens uniformiseren ...
    DSP = emptyDataSet(dsARMIN1);
    DSN = emptyDataSet(dsARMIN2);
    if ~isempty(dsNRHO), DSNRHO = emptyDataSet(dsNRHO); end
end

function [ARMIN, DIFF, NRHO] = calcARMIN(FF1, R1, FF2, R2, Rho, R, Param)

%Incomplete data die weggevallen is omwille van rectificatie aanvullen met nullen ...
FFdiff = intersect(FF1, FF2);
N1 = length(FF2) - length(FFdiff);
N2 = length(FF1) - length(FFdiff);
if any([N1, N2]),
    warning(sprintf('Flip frequency range differs for ARMIN-datasets, rectification assumed as reason.\nZeros are appended to compensate.'));
    [FF1, FF2] = deal(union(FF1, FF2));
    R1 = [R1 zeros(1, N1)];
    R2 = [zeros(1, N2) R2];
end

%Normaliseren naar standaard deviatie om drift in response weg te krijgen ... en lopend gemiddelde nemen ...
R1norm = R1 / std(R1);
R2norm = R2 / std(R2);

if strncmpi(Param.runavunit, 'h', 1),
    df1 = FF1(2) - FF1(1); RunAvN1 = Param.runavrange / df1;
    df2 = FF2(2) - FF2(1); RunAvN2 = Param.runavrange / df2;
else, [RunAvN1, RunAvN2] = deal(Param.runavrange); end    

R1av = runav(R1norm, RunAvN1);
R2av = runav(R2norm, RunAvN2);

%Snijpunt tussen twee genormaliseerde curven nagaan ...
[xi, yi] = interceptARMIN(FF1, R1av, FF2, R2av);
CF = xi; %Center Frequency in Hz van de binaurale filter ...

%Maximum wordt gegeven door het gemiddelde van het maximum van beide curven ...
MaxRnorm = mean([max(R1av), max(R2av)]);
HH       = (MaxRnorm + yi)/2;

%Snijpunten met rechte op halve hoogte bepalen ...
pc(2) = HH;

idx = max(find(R1av > HH));
if ~isempty(idx),
    x1 = FF1([idx, idx+1]); y1 = R1av([idx, idx+1]);
    
    p1 = polyfit(x1, y1, 1);
    HHWx1 = intercept(p1, pc);
else HHWx1 = NaN; end
    
idx = min(find(R2av > HH));
if ~isempty(idx),
    x2 = FF2([idx-1, idx]); y2 = R2av([idx-1, idx]);
    
    p2 = polyfit(x2, y2, 1);
    HHWx2 = intercept(p2, pc);
else HHWx2 = NaN; end
    
%De breedte thv van de halve hoogte berekenen ...
HHW = HHWx2 - HHWx1;

%Verschil curve maken om rectificatie probleem op te lossen ...
%FFdiff = intersect(FF1, FF2);
%idx1 = find(ismember(FF1, FFdiff)); idx2 = find(ismember(FF2, FFdiff));
%Rdiff = R1av(idx1) - R2av(idx2);
FFdiff = FF1; Rdiff = R1av - R2av;

%Rdiff horizontaal spiegelen rond CF ...
idx = find(FFdiff > xi);
Rdiff(idx) = abs(Rdiff(idx));

xdi = xi; ydi = interp1(FFdiff, Rdiff, xi);

%Maximum wordt gegeven door het gemiddelde van het maximum van beide curven ...
MaxRdiff = mean(Rdiff([1,end]));
HHdiff   = (MaxRdiff + ydi)/2;

%Snijpunten met rechte op halve hoogte bepalen ...
pc(2) = HHdiff;

idx = min(find(Rdiff < HHdiff));
if idx > 1,
    x1 = FFdiff([idx, idx-1]); y1 = Rdiff([idx, idx-1]);
    
    p1 = polyfit(x1, y1, 1);
    HHWx1diff = intercept(p1, pc);
else HHWx1diff = NaN; end
    
%idx = max(find(Rdiff < HHdiff));
%Nieuwe techniek ingevoerd omwille van C0222 <16-10>, <16-9>.
idxadd = min(find(FFdiff > xi)) - 1;
idx = min(find(Rdiff(idxadd+1:end) > HHdiff));
if (idxadd+idx) < length(Rdiff),
    x2 = FFdiff([idxadd+idx, idxadd+idx+1]); y2 = Rdiff([idxadd+idx, idxadd+idx+1]);
    
    p2 = polyfit(x2, y2, 1);
    HHWx2diff = intercept(p2, pc);
else HHWx2diff = NaN; end
    
HHWdiff = HHWx2diff - HHWx1diff;

%Standaard analyse geeft de volgende gegevens : 
%R1norm, R1av, R2norm, R2av, CF, HH, HHWx1, HHWx2, HHW, FFdiff, Rdiff, HHdiff, HHWx1diff, HHWx2diff, HHWdiff.

ARMIN = struct('FF1', FF1, 'R1', R1, 'R1av', R1av, 'R1norm', R1norm, ...
               'FF2', FF2, 'R2', R2, 'R2av', R2av, 'R2norm', R2norm, ...
               'intercept', [xi, yi], 'CF', CF, 'HH', HH, 'HHWx', [HHWx1, HHWx2], 'HHW', HHW);
DIFF  = struct('FF', FFdiff, 'R', Rdiff, ...
               'intercept', [xdi, ydi], 'CF', CF, 'HH', HHdiff, 'HHWx', [HHWx1diff, HHWx2diff], 'HHW', HHWdiff);
if ~isempty(Rho) & ~isempty(R), NRHO = CollectInStruct(Rho, R);
else NRHO = struct([]); end    

function FILTER = calcFILTER(ARMIN, NRHO, StimParam, Param)

FILTER = struct([]);

%Boogtangens functies fitten in de originele rate-curven ...
MaxY = max(ARMIN.R1); Cstart = [MaxY -0.001 ARMIN.CF MaxY/2];
[Carmin1, AFarmin1] = bgtgfit(ARMIN.FF1, ARMIN.R1, Cstart);
MaxY = max(ARMIN.R2); Cstart = [MaxY +0.001 ARMIN.CF MaxY/2];
[Carmin2, AFarmin2] = bgtgfit(ARMIN.FF2, ARMIN.R2, Cstart);

%Exponentiele functie fitten in rho versus rate curve ...
%[Cnrho, AFnrho] = expfit(NRHO.Rho, NRHO.R);
%Tweede graadsveelterm fitten in rho versus rate curve ...
Cnrho = polyfit(NRHO.Rho, NRHO.R, 2);
AFnrho = getaccfrac(inline('polyval(c, x)', 'c', 'x'), Cnrho, NRHO.Rho, NRHO.R);

%Indien fits niet accuraat genoeg zijn dan geen filter approximatie ...
if any([AFarmin1 AFarmin2 AFnrho] < (Param.accfracthr/100)), warning('Curve fit isn''t accurate enough for filter approximation.'); return; end

%Range waarover berekend wordt wordt bepaald door de maximale range over de twee curven, met de
%oorspronkelijke samplerate ...
FFrange = linspace(min([ARMIN.FF1, ARMIN.FF2]), max([ARMIN.FF1, ARMIN.FF2]), length(union(ARMIN.FF1,ARMIN.FF2)));

%Normalisatie van de oorspronkelijke ARMIN-gegevens zodat maxima en minina in rate gelijk worden over 
%al deze curven, immers in theorie zou de respons van de cel gelijk moeten zijn over de extremen want 
%dezelfde stimulus werd aangeboden ...
Ydata = bgtgfunc(Carmin1, FFrange);
MinY = min(Ydata); MaxY = max(Ydata);
R1fitnorm = (ARMIN.R1 - MinY)/(MaxY - MinY);

Ydata = bgtgfunc(Carmin2, FFrange);
MinY = min(Ydata); MaxY = max(Ydata);
R2fitnorm = (ARMIN.R2 - MinY)/(MaxY - MinY);

%Exponentiele functie die NRHO-gegevens fit normaliseren ...
%Ydata = expfunc(Cnrho, NRHO.Rho);
%MinY = min(Ydata); MaxY = max(Ydata);
%Cnrhonorm = [Cnrho(1)/(MaxY-MinY) Cnrho(2:3) (Cnrho(4)-MinY)/(MaxY-MinY)];
%Tweede graadsveelterm functie die NRHO-gegevens fit normaliseren ...
Ydata = polyval(Cnrho, NRHO.Rho);
MinY = min(Ydata); MaxY = max(Ydata);
Cnrhonorm = [Cnrho(1:2)/(MaxY-MinY) (Cnrho(3)-MinY)/(MaxY-MinY)];

%Indien correctie aangevraagd voor poisson-distributie van spike-activiteit van een cel, dan wordt vierkants-
%wortel genomen van de reeds genormaliseerde rate-curven ... Hierdoor compressie van grotere spreiding bij hogere
%rates ...
if strncmpi(Param.ratecomp, 'y', 1),
    %Negatieve getallen geven compexe getallen, deze worden op nul gezet ...
    R1fitnorm(find(R1fitnorm < 0)) = 0; 
    R1fitnorm = sqrt(R1fitnorm);
    R2fitnorm(find(R2fitnorm < 0)) = 0; 
    R2fitnorm = sqrt(R2fitnorm);
end    

%Filter met twee parameters, namelijk center frequency (CF) en bandbreedte (BW) passen in deze 
%genormaliseerde data ...
filtermodel('ratecor', Param.ratecomp); filtermodel('expc', Cnrhonorm);
filtermodel('flow', StimParam.flow); filtermodel('fhigh', StimParam.fhigh);
Cstart = [];
if ~isnan(ARMIN.CF),  Cstart(1) = ARMIN.CF; else Cstart(1) = mean(FFrange); end
if ~isnan(ARMIN.HHW), Cstart(2) = ARMIN.HHW; else Cstart(2) = mean(FFrange); end
Cfilter  = lsqcurvefit(@filtermodel, Cstart, FFrange', [R1fitnorm', R2fitnorm'], [], [], optimset('display', 'off'));
AFfilter = getaccfrac(@filtermodel, Cfilter, FFrange', [R1fitnorm', R2fitnorm']);

if AFfilter < (Param.accfracthr/100), warning('Filter approximation isn''t accurate enough.'); return; end

%Indien geen range opgegeven is voor de filtercurve, dan is de range -3 SD tot +3SD van het gemiddelde ...
%Indien de samplerate voor de curve niet opgegeven is dan wordt de oorspronkelijke samplerate van de curven
%overgenomen ...
if isnan(Param.filterrange(1)) | Param.filterrange(1) > Cfilter(1), Param.filterrange(1) = Cfilter(1) - 3 * Cfilter(2); end
if isnan(Param.filterrange(2))| Param.filterrange(2) < Cfilter(1), Param.filterrange(2) = Cfilter(1) + 3 * Cfilter(2); end
if isnan(Param.filtersr), Param.filtersr = 1/(FFrange(2)-FFrange(1)); end

CF = Cfilter(1); BW = Cfilter(2) * 2;
Freq  = Param.filterrange(1):Param.filtersr:Param.filterrange(2);
Power = normpdf(Freq, Cfilter(1), Cfilter(2))*Param.filtersr;
dB    = p2db(Power);
%ERB   = sum(Power)/max(Power)*Param.filtersr; %Equivalent Rectangular Bandwidth ...
%ERB = (normcdf(StimParam.fhigh, Cfilter(1), Cfilter(2)) - normcdf(StimParam.flow, Cfilter(1), Cfilter(2)))/max(Power)*Param.filtersr;
ERB = 1/max(Power)*Param.filtersr;

%Diagostische gegevens berekenen ...
DIAGNOSTICS = diagnoseFILTER(Cfilter, FFrange', [R1fitnorm', R2fitnorm'], Param);

%Filter approximatie geeft de volgende gegevens : 
%Carmin1, AFarmin1, Carmin2, AFarmin2, Cnrho, AFnrho, FFrange, R1fitnorm, R2fitnorm, Cfilter, CF, BW, AFfilter, Freq, Power.
FILTER = struct('ARMIN', struct('FitC1', Carmin1, 'FitC2', Carmin2, 'AccFrac1', AFarmin1, 'AccFrac2', AFarmin2), ...
                'NRHO',  struct('FitC', Cnrho, 'AccFrac', AFnrho), ...
                'FIT',   struct('FF', FFrange, 'R', [R1fitnorm; R2fitnorm], 'FitC', Cfilter, 'AccFrac', AFfilter), ...
                'DIAGNOSTICS', DIAGNOSTICS, ...
                'SHAPE', struct('Freq', Freq, 'Power', Power, 'dB', dB), ...
                'CF', CF, 'BW', BW, 'ERB', ERB);

function plotARMIN(ARMIN, DIFF, NRHO, FILTER, CellInfo, StimParam, Param)

Interface = figure('Name', sprintf('EvalARMIN: %s %s', CellInfo.DataFile, FormatCell(CellInfo.ARMIN.dsIDs)), ...
    'MenuBar', 'figure', ...
    'NumberTitle', 'off', ...
    'PaperType', 'A4', ...
    'PaperOrientation', 'landscape', ...
    'PaperUnits', 'normalized', ...
    'PaperPosition', [0 0 1 1]);

%Originele rate-curven weergeven ...
Ax_Rate = axes('Position', [0.10 0.55 0.20 0.35], 'Box', 'on'); 
line(ARMIN.FF1, ARMIN.R1, 'LineStyle', '-', 'Marker', '.', 'Color', 'b');
line(ARMIN.FF2, ARMIN.R2, 'LineStyle', '-', 'Marker', '.', 'Color', 'r');

title('Original Data', 'fontsize', 12);
xlabel('FF (Hz)'); ylabel('Rate (spk/sec)');

%Genormaliseerde en gesmoothe data weergeven ...
if isnan(Param.xrange(1)), MinX = min([ARMIN.FF1(:); ARMIN.FF2(:)]); else, MinX = Param.xrange(1); end
if isnan(Param.xrange(2)), MaxX = max([ARMIN.FF1(:); ARMIN.FF2(:)]); else, MaxX = Param.xrange(2); end
if isnan(Param.yrange(1)), MinY = min([ARMIN.R1norm(:); ARMIN.R2norm(:)]); else, MinY = Param.yrange(1); end
if isnan(Param.yrange(2)), MaxY = max([ARMIN.R1norm(:); ARMIN.R2norm(:)]); else, MaxY = Param.yrange(2); end

Ax_Av = axes('Position', [0.40 0.75 0.20 0.15], 'Box', 'on'); 
line(ARMIN.FF1, ARMIN.R1norm, 'LineStyle', '-', 'Marker', '.', 'Color', 'b');
line(ARMIN.FF1, ARMIN.R1av, 'LineStyle', ':', 'Marker', 'none', 'Color', 'k');
line(ARMIN.FF2, ARMIN.R2norm, 'LineStyle', '-', 'Marker', '.', 'Color', 'r');
line(ARMIN.FF2, ARMIN.R2av, 'LineStyle', ':', 'Marker', 'none', 'Color', 'k');

line(ARMIN.intercept(1), ARMIN.intercept(2), 'LineStyle', 'none', 'Marker', '*', 'Color', 'g');
line(ARMIN.HHWx, ARMIN.HH([1 1]), 'LineStyle', '-', 'Marker', '*', 'Color', 'g');

title('Normalized & Averaged Data', 'fontsize', 12);
xlabel('FF (Hz)'); ylabel('Norm Rate (SD)');
axis([MinX, MaxX, MinY, MaxY]);

text(MinX, MaxY,{sprintf('CF = %.0fHz', ARMIN.CF); sprintf('HHW = %.0fHz', ARMIN.HHW);}, ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

%Rate difference curve weergeven ...
if isnan(Param.xrange(1)), MinX = min(DIFF.FF); end
if isnan(Param.xrange(2)), MaxX = max(DIFF.FF); end
if isnan(Param.yrange(1)), MinY = min(DIFF.R); end
if isnan(Param.yrange(2)), MaxY = max(DIFF.R); end

Ax_Diff = axes('Position', [0.40 0.55 0.20 0.15], 'Box', 'on'); 
line(DIFF.FF, DIFF.R, 'LineStyle', '-', 'Marker', '.', 'Color', 'b');
line(DIFF.intercept(1), DIFF.intercept(2), 'LineStyle', 'none', 'Marker', '*', 'Color', 'g');
line(DIFF.HHWx, DIFF.HH([1 1]), 'LineStyle', '-', 'Marker', '*', 'Color', 'g');

xlabel('FF (Hz)'); ylabel('Norm Rate Diff (SD)');
axis([MinX, MaxX, MinY, MaxY]);

text(MinX, MaxY,{sprintf('HHW = %.0fHz\n', DIFF.HHW)}, ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

%Filter approximatie gegevens weergeven indien berekend ...
if ~isempty(FILTER),
    %Eerst boogtangens fit in originele ARMIN-gegevens weergeven ...
    MinX = min([ARMIN.FF1 ARMIN.FF2]); MaxX = max([ARMIN.FF1 ARMIN.FF2]);
    MinY = min([ARMIN.R1 ARMIN.R2]); MaxY = max([ARMIN.R1 ARMIN.R2]);
    
    Ax_ARMINFit = axes('Position', [0.10 0.30 0.20 0.15], 'Box', 'on'); 
    line(ARMIN.FF1, ARMIN.R1, 'LineStyle', '-', 'Color', 'b', 'Marker', '.');
    line(ARMIN.FF1, bgtgfunc(FILTER.ARMIN.FitC1, ARMIN.FF1), 'LineStyle', ':', 'Marker', 'none', 'Color', 'k');
    line(ARMIN.FF2, ARMIN.R2, 'LineStyle', '-', 'Color', 'r', 'Marker', '.');
    line(ARMIN.FF2, bgtgfunc(FILTER.ARMIN.FitC2, ARMIN.FF2), 'LineStyle', ':', 'Marker', 'none', 'Color', 'k');
    
    title('Curve Fit', 'fontsize', 12);
    xlabel('FF(Hz)'); ylabel('Rate (spk/sec)');
    axis([MinX MaxX MinY MaxY]);
    
    text(MinX, MaxY, {sprintf('AccFrac(blue) = %.0f%%', FILTER.ARMIN.AccFrac1 * 100), ...
            sprintf('AccFrac(red) = %.0f%%', FILTER.ARMIN.AccFrac2 * 100)}, ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    
    %Ten tweede rho versus rate curve weergeven ...
    MinX = min(NRHO.Rho); MaxX = max(NRHO.Rho);
    MinY = min(NRHO.R); MaxY = max(NRHO.R);
    
    Ax_NRHOFit = axes('Position', [0.10 0.10 0.20 0.15], 'Box', 'on');
    line(NRHO.Rho, NRHO.R, 'LineStyle', '-', 'Color', 'b', 'Marker', '.');
    %Exponentiele functie als fit voor correlatie-rate functie ...
    %line(NRHO.Rho, expfunc(FILTER.NRHO.FitC, NRHO.Rho), 'LineStyle', ':', 'Marker', 'none', 'Color', 'k');
    %Tweede graadsveelterm als fit voor correlatie-rate functie ...
    line(NRHO.Rho, polyval(FILTER.NRHO.FitC, NRHO.Rho), 'LineStyle', ':', 'Marker', 'none', 'Color', 'k');
    
    xlabel('Rho'); ylabel('Rate (spk/sec)');
    axis([MinX MaxX MinY MaxY]);
    
    text(MinX, MaxY, sprintf('AccFrac = %.0f%%', FILTER.NRHO.AccFrac * 100), ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    
    %Ten derde filter fit curven weergeven ...
    MinX = min(FILTER.FIT.FF); MaxX = max(FILTER.FIT.FF);
    MinY = min(FILTER.FIT.R(:)); MaxY = max(FILTER.FIT.R(:));
    
    Ax_FILTERFit = axes('Position', [0.40 0.30 0.20 0.15], 'Box', 'on');
    line(FILTER.FIT.FF, FILTER.FIT.R(1, :), 'LineStyle', '-', 'Color', 'b', 'Marker', '.');
    line(FILTER.FIT.FF, FILTER.FIT.R(2, :), 'LineStyle', '-', 'Color', 'r', 'Marker', '.');
    line(FILTER.FIT.FF', filtermodel(FILTER.FIT.FitC, FILTER.FIT.FF'), 'LineStyle', ':', 'Color', 'k', 'Marker', 'none');
    
    title('Filter Approximation', 'fontsize', 12);
    xlabel('FF (Hz)'); ylabel('Norm Rate (FIT)');
    axis([MinX MaxX MinY MaxY]);
    
    text(MinX, MaxY, sprintf('AccFrac = %.0f%%', FILTER.FIT.AccFrac * 100), ...
                     'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    
    %Ten vierde de filtershape plotten ...
    MinX = min(FILTER.SHAPE.Freq); MaxX = max(FILTER.SHAPE.Freq);
    if strncmpi(Param.dbscale, 'y', 1), MinY = -30; MaxY = max(FILTER.SHAPE.dB);
    else MinY = 0; MaxY = max(FILTER.SHAPE.Power); end
    
    Ax_FILTER = axes('Position', [0.40 0.10 0.20 0.15], 'Box', 'on');
    patch([FILTER.CF-FILTER.ERB/2 FILTER.CF-FILTER.ERB/2 FILTER.CF+FILTER.ERB/2 FILTER.CF+FILTER.ERB/2], [MinY MaxY MaxY MinY], [0.95 0.95 0.95], 'LineStyle', ':');
    if strncmpi(Param.dbscale, 'y', 1), line(FILTER.SHAPE.Freq, FILTER.SHAPE.dB, 'LineStyle', '-', 'Color', 'b', 'Marker', 'none');
    else line(FILTER.SHAPE.Freq, FILTER.SHAPE.Power, 'LineStyle', '-', 'Color', 'b', 'Marker', 'none'); end
    line(FILTER.CF([1 1]), [MinY MaxY], 'LineStyle', ':', 'Marker', 'none', 'Color', 'k');
    
    xlabel('Frequency (Hz)'); 
    if strncmpi(Param.dbscale, 'y', 1), ylabel('Power (dB)');
    else ylabel('Norm. Power'); end
    axis([MinX MaxX MinY MaxY]);
    
    text(MinX, MaxY,{sprintf('CF = %.0fHz', FILTER.CF); ...
                     sprintf('BW = %.0fHz', FILTER.BW); ...
                     sprintf('ERB = %.0fHz', FILTER.ERB)}, ...
                     'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    
    %Ten vijfde de diagnostische gegevens van de filter plotten ...
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

    if strncmpi(Param.ratecomp, 'y', 1), RateCor = ''; else RateCor = 'No '; end
    InfoTxt = {sprintf('\\fontsize{12}%s %s', CellInfo.DataFile, FormatCell(CellInfo.ARMIN.dsIDs)); ...
            sprintf('(NRHO: <%s>)\\fontsize{9}', CellInfo.NRHO.dsID); ...    
            sprintf(''); ...
            sprintf('\\fontsize{10}Calculation Parameters\\fontsize{9}'); ...
            sprintf('Analysis Window = %dms-%dms', Param.anwin); ...
            sprintf('Run. Average Range = %d%s', Param.runavrange, Param.runavunit); ...
            sprintf('%sRate Compression', RateCor); ...
            sprintf('for Filter Approximation'); ...
            sprintf(''); ...
            sprintf('\\fontsize{10}Stimulus Parameters\\fontsize{9}'); ...
            sprintf('Stim./Rep. Dur. = %.0fms/%.0fms', StimParam.burstdur, StimParam.repdur); ...
            sprintf('SPL = %ddB', StimParam.spl); ...
            sprintf('Noise BandWith = %dHz-%dHz', StimParam.flow, StimParam.fhigh)};              
else, 
    Ax_ARMINFit    = PrintInfo([0.10 0.30 0.20 0.15], sprintf('Filter approximation\nnot done.'), Interface, 'boxcolor', [0.9 0.9 0.9], 'fontsize', 12); 
    Ax_NRHOFit     = PrintInfo([0.10 0.10 0.20 0.15], sprintf('Filter approximation\nnot done.'), Interface, 'boxcolor', [0.9 0.9 0.9], 'fontsize', 12); 
    Ax_FILTERFit   = PrintInfo([0.40 0.30 0.20 0.15], sprintf('Filter approximation\nnot done.'), Interface, 'boxcolor', [0.9 0.9 0.9], 'fontsize', 12);               
    Ax_FILTERShape = PrintInfo([0.40 0.10 0.20 0.15], sprintf('Filter approximation\nnot done.'), Interface, 'boxcolor', [0.9 0.9 0.9], 'fontsize', 12); 
    Ax_DIAGNOSTICSCF = PrintInfo([0.70 0.30 0.20 0.15], sprintf('Filter approximation\nnot done.'), Interface, 'boxcolor', [0.9 0.9 0.9], 'fontsize', 12);
    Ax_DIAGNOSTICSBW = PrintInfo([0.70 0.10 0.20 0.15], sprintf('Filter approximation\nnot done.'), Interface, 'boxcolor', [0.9 0.9 0.9], 'fontsize', 12);
    
    InfoTxt = {sprintf('\\fontsize{12}%s %s\\fontsize{9}', CellInfo.DataFile, FormatCell(CellInfo.ARMIN.dsIDs)); ...
            sprintf(''); ...
            sprintf('\\fontsize{10}Calculation Parameters\\fontsize{9}'); ...
            sprintf('Analysis Window = %dms-%dms', Param.anwin); ...
            sprintf('Run. Average Range = %d%s', Param.runavrange, Param.runavunit); ...
            sprintf(''); ...
            sprintf('\\fontsize{10}Stimulus Parameters\\fontsize{9}'); ...
            sprintf('Stim./Rep. Dur. = %.0fms/%.0fms', StimParam.burstdur, StimParam.repdur); ...
            sprintf('SPL = %ddB', StimParam.spl); ...
            sprintf('Noise BandWith = %dHz-%dHz', StimParam.flow, StimParam.fhigh)};              
end    

%Extra informatie weergeven ...
PrintInfo([0.70 0.55 0.20 0.35], InfoTxt);

%-------------------------------------------------------------------------------------------------------------------
function StimParam = checkstimparam(varargin)

%Eerste dataset moet ARMIN-type dataset zijn ...
StimParam = struct('burstdur', varargin{1}.burstdur, 'repdur', varargin{1}.repdur, 'risedur', varargin{1}.riseDur, 'falldur', varargin{1}.fallDur, ...
                   'flow', varargin{1}.Flow, 'fhigh', varargin{1}.Fhigh, 'spl', varargin{1}.SPL, 'version', varargin{1}.AKversion);

N = length(varargin);
for n = 2:N
    if isempty(varargin{n}), continue; end
    switch varargin{n}.StimType
    case 'ARMIN'    
        if ~isequal(floor(StimParam.burstdur), floor(varargin{n}.burstdur)) | ...
                ~isequal(floor(StimParam.repdur), floor(varargin{n}.repdur)) | ...
                ~isequal(floor(StimParam.risedur), floor(varargin{n}.risedur)) | ...
                ~isequal(floor(StimParam.falldur), floor(varargin{n}.falldur)) | ...
                ~isequal(floor(StimParam.flow), floor(varargin{n}.Flow)) | ...
                ~isequal(floor(StimParam.fhigh), floor(varargin{n}.Fhigh)) | ...
                ~isequal(floor(StimParam.spl), floor(varargin{n}.SPL)) | ...
                ~isequal(floor(StimParam.version), floor(varargin{n}.AKversion))
            error('Stimulus parameters are different for the datasets.');
        end
    case 'NRHO'
        %Indien oude versie van NRHO gebruikt wordt, dan zal correlatie-rate verband aangevuld worden met
        %gegevens uit ARMIN-datasets en dit mag alleen maar als de energie van de gegeven noise stimulus 
        %hetzelfde is, dus bandbreedte en intensiteit moeten gelijk zijn ...
        if ~isfield(varargin{n}.stimparam, 'NRHOversion') & ...
           (~isequal(floor(StimParam.spl), floor(varargin{n}.SPL)) | ...
           ~isequal(floor(StimParam.flow), floor(varargin{n}.lowFreq)) | ...
           ~isequal(floor(StimParam.fhigh), floor(varargin{n}.highFreq))),
            error(sprintf('Bandwidth and intensity of noise token are different for NRHO and ARMIN-dataset.\nNRHO-dataset is of version one, so correlation-rate relationship cannot be extended using ARMIN-data.'));
        elseif ~isbetween(varargin{n}.burstdur, [StimParam.burstdur-200 StimParam.burstdur+200]) | ...
           ~isbetween(varargin{n}.repdur, [StimParam.repdur-200 StimParam.repdur+200]) | ...
           ~isbetween(varargin{n}.risedur, [StimParam.risedur-10 StimParam.risedur+10]) | ...
           ~isbetween(varargin{n}.falldur, [StimParam.falldur-10 StimParam.falldur+10]) | ...
           ~isbetween(varargin{n}.SPL, [StimParam.spl-10, StimParam.spl+10]) | ... 
           ~isbetween(varargin{n}.lowFreq, [StimParam.flow-50, StimParam.flow+50]) | ...
           ~isbetween(varargin{n}.highFreq, [StimParam.fhigh-50, StimParam.fhigh+50]) | ...
             warning('Stimulus-parameters are different for NRHO and ARMIN-dataset.');
        end
    end    
end

function Param = checkparam(Param, StimParam)

if (length(Param.runavrange) ~= 1) | (Param.runavrange < 0), error('Wrong value for property runavrange.'); end

if Param.anwin(2) == -1, Param.anwin(2) = StimParam.burstdur; end
if (length(Param.anwin) ~= 2) | ~isinrange(Param.anwin, [0, StimParam.burstdur]), error('Wrong value for property anwin.'); end

if length(Param.accfracthr) ~= 1 | Param.accfracthr < 0 | Param.accfracthr > 100, error('Wrong value for property accfracthr.'); end
if length(Param.filtersr) ~= 1 | Param.filtersr < 0, error('Wrong value for property filtersr.'); end
if length(Param.diagrange) ~= 1 | Param.diagrange < 0, error('Wrong value for property diagrange.'); end
if length(Param.diagsr) ~= 1 | Param.diagsr < 0, error('Wrong value for property diagsr.'); end

if ~any(strncmpi(Param.plot, {'y','n'}, 1)), error('Wrong value for property plot.'); end
if ~any(strncmpi(Param.dbscale, {'y','n'}, 1)), error('Wrong value for property dbscale.'); end
if ~any(strncmpi(Param.ratecomp, {'y','n'}, 1)), error('Wrong value for property ratecor.'); end
if ~any(strncmpi(Param.runavunit, {'h', '#'}, 1)), error('Wrong value for property runavunit.'); end

if ~isinrange(Param.xrange, [-Inf, +Inf]), error('Wrong value for property xrange.'); end
if ~isinrange(Param.yrange, [-Inf, +Inf]), error('Wrong value for property yrange.'); end
if ~isinrange(Param.diagyrange, [-Inf, +Inf]), error('Wrong value for property diagyrange.'); end
if ~isinrange(Param.filterrange, [-Inf, +Inf]), error('Wrong value for property filterrange.'); end

%Indien einde van analyse-window overeenkomt met -1 dan betekent dit de stimulusduur ...
if Param.anwin(2) == -1, Param.anwin(2) = StimParam.burstdur; end
    
function r = spktrco(sptref, sptff, burstdur, cowin)

nrep = length(sptref);

sptref = cat(2, sptref{1, :});
nRef = histc(sptref, 0:cowin:burstdur); nRef(end) = [];

if ~ischar(sptff),
    N = size(sptff, 1);
    for n = 1:N
        spttemp = cat(2, sptff{n, :});
        nFF = histc(spttemp, 0:cowin:burstdur); nFF(end) = [];
        r(n) = 1000 * sum(nRef .* nFF) /burstdur /nrep^2;
    end
else, r = 1000 * (sum(nRef .^2)-length(sptref)) /burstdur /nrep /(nrep-1); end %Geen diagonaal termen ...

function [Rho, R] = calcANNRHO(dsNRHO, dsARMINp, SubSeqP, dsARMINn, SubSeqN, StimParam, Param)

Nrec = dsNRHO.nrec;
Rho = dsNRHO.indepval(1:Nrec)';
SubSeq = find(Rho == +1);
[Rho, idx] = sort(Rho);

R = spktrco(anwin(dsNRHO.spt(SubSeq, :), Param.anwin), anwin(dsNRHO.spt(idx([1:end-1]), :), Param.anwin), StimParam.burstdur, Param.cowin);
R(end+1) = spktrco(anwin(dsNRHO.spt(SubSeq, :), Param.anwin), 'nodiag', StimParam.burstdur, Param.cowin);

%Bij oude datasets wordt de noise in beide oren gevarieerd waardoor bij reconstructie van binaurale gegevens
%enkel correlatie van 0 to +1 bekomen wordt. Om dit hiaat te overbruggen wort een extra punt toegevoegd thv
%correlatie -1. Deze gegevens worden uit de ARMIN-respons gehaald ...
if ~isfield(dsNRHO.stimparam, 'NRHOversion'),
    warning('NRHO-dataset is of version one, respons to negative correlations is extrapolated using ARMIN-datasets.'); 
    
    Rn  = spktrco(anwin(dsARMINp.spt(SubSeqP, :), Param.anwin), anwin(dsARMINn.spt(SubSeqN, :), Param.anwin), StimParam.burstdur, Param.cowin);
    R   = [Rn R];
    Rho = [-1 (Rho+1)/2];
end

function [x, y] = intercept(x1, y1, x2, y2)

if nargin == 4,
    p1 = polyfit(x1, y1, 1);
    p2 = polyfit(x2, y2, 1);
else, [p1, p2] = deal(x1, y1); end

x = (p2(2) - p1(2))/(p1(1) - p2(1));
y = polyval(p1, x);

function [x, y] = interceptARMIN(FF1, R1, FF2, R2)

%Indien dataset niet even veel flip frequenties bevatten worden de indices van de gemeenschappelijke FF
%gebruikt in de berekeningen ...
FF = intersect(FF1, FF2);
idx1 = find(ismember(FF1, FF)); idx2 = find(ismember(FF2, FF));
idx1add = idx1(1) - 1;

%Snijpunt tussen twee curven nagaan ...
idx = max(find(R1(idx1) > R2(idx2)));
x1 = FF1([idx1add+idx, idx1add+idx+1]); y1 = R1([idx1add+idx, idx1add+idx+1]);
x2 = FF2([idx, idx+1]); y2 = R2([idx, idx+1]);

[x, y] = intercept(x1, y1, x2, y2);

function y = bgtgfunc(c, x)

y = c(1)/pi * atan(c(2)*(x-c(3))) + c(4);

function [FitC, AccFrac] = bgtgfit(FF, R, C)

N = length(FF);

%Voor R1 ...
%Enkel punten gebruiken tot eerste punt dat gelijk is aan nul voor de fit als oplossing van het 
%rectificatie probleem ...
%if any(R == 0), idx = 1:min(find(R == 0))-1; else idx = 1:N; end
%Voor R2 ...
%Enkel punten gebruiken vanaf eerste punt dat verschilt van nul voor de fit ... oplossing van het
%rectificatie probleem ...
%if any(R == 0), idx = max(find(R == 0))+1:N; else idx = 1:N; end
idx = 1:N;

FitC    = lsqcurvefit(@bgtgfunc, C, FF(idx), R(idx), [], [], optimset('display', 'off'));
AccFrac = getaccfrac(@bgtgfunc, FitC, FF(idx), R(idx));

function y = expfunc(c, x)

y = c(1) * exp(c(2)*(x-c(3))) + c(4);

function [FitC, AccFrac] = expfit(Rho, R, Type)

%Start conditie voor fit parameters ...
Cstart = [1 1 0 0];

%Enkel punten gebruiken vanaf eerste punt dat verschilt van nul voor de fit ... oplossing van het
%rectificatie probleem ...
N = length(R);
%if any(R == 0), idx = max(find(R == 0))+1:N; else idx = 1:N; end
idx = 1:N;

FitC    = lsqcurvefit(@expfunc, Cstart, Rho(idx), R(idx), [], [], optimset('display', 'off'));
AccFrac = getaccfrac(@expfunc, FitC, Rho(idx), R(idx));

function DIAGNOSTICS = diagnoseFILTER(Cfilter, FF, Rfit, Param)

CF = Cfilter(1); BW = Cfilter(2)*2;

CFs = max([0, CF-Param.diagrange/2]):Param.diagsr:CF+Param.diagrange/2;
for n = 1:length(CFs), AccFracCF(n) = getaccfrac(@filtermodel, [CFs(n), BW/2], FF, Rfit); end

BWs = max([0, BW-Param.diagrange/2]):Param.diagsr:BW+Param.diagrange/2;
for n = 1:length(BWs), AccFracBW(n) = getaccfrac(@filtermodel, [CF, BWs(n)/2], FF, Rfit); end

DIAGNOSTICS = CollectInStruct(CFs, AccFracCF, BWs, AccFracBW);

function y = filtermodel(c, x)

persistent expc ratecor flow fhigh;

if ischar(c) & strcmpi(c, 'expc'), expc = x; return; 
elseif ischar(c) & strcmpi(c, 'ratecor'), ratecor = x; return;
elseif ischar(c) & strcmpi(c, 'flow'), flow = x; return;
elseif ischar(c) & strcmpi(c, 'fhigh'), fhigh = x; return;
elseif ischar(c), error('Invalid invocation of function.'); end

if isempty(expc), error('Constants of conversion function not yet set.'); end
if isempty(flow) | isempty(fhigh), error('Noise bandwidth not yet set.'); end
if isempty(ratecor), ratecor = 'n'; end

CF = c(1); BW = c(2);

%... oude methode ...
%CDF = normcdf(x,CF,BW);
%yold = expfunc(expc, 2*[1-CDF, CDF]-1);
%if strncmpi(ratecor, 'y', 1), 
%    y(find(y < 0)) = 0;
%    y = sqrt(y); 
%end

Pcor   = normcdf(flow, CF, BW);
Ptotal = normcdf(fhigh, CF, BW) - Pcor;
P = normcdf(x, CF, BW);

Rho = (2*([1-P, P] - Pcor) - Ptotal)/Ptotal;

%Exponentiele functie als fit voor correlatie-rate functie ...
%y = expfunc(expc, Rho);
%Tweede graadsveelterm als fit voor correlatie-rate functie ...
y = polyval(expc, Rho);

if strncmpi(ratecor, 'y', 1), 
    y(find(y < 0)) = 0;
    y = sqrt(y); 
end

function db = p2db(p)

refp = max(p);
db = 10 * log(p/refp);
