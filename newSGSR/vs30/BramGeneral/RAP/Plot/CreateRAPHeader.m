function HdrHdl = CreateRAPHeader(FigHdl, RAPStat)
%CreateRAPHeader    creates header on figure object
%   HdrHdl = CreateRAPHeader(FigHdl, RAPStat)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 07-05-2004

Header = RAPStat.PlotParam.Header;
HdrPos = [Header.HorMargin, (1 - (Header.Height+Header.VerMargin)), ...
    (1 - 2*Header.HorMargin), Header.Height];
HdrHdl = axes('Parent', FigHdl, 'Position', HdrPos, 'Box', 'on', 'Visible', 'on', ...
              'Units', 'normalized', 'XLim', [0 1], 'YLim', [0 1], ...
              'XTick', [], 'XTickLabel', '', 'YTick', [], 'YTickLabel', '');

ds = RAPStat.GenParam.DS; 
if isTHRdata(ds)
    NRec = length(ds.xval);
else
    NRec = ds.nrec;
end
%CalcParam = RAPStat.CalcParam;

if isfield(RAPStat, 'PlotPool')
    for n=1:length(RAPStat.PlotPool)
        ds = RAPStat.PlotPool(n).DS;
        Header = generalDatasetInfo(Header,ds, (n-1)*.25);
    end
else
    Header = generalDatasetInfo(Header, ds, 0);
end

if ~isfield(RAPStat, 'PlotPool')
    %Information on independent variable ...
    if strcmpi(ds.FileFormat, 'EDF') && (ds.indepnr == 2)
        Labels = {'Channels', 'NSubSeqs/NReps', 'IndepVar', 'IndepRange'};
        InfoTxt = {Channel2Str(ds), sprintf('%d/%d x %d', ds.nrec, ds.nsub, ds.nrep), ...
            [ds.xname '/' ds.yname], RAPIndepVar2Str(ds.EDFIndepVar(1)), ...
            RAPIndepVar2Str(ds.EDFIndepVar(2))};
    else
        Labels = {'Channels', 'NSubSeqs/NReps', 'IndepVar', 'IndepRange', 'SPL'};
        InfoTxt = {Channel2Str(ds), sprintf('%d/%d x %d', ds.nrec, ds.nsub, ds.nrep), ...
            ds.indepname, RAPIndepVar2Str(ds.indepvar), RAPSPL2Str(ds)};
    end
    MaxExtent = CreateHeaderColumn(0.25 + Header.TextSpacing, Labels, 'bold', Header);
    CreateHeaderLine(0.25 + Header.TextSpacing*2 + MaxExtent, 'single', Header);
    CreateHeaderColumn(0.25 + Header.TextSpacing*3 + MaxExtent, InfoTxt, 'normal', Header);
    CreateHeaderLine(0.75, 'double', Header);

    %Stimulus parameters ...

    %To be sure frequency conventions are equal between EDF and
    %SGSR/Pharmington datasets ...
    S = GetFreq(ds);
    %Displaying only the appropriate beat frequency ...
    if all(isnan(S.BeatFreq(1:NRec))) && all(isnan(S.BeatModFreq(1:NRec)))
        BeatFreq = NaN;
    %Beat on modulation frequency has priority over carrier frequency ...
    elseif ~all(isnan(S.BeatModFreq(1:NRec)))
        BeatFreq = S.BeatModFreq;
    else
        BeatFreq = S.BeatFreq;
    end
    MaxExtent = CreateHeaderColumn(0.75 + Header.TextSpacing, ...
        {'BurstDur', 'RepDur', 'CarFreq', 'ModFreq', 'BeatFreq'}, 'bold', Header);
    CreateHeaderLine(0.75 + Header.TextSpacing*2 + MaxExtent, 'single', Header);
    CreateHeaderColumn(0.75 + Header.TextSpacing*3 + MaxExtent, ...
        {RAPTimeVar2Str(ds.burstdur), RAPTimeVar2Str(ds.repdur), ...
        RAPFreqVar2Str(S.CarFreq(1:NRec, :)), RAPFreqVar2Str(S.ModFreq(1:NRec, :)), ...
        RAPFreqVar2Str(BeatFreq)}, 'normal', Header);
end

%-------------------------------local functions-------------------------------
function Header = generalDatasetInfo(Header, ds, spacing)
%General dataset information ...
MaxExtent = CreateHeaderColumn(spacing + Header.TextSpacing, ...
    {'FileName', 'FileFormat', 'SeqID (iSeq)', 'StimType', 'RecTime'}, 'bold', Header);
CreateHeaderLine(spacing + Header.TextSpacing*2 + MaxExtent, 'single', Header);
CreateHeaderColumn(spacing + Header.TextSpacing*3 + MaxExtent, {upper(ds.FileName), ...
    upper(ds.FileFormat), sprintf('%s (%d)', ds.SeqID, ds.iSeq), ...
    upper(ds.StimType), datestr(datenum(ds.Time(3), ds.Time(2), ...
    ds.Time(1)), 1)}, 'normal', Header);
CreateHeaderLine(spacing + 0.25, 'double', Header);


function MaxExtent = CreateHeaderColumn(X, Text, FontWeight, Header)

NLines = min([Header.MaxNLines length(Text)]);

for n = 1:NLines
    Yn = 1 - Header.TextSpacing*n - Header.FontSize*(n-1);
    HdlTxt(n) = text(X, Yn, Text{n}, 'Units', 'normalized', 'FontSize', ...
        Header.FontSize, 'FontWeight', FontWeight, 'FontName', Header.FontName, ...
        'Color', Header.Color, 'HorizontalAlignment', 'left', ...
        'VerticalAlignment', 'top'); 
end

Extent = get(HdlTxt, 'Extent');
Extent = cat(1, Extent{:});
MaxExtent = max(Extent(:, 3));

%-------------------------------------------------------------------------------
function CreateHeaderLine(X, Style, Header)

if strcmpi(Style, 'single')
    line(X([1 1]), [0 1], 'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
else
    line(X([1 1]) - Header.TextSpacing/4, [0 1], 'LineStyle', '-', 'Color', ...
        Header.Color, 'Marker', 'none');
    line(X([1 1]) + Header.TextSpacing/4, [0 1], 'LineStyle', '-', 'Color', ...
        Header.Color, 'Marker', 'none');
end

%-------------------------------------------------------------------------------