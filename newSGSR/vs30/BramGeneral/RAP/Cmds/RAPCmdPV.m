function [RAPStat, LineNr, ErrTxt] = RAPCmdPV(RAPStat, LineNr, DSToken, ErrToken)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 13-08-2004

%-------------------------------------RAP Syntax------------------------------------
%   PV DS [ERR=#]             Previous dataset (~)
%-----------------------------------------------------------------------------------

ErrTxt = '';

if nargin == 4, ErrLine = ExtractRAPErrLineNr(ErrToken);
else, ErrLine = []; end

if isRAPStatDef(RAPStat, 'GenParam.DataFile') & isempty(ErrLine), 
    ErrTxt = 'Datafile not yet specified'; return;
elseif isRAPStatDef(RAPStat, 'GenParam.DataFile'), LineNr = ErrLine; return; end

SeqNrs   = [RAPStat.GenParam.LUT.iSeq]; NSeqs = length(SeqNrs);
CurSeqNr = RAPStat.GenParam.SeqNr;
if isempty(CurSeqNr), idx = NSeqs; %No dataset specified ...
else, idx = find(ismember(SeqNrs, CurSeqNr)) - 1; end
if (idx <= 0) & isempty(ErrLine), ErrTxt = 'No more datasets in datafile'; return;
elseif (idx <= 0), LineNr = ErrLine; return; end

RAPStat.GenParam.SeqNr = SeqNrs(idx);
[RAPStat.GenParam.DS, ErrTxt] = LoadRAPDataset(RAPStat);
if ~isempty(ErrTxt) & isempty(ErrLine), return; 
elseif ~isempty(ErrTxt), ErrTxt = ''; LineNr = ErrLine; return; end

if strcmpi(RAPStat.ComLineParam.Verbose, 'yes'), 
    fprintf('Current dataset number is %d (%s).\n', RAPStat.GenParam.SeqNr, RAPStat.GenParam.LUT(idx).IDstr);
end

%Reset plot and calculation parameters ...
RAPStat.CalcParam = ManageRAPStatus('CalcParam');
RAPStat.PlotParam = ManageRAPStatus('PlotParam');
%Start a new figure ...
RAPStat = NewRAPFigure(RAPStat);

%Synchronize calculation parameters with UDI if requested ...
if strcmpi(RAPStat.GenParam.SyncUDI, 'auto'), 
    [RAPStat, ErrTxt] = SyncRAPDataset(RAPStat); 
    if ~isempty(ErrTxt) & isempty(ErrLine), ErrTxt = [ErrTxt, '. Use SYNC MAN to avoid automatic synchronization']; return; 
    elseif ~isempty(ErrTxt), ErrTxt = ''; LineNr = ErrLine; return; end
end

LineNr = LineNr + 1;