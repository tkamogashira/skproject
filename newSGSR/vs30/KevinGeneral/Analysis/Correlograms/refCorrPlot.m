function PageI = refCorrPlot(CLR, varargin)
% kevCorrPLOT Plots a waterfall plot from a corrListResult object
%
% kevCorrPlot(CLR, params)
%  Plots a waterfall plot from the given corrListResult object. For now,
%  this function only handles corrListResult objects with calcType
%  'kevCorr'.
%
% Arguments:
%     CLR: The corrListResult instance containing the results of the
%          calculations.
%  params: As usual, extra parameters are given in a 'paramName',
%          paramValue list. Look at the examples for more insight.
%          Possible parameters are:
%            applyFcns: 
%              A list of functions that should be applied to the
%              correlograms in the corrListResult object before plotting.
%              Take at the look at the applyFcns method of corrListResult
%              to see the expected format. 
%            addFcns: 
%              A list of extra functions that should be plotted. The extra
%              functions are plotted on the same plot object. 
%              !! These should be corrListResult objects!! The reason for
%              this is that the user might want to use these extra
%              functions later on. To avoid double work, the user is asked
%              to first calculate the extra functions, and only then use
%              kevCorrPlot. Look at the examples to see how to handle this.
%            scale: 
%              The scale of the WFPlotObject that is created. Refer to
%              WFPlotObject for more info about this this.
%            discernFieldLabel:
%              The label at the Y axes.
%            discernFieldUnit:
%              The unit at the Y axes.
%            plotPrimaryPeaks:
%              ['yes'] or 'no'.
%            plotSecondaryPeaks:
%              'yes' or ['no'].
%            plotExtraFcnsPeaks:
%              'yes' or ['no']: plot primary peaks for the added extra functions?
%            plotPhysRange:
%              ['yes'] or 'no': plot a yellow patch for to indicate the
%              physical range?
%            physRange:
%              A 1x2 interval, indicating the physical range. Standard:
%              [-0.4 0.4], in unites of ms.
%            plotScale:
%              ['yes'] or 'no'   Plot a small scale or not? 
%            corrXRange:
%              The delay range that is being displayed on the screen.
%              Standard is [-5 5], in units of ms.
%            corrXStep:
%              The distance between the ticks on the delay axes.
%            rightYExpr:
%              It is possible to also use the right Y axes, to indicate
%              alternative units. For example, if the left axes expresses
%              frequency, the right axes could express the cochlear
%              distance.
%              In that case rightYExpr contains a calculation that
%              determines the values at the right axes. The expression can
%              contain variables enclosed by dollar signs. The variables
%              must then be fields in the List that was used to calculate
%              CLR. 
%            rightYLabel:
%              The label for the extra Y axes.
%            rightYUnit:
%              The unit for the extra Y axes.
%            primPeakRange:
%              The range in which the peaks are detected. If there are no
%              peaks in this range, no peaks will be plotted.
%            logX:
%              Use a logarithmic scale for the delay axes.
%            logY:
%              Use a logarithmic scale for the Y axes.
% 
% Example:
%  List = struct('filename', 'A0307', ...
%               'iseqp', num2cell([368, 666, 486, 748]), ...
%               'iseqn', num2cell([368, 666, 486, 748]), ...
%               'isubseqp', num2cell([2 2 1 2]), ...
%               'isubseqn', num2cell([1 1 2 1]), ...
%               'discernvalue', num2cell([2046, 2051, 2133, 1919]));
%  CLO = corrListObject(List);
%  CLR = calcCorr(CLO, 'calcType', 'refRow', 'refRow', 2);
%  CLRExtra = applyFcns(CLR, {'KHilbert',{'1000/($DF$*$corrBinWidth$)'}});
%  kevCorrPlot(CLR, 'scale', 10, 'addFcns', CLRExtra, ...
%              'discernfieldlabel', 'Frequency', 'discernfieldunit', 'Hz', 'plotExtraFcnsPeaks', 'yes', ...
%              'rightYLabel', 'Distance', 'rightYUnit', 'mm', 'rightYExpr', 'greenwood($discernvalue$)');

P = Panel('nodraw');

%% Process params
defParams.applyFcns             = {};
defParams.addFcns               = [];
defParams.scale                 = 10;
defParams.discernFieldLabel     = '';
defParams.discernFieldUnit      = '';
defParams.plotPrimaryPeaks      = 'yes';
defParams.plotSecondaryPeaks    = 'no';
defParams.plotExtraFcnsPeaks    = 'no';
defParams.plotPhysRange         = 'yes';
defParams.physRange             = [-0.4 0.4];
defParams.plotScale             = 'yes';
defParams.corrXRange            = [-5 5];
defParams.corrXStep             = 1;
defParams.rightYLabel           = '';
defParams.rightYUnit            = '';
defParams.rightYExpr            = '';
defParams.primPeakRange         = [-Inf Inf];
defParams.logX                  = 'no';
defParams.logY                  = 'no';
params = processParams(varargin, defParams);

%% Gather data
CLO         = getCLO(CLR);
list        = getList(CLO);
refRow      = getRefRow(CLR);
[primaryPeaks, secondaryPeaks] = getPeaks(CLR, params.primPeakRange);
n = length(list);
ZData = cell(1,n);
for i = 1:n
    ZData{i} = list(i).('discernvalue');
end
ZData = ZData';

%% Apply extra functions and create WFPlot object
CLR = applyFncs(CLR, params.applyFcns);
lineWidth = repmat({0.5}, length(list), 1);
lineWidth{refRow} = 1.5; % make refrow thicker

% apply corrXRange
WFPXData = getCorrLag(CLR);
WFPYData = getCorrFncs(CLR);
for i = 1:size(WFPXData, 1)
    [WFPXData{i}, WFPYData{i}] = applyXRange(WFPXData{i}, WFPYData{i}, params.corrXRange);
end
WFP = WFPlotObject(WFPXData, WFPYData, ZData, ...
    'marker', 'none', 'color', 1, 'lineWidth', lineWidth, 'scale', params.scale, 'plotScale', params.plotScale, 'scaleRow', refRow);
% get YRange
[YRng(1), YRng(2)] = getYRange(WFP, 0, params.logY);
YRng(1) = round( (YRng(1)-6) /10) * 10; % round down to multiple of 10
YRng(2) = round( (YRng(2)+6) /10) * 10; % round up to multiple of 10

%% Plot physical range first
if isequal('yes', lower(params.plotPhysRange))
    physPatch = PatchPlotObject([params.physRange(1) params.physRange(2) params.physRange(2) params.physRange(1)], ...
        [YRng(1) YRng(1) YRng(2) YRng(2)], 'EdgeColor', [1 1 0.75], 'FaceColor', [1 1 0.75]);
    vertLines = XYPlotObject( {[params.physRange(1) params.physRange(1)];[params.physRange(2) params.physRange(2)]}, ...
        {[YRng(1) YRng(2)];[YRng(1) YRng(2)]}, 'Color', 'k', 'LineStyle', ':', 'marker', 'none');

    P = addPlot(P, physPatch, 'noredraw');
    P = addPlot(P, vertLines, 'noredraw');
end

%% vertical line at zero
zeroLine = XYPlotObject([0 0], [YRng(1), YRng(2)], 'Color', 'k', 'LineStyle', ':', 'marker', 'none');
P = addPlot(P, zeroLine, 'noredraw');

%% plot WFP
P = addPlot(P, WFP, 'noredraw');

%% extra functions
% peaks are requested for which extra functions?
if isequal( 'yes', lower(params.plotExtraFcnsPeaks))
    peaksReq = ones(1, length(params.addFcns));
elseif isequal( 'no', lower(params.plotExtraFcnsPeaks))
    peaksReq = zeros(1, length(params.addFcns));
elseif iscell(params.plotExtraFcnsPeaks) && isequal(length(params.plotExtraFcnsPeaks), length(params.addFcns))
    for cAddFcn=1:length(params.addFcns)
        peaksReq = zeros(1, length(params.addFcns));
        if isequal( 'yes', lower(params.plotExtraFcnsPeaks{cAddFcn}))
            peaksReq(cAddFcn) = 1;
        elseif ~isequal( 'no', lower(params.plotExtraFcnsPeaks))
            error('Parameter plotExtraFcnsPeaks should be ''yes'' or ''no''.');
        end
    end
else
    error('Parameter plotExtraFcnsPeaks should be ''yes'' or ''no''.');
end

for i=1:length(params.addFcns)
    extraWFPXData = getCorrLag(params.addFcns(i));
    extraWFPYData = getCorrFncs(params.addFcns(i));
    for j = 1:size(extraWFPXData,1)
        [extraWFPXData{j},extraWFPYData{j}] = applyXRange(extraWFPXData{j}, extraWFPYData{j}, params.corrXRange);
    end
    extraWFP = WFPlotObject(extraWFPXData, extraWFPYData, ZData, 'Marker', 'none', 'scale', params.scale, 'color', 1, 'plotScale', 'no');
    P = addPlot(P, extraWFP, 'noredraw');
    
    % plot peaks for extra functions
    
    if peaksReq(i)
        extraPrimaryPeaksResult = getPeaks(params.addFcns(i));
        extraWFPPeaks = WFPlotObject(num2cell(extraPrimaryPeaksResult(:, 1)),num2cell(extraPrimaryPeaksResult(:, 2)), ZData, 'marker', 'd', 'scale', params.scale, 'color', 1, 'plotScale', 'no');
        P = addPlot(P, extraWFPPeaks, 'noredraw');
    end
end

%% Plot peaks
if isequal( 'yes', lower(params.plotPrimaryPeaks) )
    WFPrimary = WFPlotObject(num2cell(primaryPeaks(:,1)), num2cell(primaryPeaks(:,2)), ZData, 'scale', params.scale, 'LineStyle', 'none', 'Marker', 'o', 'Color', 'k', 'plotScale', 'no');
    P = addPlot(P, WFPrimary, 'noredraw');
end
if isequal( 'yes', lower(params.plotSecondaryPeaks) )
    WFSecondary1 = WFPlotObject(num2cell(secondaryPeaks(:,1,1)), num2cell(secondaryPeaks(:,1,2)), ZData, 'scale', params.scale, 'LineStyle', 'none', 'Marker', 'v', 'Color', 'k', 'plotScale', 'no');
    WFSecondary2 = WFPlotObject(num2cell(secondaryPeaks(:,2,1)), num2cell(secondaryPeaks(:,2,2)), ZData, 'scale', params.scale, 'LineStyle', 'none', 'Marker', '^', 'Color', 'k', 'plotScale', 'no');
    P = addPlot(P, WFSecondary1, 'noredraw');
    P = addPlot(P, WFSecondary2, 'noredraw');
end

%% Add Y axes if requested
if ~isempty(params.rightYExpr)
    rightYValues = eval(['[' parseExpression(params.rightYExpr, 'list') ']'])';
    rightYLabelsArray = num2str(rightYValues);
    [rightYPositions, sortIndices] = sort([list.discernvalue]);
    for i = 1:size(rightYLabelsArray,1)
        rightYLabels{i} = rightYLabelsArray( sortIndices(i), :);
    end
        
    if ~isempty(params.rightYUnit)
        YLblStr = sprintf('%s (%s)', params.rightYLabel, params.rightYUnit);
    else
        YLblStr = params.rightYLabel; 
    end

    P = set(P, 'rightYAxes', 'yes', 'rightYPositions', rightYPositions', 'rightYLabels', rightYLabels', 'rightYLabel', YLblStr, 'noredraw');
end

%% Set title, labels, range, ...
% ylabel
YLblStr = params.discernFieldLabel;
if ~isempty(params.discernFieldUnit)
    YLblStr = [YLblStr ' (' params.discernFieldUnit ')'];
end

% title
titleStr = localConstructTitleStr(CLR);

% ticks
xTicks = params.corrXRange(1):params.corrXStep:params.corrXRange(2);

% apply to KPlot object
P = set(P, 'title', titleStr, 'xlabel', 'Delay (ms)', 'ylabel', YLblStr, 'ylim', YRng, 'xTicks', xTicks, 'ticksDir', 'out', 'logX', params.logX, 'logY', params.logY, 'noredraw');

PageI = defaultPage;
redraw(P);

%% Construct the title string
function titleStr = localConstructTitleStr(CLR)

% gather data
corrType    = getCorrType(CLR);
ds1         = getDSInfo(CLR);

% construct string
titleStr = 'Ref.Fiber ';
pPresent = 0;
if ~isnan(ds1(1).iseqp)
    titleStr = [titleStr 'A+[' upper(ds1(1).filename)  ' <' ds1(1).seqIdP '>(' num2str(ds1(1).indepValP,'%8.1f') ' ' ds1(1).indepUnitP ')]'];
    pPresent = 1;
end
if ~isnan(ds1(1).iseqn)
    if pPresent
        titleStr = [titleStr '/'];
    end
    titleStr = [titleStr 'A-[' upper(ds1(1).filename)  ' <' ds1(1).seqIdN '>(' num2str(ds1(1).indepValN,'%8.1f') ' ' ds1(1).indepUnitN ')]'];
end

THR = getTHR(CLR);
CF = THR.CF;
if ~isnan(CF)
    CFStr = num2str(CF);
else
    CFStr ='(no cf available)';
end

if allStringsEqual(corrType)
    switch corrType{1}
        case 'dif'
            corrTypeInfoStr = ' - corrtype: diffcor';
        case 'cor'
            corrTypeInfoStr = ' - corrtype: normal';
        case 'sum'
            corrTypeInfoStr = ' - corrtype: sumcorr';    
        otherwise
            error('unknown corrType!');
    end
else
    corrTypeInfoStr = '';
end
titleStr = [titleStr ' - CF=' CFStr ' Hz' corrTypeInfoStr];