function [yMin, yMax] = getYRange(WFP, row, logY)
% GETYRANGE Get the extent in the Y direction of the plot
%
% [yMin, yMax] = getYRange(WFP, row, logY)
% 
% Arguments:
%   row: The row for which you want the extent. If row is zero or omitted,
%        the extent whole plot is returned.
%  logY: 'yes' or ['no']; indicate whether the Y axes is logarithmically
%        scaled.

% Created by Kevin Spiritus
% Last adjustment: April 30th 2007

%% process params
if nargin < 2
    row = 0;
end
if isstruct(row) % function can also take a structure with params
    params = row;
    row = params.scaleRow;
else
    params = WFP.params;
end
if nargin < 3
    logY = 'no';
end

if isequal('keep', logY)
    switch get(gca, 'YScale')
        case 'linear'
            logY = 'no';
        case 'log'
            logY = 'yes';
        otherwise
            error('YScale is neither log nor linear?');
    end
end

if nargin > 3 | ~isnumeric(row) | ~isequal(0, mod(row,1)) | row < 0 %#ok<OR2> (ML6)
    error('Wrong format for function parameters.');
end

%% Calculate the data that will be plotted
if isequal(0, row)
    % full plot
    S = size(WFP.XData, 1);
    minimum = zeros(S, 1);
    
    for i = 1:size(WFP.XData, 1) % each row in XData contains a new plot
        switch lower(logY)
        case 'no'
            YData = params.scale*WFP.YData{i} + WFP.ZData{i} * ones(1, size(WFP.YData{i}, 2)); % ZData gives an offset to the position
        case 'yes'
            YData = 10.^(params.scale*WFP.YData{i} + log10(WFP.ZData{i}) * ones(1, size(WFP.YData{i}, 2))); % ZData gives an offset to the position
        otherwise
            error('Invalid argument for logY');
        end
        minimum(i) = min(YData);
        maximum(i) = max(YData);
    end
    
    %% Get range
    yMin = min(minimum);
    yMax = max(maximum);
else
    switch lower(logY)
        case 'no'
            YData = params.scale*WFP.YData{row};
        case 'yes'
            YData = 10.^(params.scale*WFP.YData{row} + log10(WFP.ZData{row}) * ones(1, size(WFP.YData{row}, 2))) - WFP.ZData{row};
        otherwise
            error('Invalid argument for logY');
    end
    yMin = min(YData);
    yMax = max(YData);
end