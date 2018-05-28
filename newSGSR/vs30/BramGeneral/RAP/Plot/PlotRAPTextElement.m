function TxtHdl = PlotRAPTextElement(RAPStat, AxHdl, Txt)
%PlotRAPTextElement    plot text in a corner of an RAP plot
%   TxtHdl = PlotRAPTextElement(RAPStat, Txt)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 19-03-2004

switch lower(Txt.Location)
case 'ul', %Upper Left corner ...
    XLoc     = 0;     YLoc     = 1;
    VerAlign = 'top'; HorAlign = 'left';
case 'll', %Lower Left corner ...
    XLoc     = 0;        YLoc     = 0;
    VerAlign = 'bottom'; HorAlign = 'left';
case 'ur', %Upper Right corner ...
    XLoc     = 1;     YLoc     = 1;
    VerAlign = 'top'; HorAlign = 'right';
case 'lr', %Lower Right corner ...
    XLoc     = 1;        YLoc     = 0;
    VerAlign = 'bottom'; HorAlign = 'right';
case 'al', %Above left corner ...
    XLoc     = 0;        YLoc     = 1;
    VerAlign = 'bottom'; HorAlign = 'left';
case 'ar', %Above right corner ...
    XLoc     = 1;        YLoc     = 1;
    VerAlign = 'bottom'; HorAlign = 'right';
end

TxtHdl = text(XLoc, YLoc, Txt.Label, 'Units', 'normalized', ...
    'VerticalAlignment', VerAlign, 'HorizontalAlignment', HorAlign, ...
    'FontUnits', 'centimeters', 'FontName', Txt.FontName, ...
    'FontSize', CalcRAPFontSize(RAPStat, AxHdl, Txt.FontSize), 'FontAngle', Txt.FontAngle, ...
    'FontWeight', Txt.FontWeight, 'Color', Txt.Color, 'Interpreter', 'Tex');