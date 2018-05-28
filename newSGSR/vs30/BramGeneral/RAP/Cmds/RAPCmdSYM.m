function [RAPStat, LineNr, ErrTxt] = RAPCmdSYM(RAPStat, LineNr, DotToken, ObjToken, Symbol)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 12-05-2004

%-------------------------------------RAP Syntax------------------------------------
%   SYM DOT @@ @             Marker style for any of the following (*)
%         	                    TH   : Threshold curve
%                               SP   : Rate curve
%                               SC   : Correlograms
%                               VS   : Vector strength curves
%                               SCP  : Scatterplot
%                               ALL  : All of the above
%   SYM DOT @@ DEF		     Default marker style for any of the above (*)
%-----------------------------------------------------------------------------------

%------------------------------implementation details-------------------------------
%   Symbols have to be supplied between double quotes, otherwise the tokenizer 
%   will interpret some symbols as expressions.
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 3), ObjToken = 'disp';
elseif ~strcmpi(Symbol, 'def'),
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    [Symbol, ErrTxt] = GetRAPChar(RAPStat, Symbol); 
    if ~isempty(ErrTxt), return;
    elseif (length(Symbol) > 1) | ~ismember(Symbol, '.ox+*sdv^<>ph'), ErrTxt = 'Invalid symbol'; return; end
end

switch ObjToken
case 'disp',
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
        fprintf('Markers\n');
        fprintf('-------\n');
        fprintf('Thr. curve marker   : %s\n', RAPStat.PlotParam.Thr.Marker);
        fprintf('Rate curve marker   : %s\n', RAPStat.PlotParam.Rate.Marker);
        fprintf('Correlograms marker : %s\n', RAPStat.PlotParam.Corr.Marker);
        fprintf('VS curves marker    : %s\n', RAPStat.PlotParam.Vs.Marker);
        fprintf('Scatterplot marker  : %s\n', RAPStat.PlotParam.Scp.Marker);
    end
case 'th',
    if ischar(Symbol) & strcmp(Symbol, 'def'), RAPStat.PlotParam.Thr.Marker = ManageRAPStatus('PlotParam.Thr.Marker');
    else, RAPStat.PlotParam.Thr.Marker = Symbol; end
case 'sp',
    if ischar(Symbol) & strcmp(Symbol, 'def'), RAPStat.PlotParam.Rate.Marker = ManageRAPStatus('PlotParam.Rate.Marker');
    else, RAPStat.PlotParam.Rate.Marker = Symbol; end
case 'sc',
    if ischar(Symbol) & strcmp(Symbol, 'def'), RAPStat.PlotParam.Corr.Marker = ManageRAPStatus('PlotParam.Corr.Marker');
    else, RAPStat.PlotParam.Corr.Marker = Symbol; end
case 'vs',
    if ischar(Symbol) & strcmp(Symbol, 'def'), RAPStat.PlotParam.Vs.Marker = ManageRAPStatus('PlotParam.Vs.Marker');
    else, RAPStat.PlotParam.Vs.Marker = Symbol; end
case 'scp',
    if ischar(Symbol) & strcmp(Symbol, 'def'), RAPStat.PlotParam.Scp.Marker = ManageRAPStatus('PlotParam.Scp.Marker');
    else, RAPStat.PlotParam.Scp.Marker = Symbol; end
case 'all',
    if ischar(Symbol) & strcmp(Symbol, 'def'), 
        RAPStat.PlotParam.Thr.Marker    = ManageRAPStatus('PlotParam.Thr.Marker');
        RAPStat.PlotParam.Rate.Marker   = ManageRAPStatus('PlotParam.Rate.Marker');
        RAPStat.PlotParam.Corr.Marker   = ManageRAPStatus('PlotParam.Corr.Marker');
        RAPStat.PlotParam.Vs.Marker     = ManageRAPStatus('PlotParam.Vs.Marker');
        RAPStat.PlotParam.Scp.Marker    = ManageRAPStatus('PlotParam.Scp.Marker');
    else,
        [RAPStat.PlotParam.Thr.Marker, RAPStat.PlotParam.Rate.Marker, ...
                RAPStat.PlotParam.Corr.Marker, RAPStat.PlotParam.Vs.Marker, ...
                RAPStat.PlotParam.Scp.Marker] = deal(Symbol); 
    end
end

LineNr = LineNr + 1;