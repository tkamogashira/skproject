function [T, corrFncsRaw] = kevCorr(list, refRow, varargin)
% kevCorr 
%
% [T, corrFncsRaw] = kevCorr(list, refRow, params)
%   
%
% Arguments
% ---------
%    list: a list of datasets, as constructed by a program such as GENCORRLIST
%  refRow: the reference row for constructing correlograms.
%  params: pairs of parameter names and values
%
% Parameters
% ----------
%  To view parameters with their default values, use:
%   > kevCorr('factory')
%
%  Overview of parameters:
%              spline: spline the correlograms before adding or applying 
%                      extra functions?
%           smoothing: smooth the corellograms before adding or applying 
%                      extra functions?
%       plotApplyFcns: apply extra functions to the correlograms before plotting?
%         plotAddFcns: add extra functions to the plot? These functions
%                      will be calculated on the raw correlogram, without
%                      extra functions applied (e.g. splining, smoothing,
%                      ...)
%         normcoratio: the scale of the waterfall plots
%   discernFieldLabel: the label at the Y axes
%    discernFieldUnit: the unit at the Y axes
%       plotPrimPeaks: indicate primary peaks? ('yes' or 'no')
%        plotSecPeaks: indicate secondary peaks? ('yes' or 'no')
%         plotPhysITD: indicate physical ITD with vertical lines? ('yes' or 'no')
%         plotUnitBox: plot a box indicating the scale of the waterfall
%                      correlograms
%  plotExtraFcnsPeaks: plot primary peaks for the added extra functions?
%                      ('yes' or 'no')
%        physITDRange: the physical ITD
%               anWin: analysis window used for calculating correlograms
%         corBinWidth: the binwidth for the correlograms
%           corMaxLag: maximum lag for the correlograms
%                plot: plot the results to a figure? ('yes' or 'no')
%           corxrange: the delay range that is being displayed on the
%                      screen; standard is [-5 5], in units of ms.
%            corxstep: the distance between the ticks on the delay axes.
%         rightylabel: the label for the extra Y axes.
%          rightyunit: the unit for the extra Y axes.
%          rightyexpr: it is possible to also use the right Y axes, to indicate
%                      alternative units. For example, if the left axes expresses
%                      frequency, the right axes could express the cochlear
%                      distance.
%                      In that case rightYExpr contains a calculation that
%                      determines the values at the right axes. The expression can
%                      contain variables enclosed by dollar signs. The variables
%                      must then be fields in the List that was used to calculate
%                      CLR. 
%        DFRunAvgUnit: unit for running average applied when calculating
%                      the DF (refer to the 'spectana' function) ('#' or 'Hz')
%       DFRunAvgRange: the range for the running average applied when
%                      calculating the DF
%             DFRange: the range of the correlogram over which the dominant
%                      is calculated.
%       primPeakRange: range within which the primary peak is sought
%            corrType: type of the correlation ('dif' or 'cor')
%                logX: use a logarithmic scale for the delay axes. 
%                      ('yes' or 'no')
%                logY: use a logarithmic scale for the Y axes.
%                      ('yes' or 'no') 
%
% See also: GENCORRLIST

%% proces params
defParams.spline = 0;
defParams.smoothing = 0;
defParams.plotApplyFcns = {};
defParams.plotAddFcns = {};
defParams.normcoratio = 5;
defParams.discernFieldLabel = '';
defParams.discernFieldUnit = '';
defParams.plotPrimPeaks = 'yes';
defParams.plotSecPeaks = 'no';
defParams.plotPhysITD = 'yes';
defParams.plotUnitBox = 'yes';
defParams.plotExtraFcnsPeaks = [];
defParams.physITDRange = [-0.4000 0.4000];
defParams.anWin = 'burstdur';
defParams.corBinWidth = 0.0500;
defParams.corMaxLag = 5;
defParams.plot = 'yes';
defParams.corxrange = [-5 5];
defParams.corxstep = 1;
defParams.rightylabel       = '';
defParams.rightyunit        = '';
defParams.rightyexpr        = '';
defParams.DFRunAvgUnit      = 'Hz';
defParams.DFRunAvgRange     = 100;
defParams.DFRange           = [-Inf Inf];
defParams.primPeakRange     = [-Inf Inf];
defParams.corrType = 'dif';
defParams.logX = 'no';
defParams.logY = 'no';

if isequal(1, nargin) && isequal( 'factory', lower(list) )
    disp(defParams);
    return;
end

varargin
params = processParams(varargin, defParams);
params
params.calcApplyFcns = { 'KSpline', {params.spline}, 'smooth', {params.smoothing}  };

%% calculate correlograms and apply functions (eg smooth, spline, ..)
CLO     = corrListObject(list, 'anWin', params.anWin, 'corrBinWidth', params.corBinWidth, 'corrMaxLag', params.corMaxLag);
CLRRaw  = calcCorr(CLO, 'calcType', 'refRow', 'refRow', refRow, 'DFRange', params.DFRange, 'DFRunAvgUnit', params.DFRunAvgUnit, 'DFRunAvgRange', params.DFRunAvgRange, 'corrType', params.corrType);

ClrSpline           = applyFncs(CLRRaw, { 'KSpline', {params.spline}  });
ClrSmooth           = applyFncs(CLRRaw, { 'smooth', {params.smoothing}  });
ClrSmoothSpline     = applyFncs(CLRRaw, { 'smooth', {params.smoothing}, 'KSpline', {params.spline}  });
ClrSplineSmooth     = applyFncs(CLRRaw, { 'KSpline', {params.spline}, 'smooth', {params.smoothing}  });

CLR     = applyFncs(CLRRaw, params.calcApplyFcns);

%% get properties of calculation result
magnAtZero = getMagnAtZero(CLR);
corrFncsRaw = getCorrFncs(CLRRaw); % output raw correlograms
corrFncs = getCorrFncs(CLR);

corrFncsSpline = getCorrFncs(CLRSpline);
corrFncsSmooth = getCorrFncs(CLRSmooth);
corrFncsSmoothSpline = getCorrFncs(CLRSmoothSpline);
corrFncsSplineSmooth = getCorrFncs(CLRSplineSmooth);

corrLag = getCorrLag(CLRRaw);
corrLagProc = getCorrLag(CLRSplineSmooth);
THR = getTHR(CLRRaw);
DF = getDF(CLRRaw);
DF
[ds1, ds2] = getDSInfo(CLRRaw);
corrType = getCorrType(CLRRaw);

%% Calculate extra functions (e.g. Hilbert)
NExtraFncs = size(params.plotAddFcns, 2)/2;
listLength = length(list);
% get peaks from extra functions
extraPrimaryPeaks = zeros(listLength, NExtraFncs, 2);
extraSecondaryPeaks = zeros(listLength, NExtraFncs, 2, 2);
for fcnCounter = 1:NExtraFncs
    extraFncsResults(fcnCounter) = applyFncs(CLRSplineSmooth, {params.plotAddFcns{2*fcnCounter-1}, params.plotAddFcns{2*fcnCounter}} ) ;
    [extraPrimaryPeaksResult, extraSecondaryPeaksResult] = getPeaks(extraFncsResults(fcnCounter));
    for listCounter = 1:listLength
        extraPrimaryPeaks(listCounter, fcnCounter, :) = extraPrimaryPeaksResult(listCounter, :);
        for i = 1:2
            extraSecondaryPeaks(listCounter, fcnCounter, i, 1) = extraSecondaryPeaksResult(listCounter, i, 1);
            extraSecondaryPeaks(listCounter, fcnCounter, i, 2) = extraSecondaryPeaksResult(listCounter, i, 2);
        end
    end
    extraFncs(fcnCounter).XData = getCorrLag(extraFncsResults(fcnCounter));
    extraFncs(fcnCounter).YData = getCorrFncs(extraFncsResults(fcnCounter));
end
if ~exist('extraFncsResults', 'var')
    extraFncsResults = [];
end


%% determine physical range and range for primary peak
if isequal( 'cf', lower(params.physITDRange) )
    params.physITDRange = [-500/THR.CF, 500/THR.CF];
end
if isequal('phys', lower(params.primPeakRange))
    params.primPeakRange = params.physITDRange;
end
[primaryPeaks, secondaryPeaks] = getPeaks(CLR, params.primPeakRange);

%% if asked, plot
if isequal('yes', params.plot)
    refCorrPlot(CLR, 'scale', params.normcoratio, 'addFcns', extraFncsResults, 'applyFcns', params.plotApplyFcns, ...
        'discernfieldlabel', params.discernFieldLabel, 'discernfieldunit', params.discernFieldUnit, ...
        'plotPrimaryPeaks', params.plotPrimPeaks, 'plotSecondaryPeaks', params.plotSecPeaks, 'plotScale', params.plotUnitBox, ...
        'plotPhysRange', params.plotPhysITD, 'physRange', params.physITDRange, 'corrXRange', params.corxrange, 'corrXStep', params.corxstep, ...
        'rightYLabel', params.rightylabel, 'rightYUnit', params.rightyunit, 'rightYExpr', params.rightyexpr, 'primPeakRange', params.primPeakRange, ...
        'plotExtraFcnsPeaks', params.plotExtraFcnsPeaks, 'logX', params.logX, 'logY', params.logY);
end

%% prepare output
for listCounter = 1:listLength
    T(listCounter).ds1 = rmfield(ds1(listCounter), {'SptP', 'SptN', 'WinDur', 'indepValP', 'indepUnitP','indepValN', 'indepUnitN','seqIdN'});
    T(listCounter).ds2 = rmfield(ds2(listCounter), {'SptP', 'SptN', 'WinDur', 'indepValP', 'indepUnitP','indepValN', 'indepUnitN','filename','seqIdN'});
    T(listCounter).primpeak.delay = primaryPeaks(listCounter,1);
    T(listCounter).primpeak.magn = primaryPeaks(listCounter,2);
    T(listCounter).secpeaks.delay = secondaryPeaks(listCounter, 1:2, 1)';
    T(listCounter).secpeaks.magn = secondaryPeaks(listCounter, 1:2, 2)';
    T(listCounter).magnatzero = magnAtZero(listCounter);
    T(listCounter).lag = corrLag{listCounter, :};
    T(listCounter).normco = corrFncsRaw{listCounter,:};
    T(listCounter).normcoProc = corrFncs{listCounter,:}; % after splining and smoothing
    T(listCounter).normcoSpline = corrFncsSpline{listCounter,:}; % after splining
    T(listCounter).normcoSmooth = corrFncsSmooth{listCounter,:}; % after smoothing
    T(listCounter).normcoSmoothSpline = corrFncsSmoothSpline{listCounter,:}; % after smoothing and splining 
    T(listCounter).normcoSplineSmooth = corrFncsSplineSmooth{listCounter,:}; % after splining and smoothing
    T(listCounter).THR.CF  = THR.CF;
    T(listCounter).THR.SR  = THR.SR;
    T(listCounter).THR.BW  = THR.BW;
    T(listCounter).THR.Qfactor  = THR.Qfactor;
    T(listCounter).THR.THR  = THR.THRmin;
    T(listCounter).DF  = DF(listCounter);
    T(listCounter).corrType = corrType{listCounter};
    for fncCounter=1:NExtraFncs
        T(listCounter).extraFnc(fncCounter).XData = extraFncs(fncCounter).XData(listCounter, :);
        T(listCounter).extraFnc(fncCounter).YData = extraFncs(fncCounter).YData(listCounter, :);
        T(listCounter).extraFnc(fncCounter).primpeak.delay = extraPrimaryPeaks(listCounter, fncCounter, 1);
        T(listCounter).extraFnc(fncCounter).primpeak.magn = extraPrimaryPeaks(listCounter, fncCounter, 2);
        T(listCounter).extraFnc(fncCounter).secpeaks.delay(1) = extraSecondaryPeaks(listCounter, fncCounter, 1, 1);
        T(listCounter).extraFnc(fncCounter).secpeaks.delay(2) = extraSecondaryPeaks(listCounter, fncCounter, 2, 1);
        T(listCounter).extraFnc(fncCounter).secpeaks.magn(1) = extraSecondaryPeaks(listCounter, fncCounter, 1, 2);
        T(listCounter).extraFnc(fncCounter).secpeaks.magn(2) = extraSecondaryPeaks(listCounter, fncCounter, 2, 2);
    end
end

for listCounter = 1:listLength
    T(listCounter).TRFit = getTRFit(T);
end

