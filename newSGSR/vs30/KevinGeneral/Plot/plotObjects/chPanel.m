function outPanel = chPanel(ds, cycleHist, cHistPlot)


%---------------- CHANGELOG ----------------
% 30/11/2010    Abel    Extended first argument checking to allow
% EDFdatasets


%by Abel -> extend to EDFdataset
if ~isa(ds, 'dataset')
%if ~isequal('dataset', class(ds))
    error(['First argument of ' upper(mfilename) ' should be a dataset.']);
end

binCenters = cycleHist.hist(cHistPlot).bincenters;
rate = cycleHist.hist(cHistPlot).rate;

outPanel = addPlot(Panel('nodraw'), histPlotObject(binCenters, rate), 'noredraw');

%% set ticks
outPanel = set(outPanel, 'ticksDir', 'out', 'noredraw');

%% set labels
iSubSeqs = 1:ds.nrec; 
xLabel = syncXLabel(ds, iSubSeqs);
yLabel = 'Phase (cycles)';
title = 'Vector Strength Phase';
    
outPanel = set(outPanel, 'title', title, 'xlabel', xLabel, 'ylabel', yLabel, 'noredraw');
