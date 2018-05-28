function [RAPStat, AxHdl] = CreateRAPAxis(RAPStat, LayType)
%CreateRAPAxis  creates axis object on current figure
%   [RAPStat, AxHdl] = CreateRAPAxis(RAPStat, LayoutType)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 10-03-2004

FigHdl = RAPStat.PlotParam.Figure.Hdl;
Page   = RAPStat.PlotParam.Figure;
Header = RAPStat.PlotParam.Header;
Layout = GetRAPLayout(RAPStat, LayType);

[NX, NY] = deal(Layout(1), Layout(2));
[nX, nY] = deal(Page.CurAx(1), NY-Page.CurAx(2)+1);

Width    = (1 - Page.LeftMargin - Page.RightMargin - Page.HorAxSpacing*(NX-1))/NX;
Height   = (1 - Header.Height - Header.VerMargin*2 - Page.UpperMargin - ...
            Page.LowerMargin - Page.VerAxSpacing*(NY-1))/NY;

X        = Page.LeftMargin + (Page.HorAxSpacing + Width)*(nX-1);
Y        = Page.LowerMargin + (Page.VerAxSpacing + Height)*(nY-1); 

AxHdl   = axes('Parent', FigHdl, 'Position', [X, Y, Width, Height], 'Visible', 'on');
RAPStat = SetRAPLayout(RAPStat, Layout);