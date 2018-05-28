function [RAPStat, LineNr, ErrTxt] = RAPCmdID(RAPStat, LineNr, varargin)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 13-08-2004

%-------------------------------------RAP Syntax------------------------------------
%   ID [ERR=#]                Display data set ID
%   ID @@@...@@@ [ERR=#]      Specify data set ID. Optionally branch to specified 
%                             record in macro on error
%-----------------------------------------------------------------------------------

ErrTxt = '';

%Checking input parameters ...
if (nargin == 2),
    dsID    = '';
    ErrLine = [];
elseif (nargin == 3) & isRAPErr(varargin{1}),
    dsID    = '';
    ErrLine = ExtractRAPErrLineNr(varargin{1});
elseif (nargin == 3),
    dsID = varargin{1};
    ErrLine = [];
elseif (nargin == 4), 
    dsID = varargin{1};
    ErrLine = ExtractRAPErrLineNr(varargin{2});
end   

if isempty(dsID),
    if ~isRAPStatDef(RAPStat, 'GenParam.SeqNr'),
        if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
            SeqNrs = cat(2, RAPStat.GenParam.LUT.iSeq);
            idx = find(SeqNrs == RAPStat.GenParam.SeqNr);
            fprintf('Current dataset identifier is %s.\n', RAPStat.GenParam.LUT(idx).IDstr); 
        end
    elseif isempty(ErrLine), ErrTxt = 'No dataset specified'; return; 
    else, LineNr = ErrLine; return; end
elseif ~isempty(dsID),
    if isRAPStatDef(RAPStat, 'GenParam.DataFile') & isempty(ErrLine), 
        ErrTxt = 'Datafile not yet specified'; return;
    elseif isRAPStatDef(RAPStat, 'GenParam.DataFile'), LineNr = ErrLine; return; end
    
    [dsID, ErrTxt] = GetRAPChar(RAPStat, dsID);
    if ~isempty(ErrTxt) & ~isempty(ErrLine), ErrTxt = ''; LineNr = ErrLine; return;
    elseif ~isempty(ErrTxt), return; end
    
    dsIDs = lower({ RAPStat.GenParam.LUT.IDstr });
    idx   = find(ismember(dsIDs, dsID));
    if isempty(idx) & isempty(ErrLine), ErrTxt = 'Dataset identifier doesn''t exist'; return;
    elseif isempty(idx), LineNr = ErrLine; return; end
    
    RAPStat.GenParam.SeqNr = RAPStat.GenParam.LUT(idx).iSeq;
    [RAPStat.GenParam.DS, ErrTxt] = LoadRAPDataset(RAPStat);
    if ~isempty(ErrTxt) & isempty(ErrLine), return; 
    elseif ~isempty(ErrTxt), ErrTxt = ''; LineNr = ErrLine; return; end
    
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
end

LineNr = LineNr + 1;