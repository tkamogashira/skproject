function plotOut = phasePlot(ds)

if ~isequal('dataset', class(ds))
    error(['First argument of ' upper(mfilename) ' should be a dataset.']);
end

phase = CalcVSPH(ds);


linesX = phase.curve.indepval;
linesY = phase.curve.ph;

markersX = num2cell(linesX');
markersY = num2cell(linesY');

X = [linesX; markersX];
Y = [linesY; markersY];

markers = {'o'};

markerFaceColor = repmat({'none'}, length(linesX)+1, 1);
for i = find(phase.curve.raysign < 0.3)
    markerFaceColor{i + 1} = 'b';
end

colors = ['k', repmat({'b'}, 1, length(linesX))]';

plotOut = XYPlotObject(X, Y, 'Color', colors, 'Marker', markers, 'MarkerFaceColor', markerFaceColor);