function penprint(varargin)
%PENPRINT print scaled penetration plot.
%   PENPRINT(ExperimentName, PenNr, ScaleFactor) prints a scaled 
%   penetration plot for a specified pen number of a given experiment.
%
%   E.g. PENPRINT('L89030', 1, 'inputtype', 'xls') prints the pen
%   penetration with scale 1mm/40mm for pen number one in the experiment
%   L89030. The actual data is read from the TAB-delimited text file
%   LSOHIST.DLM localized in the same directory is this m-file.
%
%   E.g. PENPRINT('M0315', 1) prints the pen penetration for pen number
%   one in the experiment M0315. The data is read from the userdatabase.
%
%   E.g. PENPRINT('L91008', '6B', 'inputtype', 'xls')
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 25-07-2005

%----------------------------default parameters------------------------------
%The property scalefactor specifies the scale that needs to be used when
%plotting. The scalefactor should be given as follows: 1 millimeter in
%reality denotes x mm on paper ...
DefParam.scalefactor = 40; 
%The program can read its data from the USERDATABASE or from an Microsoft
%Excel spreadsheet. The value for this property must be 'usr' or 'xls' ...
DefParam.inputtype   = 'usr';
%The name of the file where the histological data is located. This must be
%a TAB-delimited conversion of an Excel Spreadsheet. By default this is 
%LSOHIST.TXT localized in the same directory as this m-file. If no directory
%is supplied the current working directory is assumed, if no extension is
%given the extension '.dlm' is used ...
DefParam.xlsfilename = fullfile(fileparts(which(mfilename)), 'lsohist.dlm');
%Properties concerning printing and plotting:
DefParam.screenoutput = 'off'; %'on' or 'off' ...
DefParam.hdrmargin    = 0.25;  %in centimeters ...
DefParam.hdrheight    = 1.5;   %in centimeters ...
DefParam.textspacing  = 0.1;   %in centimeters ...
DefParam.textminsize  = 0.2;   %in centimeters ...
DefParam.textmaxsize  = 0.35;  %in centimeters ...
DefParam.datareduce   = 'on';  %'on' or 'off' ...
DefParam.papertype    = 'A4';
DefParam.papermargin  = 0.5;   %in centimeters ...
DefParam.paperborder  = 'off'; %'on' or 'off' ...

%----------------------------------main program------------------------------
%Evaluate input arguments ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    disp('Properties and their factory defaults:');
    disp(DefParam);
    return;
else, [ExperimentName, PenNr, Param] = ParseArgs(DefParam, varargin{:}); end

%Loading data ...
[Hdr, Data] = loaddata(ExperimentName, PenNr, Param);

%Plotting data ...
printdata(Hdr, Data, Param);

%---------------------------------local functions----------------------------
function [ExperimentName, PenNr, Param] = ParseArgs(DefParam, varargin)

%Checking input arguments ...
NArgs = length(varargin);
if (NArgs < 2), error('Wrong number of input arguments.'); end
if ~ischar(varargin{1}), error('First argument should be character string.'); end
ExperimentName = varargin{1};
if isnumeric(varargin{2}) & (length(varargin{2}) == 1) & (varargin{2} > 0), 
    PenNr = num2str(varargin{2});
elseif ischar(varargin{2}), PenNr = varargin{2};
else, error('Second argument should be positive integer or character string.'); end

%Retrieving properties and checking their values ...
Param = CheckPropList(DefParam, varargin{3:end});
Param = CheckParam(Param);

%----------------------------------------------------------------------------
function Param = CheckParam(Param)

if ~isnumeric(Param.scalefactor) | length(Param.scalefactor) ~= 1 | Param.scalefactor < 0, error('Invalid value for property ''scalefactor''.'); end
if ~any(strcmpi(Param.inputtype, {'usr', 'xls'})), error('Invalid value for property ''inputtype''.'); end

if ~ischar(Param.xlsfilename), error('Value for property ''xlsfilename'' should be character string.'); end
[Path, FileName, FileExt] = fileparts(Param.xlsfilename);
if isempty(FileName), error('Value for property ''xlsfilename'' should be valid filename.'); end
if isempty(Path), Path = pwd; end
if isempty(FileExt), FileExt = '.dlm'; end
Param.xlsfilename = fullfile(Path, [FileName, FileExt]);
if ~exist(Param.xlsfilename, 'file'), error(sprintf('''%s'' does not exist.')); end

if ~any(strcmpi(Param.screenoutput, {'on', 'off'})), error('Invalid value for property ''screenoutput''.'); end
if ~isnumeric(Param.hdrmargin) | length(Param.hdrmargin) ~= 1 | Param.hdrmargin < 0, error('Invalid value for property ''hdrmargin''.'); end
if ~isnumeric(Param.hdrheight) | length(Param.hdrheight) ~= 1 | Param.hdrheight < 0, error('Invalid value for property ''hdrheight''.'); end
if ~isnumeric(Param.textspacing) | length(Param.textspacing) ~= 1 | Param.textspacing < 0, error('Invalid value for property ''textspacing''.'); end
if ~isnumeric(Param.textminsize) | length(Param.textminsize) ~= 1 | Param.textminsize < 0, error('Invalid value for property ''textminsize''.'); end
if ~isnumeric(Param.textmaxsize) | length(Param.textmaxsize) ~= 1 | Param.textmaxsize < 0, error('Invalid value for property ''textmaxsize''.'); end
if Param.textmaxsize < Param.textminsize, error('Value of property textmaxsize must be greater than value of ''textminsize''.'); end
if ~any(strcmpi(Param.datareduce, {'on', 'off'})), error('Invalid value for property ''datareduce''.'); end
if ~any(strcmpi(Param.papertype, set(figure('visible', 'off'), 'PaperType'))), error('Invalid value for property ''papertype''.'); end; delete(gcf);
if ~isnumeric(Param.papermargin) | length(Param.papermargin) ~= 1 | Param.papermargin < 0, error('Invalid value for property ''papermargin''.'); end
if ~any(strcmpi(Param.paperborder, {'on', 'off'})), error('Invalid value for property ''paperborder''.'); end

%----------------------------------------------------------------------------
function [Hdr, Data] = loaddata(ExperimentName, PenNr, Param)

if strcmpi(Param.inputtype, 'xls'),
    %Reading TAB-delimited version of Excel spreadsheet ...
    fid = fopen(Param.xlsfilename, 'rt');
    if (fid < 0), error(sprintf('Cannot open ''%s''.', Param.xlsfilename)); end
    
    %Seeking requested experiment and pen number ...
    PenStr = sprintf('Pen %s', PenNr); Found = 0; PrevTokens = {''};
    while ~Found,
        Line = fgetl(fid); if ~ischar(Line), break; end
        Tokens = parseStr(Line);
        if strcmpi(PrevTokens{1}, ExperimentName) & strcmpi(Tokens{1}, PenStr), Found = 1;
        else, PrevTokens = Tokens; end   
    end
    if ~Found,
        error(sprintf('%s pen %s could not be found in ''%s''.', ExperimentName, PenNr, Param.xlsfilename)); 
    end
    
    %Information for header is already read into memory but needs to be
    %reorganized ...
    Tmp = parseStr(PrevTokens{2}, ','); 
    if (length(Tmp) == 2), [RecSide, PenType] = deal(Tmp{[1 2]});
    else [RecSide, PenType] = deal('', Tmp{1}); end     
    RecLoc = Tokens{2};
    [dummy, ExposedStr] = fileparts(Param.xlsfilename); ExposedStr = upper(ExposedStr);
    Hdr = CollectInStruct(ExperimentName, PenNr, PenType, ExposedStr, RecLoc, RecSide);
    
    %Shrinkage factor is not used ...
    Line = fgetl(fid); Tokens = parseStr(Line);
    if strcmpi(Tokens{1}, 'shrinkage'), Line = fgetl(fid); end
    
    %Reading the actual data ...
    EntryNr = 0;
    while 1,
        Line = fgetl(fid); if ~ischar(Line), break; end
        Tokens = parseStr(Line);
        if ~any(cellfun('length', Tokens)), break; 
        else,
            EntryNr = EntryNr + 1; NTokens = length(Tokens);
            if (NTokens < 6), Tokens = cat(2, Tokens(1:NTokens), repmat({''}, 1, 6-NTokens)); end
            [Data(EntryNr).HistDepth, Data(EntryNr).Col1, Data(EntryNr).Col2, Data(EntryNr).Col3, ...
                    Data(EntryNr).Comments, Data(EntryNr).Lesions] = deal(Tokens{1:max(NTokens, 6)});
        end
    end
    if (EntryNr > 0), Tmp = num2cell(str2num(char(Data.HistDepth))); [Data.HistDepth] = deal(Tmp{:});
    else Data = struct([]); end    
    
    fclose(fid);
else,
    %Loading userdata information on experiment ...
    try, S = getfield(getuserdata(ExperimentName), 'CellInfo');
    catch, error(sprintf('No userdatabase entry for experiment ''%s''.', ExperimentName)); end
    S = structfilter(S, sprintf('($iPen$ == %s) & ~isnan($HistDepth$)', PenNr)); N = length(S);
    if isempty(S), error(sprintf('No penetration with number %d in experiment ''%s''.', PenNr, ExperimentName)); end
    
    %Reformating information ...
    Hdr = struct('ExperimentName', ExperimentName, ...
                 'PenNr', PenNr, ...
                 'PenType', '', ...
                 'ExposedStr', S(1).ExposedStr, ...
                 'RecLoc', S(1).RecLoc, ...
                 'RecSide', S(1).RecSide);
    PassNr = cat(1, S.iPass);         
    Data = struct('HistDepth', {S.HistDepth}, 'Col1', repmat({''}, 1, N), 'Col2', repmat({''}, 1, N), ...
        'Col3', repmat({''}, 1, N), 'Comments', cellstr([repmat('Pass nr. ', N, 1), num2str(PassNr)])', ...
        'Lesions', repmat({''}, 1, N));
end    

%----------------------------------------------------------------------------
function printdata(Hdr, Data, Param)

%Adjust data ...
Data = adjustData(Data);

%Build figures ...
PaperSize = get(figure('visible', 'off', 'PaperType', Param.papertype, 'PaperUnits', 'centimeters'), 'PaperSize'); delete(gcf);
TotalLength = (max(cat(2, Data.RelDepth))/1000) * (Param.scalefactor/10) + 2*Param.hdrmargin + Param.hdrheight;
NPages = ceil(TotalLength / (PaperSize(2) - 2*Param.papermargin));
for n = 1:NPages, Hdl(n) = plotPage(n, NPages, Hdr, Data, Param.scalefactor, Param); end

%Print figures if requested ...
if strcmpi(Param.screenoutput, 'off'),
    for n = 1:NPages,
        fprintf('Printing page %d/%d ...\n', n, NPages);
        print(sprintf('-f%d', Hdl(n)));
    end
    delete(Hdl);
end

%----------------------------------------------------------------------------
function D = adjustData(D)

N = length(D); Nr = num2cell(1:N);
HistDepths = cat(1, D.HistDepth); RelDepth = num2cell(HistDepths - min(HistDepths));
[D.Nr] = deal(Nr{:}); [D.RelDepth] = deal(RelDepth{:});

D = structsort(D, 'RelDepth');

%----------------------------------------------------------------------------
function Fig_Hdl = plotPage(PageNr, NPages, H, D, ScaleFactor, Param)

%Onzichtbare figuur aanmaken met axes object dat oppervlakte bedekt ...
Fig_Hdl = figure('Visible', Param.screenoutput, ... 
                 'PaperOrientation', 'portrait', ...
                 'PaperType', Param.papertype, ...
                 'PaperUnits', 'centimeters', ...
                 'PaperPositionMode', 'manual');
PaperSize = get(Fig_Hdl, 'PaperSize');
set(Fig_Hdl, 'PaperPosition', [0 0 PaperSize]);

ActSize = [0 0 PaperSize-2*Param.papermargin];
Ax_Hdl = axes('Visible', Param.paperborder, ...
              'Units', 'centimeters', ...
              'Position', [Param.papermargin Param.papermargin ActSize([3:4])], ...
              'XLimMode', 'manual', 'YLimMode', 'manual', ...
              'XLim', [0 ActSize(3)], 'YLim', [0 ActSize(4)], ...
              'XTick', [], 'YTick', [], ...
              'XColor', [0 0 0], 'YColor', [0 0 0], 'Box', 'on');

%Gegevens op onzichtbare figuur plotten ...
if PageNr == 1, plotHeader(H, ActSize, Param); end;    
plotLegend(PageNr, ScaleFactor, ActSize, Param);
plotData(PageNr, NPages, D, ScaleFactor, ActSize, Param);

if NPages ~= 1,
    TextLines = 3; TextHeight = (Param.hdrheight - (TextLines+1)*Param.textspacing)/TextLines;
    text(ActSize(3)-Param.textspacing, Param.textspacing, sprintf('Page %d of %d', PageNr, NPages), 'Color', [0 0 0], ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', ...
        'FontUnits', 'centimeters', 'FontSize', TextHeight);
end

%----------------------------------------------------------------------------
function plotHeader(Hdr, Sz, Param)

Width  = Sz(3) - 2*Param.hdrmargin;
Height = Param.hdrheight;

TextLines  = 3; 
TextHeight = (Height - (TextLines+1)*Param.textspacing)/TextLines;

plotBox([Param.hdrmargin (Sz(4)-Height-Param.hdrmargin) Width Height]); %Box ...
line([Param.hdrmargin+Width*0.4 Param.hdrmargin+Width*0.4], [Sz(4)-Height-Param.hdrmargin Sz(4)-Param.hdrmargin], 'Color', [0 0 0], 'LineStyle', '-', 'Marker', 'none'); %Center line ...

Extent = [];
Txt_Hdl = text(Param.hdrmargin+Param.textspacing, Sz(4)-Param.hdrmargin-Param.textspacing-TextHeight, 'Experiment Name', 'Color', [0 0 0], ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
    'FontUnits', 'centimeters', 'FontSize', TextHeight, 'FontWeight', 'bold');
Extent = [Extent; get(Txt_Hdl, 'Extent')];
Txt_Hdl = text(Param.hdrmargin+Param.textspacing, Sz(4)-Param.hdrmargin-2*Param.textspacing-2*TextHeight, 'Pen. Nr.', 'Color', [0 0 0], ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
    'FontUnits', 'centimeters', 'FontSize', TextHeight, 'FontWeight', 'bold');
Extent = [Extent; get(Txt_Hdl, 'Extent')];
Txt_Hdl = text(Param.hdrmargin+Param.textspacing, Sz(4)-Param.hdrmargin-3*Param.textspacing-3*TextHeight, 'Pen. Type', 'Color', [0 0 0], ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
    'FontUnits', 'centimeters', 'FontSize', TextHeight, 'FontWeight', 'bold');
Extent = [Extent; get(Txt_Hdl, 'Extent')];
MaxWidth = max(Extent(:, 3));
line([Param.hdrmargin+MaxWidth+2*Param.textspacing Param.hdrmargin+MaxWidth+2*Param.textspacing], [Sz(4)-Height-Param.hdrmargin Sz(4)-Param.hdrmargin], 'Color', [0 0 0], 'LineStyle', '-', 'Marker', 'none');

text(Param.hdrmargin+MaxWidth+3*Param.textspacing, Sz(4)-Param.hdrmargin-Param.textspacing-TextHeight, Hdr.ExperimentName, 'Color', [0 0 0], ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
    'FontUnits', 'centimeters', 'FontSize', TextHeight);
text(Param.hdrmargin+MaxWidth+3*Param.textspacing, Sz(4)-Param.hdrmargin-2*Param.textspacing-2*TextHeight, Hdr.PenNr, 'Color', [0 0 0], ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
    'FontUnits', 'centimeters', 'FontSize', TextHeight);
text(Param.hdrmargin+MaxWidth+3*Param.textspacing, Sz(4)-Param.hdrmargin-3*Param.textspacing-3*TextHeight, Hdr.PenType, 'Color', [0 0 0], ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
    'FontUnits', 'centimeters', 'FontSize', TextHeight);

Extent = [];
Txt_Hdl = text(Param.hdrmargin+Width*0.4+Param.textspacing, Sz(4)-Param.hdrmargin-Param.textspacing-TextHeight, 'Exposed Str.', 'Color', [0 0 0], ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
    'FontUnits', 'centimeters', 'FontSize', TextHeight, 'FontWeight', 'bold');
Extent = [Extent; get(Txt_Hdl, 'Extent')];
Txt_Hdl = text(Param.hdrmargin+Width*0.4+Param.textspacing, Sz(4)-Param.hdrmargin-2*Param.textspacing-2*TextHeight, 'Rec. Size', 'Color', [0 0 0], ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
    'FontUnits', 'centimeters', 'FontSize', TextHeight, 'FontWeight', 'bold');
Extent = [Extent; get(Txt_Hdl, 'Extent')];
Txt_Hdl = text(Param.hdrmargin+Width*0.4+Param.textspacing, Sz(4)-Param.hdrmargin-3*Param.textspacing-3*TextHeight, 'Rec. Loc.', 'Color', [0 0 0], ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
    'FontUnits', 'centimeters', 'FontSize', TextHeight, 'FontWeight', 'bold');
Extent = [Extent; get(Txt_Hdl, 'Extent')];
MaxWidth = max(Extent(:, 3));
line([Param.hdrmargin+Width*0.4+MaxWidth+2*Param.textspacing Param.hdrmargin+Width*0.4+MaxWidth+2*Param.textspacing], [Sz(4)-Height-Param.hdrmargin Sz(4)-Param.hdrmargin], 'Color', [0 0 0], 'LineStyle', '-', 'Marker', 'none');

text(Param.hdrmargin+Width*0.4+MaxWidth+3*Param.textspacing, Sz(4)-Param.hdrmargin-Param.textspacing-TextHeight, Hdr.ExposedStr, 'Color', [0 0 0], ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
    'FontUnits', 'centimeters', 'FontSize', TextHeight);
text(Param.hdrmargin+Width*0.4+MaxWidth+3*Param.textspacing, Sz(4)-Param.hdrmargin-2*Param.textspacing-2*TextHeight, Hdr.RecSide, 'Color', [0 0 0], ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
    'FontUnits', 'centimeters', 'FontSize', TextHeight);
text(Param.hdrmargin+Width*0.4+MaxWidth+3*Param.textspacing, Sz(4)-Param.hdrmargin-3*Param.textspacing-3*TextHeight, Hdr.RecLoc, 'Color', [0 0 0], ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
    'FontUnits', 'centimeters', 'FontSize', TextHeight);

%----------------------------------------------------------------------------
function plotLegend(PageNr, ScaleFactor, Sz, Param)

if PageNr == 1, StartPoint = Sz(4) - (2*Param.hdrmargin + Param.hdrheight);
else, StartPoint = Sz(4); end;    

Height  = ScaleFactor/10; 
Width   = Param.hdrheight/3; 

TextLines  = 1;
TextHeight = (Width - (TextLines+1)*Param.textspacing)/TextLines;

plotBox([Param.hdrmargin, StartPoint-Height, Width, Height], [0 0 0], [0.5 0.5 0.5]);
text(Param.hdrmargin+Param.textspacing, StartPoint-Param.textspacing, sprintf('1mm/%dmm', ScaleFactor), 'Color', [0 0 0], ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
    'FontUnits', 'centimeters', 'FontSize', TextHeight, 'Rotation', -90);

%----------------------------------------------------------------------------
function plotData(PageNr, NPages, D, ScaleFactor, Sz, Param)

switch PageNr
case 1,    
    startPoint = Sz(4) - (2*Param.hdrmargin + Param.hdrheight);
    prevHeight = 0;
case 2, 
    startPoint = Sz(4);
    prevHeight = Sz(4) - (2*Param.hdrmargin + Param.hdrheight);
otherwise, 
    startPoint = Sz(4); 
    prevHeight = Sz(4) - (2*Param.hdrmargin + Param.hdrheight) + Sz(4)*(PageNr-2);
end;    

Ticks = cat(2, D.RelDepth);
Ticks = (Ticks/1000) * (ScaleFactor/10);

idx = find((Ticks >= prevHeight) & (Ticks < prevHeight + startPoint));
PrevNTicks = length(find(Ticks < prevHeight));
Ticks = Ticks(idx); NTicks = length(Ticks);    

%Centrale lijn plotten ...
if NPages == 1,
    X = repmat(Sz(3)*0.4, 1, NTicks);
    Y = startPoint - Ticks; 
elseif PageNr < NPages & PageNr == 1, 
    X = repmat(Sz(3)*0.4, 1, NTicks+1);
    Y = startPoint - [Ticks-prevHeight startPoint];
elseif PageNr < NPages,
    X = repmat(Sz(3)*0.4, 1, NTicks+2);
    Y = startPoint - [0 Ticks-prevHeight startPoint];
else,    
    X = repmat(Sz(3)*0.4, 1, NTicks+1);
    Y = startPoint - [0 Ticks-prevHeight]; 
end
line(X, Y, 'Color', [0 0 0], 'LineStyle', '-', 'Marker', '.');

%Indien nodig en gevraagd gegevens reduceren ...
ExList = [];
if strcmpi(Param.datareduce, 'on'),
    idx = find(diff(Ticks) < Param.textminsize);
    for n = 1:length(idx),
        if ~strncmpi(D(PrevNTicks+idx(n)).Lesions, 'lesion', 6), ExList = [ExList, idx(n)]; 
        elseif ~strncmpi(D(PrevNTicks+idx(n)+1).Lesions, 'lesion', 6), ExList = [ExList, idx(n)+1]; end
    end
    if ~isempty(ExList), fprintf('Following points on page %d are removed for space reasons: %s.\n', PageNr, formatcell(fulldeblank(cellstr(num2str(cat(1, D(ExList).Nr)))), {'<', '>'}, ',')); end
end

%Gegevens errond plotten ...
TextHeight = (min(diff(Ticks))) - Param.textspacing;
if isempty(TextHeight), TextHeight = Param.textmaxsize;
elseif TextHeight > Param.textmaxsize, TextHeight = Param.textmaxsize; 
elseif TextHeight < Param.textminsize, TextHeight = Param.textminsize; end

Y = startPoint - (Ticks-prevHeight);
for n = 1:NTicks,
    idx = n + PrevNTicks;
    if ismember(idx, ExList), continue; end
    text(Sz(3)*0.3, Y(n), int2str(D(idx).Nr), 'Color', [0 0 0], ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', ...
        'FontUnits', 'centimeters', 'FontSize', TextHeight);
    text(Sz(3)*0.35, Y(n), int2str(D(idx).RelDepth), 'Color', [0 0 0], ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', ...
        'FontUnits', 'centimeters', 'FontSize', TextHeight);
    text(Sz(3)*0.425, Y(n), int2str(D(idx).HistDepth), 'Color', [0 0 0], ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
        'FontUnits', 'centimeters', 'FontSize', TextHeight);
    text(Sz(3)*0.475, Y(n), D(idx).Col1, 'Color', [0 0 0], ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
        'FontUnits', 'centimeters', 'FontSize', TextHeight);
    text(Sz(3)*0.55, Y(n), D(idx).Col2, 'Color', [0 0 0], ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
        'FontUnits', 'centimeters', 'FontSize', TextHeight);
    text(Sz(3)*0.65, Y(n), D(idx).Col3, 'Color', [0 0 0], ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
        'FontUnits', 'centimeters', 'FontSize', TextHeight);
    text(Sz(3)*0.75, Y(n), D(idx).Comments, 'Color', [0 0 0], ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
        'FontUnits', 'centimeters', 'FontSize', TextHeight);
    Hdl = text(Sz(3)*0.85, Y(n), D(idx).Lesions, 'Color', [0 0 0], ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
        'FontUnits', 'centimeters', 'FontSize', TextHeight);
    if ~isempty(D(idx).Lesions) & strncmpi(D(idx).Lesions, 'lesion', 6), 
        TextExtent = get(Hdl, 'Extent');
        plotBox([Sz(3)*0.85-Param.textspacing Y(n)-TextHeight/2 TextExtent(3)+2*Param.textspacing TextHeight], [0 0 0], [1 1 1]); 
        line(Sz(3)*0.4, Y(n), 'Color', [0 0 0], 'LineStyle', 'none', 'Marker', 'o');
    end
end

%----------------------------------------------------------------------------
function plotBox(Pos, EdgeColor, FaceColor)

switch nargin
case 1
    EdgeColor = [0 0 0];
    FaceColor = [1 1 1];
case 2, FaceColor = [1 1 1]; end

x1 = Pos(1); x2 = Pos(1) + Pos(3);
y1 = Pos(2); y2 = Pos(2) + Pos(4);

if isequal(FaceColor, [1 1 1]),
    line([x1 x2], [y1 y1], 'Color', EdgeColor, 'LineStyle', '-', 'Marker', 'none');
    line([x2 x2], [y1 y2], 'Color', EdgeColor, 'LineStyle', '-', 'Marker', 'none');
    line([x1 x2], [y2 y2], 'Color', EdgeColor, 'LineStyle', '-', 'Marker', 'none');
    line([x1 x1], [y1 y2], 'Color', EdgeColor, 'LineStyle', '-', 'Marker', 'none');
else, patch([x1 x1 x2 x2], [y1 y2 y2 y1], FaceColor, 'EdgeColor', EdgeColor); end

%----------------------------------------------------------------------------