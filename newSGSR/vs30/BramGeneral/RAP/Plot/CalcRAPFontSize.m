function FScm = CalcRAPFontSize(RAPStat, AxHdl, FSpc)
%CalcRAPFontSize   converts fontsize from percent to centimeters
%   FScm = CalcRAPFontSize(RAPStat, AxHdl, FSpc) 
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 17-03-2004

MaxFS = RAPStat.PlotParam.Axis.MaxFontSize; %In centimeters ...
MinFS = RAPStat.PlotParam.Axis.MinFontSize; %In cemtimeters ...

OldUnits = get(AxHdl, 'Units');
set(AxHdl, 'Units', 'centimeters');
Pos = get(AxHdl, 'Position');
set(AxHdl, 'Units', OldUnits);
Height = Pos(4); %In centimetres ...

FScm = Height * FSpc;
FScm = min([MaxFS, FScm]);
FScm = max([MinFS, FScm]);