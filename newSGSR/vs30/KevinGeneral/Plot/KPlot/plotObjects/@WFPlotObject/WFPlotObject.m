function newWFPlot = WFPlotObject(XData, YData, ZData, varargin)
%{
WFPLOTOBJECT Creates a WFPlotObject instance.
A WFPlotObject is an object that contains a waterfall plot. It is similar to an
XY object, but the Y coordinate of each vector is shifted by an additional
Z-coordinate.

newWFPlot = WFPlotObject(XData, YData, ZData, paramList)
  Creates a WFPlot object from the given data. Parameter pairs can be
  given in paramList.

    XData: X-values of the data; each row contains one line
    YData: Y-values of the data; each row contains one line
    ZData: Column with Z-values (offset) for each line in XData
           and YData. 

XData, YData and ZData should have the same number of rows.

returns: A WFPlot instance.
%}

% Created by: Kevin Spiritus

%% Parameter checking
if nargin < 3
    error('WFPlotObject expects at least three arguments. Type ''help WFPlotObject'' for more information.');
end

if isnumeric(XData)
    if ~isequal( 2, ndims(XData) ) || ~isequal(size(XData), size(YData)) || ...
            ~isnumeric(YData)
        error('Wrong format of the arguments. Type ''help WFPlotObject'' for more information.');
    end
    if ~isequal( size(XData, 1), size(ZData, 1) ) || ...
            ~isequal( 1, size(ZData, 2) ) || ~isnumeric(ZData)
        error('Wrong format of the arguments. Type ''help WFPlotObject'' for more information.');
    end
    
    length = size(XData, 1);
    XDataTemp = cell(1, length);
    YDataTemp = cell(1, length);
    ZDataTemp = cell(1, length);
    for i = 1 : length
        XDataTemp{i} = XData(i, :);
        YDataTemp{i} = YData(i, :);
        ZDataTemp{i} = ZData(i);
    end
    XData = XDataTemp';
    YData = YDataTemp';
    ZData = ZDataTemp';
end
if ~iscell(XData) || ~iscell(YData) || ~iscell(ZData)
    error('Wrong format of the arguments. Type ''help WFPlotObject'' for more information.');
end
if ~isequal( 2, ndims(XData) ) || ~isequal( 1, size(XData,2) ) || ...
        ~isequal(size(XData), size(YData)) || ...
        ~isequal( [size(XData,1) 1], size(ZData) )
    error('Wrong format of the arguments. Type ''help WFPlotObject'' for more information.');
end

% delete empty rows
i = 1;
while i <= size(XData,1)
    if isempty(XData{i})
        XData = {XData{[(1:i-1), (i+1:end)]}}';
        YData = {YData{[(1:i-1), (i+1:end)]}}';
        ZData = {ZData{[(1:i-1), (i+1:end)]}}';
    else
        i = i+1;
    end
end

for i=1:size(XData,1)
    if ~isnumeric(XData{i}) || ~isnumeric(YData{i}) || ~isnumeric(ZData{i})
        error('Wrong format of the arguments. Type ''help WFPlotObject'' for more information.');
    end
    if ~isequal( 2, ndims(XData{i}) ) || ~isequal( 1, size(XData{i},1) ) || ...
            ~isequal(size(XData{i}), size(YData{i}))
        error('Wrong format of the arguments. Type ''help WFPlotObject'' for more information.');
    end
    if ~isnumeric(ZData{i}) || ~isscalar(ZData{i})
        error('Wrong format of the arguments. Type ''help WFPlotObject'' for more information.');
    end
end

paramsIn = varargin; % these will be checked later, by processParams
if isequal( [1,1], size(paramsIn) ) && iscell(paramsIn)
    paramsIn = paramsIn{1};
end

%% Assign data
newWFPlot.XData = XData;
newWFPlot.YData = YData;
newWFPlot.ZData = ZData;
newWFPlot.hdls = [];

%% Handle parameters
nRows = size(XData, 1); % The amount of vectors in input data

% define structure of parameters: just fill with defaults
newWFPlot.params.XY.Marker          = repmat({'x'}, nRows, 1);
newWFPlot.params.XY.LineStyle       = repmat({'-'}, nRows, 1);
newWFPlot.params.XY.LineWidth       = repmat({0.5}, nRows, 1);
newWFPlot.params.XY.Color           = repmat({''}, nRows, 1);
newWFPlot.params.XY.MarkerFaceColor = repmat({'none'}, nRows, 1);
newWFPlot.params.XY.MarkerEdgeColor = repmat({''}, nRows, 1);
%newWFPlot.params.XY.hist            = repmat({0}, nRows, 1);
newWFPlot.params.buttonDownFcn      = '';
newWFPlot.params.plotScale          = 'yes';
newWFPlot.params.scale              = 1;
newWFPlot.params.scaleRow           = 1;
newWFPlot.params.logX               = 'keep'; % yes, no or keep
newWFPlot.params.logY               = 'keep'; % yes, no or keep

% Parameters given as arguments are placed in the params structure.
% Other entries stay 'def'. This def value is replaced when plotting.
newWFPlot.params = processParams(paramsIn, newWFPlot.params);


%% Return object
newWFPlot = class(newWFPlot, 'WFPlotObject');
