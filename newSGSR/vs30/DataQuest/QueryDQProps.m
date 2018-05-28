function ArgOut = QueryDQProps(varargin)
%QUERYDQPROPS   acquire DATAQUEST properties by use of a GUI
%   Props = QUERYDQPROPS(DefProps) creates a graphical user interface for
%   the acquisition of the properties of DATAQUEST.
%   Attention! Only those properties of DATAQUEST that are relevant when
%   searching the database can be changed by this GUI.

%B. Van de Sande 23-07-2004

persistent PS DefProps Props;

%Checking input arguments ...
if (nargin < 1), error('Wrong number of input arguments.'); end
if (nargin == 1) & isstruct(varargin{1}),
    DefProps = varargin{1}; Action = 'init';
elseif any(nargin == [1, 2]) & ischar(varargin{1}),
    Action = varargin{1};
    if (nargin == 2), ExArgIn = varargin{2}; else ExArgIn = ''; end
else, error('Wrong input arguments.'); end

%Perform requested action ...
switch Action
case 'init',
    %Create GUI ...
    PS = CreateOUI(DefProps);
    paramOUI(PS); FigHdl = OUIhandle; 
    set(FigHdl, 'closerequestfcn', sprintf('%s abort;', mfilename));
    movegui(FigHdl, 'center'); 
    
    %Wait until figure is destroyed ...
    waitfor(FigHdl);
    
    %Return output arguments ...
    ArgOut = Props;
case 'browse',
    [PStmp, ErrMsg] = readOUI; if isempty(ErrMsg), PS = PStmp; end
    %Disable the GUI controls just to be sure ...
    UIHdls = findobj(OUIhandle, 'type', 'uicontrol'); set(UIHdls, 'enable', 'off');
    switch ExArgIn
    case 'datadir',    
        %Attention! Using the third-party routine UIGETFOLDER.M distributed
        %with SGSR ...
        DefDirName = getValue(PS.datadir);
        if exist(DefDirName, 'dir'), DirName = uigetfolder('Select the directory where the datafiles are located:', DefDirName);
        else, DirName = uigetfolder('Select data directory'); end   
        if ~isempty(DirName), PS.datadir = setValue(PS.datadir, DirName); OUIfill(PS); end    
    case 'initdir',
        %Attention! Using the third-party routine UIGETFOLDER.M distributed
        %with SGSR ...
        DefDirName = getValue(PS.initdir);
        if exist(DefDirName, 'dir'), DirName = uigetfolder('Select the directory where the initialisation files are located:', DefDirName);
        else, DirName = uigetfolder('Select initialisation directory'); end   
        if ~isempty(DirName), PS.initdir = setValue(PS.initdir, DirName); OUIfill(PS); end    
    case 'fields',
        FNames = CommonParam(CommonParam); FNames(find(cellfun('isempty', FNames))) = [];
        idx = find(ismember(lower(FNames), lower(getValue(PS.outfields))));
        [idx, Ok] = listdlg('ListString', FNames, 'PromptString', 'Common stimulus parameters:', ...
            'Name', 'DataQuest', 'InitialValue', idx, 'ListSize', [180, 300]);
        if Ok, PS.outfields = setValue(PS.outfields, FNames(idx)); OUIfill(PS); end
    otherwise, error(sprintf('Cannot browse ''%s''.', ExArgIn)); end
    set(UIHdls, 'enable', 'on');
case 'accept',
    [PS, ErrMsg] = readOUI;
    if isempty(ErrMsg), 
        try, Props = CheckPropList(DefProps, GetProps(PS)); [Props, ErrMsg] = CheckProps(Props); 
        catch, ErrMsg = lasterr; end
    end
    delete(OUIhandle);
    if ~isempty(ErrMsg), waitfor(errordlg(ErrMsg, 'DATAQUEST')); Props = DefProps; end    
case 'abort',  Props = DefProps; delete(OUIhandle);
otherwise, error(sprintf('Unknown action ''%s''.', Action)); end
    
%-----------------------------------local functions-----------------------------------
function PS = CreateOUI(DefProps)

PS = ParamSet('Props', 'DataQuest', 'Search properties', 1, [270, 170], mfilename);
PS = AddParam(PS, 'datadir',    DefProps.datadir,    '',     'char',    Inf, 'none');
PS = AddParam(PS, 'initdir',    DefProps.initdir,    '',     'char',    Inf, 'none');
PS = InitOUIGroup(PS, 'directories', [10 10 270 50], 'Directories');
PS = DefineQuery(PS, 'datadir',  0, 'edit', 'DataDir', 'C:\SGSR\vs30\BramGeneral\DataQuest\',      'Directory where datafiles and associated database can be found.');
PS = AddActionButton(PS, 'PB_DataDir_Browse', 'Browse ...', [210,  0, 50, 15], sprintf('%s browse datadir;', mfilename), '');
PS = DefineQuery(PS, 'initdir', 20, 'edit', 'InitDir   ', 'C:\SGSR\vs30\BramGeneral\DataQuest\', 'Directory with initialization files.');
PS = AddActionButton(PS, 'PB_InitDir_Browse', 'Browse ...', [210, 20, 50, 15], sprintf('%s browse initdir;', mfilename), '');

PS = AddParam(PS, 'outfields',  DefProps.outfields,  '',     'char',    Inf, 'DQParamInterpreter');
PS = AddParam(PS, 'outmode',    DefProps.outmode,    '',     'char',    Inf, 'none');
PS = InitOUIGroup(PS, 'output', [10 70 270 50], 'Output');
PS = DefineQuery(PS, 'outfields',   0, 'edit',     'Fields',   'ID.FileName ID.iSeq ID.SeqID Common.SPL',  'Names of fields to return.');
PS = AddActionButton(PS, 'PB_Select', 'Select ...', [210, 0, 50, 15], sprintf('%s browse fields;', mfilename), '');
PS = DefineQuery(PS, 'outmode',    20, 'toggle',   'Output',   {'cli', 'table'},       'Type of output: command line interface(CLI) or spreadsheet(TABLE).');
PS = SeeSaw(PS, 'outmode', 'cli', 'table');

PS = AddParam(PS, 'srchalgortm',  DefProps.srchalgortm, '',     'char',    Inf, 'none');
PS = InitOUIGroup(PS, 'miscellaneous', [10 130 270 30], 'Miscellaneous');
PS = DefineQuery(PS, 'srchalgortm',  0, 'toggle',   'Algorithm',   {'fast', 'caching'},     'Algorithm used for searching the database.');
PS = SeeSaw(PS, 'srchalgortm', 'fast', 'caching');
PS = AddActionButton(PS, 'PB_Cancel', 'Cancel', [150,  0, 50, 15], sprintf('%s abort;', mfilename), '');
PS = AddActionButton(PS, 'PB_OK',     'OK',     [210,  0, 50, 15], sprintf('%s accept;', mfilename), '');

%-------------------------------------------------------------------------------------
function Props = GetProps(PS)

PList = paramlist(PS); N = length(PList); Props = [];
for n = 1:N, Props = setfield(Props, PList{n}, getValue(eval(sprintf('PS.%s', PList{n})))); end

%-------------------------------------------------------------------------------------
function [Props, ErrMsg] = CheckProps(Props)

ErrMsg = '';

if ~exist(Props.datadir, 'dir'), ErrMsg = 'Data directory should be an existing directory.'; end
if ~exist(Props.initdir, 'dir'), ErrMsg = 'Initialisation directory should be an existing directory.'; end
Props.outfields = cellstr(Props.outfields);

%-------------------------------------------------------------------------------------