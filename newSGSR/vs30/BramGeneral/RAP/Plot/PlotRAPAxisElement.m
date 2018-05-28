function Hdl = PlotRAPAxisElement(Elem, XLimits, YLimits)
%PlotRAPAxisElement    plots extra element of an RAP plot
%   Hdl = PlotRAPAxisElement(Elem, XLimits, YLimits)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 18-12-2003

MaxIdx = find(isinf(Elem.X) & (Elem.X > 0));
MinIdx = find(isinf(Elem.X) & (Elem.X < 0));
Elem.X(MinIdx) = XLimits(1); Elem.X(MaxIdx) = XLimits(2); 
MaxIdx = find(isinf(Elem.Y) & (Elem.Y > 0));
MinIdx = find(isinf(Elem.Y) & (Elem.Y < 0));
Elem.Y(MinIdx) = YLimits(1); Elem.Y(MaxIdx) = YLimits(2); 

switch Elem.Type
case 'line',
    Hdl = line(Elem.X, Elem.Y, 'Color', Elem.FaceColor, 'LineStyle', Elem.LineStyle, ...
        'LineWidth', Elem.LineWidth, 'Marker', Elem.Marker);
case 'patch',
    Hdl = patch(Elem.X, Elem.Y, Elem.FaceColor, 'EdgeColor', Elem.EdgeColor, ...
        'LineStyle', Elem.LineStyle, 'LineWidth', Elem.LineWidth, 'Marker', Elem.Marker);
case 'dot',            
    Hdl = line(Elem.X, Elem.Y, 'Color', Elem.FaceColor, 'LineStyle', 'none', 'Marker', Elem.Marker, ...
        'MarkerFaceColor', Elem.FaceColor);
end