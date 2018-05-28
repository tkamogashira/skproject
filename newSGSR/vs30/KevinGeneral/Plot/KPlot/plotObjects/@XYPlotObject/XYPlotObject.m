function newXYPlot = XYPlotObject(XData, YData, varargin)
% XYPLOTOBJECT Creates an XYPlotObject instance.
%
% An XYPlotObject contains data and information for a rasterplot or a
% vectorplot. Plotting happens using the redraw method. After construction
% the XYPlotObject can be added to a Panel object.
%
% newXYPlot = XYPlotObject(XData, YData, paramList) 
% Creates an XYPlotObject object from the given vectors. Parameter pairs
% can be given in paramList.
%
%       XData: XData for the plots. It is a column cell array containing a
%              list of row vectors, or a two dimensional numeric array. In
%              the latter case, all vectors need to have the same length.
%       YData: YData for the plots. It is a column cell array containing a
%              list of row vectors, or a two dimensional numeric array. In
%              the latter case, all vectors need to have the same length.
%      Marker: Markers for the plots; can be a single value (same for every
%              plot) or a column cell array  with a value for every plot.
%       Color: Colors for the plots; can be a single value (same for every
%              plot) or a column cell array  with a value for every plot.
%MarkerFaceColor: An extra mode was added for MarkerFaceColor, the mode 'fill'
%                 sets the MarkerFaceColor to the value of Color
%   LineStyle: Linestyle for the plots; can be a single value (same for 
%              every plot) or a column cell array  with a value for every
%              plot.
% 
% When called without any arguments, an empty XYPlotObject is returned,
% this can be used to preallocate arrays.
% 
% EXAMPLE
%	%Draw a line and a single dot
%	X{1,:} = [1 2 3];	%X-Values of line
%	Y{1,:} = [1 2 3];	%Y-Values of line
%	X{2,:} = [4];		%X-Value of dot
%	Y{2,:} = [4];		%Y-Value of dot
%	Markers{1,:} =	['none'];	%No markers needed for the line
%	Markers{2,:} =	['o'];		%Use 'o' as marker for the dot
%	Obj = XYPlotObject(X, Y, 'marker', Markers)

% Created by: Kevin Spiritus
% Edited by: Ramses de Norre

%% ---------------- CHANGELOG -----------------------
%  Fri Jan 28 2011  Abel   
%	- Added example in Doc
%  Tue Apr 26 2011  Abel   
%   - Reorganised code so XYPlotObject() without arguments returns an
%   object with default parameters.

%% standard properties
% Internals
newXYPlot.XData						= [];
newXYPlot.YData						= [];
newXYPlot.plotHdl					= [];
% User adaptable MatLab options
newXYPlot.params.ML.Marker			= {'x'};
newXYPlot.params.ML.MarkerEdgeColor = {''};
newXYPlot.params.ML.MarkerFaceColor = {'none'};
newXYPlot.params.ML.MarkerSize		= {6};
newXYPlot.params.ML.LineStyle		= {'-'};
newXYPlot.params.ML.LineWidth		= {0.5};
newXYPlot.params.ML.Color			= {''};
newXYPlot.params.ML.ButtonDownFcn	= {''};


%% Parameter checking
if isequal(nargin,0)
    newXYPlot = class(newXYPlot, 'XYPlotObject');
    return
end

if nargin < 2
    error(['XYPlotObject expects at least two arguments or none. ' ...
        'Type ''help XYPlotObject'' for more information.']);
end

if isnumeric(XData)
    if ~isequal( 2, ndims(XData) ) || ~isequal(size(XData), size(YData))  || ...
            ~isnumeric(YData)
        error(['Wrong format of the arguments. ' ...
            'Type ''help XYPlotObject'' for more information.']);
    end
    
    length = size(XData, 1);
    XDataTemp = cell(1, length);
    YDataTemp = cell(1, length);
    for i = 1 : length
        XDataTemp{i} = XData(i, :);
        YDataTemp{i} = YData(i, :);
    end
    XData = XDataTemp';
    YData = YDataTemp';
end
if ~iscell(XData) || ~iscell(YData)
    error(['Wrong format of the arguments. ' ...
        'Type ''help XYPlotObject'' for more information.']);
end
if ~isequal( 2, ndims(XData) ) || ~isequal( 1, size(XData,2) ) || ...
        ~isequal(size(XData), size(YData))
    error(['Wrong format of the arguments. ' ...
        'Type ''help XYPlotObject'' for more information.']);
end

% delete empty rows
i = 1;
while i <= size(XData,1)
    if isempty(XData{i})
        XData = {XData{[(1:i-1), (i+1:end)]}}';
        YData = {YData{[(1:i-1), (i+1:end)]}}';
    else
        i = i+1;
    end
end

% continue checking data format
for i=1:size(XData,1)
    if ~isnumeric(XData{i}) || ~isnumeric(YData{i})
        error(['Wrong format of the arguments. ' ...
            'Type ''help XYPlotObject'' for more information.']);
    end
    if ~isequal( 2, ndims(XData{i}) ) || ~isequal( 1, size(XData{i},1) ) || ...
            ~isequal(size(XData{i}), size(YData{i}))
        error(['Wrong format of the arguments. ' ...
            'Type ''help XYPlotObject'' for more information.']);
    end
end

paramsIn = varargin; % these will be checked later, by processParams

%% Assign data
newXYPlot.XData = XData;
newXYPlot.YData = YData;

%% Handle parameters
nRows = size(XData, 1); % The amount of vectors in input data

% define structure of parameters: just fill with defaults based on the
% number of input XData
optFields = fieldnames(newXYPlot.params.ML);
for n=1:size(optFields, 1)
	newXYPlot.params.ML.(optFields{n}) = repmat(newXYPlot.params.ML.(optFields{n}), nRows, 1);
end

% Parameters given as arguments are placed in the params structure.
% Other entries remain 'def'. This def value is replaced when plotting.
newXYPlot.params = processParams(paramsIn, newXYPlot.params);

%% Return object
newXYPlot = class(newXYPlot, 'XYPlotObject');
