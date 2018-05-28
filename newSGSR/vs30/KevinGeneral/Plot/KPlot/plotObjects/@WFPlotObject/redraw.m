function WFP = redraw(hdl, WFP, startColor)
% REDRAW Draws a WFPlotObject instance on the given handle.
%
% WFPlotObject WFP = redraw(hdl, WFPlotObject WFP)
% Redraws the given WFPlotObject instance, and returns the new WFPlotObject
% instance. 
%
%         hdl: The handle on which you want to plot the WFPlotObject
%              instance. Typically a figure or an axes.
%  startColor: determines at which position in the ColorOrder array (see 
%              axes properties in Matlab Help) the colors of the plot
%              start. This helps making sure different plots have different
%              colors.

% Created by: Kevin Spiritus
% Last edited: January 8th, 2007
%% Check arguments
% number of arguments
if ~(isequal(2, nargin) || isequal(3, nargin))
    error('Incorrect number of arguments.');
end

if isequal(2, nargin)
    startColor = 1;
end

if ~isnumeric(startColor) || ~isequal(0, mod(startColor,1))
    error('startColor should be a whole number');
end

% check given handle
try
    findobj(hdl);
catch
    error('Given handle for drawing WFPlotObject is invalid. Type ''help redraw'' for more information.');
end

if ~isequal('wfplotobject', lower(class(WFP)))
    error('Second argument should be a WFPlotObject instance.');
end

% copy params from WFPlotObject instance to avoid changing things
params      = WFP.params;

%% Plot
axes(hdl);
%create an XYPlotObject from the data
XY.XData = WFP.XData;
XY.YData = WFP.YData;

% get scaling
switch lower(params.logX)
    case 'yes'
        set(hdl, 'XScale', 'log');
    case 'no'
        set(hdl, 'XScale', 'linear');
    case 'keep'
        % do nothing
    otherwise
        error('Invalid argument for logX');
end
for i = 1:size(WFP.XData, 1) % each row in XData contains a new plot
    switch lower(params.logY)
        case 'no'
            set(hdl, 'YScale', 'linear');
            % ZData gives an offset to the position
            XY.YData{i} = params.scale*XY.YData{i} + WFP.ZData{i} * ...
                ones(1, size(XY.YData{i}, 2));
        case 'keep'
            % ZData gives an offset to the position
            XY.YData{i} = params.scale*XY.YData{i} + WFP.ZData{i} * ...
                ones(1, size(XY.YData{i}, 2));
        case 'yes'
            set(hdl, 'YScale', 'log');
            % ZData gives an offset to the position
            XY.YData{i} = 10.^(params.scale*XY.YData{i} + ...
                log10(WFP.ZData{i}) * ones(1, size(XY.YData{i}, 2)));
        otherwise
            error('Invalid argument for logY');
    end
end

% Run through the plot parameters and build a string for the plot
% command
WFPlotFieldNames = fieldnames(params.XY);
paramString = '';
for FNCounter = 1:size(WFPlotFieldNames, 1)
    % Adding an 'f' to a Marker symbol gives it the color specified in
    % Marke
%     if strcmpi(WFPlotFieldNames{FNCounter}, 'Marker')
%         fillIdx = cellfun(@(x) isequal(length(x), 2) && isequal(x(2), 'f'), ...
%             params.XY.Marker);
%         markers = params.XY.Marker;
%         for i = 1 : length(markers)
%             if fillIdx(i)
%                 markers{i} = markers{i}(1);
%             end
%         end
%         params.XY.Marker = markers;
%         
%         markerFaceColor = cell(size(params.XY.Marker));
%         for i = 1 : length(markerFaceColor)
%             if fillIdx(i)
%                 markerFaceColor{i} = params.XY.Color{i};
%             else
%                 markerFaceColor{i} = 'none';
%             end
%         end
%         
%         paramString = [paramString ', ''Marker'', params.XY.Marker' ...
%             ', ''MarkerFaceColor'', markerFaceColor '];
%     else
        paramString = [paramString ', ''' WFPlotFieldNames{FNCounter} ...
            ''', params.XY.(WFPlotFieldNames{' int2str(FNCounter) '})'];
%    end
end    
paramString = [paramString ', ''ButtonDownFcn'', params.buttonDownFcn'];
XYP = []; % XYPlotObject
plotString = ['XYP = XYPlotObject(XY.XData, XY.YData' paramString ');'];    
eval(plotString);
XYP = redraw(hdl, XYP, startColor);

if isequal('yes', params.plotScale)
    plotScale(WFP, params);
end

WFP.hdls = getHandles(XYP);
