function outPanel = phasePanel(ds, phase, raycrit, logX)
%PHASEPANEL		Return a populated panel object for the plotting of "Vector
%				Strenght Phase" within EvalSync()

%% ---------------- CHANGELOG ----------------
% 30/11/2010    Abel    Extended first argument checking to allow
% EDFdatasets
%  Tue Jan 25 2011  Abel   
%  - Documentation / Cleanup
%  - Add lin. fit for vector strength phase (Cfr RAP ou ph)  


%by Abel: extended to EDFdataset
if ~isa(ds, 'dataset')
    error(['First argument of ' upper(mfilename) ' should be a dataset.']);
end

%First plot line
linesX = phase.curve.indepval;
linesY = phase.curve.ph;

%The plot values of the line as markers
markersX = num2cell(linesX');
markersY = num2cell(linesY');

%Combine plots
X = [linesX; markersX];
Y = [linesY; markersY];

%Set Colors
markerFaceColor = repmat({'none'}, length(linesX)+1, 1);
for i = find(phase.curve.raysign <= raycrit)
    markerFaceColor{i + 1} = 'b';
end
colors = ['k', repmat({'b'}, 1, length(linesX))]';

%% By Abel: Add linear fit
% Show linear fit of point, slope and intercept were already calculated by
% vectorStrength(). (X:indepval, Y:lin. fitted line)
%Add line to plots
X{end+1} = linesX;
Y{end+1} = polyval([phase.curve.slope, phase.curve.yintrcpt], linesX);

%Add parameters to input for XYPlotObject()
colors{end +1} = 'k';
markerFaceColor{end +1} = 'none';
markers = [ repmat({'o'}, 1, length(linesX) +1), 'none' ]';
lineStyle = [ repmat({'-'}, 1, length(linesX) +1), ':' ]';

%% Create plot object 
plotOut = XYPlotObject(X, Y, 'Color', colors, 'Marker', markers, ...
     'MarkerFaceColor', markerFaceColor, 'LineStyle', lineStyle);
outPanel = addPlot(Panel('logX', logX, 'nodraw'), plotOut, ...
    'noredraw');

%% set ticks
outPanel = set(outPanel, 'ticksDir', 'out', 'noredraw');

%% set labels
iSubSeqs = 1:ds.nrec; 
xLabel = syncXLabel(ds, iSubSeqs);
yLabel = 'Phase (cycles)';
title = 'Vector Strength Phase';
    
outPanel = set(outPanel, 'title', title, 'xlabel', xLabel, 'ylabel', yLabel, ...
    'noredraw');

%% set limits
outPanel = autoLimits(outPanel, 0, 0.05, 'noredraw');

%% add text
dataTxt = {sprintf('Slope: %f', phase.curve.slope), ...
    sprintf('Yicpt: %f', phase.curve.yintrcpt)};
dataTextBox = ...
    textBoxObject(dataTxt', 'Position', 'NorthEast', 'LineStyle', 'none', ...
    'BackgroundColor', 'none', 'VerticalAlignment', 'top');

outPanel = addTextBox(outPanel, dataTextBox, 'noredraw');
