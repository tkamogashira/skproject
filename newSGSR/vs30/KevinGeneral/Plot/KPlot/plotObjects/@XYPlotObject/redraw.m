function XYPlotObject = redraw(hdl, XYPlotObject, startColor)
% REDRAW Redraws the given plot on the given handle.
%
% XYPlotObject P = Redraw(XYPlotObject P, dbl hdl[, int startColor])
% The plot P is being plotted on the given figure or axes.
%
%           P: The XYPlotObject which is being plotted.
%         hdl: The handle where XYPlotObject is being plotted (typically a figure
%              or axes).
%  startColor: Determines at which position in the ColorOrder array (see 
%              axes properties in Matlab Help) the colors of the plot
%              start. This helps making sure different plots have different
%              colors.

% Created by: Kevin Spiritus
% Last edited: December 4th, 2006

%% parameters
if isequal(2, nargin)
    startColor = 1;
end

if nargin > 3
    error('Too many arguments.');
end

%% check given handle
try
    findobj(hdl);
catch
    error(['Given handle for drawing XYPlotObject is invalid. ' ...
        'Type ''help redraw'' for more information.']);
end

%% Then plot
axes(hdl);

% give the user the possibility to just specify the startColor; if this is
% what happened, all values should be equal and whole
if isscalar(XYPlotObject.params.ML.Color{1}) && ...
        isnumeric(XYPlotObject.params.ML.Color{1})
    colors = [XYPlotObject.params.ML.Color{:}];
    if ~isequal( ones(1,length(colors)), colors/colors(1) )
        error('Internal error: invalid color specification.')
    end
    startColor = colors(1);
end

CO = get(gca, 'ColorOrder');
XYPlotFieldNames = fieldnames(XYPlotObject.params.ML);

% Run through the plot parameters and build a string for the plot command
% A = {};
% paramString = '';
% for FNCounter = 1:size(XYPlotFieldNames, 1)
%     A{FNCounter} = getfield(XYPlotObject.params.ML, XYPlotFieldNames{FNCounter});
%     paramString = [paramString ', ''' XYPlotFieldNames{FNCounter} ''', ...
%           A{' int2str(FNCounter) '}{i}']; %#ok<AGROW>
% end
% plotString = ['line(XYPlotObject.XData{i}, XYPlotObject.YData{i}' paramString ');'];

fieldArray = cell(1, size(XYPlotFieldNames, 1));
for FNCounter = 1:size(XYPlotFieldNames, 1)
    fieldArray{FNCounter} = XYPlotObject.params.ML.(XYPlotFieldNames{FNCounter});
    
%    fillIdx = cellfun(@(x) isequal(length(x), 2) && isequal(x(2), 'f'), ...
%            params.XY.Marker);
%     markers = params.XY.Marker;
%     for i = 1 : length(markers)
%         if fillIdx(i)
%             markers{i} = markers{i}(1);
%         end
%     end
%     params.XY.Marker = markers;
%     markerFaceColor = cell(size(params.XY.Marker));
%     for i = 1 : length(markerFaceColor)
%         if fillIdx(i)
%             markerFaceColor{i} = params.XY.Color{i};
%         else
%             markerFaceColor{i} = 'none';
%         end
%     end
%     paramString = [paramString ', ''Marker'', params.XY.Marker' ...
%         ', ''MarkerFaceColor'', markerFaceColor '];
end

for i = 1:size(XYPlotObject.XData, 1) % each row in XData contains a new plot
    paramStruct = [];
    for FNCounter = 1:size(XYPlotFieldNames, 1)
        paramStruct.(XYPlotFieldNames{FNCounter}) = fieldArray{FNCounter}{i};
    end
    
    %if colors are default, look at the argument startColor: it is used by
    %KPlotObject to give different plotObjects different colors.
    if isequal( '', XYPlotObject.params.ML.Color{i} ) ...
            || (isscalar( XYPlotObject.params.ML.Color{i} ) && ...
            isnumeric( XYPlotObject.params.ML.Color{i} ))
        XYPlotObject.params.ML.Color{i} = ...
            CO( mod(i + startColor - 1, size(CO, 1)) + 1, :);
        % also change the color in paramStruct
        paramStruct.Color = XYPlotObject.params.ML.Color{i};
    end
    if isequal( 'fill', XYPlotObject.params.ML.MarkerFaceColor{i})
        XYPlotObject.params.ML.MarkerFaceColor{i} = XYPlotObject.params.ML.Color{i};
        paramStruct.MarkerFaceColor = XYPlotObject.params.ML.MarkerFaceColor{i};
    end
    if isequal( '', XYPlotObject.params.ML.MarkerEdgeColor{i})
            XYPlotObject.params.ML.MarkerEdgeColor{i} = XYPlotObject.params.ML.Color{i};
            paramStruct.MarkerEdgeColor = XYPlotObject.params.ML.MarkerEdgeColor{i};
    end

    XYPlotObject.plotHdl(i) = ...
        line(XYPlotObject.XData{i}, XYPlotObject.YData{i}, paramStruct);
end
