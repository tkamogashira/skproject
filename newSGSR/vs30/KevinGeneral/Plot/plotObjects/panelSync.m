function outPanel = panelSync(ds, anWin)

if ~isequal('dataset', class(ds))
    error(['First argument of ' upper(mfilename) ' should be a dataset.']);
end

if isequal(2, nargin)
    vectorStrength = CalcVSPH(ds, 'anwin', anWin);
else
    vectorStrength = CalcVSPH(ds);
end

%% Generate the XY plot


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

outPanel = addPlot(Panel, plotOut, 'noredraw');

%% set Labels
iSubSeqs = 1:ds.nrec; 
[IndepVal, ConstIndepNr, ConstVal] = ExtractIndepVal(ds, iSubSeqs);
if strcmpi(ds.FileFormat, 'EDF') & (ds.indepnr == 2)
    if isnan(ConstIndepNr)
        fprintf('WARNING: No one-dimensional restriction on dataset with more than one independent variable.\n');
        xLabel = 'SubSequence (#)';
    elseif (ConstIndepNr == 1), %First independent variable is held constant ...
        xLabel = [ ds.yname '(' ds.yunit ')'];
    else
        xLabel = [ ds.xname '(' ds.xunit ')']; 
    end
else
    xLabel = [ ds.xname '(' ds.xunit ')'];
end
yLabel = 'R';

title = 'Vector Strength Magnitude';

outPanel = set(outPanel, 'xlabel', xLabel, 'yLabel', yLabel, 'title', title, 'noredraw');

%% set ticks
outPanel = set(outPanel, 'ticksDir', 'out');

%% set limits
outPanel = autoLimits(outPanel, 0, 0.05, 'noredraw');
outPanel = set(outPanel, 'ylim', [0, 1]);

%% add text
UnitStr = '';
subSeqTxt = sprintf('\\itSubSeqs:\\rm %s', range2Str(iSubSeqs));   
if strcmpi(ds.FileFormat, 'EDF') & (ds.indepnr == 2)
    if ~isnan(ConstIndepNr)
        if (ConstIndepNr == 1), %First independent variable is held constant ...
            UnitStr = ds.yunit; 
            XLabelStr = [ ds.yname '(' UnitStr ')'];
            subSeqTxt = [sprintf('\\itSubSeqs:\\rm %s', range2Str(iSubSeqs)), {sprintf('IndepVal(X): %s', indepVal2Str(ConstVal, ds.xunit))}];
        else
            UnitStr = ds.xunit; 
            XLabelStr = [ ds.xname '(' UnitStr ')'];
            subSeqTxt = [sprintf('\\itSubSeqs:\\rm %s', range2Str(iSubSeqs)), {sprintf('IndepVal(Y): %s', indepVal2Str(ConstVal, ds.yunit))}];
        end
    end
end
subSeqTextBox = TextBoxObject(subSeqTxt, 'Position', 'NorthWest', 'LineStyle', 'none');
outPanel = addTextBox(outPanel, subSeqTextBox, 'noredraw');


calcParamTxt{1} = sprintf('\\itReps:\\rm %s', range2Str(1:ds.nrep));calcParamTxt{end+1} = sprintf('\\itAnWin:\\rm %s', win2Str([0, min(ds.burstdur)]));
calcParamTxt{end+1} = sprintf('\\itReWin:\\rm %s', win2str([]));
calcParamTxt{end+1} = sprintf('\\itMinISI:\\rm %s', sprintf('%.2f ms', 0));
calcParamTxt{end+1} = sprintf('\\itConSub:\\rm %s', sprintf('%.2f ms', 0));
calcParamTxt{end+1} = sprintf('\\itBinFreq:\\rm %s', freq2Str(abs(ExpandBinFreq(ds, 'auto', iSubSeqs))));
calcParamTxt{end+1} = sprintf('\\itIntNCycles:\\rm %s', 'no');
calcParamTxt{end+1} = sprintf('\\itRayCrit:\\rm %s', sprintf('%.3f', 0.001));
calcParamTxt{end+1} = sprintf('\\itPhaseConv:\\rm %s', 'lead');
calcParamTxt{end+1} = sprintf('\\itCompDelay:\\rm %s', '0 ms');
calcParamTxt{end+1} = sprintf('\\itRunAv:\\rm %s', '0 #');
calcParamTxt{end+1} = sprintf('\\itCutOffThr:\\rm %s', '3.0 dB');
calcParamTextBox = TextBoxObject(calcParamTxt', 'Position', 'SouthEast', 'LineStyle', 'none');

outPanel = addTextBox(outPanel, calcParamTextBox, 'noredraw');

dataTxt{1} = sprintf('\\itMaxR:\\rm %.2f', vectorStrength.curve.maxr);
dataTxt{end+1} = sprintf('\\itBestIndepVal:\\rm %.0f (%s)', vectorStrength.curve.valatmax, UnitStr);
dataTxt{end+1} = sprintf('\\itCutOffR:\\rm %.2f', vectorStrength.curve.cutoffr);
dataTxt{end+1} = sprintf('\\itCutOffVal:\\rm %.0f (%s)', vectorStrength.curve.cutoffval, UnitStr);
dataTextBox = TextBoxObject(dataTxt', 'Position', 'NorthEast', 'LineStyle', 'none');

outPanel = addTextbox(outPanel, dataTextBox, 'noredraw');

%% Local functions
function indepVal2Str
% written by Bram
if mod(Val, 1)
    Str = sprintf('%.2f (%s)', Val, Unit);
else
    Str = sprintf('%.0f (%s)', Val, Unit); 
end