function plotOut = syncPlot(ds)

if ~isequal('dataset', class(ds))
    error(['First argument of ' upper(mfilename) ' should be a dataset.']);
end

vectorStrength = CalcVSPH(ds);

linesX = vectorStrength.curve.indepval;
linesY = vectorStrength.curve.r;

markersX = num2cell(linesX');
markersY = num2cell(linesY');

X = [linesX; markersX];
Y = [linesY; markersY];

markers = {'o'};

markerFaceColor = repmat({'none'}, length(linesX)+1, 1);
for i = find(vectorStrength.curve.raysign < 0.3)
    markerFaceColor{i + 1} = 'b';
end

colors = ['k', repmat({'b'}, 1, length(linesX))]';

plotOut = XYPlotObject(X, Y, 'Marker', markers, 'Color', colors, 'MarkerFaceColor', markerFaceColor);