function outPanel = syncPanel(ds, vectorStrength, raycrit, logX, logY, johnson)

%---------------- CHANGELOG ----------------
% 30/11/2010    Abel    Extended first argument checking to allow
% EDFdatasets


    
    %by Abel -> extend to EDFdataset
    if ~isa(ds, 'dataset')
    %if ~isequal('dataset', class(ds))
        error(['First argument of ' upper(mfilename) ' should be a dataset.']);
    end
    
    %% Generate the XY plot
    linesX = vectorStrength.curve.indepval;
    linesY = vectorStrength.curve.r;
    
    if isequal(johnson, 'yes')
        linesY = 1 - linesY;
        logY = 'yes';
        reverseY = 'yes';
        ylim = [1e-3 1];
        yTicks = 0 : .1 : 1;
        yTickLabels = 1 : -.1 : 0;
    else
        reverseY = 'no';
        ylim = [0 0];
        yTicks = {};
        yTickLabels = {};
    end
    
    markersX = num2cell(linesX');
    markersY = num2cell(linesY');
    
    X = [linesX; markersX];
    Y = [linesY; markersY];
    
    markers = {'o'};
    
    markerFaceColor = repmat({'none'}, length(linesX)+1, 1);
    for i = find(vectorStrength.curve.raysign <= raycrit)
        markerFaceColor{i + 1} = 'b';
    end
    
    colors = ['k', repmat({'b'}, 1, length(linesX))]';
    
    plotOut = XYPlotObject(X, Y, 'Marker', markers, 'Color', colors, ...
        'MarkerFaceColor', markerFaceColor);
    
    outPanel = addPlot(Panel('nodraw'), plotOut, 'noredraw');
    
    %% set Labels
    iSubSeqs = 1:ds.nrec;
    xLabel = syncXLabel(ds, iSubSeqs);
    if isequal(johnson, 'yes')
        yLabel = 'R (Johnson)';
    else
        yLabel = 'R';
    end
    
    title = 'Vector Strength Magnitude';
    
    outPanel = set(outPanel, 'xlabel', xLabel, 'yLabel', yLabel, ...
        'logX', logX, 'logY', logY, 'reverseY', reverseY, 'ylim', ylim, ...
        'yTicks', yTicks, 'yTickLabels', yTickLabels,'title', title, 'noredraw');
    
    %% set ticks
    outPanel = set(outPanel, 'ticksDir', 'out', 'noredraw');
    
    %% set limits
    outPanel = autoLimits(outPanel, 0, 0.05, 'noredraw');
    outPanel = set(outPanel, 'ylim', [0, 1], 'noredraw');
    
    %% add text
    UnitStr = '';
    subSeqTxt = sprintf('\\itSubSeqs:\\rm %s', range2Str(iSubSeqs));
    if strcmpi(ds.FileFormat, 'EDF') && (ds.indepnr == 2)
        if ~isnan(ConstIndepNr)
            if (ConstIndepNr == 1) %First independent variable is held constant
                UnitStr = ds.yunit;
                subSeqTxt = ...
                    [sprintf('\\itSubSeqs:\\rm %s', range2Str(iSubSeqs)), ...
                    {sprintf('IndepVal(X): %s', indepVal2Str(ConstVal, ds.xunit))}];
            else
                UnitStr = ds.xunit;
                subSeqTxt = [sprintf('\\itSubSeqs:\\rm %s', range2Str(iSubSeqs)), ...
                    {sprintf('IndepVal(Y): %s', indepVal2Str(ConstVal, ds.yunit))}];
            end
        end
    end
    subSeqTextBox = textBoxObject(subSeqTxt, 'Position', 'NorthWest', ...
        'LineStyle', 'none', 'BackgroundColor', 'none');
    outPanel = addTextBox(outPanel, subSeqTextBox, 'noredraw');
    
    dataTxt{1} = sprintf('\\itMaxR:\\rm %.2f', vectorStrength.curve.maxr);
    dataTxt{end+1} = sprintf('\\itBestIndepVal:\\rm %.0f (%s)', ...
        vectorStrength.curve.valatmax, UnitStr);
    dataTxt{end+1} = sprintf('\\itCutOffR:\\rm %.2f', ...
        vectorStrength.curve.cutoffr);
    dataTxt{end+1} = sprintf('\\itCutOffVal:\\rm %.0f (%s)', ...
        vectorStrength.curve.cutoffval, UnitStr);
    dataTextBox = ...
        textBoxObject(dataTxt', 'Position', 'NorthEast', 'LineStyle', 'none', ...
        'BackgroundColor', 'none', 'VerticalAlignment', 'top');
    
    outPanel = addTextBox(outPanel, dataTextBox, 'noredraw');
    
%% Local functions
function Str = indepVal2Str
    % written by Bram
    if mod(Val, 1)
        Str = sprintf('%.2f (%s)', Val, Unit);
    else
        Str = sprintf('%.0f (%s)', Val, Unit);
    end
