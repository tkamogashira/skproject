function [D, corrFncs] = deltaCorr(list, deltaDiscern, varargin)

%% proces params
defParams.spline = 0;
defParams.smoothing = 0;
defParams.physITDRange = [-0.4000 0.4000];
defParams.anWin = 'burstdur';
defParams.corBinWidth = 0.0500;
defParams.corMaxLag = 5;
defParams.corxrange = [-5 5];
defParams.corxstep = 1;
defParams.DFRunAvgUnit      = 'Hz';
defParams.DFRunAvgRange     = 100;
defParams.primPeakRange     = [-Inf Inf];
defParams.plotAddFcns = {};
params = processParams(varargin, defParams);

params.calcApplyFcns = { 'KSpline', {params.spline}, 'smooth', {params.smoothing} };

%% calculate correlograms and apply functions (eg smooth, spline, ..)
CLO     = corrListObject(list, 'anWin', params.anWin, 'corrBinWidth', params.corBinWidth, 'corrMaxLag', params.corMaxLag);
CLRRaw  = calcCorr(CLO, 'calcType', 'deltaDiscern', 'delta', deltaDiscern, 'DFRunAvgUnit', params.DFRunAvgUnit, 'DFRunAvgRange', params.DFRunAvgRange);
CLR     = applyFncs(CLRRaw, params.calcApplyFcns);

%% get properties of calculation result
magnAtZero = getMagnAtZero(CLR);
corrFncs = getCorrFncs(CLRRaw); % output raw correlograms
corrLag = getCorrLag(CLRRaw);
CF = getCF(CLRRaw);
DF = getDF(CLRRaw);
[ds1, ds2] = getDSInfo(CLRRaw);
corrType = getCorrType(CLRRaw);

%% Calculate extra functions (e.g. Hilbert)
NExtraFncs = size(params.plotAddFcns, 2)/2;
for i = 1:NExtraFncs
    extraFncsResults(i) = applyFncs(CLR, {params.plotAddFcns{2*i-1}, params.plotAddFcns{2*i}} ) ;
    extraFncs(i).XData = getCorrLag(extraFncsResults(i));
    extraFncs(i).YData = getCorrFncs(extraFncsResults(i));
end

%% determine physical range and range for primary peak
if isequal( 'cf', lower(params.physITDRange) )
    params.physITDRange = [-500/CF, 500/CF];
end
if isequal('phys', lower(params.primPeakRange))
    params.primPeakRange = params.physITDRange;
end
[primaryPeaks, secondaryPeaks] = getPeaks(CLR, params.primPeakRange);

%% prepare output
for row = 1:length(list)
    for col = 1:length(list)
        D(row,col).primpeak.delay = primaryPeaks(row,col,1);
        D(row,col).primpeak.magn = primaryPeaks(row,col,2);
        D(row,col).secpeaks.delay = [secondaryPeaks(row, col, 1, 1) secondaryPeaks(row, col, 2, 1)];
        D(row,col).secpeaks.magn = [secondaryPeaks(row, col, 1, 2) secondaryPeaks(row, col, 2, 2)];
        D(row,col).magnatzero = magnAtZero(row, col);
        D(row,col).lag = corrLag(row, col,:);
        D(row,col).normco = corrFncs(row,col,:);
        D(row,col).ds1 = rmfield(ds1(row,col), {'SptP', 'SptN', 'WinDur'});
        D(row,col).ds2 = rmfield(ds2(row,col), {'SptP', 'SptN', 'WinDur'});
        D(row,col).CF  = CF;
        D(row,col).DF  = DF(row,col);
        D(row,col).corrType = corrType{row,col};
        for j=1:NExtraFncs
            D(row,col).extraFnc(j).XData = extraFncs(j).XData(row, col, :);
            D(row,col).extraFnc(j).YData = extraFncs(j).YData(row, col, :);
        end
    end
end
