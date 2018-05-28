function C = structplot(varargin)
%STRUCTPLOT plot scatterplot using fields from a structure-array.
%   STRUCTPLOT(S, XField, YField) plots XField versus YField from structure-array S.
%
%   STRUCTPLOT(S1, S2, XField, YField) plots XField versus YField from structure-arrays S1 and 
%   S2 on the same plot.
%
%   STRUCTPLOT(S1, XField, S2, YField) plots XField from struct S1 versus YField from struct S2.
%
%   Optional properties and their values can be given as a comma-separated list. To view list
%   of all possible properties and their default values, use 'list' as only property. STRUCTPLOT 
%   reads and uses the configuration file STRUCTPLOT.CFG in the current working directory. For 
%   information on the syntax of a configuration file, see READPROPLIST.

%B. Van de Sande 10-12-2003

%Default parameters ...
DefParam.cellidfields  = {'ds1.filename', 'ds1.icell'};
DefParam.totalidfields = {'ds1.filename', 'ds1.icell', 'ds1.seqid', 'ds2.seqid'};

DefParam.filterfields = {};
DefParam.filtervalues = {};

DefParam.colors   = {'b', 'r'};
DefParam.markers  = {'o', '^'};
DefParam.xlim     = [-Inf +Inf];
DefParam.ylim     = [-Inf +Inf];

DefParam.xexp = '';
DefParam.yexp = ''; %vb.: '1000./%' voor conversie van ms naar Hz ...

DefParam.Fit = 'none'; %'none', 'linear' or 'hyperbolic' ...

%Parameters evalueren ...
if nargin == 1 & ischar(varargin{1}) & strcmpi(varargin{1}, 'callback'), callbackfunc; return; end %CALLBACK ...

if nargin < 3, error('Wrong number of input arguments.'); end

%Om snelheid te winnen eerst conversie uitvoeren van structuur-array naar tabel (is eigenlijk een cell-array) 
%en daarna steeds hierop blijven werken.
if isstruct(varargin{2}),
    try
        [S1, S2, XField, YField] = deal(varargin{1:4});
        [T1.Data, T1.FName] = destruct(S1); [T2.Data, T2.FName] = destruct(S2);
        
        if ~all(ismember({XField, YField}, T1.FName)), error('Wrong input arguments.'); end
        if ~all(ismember({XField, YField}, T2.FName)), error('Wrong input arguments.'); end
        S1name = inputname(1); S2name = inputname(2);
        idx = 5; Mode = 'single';
    catch error('Wrong input arguments.'); end    
elseif isstruct(varargin{3}),
    try
        [S1, XField, S2, YField] = deal(varargin{1:4});
        [T1.Data, T1.FName] = destruct(S1); [T2.Data, T2.FName] = destruct(S2);
        
        if ~ismember(XField, T1.FName), error('Wrong input arguments.'); end
        if ~ismember(YField, T2.FName), error('Wrong input arguments.'); end
        S1name = inputname(1); S2name = inputname(3);
        idx = 5; Mode = 'multi';
    catch error('Wrong input arguments.'); end    
else, 
    try 
        [S1, XField, YField] = deal(varargin{1:3});
        [T1.Data, T1.FName] = destruct(S1);

        if ~all(ismember({XField, YField}, T1.FName)), error('Wrong input arguments.'); end
        S2 = struct([]); [T2.Data, T2.FName] = deal(cell(0));
        S1name = inputname(1); S2name = '';
        idx = 4; Mode = 'single';
    catch error('Wrong input arguments.'); end    
end

DefParam = readproplist('structplot.cfg', DefParam);
Param = checkproplist(DefParam, varargin{idx:end});
Param = checkparam(Param);

%Filters toepassen op tabellen ...
T1 = Tfilter(T1, Param.filterfields, Param.filtervalues);
if ~isempty(S2), T2 = Tfilter(T2, Param.filterfields, Param.filtervalues); end

%Gegevens herorganiseren en punten van dezelfde cel combineren ...
switch Mode
case 'single',
    [X1, Y1, XData1, YData1, sidx1] = getplotfields(T1, XField, YField, Param);
    if ~isempty(S2), 
        [X2, Y2, XData2, YData2, sidx2] = getplotfields(T2, XField, YField, Param);
        if any(cellfun('isempty', {X2, Y2, XData2, YData2})),
            CellList1 = getcelllist(sidx1, T1, Param.totalidfields);
            CellList2 = cell(0);
            S2 = struct([]); 
        elseif any(cellfun('isempty', {X1, Y1, XData1, YData1})), 
            CellList1 = cell(0);
            CellList2 = getcelllist(sidx2, T2, Param.totalidfields);
            S1 = struct([]);
        else,
            idx1 = find(ismember(Param.totalidfields, T1.FName));
            idx2 = find(ismember(Param.totalidfields, T2.FName)); 
            CommonIDFields = Param.totalidfields(intersect(idx1, idx2));
            
            CellList1 = getcelllist(sidx1, T1, CommonIDFields);
            CellList2 = getcelllist(sidx2, T2, CommonIDFields);
          
            Param.totalidfields = CommonIDFields;
        end    
    else, 
        [X2, Y2, XData2, YData2] = deal([]); 
        CellList1 = getcelllist(sidx1, T1, Param.totalidfields);
        CellList2 = cell(0); 
    end
    
    if size(X1, 1) == 1, LineStyle1 = 'none'; else LineStyle1 = '-'; end
    if size(X2, 1) == 1, LineStyle2 = 'none'; else LineStyle2 = '-'; end   
case 'multi'
    XData1 = getTcol(T1, XField); YData1 = getTcol(T2, YField);
    [XData2, YData2, X2, Y2] = deal([]);
    
    LineStyle1 = 'none'; LineStyle2 = 'none';

    if all(ismember(Param.cellidfields, T1.FName)) & all(ismember(Param.cellidfields, T2.FName))
        idx1 = find(ismember(Param.totalidfields, T1.FName)); 
        idx2 = find(ismember(Param.totalidfields, T2.FName)); 
        CommonIDFields = Param.totalidfields(intersect(idx1, idx2));
        
        CellList1 = getTcol(T1, CommonIDFields{:});
        CellList2 = getTcol(T2, CommonIDFields{:}); 
        
        Param.totalidfields = CommonIDFields;
        
        List1 = upper(cv2str(getTcol(T1, Param.cellidfields{:})));
        List2 = upper(cv2str(getTcol(T2, Param.cellidfields{:})));

        [List, idx] = intersect(List1, List2, 'rows');
        
        CellList1 = CellList1(idx, :); CellList2 = cell(0);

        idx1 = find(ismember(List1(:, 1:end-1), List, 'rows'));
        idx2 = find(ismember(List2(:, 1:end-1), List, 'rows'));
        
        XData1 = XData1(idx1); YData1 = YData1(idx2);
 
        [dummy, idx1] = unique(List1(idx1, :), 'rows'); [X1, XData1] = deal(XData1(idx1));
        [dummy, idx2] = unique(List2(idx2, :), 'rows'); [Y1, YData1] = deal(YData1(idx2));
    else, error('Could not retrieve cell information, property cellidfield has wrong value.'); end
end    

CellList1 = conv2cellstr(CellList1);
CellList2 = conv2cellstr(CellList2);

X1 = evalexp(X1, Param.xexp); XData1 = evalexp(XData1, Param.xexp);
X2 = evalexp(X2, Param.xexp); XData2 = evalexp(XData2, Param.xexp);
Y1 = evalexp(Y1, Param.yexp); YData1 = evalexp(YData1, Param.yexp);
Y2 = evalexp(Y2, Param.yexp); YData2 = evalexp(YData2, Param.yexp);

%Fitten van gevraagde curve ...
if strncmpi(Param.fit, 'l', 1),
    idx = find(~isnan(X1) & ~isnan(Y1));
    Xt = X1(idx)'; Yt = Y1(idx)';
    [Xt, idx] = sort(Xt); Yt = Yt(idx);
    Cfit1 = polyfit(Xt, Yt, 1);
    if ~isempty(X2) & ~isempty(Y2), 
        idx = find(~isnan(X2) & ~isnan(Y2));
        Xt = X2(idx)'; Yt = Y2(idx)';
        [Xt, idx] = sort(Xt); Yt = Yt(idx);
        Cfit2 = polyfit(Xt, Yt, 1);
    end      
elseif strncmpi(Param.fit, 'h', 1),
    Cstart = [1, 0]; %Starten met standaard hyperbolische functie y = 1/x ...
    
    idx = find(~isnan(X1) & ~isnan(Y1));
    Xt = X1(idx)'; Yt = Y1(idx)';
    [Xt, idx] = sort(Xt); Yt = Yt(idx);
    Cfit1 = lsqcurvefit(@hypfunc, Cstart, Xt, Yt, [], [], optimset('Display', 'off'));
    if ~isempty(X2) & ~isempty(Y2), 
        idx = find(~isnan(X2) & ~isnan(Y2));
        Xt = X2(idx)'; Yt = Y2(idx)';
        [Xt, idx] = sort(Xt); Yt = Yt(idx);
        Cfit2 = lsqcurvefit(@hypfunc, Cstart, Xt, Yt, [], [], optimset('Display', 'off'));
    end      
end

%Aantal elementen berekenen ...
N1 = length(find(~isnan(XData1) & ~isnan(YData1)));
N2 = length(find(~isnan(XData2) & ~isnan(YData2)));
NPoints = N1 + N2;
switch Mode
case 'single', 
    N1 = length(find(any((~isnan(X1) & ~isnan(Y1)), 1)));
    N2 = length(find(any((~isnan(X2) & ~isnan(Y2)), 1)));
    NCells  = N1 + N2;
case 'multi', NCells = NPoints; end
DateStr = date;

%Gegevens plotten ...
Hdl_Interface = figure('Name', 'structplot', 'NumberTitle', 'on');
Hdl_Ax = axes('Units', 'normalized', 'Position', [0.10 0.10 0.80 0.80], 'Box', 'on');

Hdl_Dots = min(line(X1, Y1, 'LineStyle', LineStyle1, 'Marker', Param.markers{1}, 'Color', Param.colors{1}, 'ButtonDownFcn', 'structplotOLD(''CALLBACK'')'));
Hdl_Dots = [ Hdl_Dots min(line(X2, Y2, 'LineStyle', LineStyle2, 'Marker', Param.markers{2}, 'Color', Param.colors{2}, 'ButtonDownFcn', 'structplotOLD(''CALLBACK'')'))];

Tmp = xlim(Hdl_Ax); [MinX, MaxX] = deal(Tmp(1), Tmp(2));
Tmp = ylim(Hdl_Ax); [MinY, MaxY] = deal(Tmp(1), Tmp(2));
if ~isinf(Param.xlim(1)), MinX = Param.xlim(1); end
if ~isinf(Param.xlim(2)), MaxX = Param.xlim(2); end
if ~isinf(Param.xlim(1)), MinY = Param.xlim(1); end
if ~isinf(Param.ylim(2)), MaxY = Param.ylim(2); end

axis([MinX, MaxX, MinY, MaxY]);
if strncmpi(Param.fit, 'l', 1),
    line([MinX, MaxX], polyval(Cfit1, [MinX, MaxX]), 'LineStyle', ':', 'Marker', 'none', 'Color', Param.colors{1});
    if ~isempty(X2) & ~isempty(Y2), line([MinX, MaxX], polyval(Cfit2, [MinX, MaxX]), 'LineStyle', ':', 'Marker', 'none', 'Color', Param.colors{2}); end      
elseif strncmpi(Param.fit, 'h', 1),
    Xv = linspace(MinX, MaxX);
    line(Xv, hypfunc(Cfit1, Xv), 'LineStyle', ':', 'Marker', 'none', 'Color', Param.colors{1});
    if ~isempty(X2) & ~isempty(Y2), line(Xv, hypfunc(Cfit2, Xv), 'LineStyle', ':', 'Marker', 'none', 'Color', Param.colors{2}); end      
end

%text(0, 0, {sprintf('Number of DataPoints: %d', NPoints); ...
%            sprintf('Number of Cells: %d', NCells); ...
%            sprintf('Date: %s', DateStr)}, ...
%    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'units', 'normalized');
title({sprintf('Number of DataPoints: %d', NPoints); sprintf('Number of Cells: %d', NCells); sprintf('Date: %s', DateStr)})

switch Mode
case 'single', 
    xlabel(sprintf('%s', XField)); ylabel(sprintf('%s', YField));
    if isempty(S1), [Hdl_Legend, Hdl_Obj] = legend(Hdl_Dots, {S2name});
    elseif isempty(S2), [Hdl_Legend, Hdl_Obj] = legend(Hdl_Dots, {S1name});
    else, [Hdl_Legend, Hdl_Obj] = legend(Hdl_Dots, {S1name, S2name}); end
    set(findobj(Hdl_Obj, 'Type', 'Text'), 'Interpreter', 'none');
case 'multi', 
    Hdl_XLb = xlabel(sprintf('%s (%s)', XField, S1name)); Hdl_YLb = ylabel(sprintf('%s (%s)', YField, S2name)); 
    set([Hdl_XLb, Hdl_YLb], 'Interpreter', 'none');
end

%In UserData van figuur handles en plot gegevens opslaan ...
UserData.FieldNames  = Param.totalidfields;
UserData.X           = [XData1; XData2];
UserData.Y           = [YData1; YData2];
UserData.CellList    = [CellList1; CellList2];
set(Hdl_Interface, 'UserData', UserData);

%Indien output argument opgegeven dan correlatie-coefficient berekenen ...
if nargout > 0,
    X = [XData1; XData2]; Y = [YData1; YData2];
    idx = find(~isnan(X) & ~isnan(Y));
    if ~isempty(idx),
        C = corrcoef(X(idx), Y(idx));
        C = C(1, 2);
    else C = NaN; end    
end    

%----------------------------------------------locale functies-------------------------------------------------
function D = getTcol(T, varargin)

idx = find(ismember(T.FName, varargin));
D = T.Data(:, idx);
if size(D, 2) == 1 & isa(D{1}, 'double'), D = cat(1, D{:}); end

function T = Tfilter(T, FilterFields, FilterValues)

if isempty(FilterFields), return; end

NFields = length(FilterFields);
[NRow, NCol] = size(T.Data);

idx = 1:NRow;
for n = 1:NFields,
    rowidx = find(strcmp(T.FName, FilterFields{n})); 
    
    switch class(FilterValues{n})
    case 'double',
        %Indien matrix van doubles opgegeven als waarde dan alle elementen weerhouden in de tabel die als waarde 
        %voor de overeenkomende kolomnaam een van de waarden hebben in de matrix ...
        D = cat(2, T.Data{:, rowidx});
        idx = intersect(idx, find(any(repmat(D, length(FilterValues{n}), 1) == repmat(FilterValues{n}', 1, NRow), 1)));
    case 'char', idx = intersect(idx, find(strcmp(T.Data(:, rowidx), FilterValues{n})));
    otherwise, error(sprintf('Filter for columns with value of type %s not implemented yet.', class(FilterValues{n}))); end    
end

T.Data = T.Data(idx, :);

function Param = checkparam(Param)

if ~iscellstr(Param.cellidfields), error('Invalid value for property cellidfields.'); end
if ~iscellstr(Param.totalidfields), error('Invalid value for property totalidfields.'); end

if ~ischar(Param.filterfields) & ~iscellstr(Param.filterfields), error('Invalid value for property filterfields.'); end
Param.filterfields = cellstr(Param.filterfields);
if ~iscell(Param.filtervalues), Param.filtervalues = {Param.filtervalues}; end

if ~isequal(length(Param.filterfields), length(Param.filtervalues)), error('Value for property filterfields and filtervalues should have same number of elements.'); end

if ~iscellstr(Param.colors) | length(Param.colors) ~= 2 | ~all(ismember(Param.colors, {'r', 'g', 'b', 'c', 'm', 'y', 'k'})), error('Wrong value for property colors.'); end
if ~iscellstr(Param.markers) | length(Param.markers) ~= 2 | ~all(ismember(Param.markers, {'.', 'o', 'x', '+', '-', '*', '^', 'v', '<', '>', 'p', 'h', 'd', 's'})), error('Wrong value for property markers.'); end
if ~isnumeric(Param.xlim) | ~isequal(sort(size(Param.xlim)), [1, 2]) | (Param.xlim(1) >= Param.xlim(2)), error('Wrong value for property xlim.'); end
if ~isnumeric(Param.ylim) | ~isequal(sort(size(Param.ylim)), [1, 2]) | (Param.ylim(1) >= Param.ylim(2)), error('Wrong value for property ylim.'); end

if ~ischar(Param.xexp), error('Wrong value for property xexp.'); end
if ~ischar(Param.yexp), error('Wrong value for property yexp.'); end

if ~ischar(Param.fit) & ~any(strncmpi(Param.fit, {'n', 'l', 'h'}, 1)), error('Wrong value for property fit.'); end

function [X, Y, XData, YData, sortidx] = getplotfields(T, XField, YField, Param)

XData = getTcol(T, XField); 
YData = getTcol(T, YField);

if all(ismember(Param.cellidfields, T.FName))
    List = upper(cv2str(getTcol(T, Param.cellidfields{:})));
    
    [List, sortidx] = sortrows(List); 
    [XData, YData] = deal(XData(sortidx), YData(sortidx));
    
    if isempty(List), [X, Y, XData, YData] = deal([]); return; end
    
    [dummy, idx] = unique(List, 'rows'); N = [idx(1); diff(idx)];
    [X, Y] = deal(repmat(NaN, max(N), length(idx)));
    for n = 1:length(idx),
        exidx = idx(n)-N(n)+1:idx(n);
        XVec = XData(exidx); YVec = YData(exidx);
        
        exidx = find(~isnan(XVec) & ~isnan(YVec));
        XVec = XVec(exidx); YVec = YVec(exidx);
        
        NElem = length(exidx);
        X(1:NElem, n) = XVec; Y(1:NElem, n) = YVec;
    end   
else, [X, Y] = deal(XData, YData); sortidx = 1:length(X); end

function CellList = getcelllist(sidx, T, IDFields)

idx = find(ismember(IDFields, T.FName));
CellList = getTcol(T, IDFields{idx});
CellList = CellList(sidx, :);

function C = conv2cellstr(C)

idx = find(cellfun('isclass', C, 'double'));
if ~isempty(idx),
    temp = cellstr(num2str(cat(1, C{idx})));
    [C{idx}] = deal(temp{:});
end

function V = evalexp(V, exp)

if isempty(exp) | isempty(V), return; end

idx = findstr(exp, '%'); if isempty(idx), return; end
exp(idx) = 'V';

eval(sprintf('V = %s;', exp));

function y = hypfunc(c, x)
%Hyperbolische functie ...

y = 1./(c(1).*x + c(2));

function callbackfunc

UserData = get(gcf, 'UserData');

if isempty(UserData.CellList), return; end
    
Position    = get(gca, 'CurrentPoint');
AspectRatio = get(gca, 'DataAspectRatio');
Xpos = Position(1,1);  Ypos = Position(1,2);
Xar  = AspectRatio(1); Yar  = AspectRatio(2);
    
%Dichtsbijzijnde dot vinden ...
[dst, rowidx] = min(((Xpos - UserData.X)/Xar).^2 + ((Ypos - UserData.Y)/Yar).^2);
if ndims(rowidx) ~= 2 | length(rowidx) ~= 1, return; end

colidx  = find(~cellfun('isempty', UserData.CellList(rowidx, :)));
Args = vectorzip(UserData.FieldNames(colidx), UserData.CellList(rowidx, colidx));
Text = [ sprintf('\\bf\\fontsize{9}Datapoint has following ID parameters :\\rm\n'), sprintf('\\it%s\\rm : %s\n', Args{:}) ];

Hdl = msgbox(Text, 'structplot', struct('WindowStyle', 'non-modal', 'Interpreter', 'tex'));