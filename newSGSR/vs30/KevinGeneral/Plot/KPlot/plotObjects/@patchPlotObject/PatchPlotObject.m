function newPatchPlot = PatchPlotObject(XData, YData, varargin)
% PATCHPLOTOBJECT Creates an PatchPlotObject instance.
%
% A PatchPlotObject contains information for drawing a patch on a plot.
% Advantage of using a PatchPlotObject is that it can be added to a Panel
% object. 
%
% newPatchPlot = PatchPlotObject(XData, YData, paramList) 
% Creates a PatchPlot object from the given vectors. Parameter pairs can be
% given in paramList.
%
%       XData: XData for the patches. Different rows form different patches 
%              to be plotted.
%       YData: YData for the patches. Different rows form different patches
%              to be plotted.
%   EdgeColor: Colors for the edges of the patches; can be a single value 
%              (same for every patch) or a column vector with a value for 
%              every patch.
%   FaceColor: Colors for the faces of the patches; can be a single value 
%              (same for every patch) or a column vector with a value for 
%              every patch.
%   LineStyle: Linestyle for the edges; can be a single value (same for 
%              every patch) or a column vector with a value for every 
%              patch.
%   LineWidth: Linewidth for the edges; can be a single value (same for 
%              every patch) or a column vector with a value for every 
%              patch.
%      Marker: Markers used for the vertices; can be a single value (same 
%              for every patch) or a column vector with a value for every 
%              patch.

% Created by: Kevin Spiritus
% Last edited: January 10th, 2006

%% Parameter checking
if nargin < 2
    error('PatchPlotObject expects at least two arguments. Type ''help PatchPlotObject'' for more information.');
end

if isequal('double', class(XData))
        if ~isequal( 2, ndims(XData) ) | ~isequal( 1, size(XData,1) ) | ~isequal(size(XData), size(YData))  | ~isnumeric(XData) | ~isnumeric(YData)  %#ok<OR2>
            error('Wrong format of the arguments. Type ''help PatchPlotObject'' for more information.');
        end
        XData = {XData};
        YData = {YData};
end
if ~iscell(XData) | ~iscell(YData) %#ok<OR2>
    error('Wrong format of the arguments. Type ''help PatchPlotObject'' for more information.');
end
if ~isequal( 2, ndims(XData) ) | ~isequal( 1, size(XData,2) ) | ~isequal(size(XData), size(YData)) %#ok<OR2>
    error('Wrong format of the arguments. Type ''help PatchPlotObject'' for more information.');
end

for i=1:size(XData,1)
    if ~isequal( 'double', class(XData{i}) ) | ~isequal( 'double', class(YData{i}) )  %#ok<OR2>
        error('Wrong format of the arguments. Type ''help PatchPlotObject'' for more information.');
    end
    if ~isequal( 2, ndims(XData{i}) ) | ~isequal( 1, size(XData{i},1) ) | ~isequal(size(XData{i}), size(YData{i})) %#ok<OR2>
        error('Wrong format of the arguments. Type ''help PatchPlotObject'' for more information.');
    end
end

paramsIn = varargin; % these will be checked later, by processParams

%% Assign data
newPatchPlot.XData = XData;
newPatchPlot.YData = YData;
newPatchPlot.plotHdl = [];

%% Handle parameters
nRows = size(XData, 1); % The amount of vectors in input data

% define structure of parameters: just fill with defaults
newPatchPlot.params.ML.EdgeColor = repmat({'k'}, nRows, 1);
newPatchPlot.params.ML.FaceColor = repmat({'w'}, nRows, 1);
newPatchPlot.params.ML.LineStyle = repmat({'-'}, nRows, 1);
newPatchPlot.params.ML.LineWidth = repmat({0.5}, nRows, 1);
newPatchPlot.params.ML.Marker = repmat({'none'}, nRows, 1);

% Parameters given as arguments are placed in the params structure.
% Other entries remain 'def'. This def value is replaced when plotting.
newPatchPlot.params = processParams(paramsIn, newPatchPlot.params);

%% Return object
newPatchPlot = class(newPatchPlot, 'PatchPlotObject');