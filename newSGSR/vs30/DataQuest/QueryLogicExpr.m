function [Expr, Props] = QueryLogicExpr(varargin)
%QUERYLOGICEXPR   acquire logical expression by use of a GUI
%   Expr = QUERYTLOGICEXPR creates a graphical user interface for the
%   acquisition of a logical expression which can be used in DATAQUEST.
%   If the user closed the window then 0 is returned, else the expression
%   is returned as a character string.
%   [Expr, Props] = QUERYTLOGICEXPR(Props) adds additional elements to
%   the GUI which allows the user to change the properties of DATAQUEST
%   that are relevant when searching the database.

%B. Van de Sande 23-07-2004

persistent PS CurExpr CurProps;

%Checking input arguments ...
if ~any(nargin == [0, 1]), error('Wrong number of input arguments.'); end
if (nargin == 0), Action = 'main'; CurProps = struct([]);
elseif (nargin == 1) & isstruct(varargin{1}), Action = 'main'; CurProps = varargin{1};
else, Action = lower(varargin{1}); end

%Perform requested action ...
switch Action
case 'main',
    CurExpr = 0; %Setting the return argument as if the user cancelled the operation ...
    %Get paramset object with associated GUI ...
    PS = CommonParam;
    %Extend the paramset object with the logical expression itself and create
    %GUI controls associated with it ...
    PS = ExtendParamSet(PS, ~isempty(CurProps));
    %Create the actual GUI in the center of the screen and extract the figure
    %handle ...
    paramOUI(PS); FigHdl = OUIhandle;
    set(FigHdl, 'closerequestfcn', sprintf('%s abort;', mfilename));
    movegui(FigHdl, 'center');
    %Make prompt of SchName query oblique ...
    set(OUIhandle('SchName.prompt'), 'fontangle', 'oblique');
    
    %Wait until figure is destroyed ...
    waitfor(FigHdl);
    
    %Return the logical expression and the properties if necessary ...
    Expr = CurExpr;
    if isempty(CurProps) & (nargout > 1), error('Wrong number of output arguments.');
    elseif (nargout > 1), Props = CurProps; end
case 'props', 
    %When setting up the GUI for changing the search properties the user cannot use
    %the GUI for the acquisition of a logical expression ...
    FigHdl = OUIhandle;
    UIHdls = [findobj(OUIhandle, 'type', 'uicontrol'); findobj(OUIhandle, 'type', 'uimenu')];

    set(FigHdl, 'closerequestfcn', ''); set(UIHdls, 'enable', 'off');
    CurProps = QueryDQProps(CurProps);
    set(FigHdl, 'closerequestfcn', sprintf('%s abort;', mfilename)); set(UIHdls, 'enable', 'on');
case 'acquire',
    [PSupdate, ErrMsg] = readOUI;
    if ~isempty(ErrMsg), OUIerror(ErrMsg); return; else, OUIreport('---'); PS = PSupdate; end
    
    List = paramlist(PS);
    %Parameters SchName and Time are processed first ...
    SchemaIDExpr = sprintf(Char2Pattern(getValue(PS.SchName)), GetFieldName(PS.SchName));
    TimeExpr     = sprintf(Time2Pattern(getValue(PS.Time), getValue(PS.relTime)), GetFieldName(PS.Time));
    %Followed by all other parameters ...
    idx = find(ismember(List, {'LogicExpr', 'SchName', 'Time', 'relTime'})); List(idx) = [];
    N = length(List); Expr = cell(1, N);
    for n = 1:N,
        P = eval(sprintf('PS.%s', List{n})); Val = getValue(P);
        switch class(Val),
        case 'double', Expr{n} = sprintf(Num2Pattern(Val), GetFieldName(P));
        case 'cell',   Expr{n} = sprintf(Char2Pattern(Val), GetFieldName(P));
        case 'struct', 
            Pattern = Interval2Pattern(Val); N = length(findstr(Pattern, '%s'));
            FName = repmat({GetFieldName(P)}, 1, N);
            Expr{n} = sprintf(Pattern, FName{:}); 
        end
    end
    %Create the logical expression and update the GUI ...
    Expr = [{SchemaIDExpr}, {TimeExpr}, Expr]; Expr(find(cellfun('isempty', Expr))) = [];
    if ~isempty(Expr),
        N = length(Expr); Expr = vectorzip(Expr, repmat({'&'}, 1, N)); Expr(end) = [];
        Expr = cat(2, Expr{:});
    else, Expr = ''; end
    
    PS.LogicExpr = setValue(PS.LogicExpr, Expr);
    ErrMsg = OUIfill(PS); OUIerror(ErrMsg);
case 'finish', [dummy, CurExpr] = OUIhandle('LogicExpr'); delete(OUIhandle);
case 'abort', delete(OUIhandle);
otherwise, error(sprintf('''%s'' is not a valid callback action.', Action)); end

%-------------------------------locals---------------------------------
function PS = ExtendParamSet(PS, addMenu)

%Add parameter for the logical expression (the default interpreter is used) ...
%Attention! Because of an unknown reason a value of type char cannot have an empty
%default value. This causes the logical expression the be by default ' ' 
%instead of the empty string ...
PS = AddParam(PS, 'LogicExpr',    ' ',    '',     'char',    Inf, 'none');
    
%Control buttons and editable text box for the logical expression ...
PS = InitOUIGroup(PS, 'LogicExpr', [10 360 360 30], '');
PS = AddActionButton(PS, 'PB_Acquire', 'Acquire', [10, 0, 50, 20], sprintf('%s acquire;', mfilename), 'Acquire logical expression.');
PS = DefineQuery(PS, 'LogicExpr', [70, 0], 'edit', '', repmat(' ', 1, 90), 'Logical expression');
PS = AddActionButton(PS, 'PB_Evaluate', 'Evaluate', [300, 0, 50, 20], sprintf('%s finish;', mfilename), 'Evaluate logical expression.');

%Standard message board ...
PS = InitOUIGroup(PS, 'Message', [50 310 280 40], 'Messages');
PS = DefineReporter(PS, 'stdmess', [40, 10], repmat(' ', 2, 90), '');

%Create menu bar for changing search properties if necessary ...
if addMenu, PS = AddMenu(PS, 'Props', 'Change properties ...', sprintf('%s props;', mfilename)); end

%----------------------------------------------------------------------
function FName = GetFieldName(P)

[FName, ErrMsg] = CommonParam(P); error(ErrMsg);
FName = ['$', FName, '$'];

%----------------------------------------------------------------------
function Pattern = Time2Pattern(Time, RelOp) 

if strcmpi(RelOp{1}, 'after'), RelOp = '>'; else, RelOp = '<'; end

if isempty(Time), Pattern = '';
else, Pattern = sprintf('(%%s%sdatenum(''%s''))', RelOp, Time); end

%----------------------------------------------------------------------
function Pattern = Num2Pattern(Val)

if isnan(Val), Pattern = '';
elseif (length(Val) > 1), Pattern = sprintf('ismember(%%s,%s)', mat2str(Val));
else, Pattern = sprintf('(%%s==%.16g)', Val); end

%----------------------------------------------------------------------
function Pattern = Char2Pattern(Val)

N = length(Val);

%Case-insensitive string compare ...
if (N == 0), Pattern = '';
elseif (N == 1), Pattern = sprintf('strcmpi(%%s,''%s'')', Val{1});
else, Pattern = sprintf('ismember(lower(%%s),lower({%s}))', cellstr2str(Val, ',', '''', '''')); end

%----------------------------------------------------------------------
function Pattern = Interval2Pattern(Interval)

if isempty(Interval), Pattern = '';
elseif (diff(Interval.rng) == 0), Pattern = sprintf('(%%s == %.16g)', Interval.rng(1));
elseif any(isinf(Interval.rng)),
    idx = find(~isinf(Interval.rng)); 
    Val = Interval.rng(idx); Border = Interval.border;
    if (idx == 1),
        if (Border{1} == '['), RelOp = '>='; else, RelOp = '>'; end
    else,
        if (Border{2} == ']'), RelOp = '<='; else, RelOp = '<'; end
    end            
    Pattern = sprintf('(%%s%s%.16g)', RelOp, Val);
else,
    [Rng, Border] = deal(Interval.rng, Interval.border);
    switch Border{1}, 
    case ']', RelOp{1} = '>';
    case '[', RelOp{1} = '>='; end
    switch Border{2}, 
    case ']', RelOp{2} = '<=';
    case '[', RelOp{2} = '<'; end
    Pattern = sprintf('(%%s%s%.16g)&(%%s%s%.16g)', RelOp{1}, Rng(1), RelOp{2}, Rng(2));
end

%----------------------------------------------------------------------