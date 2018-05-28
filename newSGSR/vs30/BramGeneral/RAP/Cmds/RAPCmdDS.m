function [RAPStat, LineNr, ErrTxt] = RAPCmdDS(RAPStat, LineNr, SeqNr)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 13-08-2004

%-------------------------------------RAP Syntax------------------------------------
%   DS #                      Specify data set number
%-----------------------------------------------------------------------------------

ErrTxt = '';

if nargin == 2,
    if ~isRAPStatDef(RAPStat, 'GenParam.SeqNr') 
        if isRAPStatDef(RAPStat, 'ComLineParam.Verbose')
            fprintf('Current dataset sequence number is %d.\n', ...
                RAPStat.GenParam.SeqNr); 
        end
    else
        ErrTxt = 'No dataset specified'; 
        return; 
    end
else
    if isRAPStatDef(RAPStat, 'GenParam.DataFile')
        ErrTxt = 'Datafile not yet specified'; 
        return; 
    end
    
    [SeqNr, ErrTxt] = GetRAPInt(RAPStat, SeqNr); 
    if ~isempty(ErrTxt)
        return; 
    end
    
    SeqNrs = [RAPStat.GenParam.LUT.iSeq];
    if ~ismember(SeqNr, SeqNrs)
        ErrTxt = 'Dataset sequence number doesn''t exist'; 
        return; 
    end
    
    RAPStat.GenParam.SeqNr = SeqNr;
    [RAPStat.GenParam.DS, ErrTxt] = LoadRAPDataset(RAPStat);
    if ~isempty(ErrTxt)
        return; 
    end
    
    %Reset plot and calculation parameters ...
    RAPStat.CalcParam = ManageRAPStatus('CalcParam');
    RAPStat.PlotParam = ManageRAPStatus('PlotParam');
    
    %Load independent values to CalcData
    DS = RAPStat.GenParam.DS;
    if any(strcmpi(DS.stimtype , {'thr', 'th'}))               % THR Curve: XData = freqs
        if strcmpi(DS.fileformat, 'sgsr')
            Nsub = DS.nsub-1;
        else
            Nsub = DS.nsub; 
        end
        
        RAPStat.CalcData.XData = DS.OtherData.thrCurve.freq(1:Nsub);
    else                                                       % Not THR: XData = IndepVal
        Nsub = DS.NRec;
        
        IndepVal = ExtractIndepVal(DS, 1:Nsub);
        [IndepVal, idx] = sort(IndepVal); %#ok
        RAPStat.CalcData.XData = IndepVal;
    end
    
    %Start a new figure ...
    RAPStat = NewRAPFigure(RAPStat);
    
    %Synchronize calculation parameters with UDI if requested ...
    if strcmpi(RAPStat.GenParam.SyncUDI, 'auto')
        [RAPStat, ErrTxt] = SyncRAPDataset(RAPStat); 
        if ~isempty(ErrTxt)
            ErrTxt = [ErrTxt, '. Use SYNC MAN to avoid automatic synchronization']; 
            return; 
        end
    end
end

LineNr = LineNr + 1;