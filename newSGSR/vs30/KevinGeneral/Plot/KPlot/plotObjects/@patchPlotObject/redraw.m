function PatchPlotObject = redraw(hdl, PatchPlotObject, varargin)
% REDRAW Redraws the given plot on the given handle.
%
% PatchPlotObject P = Redraw(PatchPlotObject P, dbl hdl)
% The plot P is being plotted on the given figure or axes.
%
% Arguments:
%    P: The PatchPlot Object which is being plotted.
%  hdl: The handle where PatchPlotObject is being plotted (typically a figure
%       or an axes).

% Created by: Kevin Spiritus
% Last edited: January 10th, 2007

%% parameters
if nargin < 2
    error('Too few arguments')
end
if isequal(3, nargin) & (~isequal( 0, mod(varargin{1},1) ) | varargin{1} < 1) % third param is not whole and >= 1 (we ignore startColor parameters)
    error('Too many arguments.');    
end
if nargin > 3
    error('Too many arguments.');
end

%% check given handle
try
    findobj(hdl);
catch
    error('Given handle for drawing PatchPlotObject is invalid. Type ''help redraw'' for more information.');
end

%% Then plot
axes(hdl);
params = PatchPlotObject.params;
for i = 1:size(PatchPlotObject.XData, 1) % each row in XData contains a new patch
    % Run through the plot parameters and build a string for the patch
    % command
    XYPlotFieldNames = fieldnames(params.ML);
    paramString = '';
    A = {};
    for FNCounter = 1:size(XYPlotFieldNames, 1)
        A{FNCounter} = getfield(params.ML, XYPlotFieldNames{FNCounter});
        paramString = [paramString ', ''' XYPlotFieldNames{FNCounter} ''', A{' int2str(FNCounter) '}{i}']; %#ok<AGROW>
    end
    
    plotString = ['PatchPlotObject.plotHdl(i) = patch(PatchPlotObject.XData{i}, PatchPlotObject.YData{i}, ''w''' paramString ');'];    
    eval(plotString);
end