function [BF,BestITD,BP,CD,CP,CF1,CF2,IPCx,IPCy,ISRx,ISRy] = EvalFSphase2R_A0242(varargin)
%EVALFS   plot composite curve, interaural phase versus stimulus frequency, 
%         monaural phase versus stimulus frequency and ratecurve for two
%         cells with different CF. 
%         Datasets for both cells must contain responses of these cells to
%         monospectral tones. 
%   Data = EVALFS(ds1, ds2, ... )
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default values,
%   use 'list' as only property. 
%
%   The result is clipped to 2 cycles by default. To change this, use the
%   property 'display'. Use Inf as value to display all cycles.

%B. Van de Sande 19-08-2004
%K. Spiritus     02-10-2007

%Parameter Lijst ...
DefParam.plot     = 'YES';
DefParam.plotmode = 'ALL';
DefParam.corbinwidth = 0.05;
DefParam.cormaxlag   = 30;
DefParam.coranwin    = [0 -1];
DefParam.corrunav    = 0.5;
DefParam.corcutoff   = 0.10;
DefParam.cyclenbin   = 64;
DefParam.fftrunav    = 25;
DefParam.linregtype  = 'W'; %Weighted or Non-weigthed ...
DefParam.display       = 2; % limit display to a certain amount of periods periods: yes or no

%Parameters evalueren ...
[DataFile, Cell1, Cell2, ds1, ds2, CalcParam, PlotParam] = EvalParam(varargin, DefParam);
if CalcParam.corbinwidth==0
    ArgOut=[];BF=0;BestITD=0;BP=0;CD=0;CP=0;CF1=0;CF2=0;IPCx=[];IPCy=[];ISRx=[];ISRy=[];return;
end

%Cell parameters halen uit userdata ...
UD = getuserdata_Kold(ds1);
if ~isempty(UD) & ~isempty(UD.CellInfo) & ~isnan(UD.CellInfo.THRSeq)
    dsTHR = dataset(DataFile, UD.CellInfo.THRSeq);
    [CellParam(1).CF, CellParam(1).SA] = evalTHR(dsTHR, 'plot', 'no');
else
    [CellParam(1).CF, CellParam(1).SA] = deal(NaN); 
end
CellParam(1).CD = greenwood(CellParam(1).CF);
UD = getuserdata_Kold(ds2);
if ~isempty(UD) & ~isempty(UD.CellInfo) & ~isnan(UD.CellInfo.THRSeq)
    dsTHR = dataset(DataFile, UD.CellInfo.THRSeq);
    [CellParam(2).CF, CellParam(2).SA] = evalTHR(dsTHR, 'plot', 'no');
else
    [CellParam(2).CF, CellParam(2).SA] = deal(NaN); 
end
CellParam(2).CD = greenwood(CellParam(2).CF);

%Gemeenschappelijke onafhankelijke variabelen opsporen ...
[StimFreq, ComSub] = findComSub(ds1, ds2); NSub = size(ComSub,2);
if isempty(ComSub)
    fprintf('No common subsequences.');ArgOut=[];BF=0;BestITD=0;BP=0;CD=0;CP=0;CF1=0;CF2=0;IPCx=[];IPCy=[];ISRx=[];ISRy=[];return; 
elseif NSub == 1
    fprintf('Only one common subsequence.');ArgOut=[];BF=0;BestITD=0;BP=0;CD=0;CP=0;CF1=0;CF2=0;IPCx=[];IPCy=[];ISRx=[];ISRy=[];return;
else
    fprintf('Common subsequences are : '); 
    fprintf('%dHz,', ds1.indepval(ComSub(1,:))); 
    fprintf('\b.\n'); 
end

%Voor elke gemeenschappelijke toon het CrossCorrelogram berekenen en daarop cyclehistogram nagaan.
%Bovendien ook op monaurale gegevens het cyclehistogram berekenen ...
DisSub = [];
fprintf('Calculating Correlogram and Cyclehistogram for : ');
for n = 1:NSub
    fprintf([int2str(StimFreq(n)) 'Hz,']);
    
    SpkTr1 = ds1.spt(ComSub(1, n), :); SpkTr2 = ds2.spt(ComSub(2, n), :);
    N = length(SpkTr1); M = length(SpkTr2);
    AnDur = abs(diff(CalcParam.coranwin));
    if isequal(SpkTr1, SpkTr2)
        [Y, X] = sptcorr(anwin(ds1.spt(ComSub(1, n), :), CalcParam.coranwin), 'nodiag', CalcParam.cormaxlag, CalcParam.corbinwidth);
        NRep = N*(N-1); Y = (1000*Y)/(AnDur*NRep);
    else
        [Y, X] = sptcorr(anwin(ds1.spt(ComSub(1, n), :), CalcParam.coranwin), anwin(ds2.spt(ComSub(2, n), :), CalcParam.coranwin), CalcParam.cormaxlag, CalcParam.corbinwidth);
        NRep = N*M; Y = (1000*Y)/(AnDur*NRep);
    end
    CrossCor(n) = CollectInStruct(X, Y);
    
    %N = size(ds1.spt, 2); M = size(ds2.spt, 2); if isequal(ds1.spt, ds2.spt), NRep = N*(N-1); else NRep = N*M; end
    BinCycleHist(n) = cyclehist(X, Y, CalcParam.coranwin(2)-CalcParam.coranwin(1), NRep, StimFreq(n), CalcParam.cyclenbin);
    
    if all(CrossCor(n).Y == 0)
        fprintf('\b discarded,'); 
        DisSub = [DisSub n]; 
    end
end
fprintf('\b.\n');

if ~isempty(DisSub) %Indien er subsequenties wegvallen ... 
    StimFreq(DisSub) = [];
    CrossCor(DisSub) = [];
    BinCycleHist(DisSub) = [];
    ComSub(:, DisSub) = [];
end

if length(StimFreq) == 1
    error('Only one common subsequence left.'); 
end

for n = 1:ds1.nsubrecorded
    MonCycleHist1(n) = cyclehist(ds1, n, -1, CalcParam.cyclenbin, CalcParam.coranwin(1), CalcParam.coranwin(2));
end

for n = 1:ds2.nsubrecorded
    MonCycleHist2(n) = cyclehist(ds2, n, -1, CalcParam.cyclenbin, CalcParam.coranwin(1), CalcParam.coranwin(2));
end

%Composite Curve berekenen ...
X = CrossCor(1).X;
Y = mean(cat(1, CrossCor.Y));

%Indien MaxLag groter is dan 10ms dan zoeken naar hoofdpiek en niet naar die van de
%aanwezige harmonieken op 10ms (100Hz) en 20ms(50Hz)...
if CalcParam.cormaxlag > 10
    BestITD = getmaxloc(X, Y, CalcParam.corrunav, [-7, +7]);
else
    BestITD = getmaxloc(X, Y, CalcParam.corrunav); 
end

CFdiff  = log2(CellParam(2).CF/CellParam(1).CF);
CDdiff  = CellParam(2).CD - CellParam(1).CD;

CC = CollectInStruct(X, Y, BestITD, CFdiff, CDdiff);

%Gegevens uit de composite curve halen ...
%CAVE: Fourier.m houdt geen rekening met het feit dat er harmonische pieken aanwezig zijn
%in de Composite Curve ...
[XFft, YFft, YFftAv, DF] = spectana(X, Y, CalcParam.fftrunav);
FFT.X = XFft; 
FFT.Y = [YFft; YFftAv]; 
FFT.DF = DF;

%SuperImpose Curve berekenen ... van elk crosscorrelogram 2 cycli overhouden en elk normaliseren naar
%zijn maximum ... Bovendien worden slechts die correlogrammen geplot die boven bepaalde cutoff rate komen ...
Y = cat(1, CrossCor.Y);
Ymax = max(Y, [], 2); 
iExc = find(Ymax < CalcParam.corcutoff);
Y(iExc, :) = []; 

Freq = StimFreq; 
Freq(iExc) = [];
Period = repmat(1000./Freq, 1, size(Y, 2));
Xtemp = repmat(X, size(Y, 1), 1);
display = CalcParam.display * Period / 2;
iExc = find((Xtemp <= -display) | (Xtemp >= display));
Y(iExc)= NaN;

%No normalization ... 16-02-2004
%Ymax = max(Y, [], 2);
%Y = Y ./ repmat(Ymax, 1, size(Y, 2));

if isempty(Y)
    warning('No curves left for super impose plot.'); 
    Y = repmat(NaN, 1, length(X)); 
end
SI = CollectInStruct(X,Y);

%Interaurale VS magnitude curve berekenen ...
X = StimFreq';
Y = cat(2, BinCycleHist.R);
pRayleigh = cat(2, BinCycleHist.pRaySig);
MaxR = max(Y);

IR = CollectInStruct(X, Y, pRayleigh, MaxR);

%Monaurale VS magnitude curven berekenen ...
X = ds1.indepval(1:ds1.nsubrecorded)';
Y = cat(2, MonCycleHist1.R);
pRayleigh = cat(2, MonCycleHist1.pRaySig);
MaxR = max(Y);

MR(1) = CollectInStruct(X, Y, pRayleigh, MaxR);

X = ds2.indepval(1:ds2.nsubrecorded)';
Y = cat(2, MonCycleHist2.R);
pRayleigh = cat(2, MonCycleHist2.pRaySig);
MaxR = max(Y);

MR(2) = CollectInStruct(X, Y, pRayleigh, MaxR);

%Response area curves berekenen ... 
MRA(1).X = ds1.indepval(1:ds1.nsubrecorded)';
MRA(1).Y = GetRate(ds1, 1:ds1.nsubrecorded, CalcParam.coranwin(1), CalcParam.coranwin(2));

MRA(2).X = ds2.indepval(1:ds2.nsubrecorded)';
MRA(2).Y = GetRate(ds2, 1:ds2.nsubrecorded, CalcParam.coranwin(1), CalcParam.coranwin(2));

IRA.X = StimFreq';
IRA.Y = mean(cat(1, BinCycleHist.Y), 2);
IRA.Max = max(IRA.Y(:));

%Interaurale Synchronicity Rate berekenen ...
X = StimFreq';
Y = IRA.Y' .* IR.Y;
pRayleigh = IR.pRayleigh;
Max = max(Y); 
SRleft = Y(1); SRright = Y(end);
NormSRleft = SRleft/Max; NormSRright = SRright/Max;

ISR = CollectInStruct(X, Y, pRayleigh, Max, SRleft, SRright, NormSRleft, NormSRright);

%Interaurale phase curve berekenen ...
X = StimFreq';
Y = cat(2, BinCycleHist.Ph);
Y = unwrap(Y * (2*pi))/2/pi;

%Gegevens uit interaurale phase curve halen ...
pRayleigh = cat(2, BinCycleHist.pRaySig);
iSign = find(pRayleigh <= 0.001);
if length(X(iSign)) > 1
    if strncmpi(CalcParam.linregtype, 'W', 1)
        %Gewogen gemiddelde naar syncrate ...
        P = linregfit(X(iSign), Y(iSign), ISR.Y(iSign));
        [pLinReg, MSerror, DF] = signlinreg(P, X(iSign), Y(iSign), ISR.Y(iSign));
    else
        P = polyfit(X(iSign), Y(iSign), 1); 
        [pLinReg, MSerror, DF] = signlinreg(P, X(iSign), Y(iSign));
    end
    CD = P(1)*1000; CP = P(2);
else
    [CD, CP, pLinReg, MSerror, DF] = deal(NaN); 
end

IPC = CollectInStruct(X, Y, pRayleigh, CD, CP, pLinReg, MSerror, DF);

%Monaurale Synchronicity Rate berekenen ...
X = ds1.indepval(1:ds1.nsubrecorded)';
idx = find(ismember(MRA(1).X, intersect(MRA(1).X, MR(1).X)));
Y = MRA(1).Y(idx) .* MR(1).Y;
pRayleigh = MR(1).pRayleigh;
Max = max(Y);

MSR(1) = CollectInStruct(X, Y, pRayleigh, Max);

X = ds2.indepval(1:ds2.nsubrecorded)';
idx = find(ismember(MRA(2).X, intersect(MRA(2).X, MR(2).X)));
Y = MRA(2).Y(idx) .* MR(2).Y;
pRayleigh = MR(2).pRayleigh;
Max = max(Y);

MSR(2) = CollectInStruct(X, Y, pRayleigh, Max);

%Monaurale phase curven berekenen ...
X = ds1.indepval(1:ds1.nsubrecorded)';
Y = cat(2, MonCycleHist1.Ph);
Y = unwrap(Y * (2*pi))/2/pi;
pRayleigh = cat(2, MonCycleHist1.pRaySig);

iSign = find(pRayleigh <= 0.001);
if length(X(iSign)) > 1,
    if strncmpi(CalcParam.linregtype, 'W', 1)
        %Gewogen gemiddelde naar syncrate ...
        P = linregfit(X(iSign), Y(iSign), MSR(1).Y(iSign));
        [pLinReg, MSerror, DF] = signlinreg(P, X(iSign), Y(iSign), MSR(1).Y(iSign));
    else, 
        P = polyfit(X(iSign), Y(iSign), 1); 
        [pLinReg, MSerror, DF] = signlinreg(P, X(iSign), Y(iSign));
    end
    Slope = P(1)*1000; YInterSect = P(2);
else, [Slope, YInterSect, pLinReg, MSerror, DF] = deal(NaN); end

MPC(1) = CollectInStruct(X, Y, pRayleigh, Slope, YInterSect, pLinReg, MSerror, DF);

X = ds2.indepval(1:ds2.nsubrecorded)';
Y = cat(2, MonCycleHist2.Ph);
Y = unwrap(Y * (2*pi))/2/pi;
pRayleigh = cat(2, MonCycleHist2.pRaySig);

iSign = find(pRayleigh <= 0.001);
if length(X(iSign)) > 1,
    if strncmpi(CalcParam.linregtype, 'W', 1)
        %Gewogen gemiddelde naar syncrate ...
        P = linregfit(X(iSign), Y(iSign), MSR(2).Y(iSign));
        [pLinReg, MSerror, DF] = signlinreg(P, X(iSign), Y(iSign), MSR(2).Y(iSign));
    else, 
        P = polyfit(X(iSign), Y(iSign), 1);
        [pLinReg, MSerror, DF] = signlinreg(P, X(iSign), Y(iSign));
    end
    Slope = P(1)*1000; YInterSect = P(2);
else [Slope, YInterSect, pLinReg, MSerror, DF] = deal(NaN); end   

MPC(2) = CollectInStruct(X, Y, pRayleigh, Slope, YInterSect, pLinReg, MSerror, DF);

%Monaurale phaseverschil ...
X = intersect(MPC(1).X, MPC(2).X);
idx1 = find(ismember(MPC(1).X, X));
idx2 = find(ismember(MPC(2).X, X));
Y = MPC(1).Y(idx1) - MPC(2).Y(idx2);
idx = find(~isnan(Y)); X = X(idx); Y = Y(idx);

iRayleigh = find(all([MPC(1).pRayleigh(idx1); MPC(2).pRayleigh(idx2)] <= 0.001));

P = polyfit(X, Y, 1);
Slope = P(1)*1000; YInterSect = P(2);
idx = find(ismember(X, IPC.X));
[pCorrCoef, CorrCoef] = signcorr(IPC.Y, Y(idx)); 

PD = CollectInStruct(X, Y, iRayleigh, Slope, YInterSect, pCorrCoef, CorrCoef);

%Gegevens herorganiseren ...
BurstDur  = ds1.burstdur;
RepDur    = ds1.repdur;
StimParam = CollectInStruct(BurstDur, RepDur, StimFreq);

Param = CollectInStruct(CellParam, StimParam, CalcParam);
CellInfo = CollectInStruct(DataFile, Cell1, Cell2);
CalcData = CollectInStruct(CrossCor, BinCycleHist, MonCycleHist1, MonCycleHist2, CC, SI, FFT, IPC, IR, MR, MPC, MRA, IRA, ISR, MSR, PD);

if strcmpi(PlotParam.plot, 'YES')
    if any(strcmpi(PlotParam.plotmode, {'ALL', 'CC'})) 
        %Overzicht van alle CrossCorrelogrammen met gecentralizeerd de CompositeCurve ...
        [BF,BestITD,BP] = PlotCC(CC, SI, CrossCor, FFT, CellInfo, Param);
    end
    if any(strcmpi(PlotParam.plotmode, {'ALL', 'IPC'}))
        %Overzicht van alle CycleHistogrammen met gecentraliseerd de Interaurale phase curve ...
        [CD,CP,CF1,CF2,IPCx,IPCy] = PlotIPC(IPC, IR, BinCycleHist, CellInfo, Param);
    end
    if any(strcmpi(PlotParam.plotmode, {'ALL', 'MPC'}))
        %Overzicht van alle CycleHistogrammen met gecentraliseerd de monaurale phase curve voor beide cellen ...
        PlotMPC(1, MPC, MonCycleHist1, CellInfo, Param);
        PlotMPC(2, MPC, MonCycleHist2, CellInfo, Param);
    end
    if any(strcmpi(PlotParam.plotmode, {'ALL', 'PRA'}))
        %Monaurale phaseverschil vergelijken met interaurale phase ...
        [ISRx,ISRy] = PlotPRA(MRA, IRA, MPC, IPC, IR, MR, MSR, ISR, PD, CellInfo, Param);
    end
end


if nargout == 1
    ArgOut = CalcData; 
end

%-------------------------------------------------------------------------------------------------------------------%
%                                             LOCALE FUNCTIES                                                       % 
%-------------------------------------------------------------------------------------------------------------------%
%-----------%
% EVALPARAM %
%-----------%
function [DataFile, Cell1, Cell2, ds1, ds2, CalcParam, PlotParam] = EvalParam(ParamList, DefParam)
%EVALFS(ds1, ds2, ...)

if length(ParamList) < 2, error('Wrong number of input parameters.'); end

ds1 = ParamList{1};
ds2 = ParamList{2};

%Nagaan of datasets wel van zelfde experiment afkomstig zijn ...
if ~strncmp(ds1.FileName, ds2.FileName, 5), error('Datasets are from different experiment.'); end
DataFile = ds1.FileName;

Cell1 = CreateCellStruct(ds1.SeqID);
Cell2 = CreateCellStruct(ds2.SeqID);

ParamList(1:2) = [];

%Optionele lijst van property/values evalueren ...
Param = checkproplist(DefParam, ParamList{:});
    
%ParameterLijst evalueren ...
if ~isnumeric(Param.display)
    error('Property display must be numeric.'); 
end

Param.plot = upper(Param.plot);
if ~any(strcmpi(Param.plot, {'YES', 'NO'}))
    error('Property Plot must be YES or NO.'); 
end

Param.plotmode = upper(Param.plotmode);
if ~any(strcmpi(Param.plotmode, {'ALL', 'IPC', 'CC', 'MPC', 'PRA'})), error('Wrong mode. Mode should be ''ALL'', ''IPC'', ''CC'', ''MPC'' or ''PRA''.'); end

Param.linregtype = upper(Param.linregtype);
if ~any(strncmpi(Param.linregtype, {'W', 'N'}, 1)), error('Wrong value for property linregtype.'); end

if (length(Param.corcutoff) ~= 1) | (Param.corcutoff < 0), error('Wrong value for property corcutoff.'); end

%Nagaan of datasets wel dezelfde stimulustype hebben en of ze wel voor dit project bedoeld zijn ...
if ~any(strcmp(ds1.FileFormat, {'IDF/SPK', 'SGSR'})) | ...
   ~any(strcmp(ds2.FileFormat, {'IDF/SPK', 'SGSR'})) | ...
   ~any(strcmp('FS', { ds1.StimType, ds2.StimType }))
    error('Wrong datasets.');
end

%Nagaan of datasets dezelfde stimulusparameters hebben ...
if CheckStimParam(ds1, ds2)
    fprintf('Stimulus Parameters are different for both datasets.');
    DataFile=[];Cell1=[];Cell2=[];ds1=[];ds2=[];CalcParam.corbinwidth=0;PlotParam=[];ArgOut=[];BF=0;BestITD=0;BP=0;CD=0;CP=0;CF1=0;CF2=0;IPCx=[];IPCy=[];ISRx=[];ISRy=[];return
end

%Einde analysewindow kan -1 zijn, wat staat voor de stimulusduur ...
if Param.coranwin(2) == -1, Param.coranwin(2) = ds1.burstdur; end
    
%PlotParam-structuur opstellen ...
CalcParam = getfields(Param, {'corbinwidth', 'cormaxlag', 'coranwin', 'corrunav', 'corcutoff', 'cyclenbin', 'fftrunav', 'linregtype', 'display'});
PlotParam = getfields(Param, {'plot', 'plotmode'});

%----------------%
% CHECKSTIMPARAM %
%----------------%
function Err = CheckStimParam(ds1, ds2)

Err = 0;

%Kijken of stimulusparameters gelijk zijn tussen de cellen en of beide cellen zelfde SPL hebben ...
if ~isequal(ds1.burstdur, ds2.burstdur) | ...
   ~isequal(ds1.repdur, ds2.repdur)     | ...
   ~isequal(ds1.spl, ds2.spl)
    Err = 1;
    return
end

%------------%
% FINDCOMSUB %
%------------%
function [ComIndepVar, ComSub] = findComSub(varargin)

ComIndepVar = varargin{1}.IndepVal;
for i = 2:length(varargin)
    ComIndepVar = intersect(ComIndepVar, varargin{i}.IndepVal);
end
if isempty(ComIndepVar), ComSub = []; return; end

for ds = 1:length(varargin)
    IndexList = find(ismember(varargin{ds}.IndepVal, ComIndepVar));
    ComSub(ds, :) = reshape(IndexList, 1, length(IndexList)); 
end

%--------%
% PLOTCC %
%--------%
function [BF,BestITD,BP] = PlotCC(ComCurve, SuperImpose, CrossCor, FFT, CellInfo, Param)

DataID  = [ CellInfo.DataFile ' <' CellInfo.Cell1.dsID '> & <' CellInfo.Cell2.dsID '>' ];

%Interface = figure('Name', ['EvalFS: Composite Curve for ' DataID], ...
    %'NumberTitle', 'off', ...
    %'PaperType', 'a4letter', ...
    %'PaperUnits', 'normalized', ...
    %'PaperPosition', [0.05 0.05 0.90 0.90], ...
    %'PaperOrientation', 'landscape');

%Ax_CC = axes('Position', [0.195 0.59 0.3025 0.37]); 
%line(ComCurve.X, ComCurve.Y, 'LineStyle', '-', 'Color', 'r', 'Marker', 'none');
%title(['Composite Curve for ' DataID], 'FontSize', 12);
%xlabel('Delay(ms)'); ylabel('Coincidence Rate(spk/sec)');

%MinX = -5; MaxX = +5;
%MinY = 0; MaxY = 1.5; 
%axis([MinX MaxX MinY MaxY]); 

%text(MinX, MaxY, {sprintf('DF : %.0fHz', FFT.DF); ...
                  %sprintf('BestITD : %.3fms', ComCurve.BestITD)}, ...
                  %'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

%line([0 0], [MinY MaxY], 'LineStyle', ':', 'Color', 'k');
%line([ComCurve.BestITD ComCurve.BestITD], [MinY MaxY], 'LineStyle', ':', 'Color', 'k');

%Ax_SI = axes('Position', [0.5425 0.59 0.3025 0.37]);
%line(SuperImpose.X, SuperImpose.Y, 'LineStyle', '-', 'Marker', '.');
%title(['Superimpose Curve for ' DataID], 'FontSize', 12);
%xlabel('Delay(ms)'); ylabel('Coincidence Rate (spk/sec)');

%if size(SuperImpose.Y, 1) == 1,
    %iMinX = min(find(~isnan(SuperImpose.Y)));
    %iMaxX = max(find(~isnan(SuperImpose.Y)));
    %else
    %iMinX = min(find(any(~isnan(SuperImpose.Y))));
    %iMaxX = max(find(any(~isnan(SuperImpose.Y))));
    %end    
%MinX = SuperImpose.X(iMinX); MaxX = SuperImpose.X(iMaxX);
%MinY = 0; MaxY = max(SuperImpose.Y(:)); 
%if isempty(MinX), MinX = 0; end
%if isempty(MaxX), MaxX = 1; end
%axis([MinX MaxX MinY MaxY]); was removed for combination data by Shotaro
%BF&BestITD&BP assign
BF=FFT.DF;BestITD=ComCurve.BestITD;BP=ComCurve.BestITD*FFT.DF/1000;
assignin('base','BF',BF);assignin('base','BestITD',BestITD);assignin('base','BP',BP);

%Weergeven van plotparameters en cellparameters naast Composite Curve ...
%PrintInfo([0.02 0.59 0.125 0.37], {['<' CellInfo.Cell1.dsID '>']; ...
        %sprintf('CF = %.0fHz', Param.CellParam(1).CF); ...
        %sprintf('SR = %.0fspk/sec', Param.CellParam(1).SA); ...
        %''; ...
        %['<' CellInfo.Cell2.dsID '>']; ...
        %sprintf('CF = %.0fHz', Param.CellParam(2).CF); ...
        %sprintf('SR = %.0fspk/sec', Param.CellParam(2).SA); ...
        %''; ...
        %['\DeltaCF = ' sprintf('%.3f', log2(Param.CellParam(2).CF/Param.CellParam(1).CF)) 'oct']; ...
        %['\DeltaCoDist = ' sprintf('%.2f', (Param.CellParam(2).CD - Param.CellParam(1).CD)) 'mm']});
%PrintInfo([0.855  0.59 0.125 0.37], {'Stimulus Parameters:'; ...
        %sprintf('StimDur = %dms', Param.StimParam.BurstDur); ...
        %sprintf('RepDur  = %dms', Param.StimParam.RepDur); ...
        %''; ...
        %'CrossCorrelation:'; ...
        %sprintf('BinWidth = %.3fms', Param.CalcParam.corbinwidth); ...
        %sprintf('MaxLag = %dms', Param.CalcParam.cormaxlag); ...
        %sprintf('AnWin = [%dms-%dms]', Param.CalcParam.coranwin(1), Param.CalcParam.coranwin(2))});

%Alle crosscorrelogrammen plotten ...
%PlotInfo.XLabel = 'Delay(ms)'; PlotInfo.XLim = [-5 +5];
%PlotInfo.YLabel = 'Rate(spk/sec)';
%PlotInfo.Text = '[''StimFreq = '' num2str(PlotInfo.StimFreq(n)) ''Hz'']';
%PlotInfo.StimFreq = Param.StimParam.StimFreq;
%PlotInfo.Type = 'PLOT';
%PlotSmallCurves(CrossCor, PlotInfo);

%---------%
% PLOTIPC %
%---------%
function [CD,CP,CF1,CF2,IPCx,IPCy] = PlotIPC(IPC, IR, BinCycleHist, CellInfo, Param)

DataID  = [ CellInfo.DataFile ' <' CellInfo.Cell1.dsID '> & <' CellInfo.Cell2.dsID '>' ];

%Weergeven van de Interaurale Phase Curve ...
%Interface = figure('Name', ['EvalFS: Interaural Phase Curve for ' DataID], ...
    %'NumberTitle', 'off', ...
    %'PaperType', 'a4letter', ...
    %'PaperUnits', 'normalized', ...
    %'PaperPosition', [0.05 0.05 0.90 0.90], ...
    %'PaperOrientation', 'landscape');

%Ax_IPC = axes('Position', [0.195 0.59 0.3025 0.37]); 
%line(IPC.X, IPC.Y, 'LineStyle', '-', 'Color', 'r', 'Marker', 'o');
%title(['Interaural Phase Curve for ' DataID], 'FontSize', 12);
%xlabel('Stimulus Frequency(Hz)'); ylabel('Interaural Phase(cycles)');

%MinX = 0; MaxX = IPC.X(end);
%MinY = floor(min(IPC.Y)); MaxY = ceil(max(IPC.Y));
%axis([MinX MaxX MinY MaxY]);

%text(MinX, MaxY, {sprintf('CD : %.3fms', IPC.CD); ...
                  %sprintf('CP : %.3f', IPC.CP); ...
                  %sprintf('MSerror : %.3f', IPC.MSerror); ...
                  %sprintf('pLinReg : %.3f', IPC.pLinReg)}, ...
                  %'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

%line([0, MaxX], [IPC.CP, polyval([IPC.CD/1000 IPC.CP], MaxX)], 'Color', 'k', 'LineStyle', ':', 'Marker', 'none');
%CD&CP assign
CD=IPC.CD;CP=IPC.CP
assignin('base','CD',CD);assignin('base','CP',CP);
%IPCx&IPCy assign
idx2 = find(IPC.pRayleigh <= 0.001);
IPCx=IPC.X(idx2);IPCy=IPC.Y(idx2);
assignin('base','IPCx',IPCx);assignin('base','IPCy',IPCy);
%Niet significante waarden donker plotten
idx = find(IPC.pRayleigh > 0.001); %line(IPC.X(idx), IPC.Y(idx), 'Color', [1 0 0], 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 24);

%Ax_IR = axes('Position', [0.5425 0.59 0.3025 0.37]); 
%line(IR.X, IR.Y, 'LineStyle', '-', 'Color', 'r', 'Marker', 'o');
%title(['Interaural R for ' DataID], 'FontSize', 12);
%xlabel('Stimulus Frequency(Hz)'); ylabel('R');

%MinX = IR.X(1); MaxX = IR.X(end);
%MinY = 0; MaxY = 1;
%axis([MinX MaxX MinY MaxY]);

%text(MinX, MaxY, sprintf('Rmax = %.3f', IR.MaxR), ...
             %'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
       
%Niet significante waarden donker plotten
idx = find(IR.pRayleigh > 0.001); %line(IR.X(idx), IR.Y(idx), 'Color', [1 0 0], 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 24);

%Weergeven van plotparameters en cellparameters naast Interaurale Phase Curve ...
%PrintInfo([0.02 0.59 0.125 0.37], {['<' CellInfo.Cell1.dsID '>']; ...
        %sprintf('CF = %.0fHz', Param.CellParam(1).CF); ...
        %sprintf('SR = %.0fspk/sec', Param.CellParam(1).SA); ...
        %''; ...
        %['<' CellInfo.Cell2.dsID '>']; ...
        %sprintf('CF = %.0fHz', Param.CellParam(2).CF); ...
        %sprintf('SR = %.0fspk/sec', Param.CellParam(2).SA); ...
        %''; ...
        %['\DeltaCF = ' sprintf('%.3f', log2(Param.CellParam(2).CF/Param.CellParam(1).CF)) 'oct']; ...
        %['\DeltaCoDist = ' sprintf('%.2f', (Param.CellParam(2).CD - Param.CellParam(1).CD)) 'mm']});
%PrintInfo([0.855  0.59 0.125 0.37], {'Stimulus Parameters:'; ...
        %sprintf('StimDur = %dms', Param.StimParam.BurstDur); ...
        %sprintf('RepDur  = %dms', Param.StimParam.RepDur); ...
        %''; ...
        %'CrossCorrelation:'; ...
        %sprintf('BinWidth = %.3fms', Param.CalcParam.corbinwidth); ...
        %sprintf('MaxLag = %dms', Param.CalcParam.cormaxlag); ...
        %sprintf('AnWin = [%dms-%dms]', Param.CalcParam.coranwin(1), Param.CalcParam.coranwin(2)); ...
        %''; ...
        %'CycleHistogram:'; ...
        %sprintf('Nr. of Bins = %d', Param.CalcParam.cyclenbin)});
%CF1&CF2 assign
CF1=Param.CellParam(1).CF;CF2=Param.CellParam(2).CF;
assignin('base','CF1',CF1);assignin('base','CF2',CF2);

%Plotten van alle cyclehistogrammen
%PlotInfo.XLabel = 'Cycle'; PlotInfo.XLim = [0 1];
%PlotInfo.YLabel = 'Rate(spk/sec)';
%PlotInfo.Text = ['{[''BF = '' int2str(PlotInfo.BinFreq(n)) ''Hz'' ];' ...
                 %' [''R = '' sprintf(''%.3f'', PlotInfo.R(n))];' ...
                 %' [''\phi = '' sprintf(''%.2f'', PlotInfo.Phase(n))];' ...
                 %' [''RaySig = '' num2str(PlotInfo.RaySig(n))];' ...
                 %' [''N = '' int2str(PlotInfo.N(n))]}' ];
%PlotInfo.BinFreq = Param.StimParam.StimFreq;
%PlotInfo.R       = cat(1, BinCycleHist.R);
%PlotInfo.Phase   = cat(1, BinCycleHist.Ph);
%PlotInfo.RaySig  = cat(1, BinCycleHist.pRaySig);
%PlotInfo.N       = cat(1, BinCycleHist.N);
%PlotInfo.Type = 'BAR';
%PlotSmallCurves(BinCycleHist, PlotInfo);

%---------%
% PLOTMPC %
%---------%
function PlotMPC(CellNr, MPC, MonCycleHist, CellInfo, Param)

DataID = eval(sprintf('[CellInfo.DataFile '' <'' CellInfo.Cell%d.dsID ''>''];', CellNr));

%Weergeven van de monaurale phase curve ...
%MinX = 0; MaxX = MPC(CellNr).X(end);
%MinY = floor(min(MPC(CellNr).Y)); MaxY = ceil(max(MPC(CellNr).Y));

%PlotInfo.Title  = ['Monaural Phase Curve for ' DataID];
%PlotInfo.XLabel = 'Stimulus Frequency(Hz)'; PlotInfo.XLim = [MinX MaxX];
%PlotInfo.YLabel = 'Phase(cycles)'; PlotInfo.YLim = [MinY MaxY];
%PlotInfo.Text   = {sprintf('Slope : %.3fms', MPC(CellNr).Slope); ...
                   %sprintf('YInterSect : %.3f', MPC(CellNr).YInterSect); ...
                   %sprintf('MSerror : %.3f', MPC(CellNr).MSerror); ...
                   %sprintf('pLinReg : %.3f', MPC(CellNr).pLinReg)};
%PlotInfo.Style  = 'ro-';
%Interface = PlotMainCurve(struct('X', MPC(CellNr).X, 'Y', MPC(CellNr).Y), PlotInfo);

%Niet significante waarden donker plotten
idx = find(MPC(CellNr).pRayleigh > 0.001); 
%line(MPC(CellNr).X(idx), MPC(CellNr).Y(idx), 'Color', [1 0 0], 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 24);

%line([0, MaxX], [MPC(CellNr).YInterSect, polyval([MPC(CellNr).Slope/1000 MPC(CellNr).YInterSect], MaxX)], 'Color', 'k', 'LineStyle', ':', 'Marker', 'none');

%MinX = 0; MaxX = MPC(CellNr).X(end);
%MinY = floor(min(MPC(CellNr).YInterSect)); MaxY = ceil(max(MPC(CellNr).Y));
%axis([MinX MaxX MinY MaxY]); was removed for combination data by Shotaro

%Weergeven van plotparameters en cellparameters  ...
%s = eval(sprintf('[ ''<'' CellInfo.Cell%d.dsID ''>'']', CellNr));
%PrintInfo([0.02 0.59 0.125 0.37], {s; ...
        %sprintf('CF = %.0fHz', Param.CellParam(CellNr).CF); ...
        %sprintf('SR = %.0fspk/sec', Param.CellParam(CellNr).SA)});
%PrintInfo([0.855  0.59 0.125 0.37], {'Stimulus Parameters:'; ...
        %sprintf('StimDur = %dms', Param.StimParam.BurstDur); ...
        %sprintf('RepDur  = %dms', Param.StimParam.RepDur); ...
        %''; ...
        %'CycleHistogram:'; ...
        %sprintf('AnWin = [%dms-%dms]', Param.CalcParam.coranwin); ...
        %sprintf('Nr. of Bins = %d', Param.CalcParam.cyclenbin)});

%Plotten van alle cyclehistogrammen
%PlotInfo.XLabel = 'Cycle'; PlotInfo.XLim = [0 1];
%PlotInfo.YLabel = 'Rate(spk/sec)';
%PlotInfo.Text = ['{[''BF = '' int2str(PlotInfo.BinFreq(n)) ''Hz'' ];' ...
                 %' [''R = '' sprintf(''%.3f'', PlotInfo.R(n))];' ...
                 %' [''\phi = '' sprintf(''%.3f'', PlotInfo.Phase(n))];' ...
                 %' [''RaySig = '' num2str(PlotInfo.RaySig(n))];' ...
                 %' [''N = '' int2str(PlotInfo.N(n))]}' ];
%PlotInfo.BinFreq = MPC(CellNr).X;
%PlotInfo.R       = cat(1, MonCycleHist.R);
%PlotInfo.Phase   = cat(1, MonCycleHist.Ph);
%PlotInfo.RaySig  = cat(1, MonCycleHist.pRaySig);
%PlotInfo.N       = cat(1, MonCycleHist.N);
%PlotInfo.Type = 'BAR';
%PlotSmallCurves(MonCycleHist, PlotInfo);

%---------%
% PLOTPRA %
%---------%
function [ISRx,ISRy] = PlotPRA(MRA, IRA, MPC, IPC, IR, MR, MSR, ISR, PD, CellInfo, Param);

DataID  = [ CellInfo.DataFile ' <' CellInfo.Cell1.dsID '> & <' CellInfo.Cell2.dsID '>' ];
DataID1 = [ CellInfo.DataFile ' <' CellInfo.Cell1.dsID '>' ];
DataID2 = [ CellInfo.DataFile ' <' CellInfo.Cell2.dsID '>' ];

%Interface = figure('Name', ['EvalFS: Response Area, Phase, R and SyncRate for ' DataID ], ...
    %'NumberTitle', 'off', ...
    %'PaperType', 'a4letter', ...
    %'PaperUnits', 'normalized', ...
    %'PaperPosition', [0.05 0.05 0.90 0.90], ...
    %'PaperOrientation', 'landscape');

StimFreqs = unique(cat(2, MRA.X));
MinFreq = min(StimFreqs);
MaxFreq = max(StimFreqs);

%Eerst ratecurve weergeven, dit voor beide monaurale gegevens, maar ook voor de gesimuleerde
%coincidence-detector ...
%Ax_Mon = axes('Position', [0.05 0.55 0.30 0.40]); set(Ax_Mon, 'XLim', [MinFreq MaxFreq]);
%Hdl_LineMon1 = line(MRA(1).X, MRA(1).Y, 'Color', 'b', 'LineStyle', '-', 'Marker', '^');
%Hdl_LineMon2 = line(MRA(2).X, MRA(2).Y, 'Color', 'b', 'LineStyle', '-', 'Marker', 'v');

%xlabel('Stimulus Frequency(Hz)'); ylabel('Monaural Rate(spk/sec)');

%line([MinFreq MaxFreq], [Param.CellParam(1).SA Param.CellParam(1).SA], 'Color', 'k', 'LineStyle', ':', 'Marker', 'none');
%line(MinFreq, Param.CellParam(1).SA, 'Color', 'b', 'LineStyle', 'none', 'Marker', '^');
%line([MinFreq MaxFreq], [Param.CellParam(2).SA Param.CellParam(2).SA], 'Color', 'k', 'LineStyle', ':', 'Marker', 'none');
%line(MinFreq, Param.CellParam(2).SA, 'Color', 'b', 'LineStyle', 'none', 'Marker', 'v');

%Ax_Bin = axes('Position', get(Ax_Mon, 'Position')); set(Ax_Bin, 'XLim', [MinFreq MaxFreq], 'Color', 'none', 'YAxisLocation', 'right');
%Hdl_LineBin = line(IRA.X, IRA.Y, 'Color', 'g', 'LineStyle', '-', 'Marker', 'o');

%ylabel('Interaural Rate(spk/sec)');

%Daarna phasecurven weergeven ...
%subplot('Position', [0.05 0.05 0.30 0.40]); hold on;
%idx1 = find(MPC(1).pRayleigh <= 0.001);
%plot(MPC(1).X(idx1), MPC(1).Y(idx1), 'b^-');
%idx2 = find(MPC(2).pRayleigh <= 0.001);
%plot(MPC(2).X(idx2), MPC(2).Y(idx2), 'bv-');

%plot(PD.X(PD.iRayleigh), PD.Y(PD.iRayleigh), 'rx-');
%idx = find(IPC.pRayleigh <= 0.001);
%plot(IPC.X(idx), IPC.Y(idx), 'go-');

%xlabel('Stimulus Frequency(Hz)'); ylabel('Phase(cycles)');

%MinX = 0; MaxX = max([MPC(1).X(end) MPC(2).X(end)]);
%line([MinX, MaxX], [MPC(1).YInterSect, polyval([MPC(1).Slope/1000 MPC(1).YInterSect], MaxX)], 'Color', 'k', 'LineStyle', ':', 'Marker', 'none');
%line([MinX, MaxX], [MPC(2).YInterSect, polyval([MPC(2).Slope/1000 MPC(2).YInterSect], MaxX)], 'Color', 'k', 'LineStyle', ':', 'Marker', 'none');
%line([MinX, MaxX], [IPC.CP, polyval([IPC.CD/1000 IPC.CP], MaxX)], 'Color', 'k', 'LineStyle', ':', 'Marker', 'none');
%line([MinX, MaxX], [PD.YInterSect, polyval([PD.Slope/1000 PD.YInterSect], MaxX)], 'Color', 'k', 'LineStyle', ':', 'Marker', 'none');
%xlim([MinX MaxX]);

%legend({[DataID1]; ...
        %[DataID2]; ...
        %['\Delta'];...
        %['CC']},2);

%R curven plotten ...
%Ax_IR = axes('Position', [0.45 0.55 0.30 0.40]); 
%idx = find(MR(1).pRayleigh <= 0.001);
%line(MR(1).X(idx), MR(1).Y(idx), 'LineStyle', '-', 'Color', 'b', 'Marker', '^');
%idx = find(MR(2).pRayleigh <= 0.001);
%line(MR(2).X(idx), MR(2).Y(idx), 'LineStyle', '-', 'Color', 'b', 'Marker', 'v');
%idx = find(IR.pRayleigh <= 0.001);
%line(IR.X(idx), IR.Y(idx), 'LineStyle', '-', 'Color', 'g', 'Marker', 'o');
%xlabel('Stimulus Frequency(Hz)'); ylabel('R');

%MinX = min([MR(1).X(1) MR(2).X(1) IR.X(1)]); MaxX = max([MR(1).X(end) MR(2).X(end) IR.X(end)]);
%MinY = 0; MaxY = 1;
%axis([MinX MaxX MinY MaxY]);

%SyncRate curven plotten ...
%Ax_MSR = axes('Position', [0.45 0.05 0.30 0.40]); 
idx = find(MSR(1).pRayleigh <= 0.001);
%Hdl_MSR1 = line(MSR(1).X(idx), MSR(1).Y(idx), 'LineStyle', '-', 'Color', 'b', 'Marker', '^');
idx = find(MSR(2).pRayleigh <= 0.001);
%Hdl_MSR2 = line(MSR(2).X(idx), MSR(2).Y(idx), 'LineStyle', '-', 'Color', 'b', 'Marker', 'v');

%xlabel('Stimulus Frequency(Hz)'); ylabel('Monaurale SyncRate(R*Rate)');

%MinX = min([MSR(1).X MSR(2).X]); MaxX = max([MSR(1).X MSR(2).X]);
%xlim([MinX MaxX]);

%Ax_ISR = axes('Position', get(Ax_MSR, 'Position')); set(Ax_ISR, 'XLim', [MinX MaxX], 'Color', 'none', 'YAxisLocation', 'right');
idx = find(ISR.pRayleigh <= 0.001);
%Hdl_ISR = line(ISR.X(idx), ISR.Y(idx), 'LineStyle', '-', 'Color', 'g', 'Marker', 'o');

%ylabel('Interaurale SyncRate(R*Rate)');
%ISRx&ISRy assign (removing the case of pRayleigh > 0.001)
ISRx=ISR.X(idx);ISRy=ISR.Y(idx);
assignin('base','ISRx',ISRx);assignin('base','ISRy',ISRy);

%Extra gegevens weergeven ...
%PrintInfo([0.80 0.55 0.15 0.40], {sprintf('%s', DataID); ...
         %''; ...
         %['<' CellInfo.Cell1.dsID '>']; ...
        %sprintf('CF = %.0fHz', Param.CellParam(1).CF); ...
        %sprintf('SR = %.0fspk/sec', Param.CellParam(1).SA); ...
        %''; ...
        %['<' CellInfo.Cell2.dsID '>']; ...
        %sprintf('CF = %.0fHz', Param.CellParam(2).CF); ...
        %sprintf('SR = %.0fspk/sec', Param.CellParam(2).SA); ...
        %''; ...
        %['\DeltaCF = ' sprintf('%.3f', log2(Param.CellParam(2).CF/Param.CellParam(1).CF)) 'oct']; ...
        %['\DeltaCoDist = ' sprintf('%.2f', (Param.CellParam(2).CD - Param.CellParam(1).CD)) 'mm']});
%PrintInfo([0.80 0.05 0.15 0.40], {'Rate:'; ...
        %sprintf('AnWin = [%dms-%dms]', Param.CalcParam.coranwin(1), Param.CalcParam.coranwin(2)); ...
        %''; ...
        %'CycleHistogram:'; ...
        %sprintf('AnWin = [%dms-%dms]', Param.CalcParam.coranwin(1), Param.CalcParam.coranwin(2)); ...
        %sprintf('Nr. of Bins = %d', Param.CalcParam.cyclenbin); ...
        %''; ...
        %'IPC-\DeltaMonPhase Corr:'; ...
        %sprintf('CorrCoeff : %.3f', PD.CorrCoef); ...
        %sprintf('pCorrCoef : %.3f', PD.pCorrCoef)});

%---------------%
% PLOTMAINCURVE %
%---------------%
function Hdl = PlotMainCurve(PlotData,PlotInfo)

Hdl = figure('Name', ['EvalFS: ' PlotInfo.Title ], ...
    'NumberTitle', 'off', ...
    'PaperType', 'a4letter', ...
    'PaperUnits', 'normalized', ...
    'PaperPosition', [0.05 0.05 0.90 0.90], ...
    'PaperOrientation', 'landscape');

subplot('Position', [0.25 0.59 0.5 0.37]); plot(PlotData.X, PlotData.Y, PlotInfo.Style);
txt_title = title(PlotInfo.Title); set(txt_title, 'FontSize', 12);
xlabel(PlotInfo.XLabel); ylabel(PlotInfo.YLabel);
axis([ PlotInfo.XLim, PlotInfo.YLim ]);
hold on;

txt_info = text(PlotInfo.XLim(1), PlotInfo.YLim(2), PlotInfo.Text);
set(txt_info, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

%-----------------%
% PLOTSMALLCURVES %
%-----------------%
function PlotSmallCurves(PlotData, PlotInfo)

XStartSpace = 0.055; YStartSpace = 0.055;
XSpacing = 0.015; YSpacing = 0.020; Width = 0.50; Length = 1;

N       = length(PlotData);   %Aantal correlogrammen te plotten
[nL,nW] = fact2(N);       %Beste organisatie van plots nagaan 

PlotWidth = (Width - (nW*YSpacing) - YStartSpace)/nW; 
PlotLength = (Length - (nL*XSpacing) - XStartSpace)/nL;

for n = 1:N
    Nrow = nW - floor((n-1)/nL); 
    Ncol = rem(n,nL); if Ncol == 0, Ncol = nL; end
    X = (Ncol-1)*PlotLength + (Ncol-1) * XSpacing + XStartSpace;
    Y = (Nrow-1)*PlotWidth + (Nrow-1) * YSpacing + YStartSpace;
    Pos  = [X Y PlotLength PlotWidth];
    
    axhdl(n) = axes('Parent', gcf, 'Position', Pos); 
    switch PlotInfo.Type
    case 'PLOT', plot(PlotData(n).X, PlotData(n).Y, 'b-');
    case 'BAR' 
        barhdl = bar(PlotData(n).X, PlotData(n).Y, 1);
        set(barhdl, 'EdgeColor', [0.7 0.7 0.7], 'FaceColor', [0.7 0.7 0.7]);
    end    
    set(axhdl(n), 'Box', 'on', 'XtickLabel', [], 'YTickLabel', []);
    
    MaxY(n) = max(PlotData(n).Y); if isnan(MaxY(n)), MaxY(n) = 1; end
    axis([PlotInfo.XLim, 0, MaxY(n)]);
    
    if Nrow == 1
        set(axhdl(n), 'XTickLabel', [PlotInfo.XLim(1) mean(PlotInfo.XLim) PlotInfo.XLim(2)]);
        xlabel(PlotInfo.XLabel);
    end
    
    txt_info(n) = text(PlotInfo.XLim(1), MaxY(n), eval(PlotInfo.Text));
    set(txt_info(n), 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', 'FontSize', 8);
end
MaxY = max(MaxY);
for n = 1:N
    Nrow = nW - floor((n-1)/nL); 
    Ncol = rem(n,nL); if Ncol == 0, Ncol = nL; end
    
    set(axhdl(n),'YLim', [0, MaxY] );
    set(txt_info(n), 'Position', [PlotInfo.XLim(1), MaxY]);
    
    if Ncol == 1
        YTickNum = (0:2)' *(MaxY/2);
        YTickLabel = []; for i = 1:length(YTickNum), YTickLabel = strvcat(YTickLabel, sprintf('%.1f', YTickNum(i))); end
        set(axhdl(n), 'YTick', YTickNum, 'YTickLabel', YTickLabel);
        axes(axhdl(n));
    end
    if (Ncol == 1) & (Nrow == floor(nW/2)), ylabel(PlotInfo.YLabel); end
end
