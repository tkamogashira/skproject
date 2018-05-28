function [RAPStat, LineNr, ErrTxt] = RAPCmdDF(RAPStat, LineNr, FileName)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 11-05-2004

%-------------------------------------RAP Syntax------------------------------------
%   DF @@@...@@@              Specify data file name
%-----------------------------------------------------------------------------------

%----------------------------Implementation details---------------------------------
% Because datafile and its LUT aren't saved separatly for foreground and background
% datasets, the background dataset has to be resetted when changing datafile ...
%-----------------------------------------------------------------------------------

ErrTxt = '';

if nargin == 2, 
    if ~isRAPStatDef(RAPStat, 'GenParam.DataFile')
        if isRAPStatDef(RAPStat, 'ComLineParam.Verbose')
            fprintf('Current data file is %s.\n', RAPStat.GenParam.DataFile); 
        end
    else
        ErrTxt = 'No datafile specified'; 
        return; 
    end
else
    [FullFileName, FileName, ErrTxt] = ParseDataFileName(FileName);
    if ~isempty(ErrTxt)
        return; 
    end
    
    try 
        LUT = log2lut(FileName); 
    catch
        ErrTxt = sprintf('%s is not a valid datafile name', FileName); 
        return; 
    end
    
    %Set general parameters ...
    RAPStat.GenParam.DataFile     = FileName;
    RAPStat.GenParam.FullFileName = FullFileName;
    RAPStat.GenParam.LUT          = LUT;
    RAPStat.GenParam.SeqNr        = ManageRAPStatus('GenParam.SeqNr');
    RAPStat.GenParam.DS           = ManageRAPStatus('GenParam.DS');
    RAPStat.GenParam.DS2          = ManageRAPStatus('GenParam.DS2');
    RAPStat.GenParam.SeqNr2       = ManageRAPStatus('GenParam.SeqNr2');
    
    %Reset plot and calculation parameters ...
    RAPStat.CalcParam  = ManageRAPStatus('CalcParam');
    RAPStat.CalcParam2 = ManageRAPStatus('CalcParam2');
    RAPStat.PlotParam  = ManageRAPStatus('PlotParam');
    %Start a new figure ...
    RAPStat = NewRAPFigure(RAPStat);
    
    LineNr = LineNr + 1;
end