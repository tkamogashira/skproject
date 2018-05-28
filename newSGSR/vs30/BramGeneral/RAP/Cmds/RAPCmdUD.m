function [RAPStat, LineNr, ErrTxt] = RAPCmdUD(RAPStat, LineNr)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 08-12-2004

%-------------------------------------RAP Syntax------------------------------------
%   UD                        Update current data file
%-----------------------------------------------------------------------------------

ErrTxt = '';

%Get current datafile ...
FileName = RAPStat.GenParam.DataFile;
if strcmpi(FileName, ManageRAPStatus('GenParam.DataFile')),
    ErrTxt = 'Currently no datafile loaded'; return
end    

%Data directory may have been changed ...
[FullFileName, FileName, ErrTxt] = ParseDataFileName(FileName);
if ~isempty(ErrTxt), return; end
    
try LUT = log2lut(FileName); 
catch, ErrTxt = sprintf('%s is not a valid datafile name', FileName); return; end
    
%Set general parameters ...
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