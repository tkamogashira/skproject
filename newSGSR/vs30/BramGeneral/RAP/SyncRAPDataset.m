function [RAPStat, ErrTxt] = SyncRAPDataset(RAPStat)
%SyncRAPDataset Synchronize calculation parameters of current dataset with UDI
%   [RAPStat, ErrTxt] = SyncRAPDataset(RAPStat)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 13-08-2004

%% ---------------- CHANGELOG -----------------------
%  Tue Apr 19 2011  Abel   
%   - addapted to new getuserdata which does not return an empty UD by
%   default

ErrTxt = '';

if isRAPStatDef(RAPStat, 'GenParam.DS')
    ErrTxt = 'No dataset specified'; 
    return;
else
    ds = RAPStat.GenParam.DS; 
end

%Get userdata concerning the currently loaded foreground dataset ...
try
    UD = getuserdata(ds); 
	%by Abel: return to catch if DSInfo struct is empty (i.e. no additional info for DS) 
    if isempty(UD) || size(UD.DSInfo, 2) == 0
        error('To catch block ...'); 
    end
catch 
    ErrTxt = 'Cannot extract userdata information for current dataset'; 
    return; 
end

%Setting the calculation parameters ...
if strcmpi(RAPStat.ComLineParam.Verbose, 'yes')
    fprintf('Synchronizing calculation parameters for current foreground dataset.\n');
end

%UD.DSInfo.Ignore ...
if UD.DSInfo.Ignore
    %Reset general parameters ...
    RAPStat.GenParam.DS    = [];
    RAPStat.GenParam.SeqNr = [];
    %Reset plot and calculation parameters ...
    RAPStat.CalcParam = ManageRAPStatus('CalcParam');
    RAPStat.PlotParam = ManageRAPStatus('PlotParam');
    %Start a new figure ...
    RAPStat = NewRAPFigure(RAPStat);
    
    if ~isempty(UD.DSInfo.Eval)
        ErrTxt = sprintf('Dataset is ignored because ''%s''', UD.DSInfo.Eval);
    else
        ErrTxt = 'Dataset is ignored';
    end
    return;
end

%UD.DSInfo.BadSubSeq ...
if ~all(ismember(UD.DSInfo.BadSubSeq, 1:ds.nrec))
    ErrTxt = 'Some of the subsequences to be excluded for this dataset don''t exist or weren''t recorded'; 
    return;
elseif isTHRdata(ds)
    RAPStat.CalcParam.SubSeqs = setdiff(1:length(ds.xval), UD.DSInfo.BadSubSeq);
else
    RAPStat.CalcParam.SubSeqs = setdiff(1:ds.nrec, UD.DSInfo.BadSubSeq); 
end

%Printing evaluation of dataset ...
if strcmpi(RAPStat.ComLineParam.Verbose, 'yes') && ~isempty(UD.DSInfo.Eval), 
    fprintf('Evaluation of current dataset : ''%s''.\n', UD.DSInfo.Eval); 
end