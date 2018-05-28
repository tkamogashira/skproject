function RAPStat = NewRAPFigure(RAPStat)
%NewRAPFigure    starts a new RAP figure
%   RAPStat = NewRAPFigure(RAPStat)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 20-02-2004

%Start new figure ...
RAPStat.PlotParam.Figure.Hdl = ManageRAPStatus('PlotParam.Figure.Hdl');
%Reset current layout ...
RAPStat.PlotParam.Figure.Layout.Current = ManageRAPStatus('PlotParam.Figure.Layout.Current');
RAPStat.PlotParam.Figure.CurAx = ManageRAPStatus('PlotParam.Figure.CurAx');