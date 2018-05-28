function GroupPlot(varargin)
%GROUPPLOT  make groupplot from structure-array.
%   GROUPPLOT(S, Xname, Yname) makes a groupplot for the supplied structure-array S.
%   For each row in the structure-array S the vector in the fieldname XName is plotted
%   versus the vector in the fieldname YName.
%
%   Optional properties and their values can be given as a comma-separated list.
%   To view a list of all possible properties and their default values, use 'factory'
%   as only input argument.

%B. Van de Sande 28-02-2005

%----------------------------default parameters-------------------------------
DefParam.colors         = {'b', 'g', 'r', 'c', 'm', 'y'};
DefParam.linestyles     = {'-'};
%Marker symbols can be extended with the postfix 'f' or 'u'. If no postfix is suplied
%then then the surface color is transparent, this corresponds with the postfix 'u'.
%Adding an 'f' to the symbol will set the surface color equal to the color of the edges.
DefParam.markers        = {'o', '^', 'v', '*', '+', 'x', '<', '>', 's', 'd', 'p', 'h'};
%Logical indexation of vectors with abcissa and ordinate values. This is done separatly
%for each plot ...
DefParam.indexexpr      = '';
%List of fields to display when clicking on a curve ...
DefParam.infofields     = {};
%MATLAB statement to execute when clicking on a curve. Fieldnames in these statements
%must be enclosed between dollar signs and for branched structures fieldnames can be
%given using the dot as a fieldname separator ...
DefParam.execevalfnc    = '';

%------------------------------main program-----------------------------------
%Checking input parameters
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'), %Display list of properties ...
    disp('List of factory defaults:');
    disp(DefParam);
    return;
elseif (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'callback'), %Invocation of callback funtion ...
    CallBackFunc; return;
end
if (nargin < 3), error('Wrong number of input arguments.'); end
[S, XName, YName] = deal(varargin{1:3});
if ~isstruct(S), error('First argument should be structure array.'); end
[C, FNames] = destruct(S);
if ~ischar(XName) | ~ismember(XName, FNames), error('Second argument should be valid fieldname for supplied structure-array.'); end
if ~ischar(YName) | ~ismember(YName, FNames), error('Third argument should be valid fieldname for supplied structure-array.'); end    
idx = find(ismember(FNames, {XName, YName}));
if ~all(cellfun('isclass', C(:, idx), 'double')) | any(cellfun('ndims', C(:, idx)) > 2) | ...
   ~all(all((cellfun('size', C(:, idx), 1) == 1) | (cellfun('size', C(:, idx), 2) == 1))),
   error('The supplied fieldnames do not contain numeric vectors.'); 
end
if ~all(cellfun('prodofsize', C(:, idx(1))) == cellfun('prodofsize', C(:, idx(2)))),
    error('Vector supplying abcissa values must have same length as vector supplying the ordinate values.'); 
end    
%Evaluate additional list of properties and their values ...
Param = CheckPropList(DefParam, varargin{4:end});
CheckParam(Param);
%The property markers is checked independently and parsed along the way ...
[Param.mrksymb, Param.mrksurf] = parsemrksymb(Param.markers);
%The property indexexpr is checked independently ...
if ~isempty(Param.indexexpr), Param.indexexpr = parseexpr(Param.indexexpr, FNames); end
%The property infofields and execevalfnc are checked independently ...
if ~isempty(Param.infofields) & ~isempty(Param.execevalfnc),
    error('One of the properties infofields or execevalfnc must have an empty value.');    
elseif isempty(Param.execevalfnc),
    if ~isempty(Param.infofields) & ~(iscellstr(Param.infofields) & all(ismember(Param.infofields, FNames))),
        error('Value of property infofields must be empty cell-array or cell-array of strings with valid fieldnames.');
    end
    N = length(Param.infofields); idx = zeros(1, N);
    for n = 1:N, idx(n) = find(ismember(FNames, Param.infofields{n})); end
    UD.Stat   = {};
    UD.FNames = FNames(idx);
    UD.Data   = C(:, idx);
else,
    try, ExecStat = ParseExpr(Param.execevalfnc, FNames);
    catch, error(sprintf('''%s'' is not a valid statement.', Param.execevalfnc)); end
    idx1 = find(cellfun('isclass', ExecStat, 'double'));
    idx2 = cat(1, ExecStat{idx1});
    UD.FNames = FNames(idx2);
    UD.Data   = C(:, idx2);
    N = length(idx1); ExecStat(idx1) = num2cell(1:N);
    UD.Stat   = ExecStat;
end

%Performing actual plotting ...
FigHdl = figure('Name', sprintf('%s', upper(mfilename)), ...
             'NumberTitle', 'on', ...
             'PaperType', 'A4', ...
             'PaperPositionMode', 'manual', ...
             'PaperUnits', 'normalized', ...
             'PaperPosition', [0.05 0.05 0.90 0.90], ...
             'PaperOrientation', 'landscape');
         
AxHdl  = axes('Units', 'normalized', ...
              'Position', [0.10 0.10 0.80 0.80], ...
              'Box', 'off', ...
              'TickDir', 'out', ...
              'FontSize', 8);

CallBackStr = sprintf('%s(''callback'');', mfilename);
NMrk = length(Param.markers); NCol = length(Param.colors); NLin = length(Param.linestyles);
MrkIdx = 0; ColIdx = 0; LinIdx = 0;
Xidx = find(ismember(FNames, XName)); Yidx = find(ismember(FNames, YName));
if ~isempty(Param.indexexpr), Fidx = find(cellfun('isclass', Param.indexexpr, 'double')); NF = length(Fidx); end
N = length(S);
for n = 1:N,
    Xval = C{n, Xidx}; Yval = C{n, Yidx};
    if ~isempty(Param.indexexpr),
        Expr = Param.indexexpr;
        for f = 1:NF, Expr{Fidx(f)} = sprintf('C{n, %d}', Expr{Fidx(f)}); end
        Value = eval(cat(2, Expr{:}));
        if (length(Value) ~= length(Xval)), error('Invalid indexation expression.'); 
        else, idx = find(Value); end
        [Xval, Yval] = deal(Xval(idx), Yval(idx));
    end
    
    MrkIdx = mod(MrkIdx, NMrk) + 1;
    ColIdx = mod(ColIdx, NCol) + 1;
    LinIdx = mod(LinIdx, NLin) + 1;
    if strcmpi(Param.mrksurf{MrkIdx}, 'u'), MrkFCol = 'none'; 
    else, MrkFCol = Param.colors{ColIdx}; end;
    LnHdl = line(Xval, Yval, ...
        'LineStyle', Param.linestyles{LinIdx}, ...
        'Marker', Param.mrksymb{MrkIdx}, ...
        'MarkerFaceColor', MrkFCol, ...
        'Color', Param.colors{ColIdx}, ...
        'ButtonDownFcn', CallBackStr, ...
        'UserData', n); %Plot number ...
end

%Attaching userdata to figure ...
set(FigHdl, 'UserData', UD);

%-----------------------------local functions---------------------------------
function Param = CheckParam(Param)

if ~iscellstr(Param.colors) | ~all(ismember(Param.colors, {'r', 'g', 'b', 'c', 'm', 'y', 'k'})), 
    error('Wrong value for property colors.'); 
end
if ~iscellstr(Param.linestyles) | ~all(ismember(Param.linestyles, {'-', '--', ':', '-.', 'none'})), 
    error('Wrong value for property linestyles.'); 
end

%-----------------------------------------------------------------------------
function CallBackFunc

PlotNr = get(gcbo, 'UserData');
UD = get(gcf, 'UserData');

if isempty(UD.Stat),
    Args = vectorzip(UD.FNames, UD.Data(PlotNr, :));
    %Converting numeric fieldnames to character strings ...
    Nidx = find(cellfun('isclass', Args, 'double'));
    for idx = Nidx(:)', Args{idx} = num2str(Args{idx}, '%.2f '); end
    Txt = [ sprintf('\\bf\\fontsize{9}Datapoint has following ID parameters :\\rm\n'), ...
            sprintf('\\it%s\\rm : %s\n', Args{:}) ];
    
    Hdl = msgbox(Txt, upper(mfilename), struct('WindowStyle', 'non-modal', 'Interpreter', 'tex'));
else, EvalExpr(UD.Stat, UD.Data(PlotNr, :)); end

%-----------------------------------------------------------------------------