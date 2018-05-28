function GridPlot(Xdata, Ydata, ds, varargin)
% GRIDPLOT Creates a 2x3 gridplot with a header.
%
% gridplot(X, Y, dataset) plots the data in the cell arrays X and Y and
% creates a header with the info from the dataset. Every plot corresponds to
% one element of the X cell and one from the Y cell.
%
% X and Y are cell arrays of vectors.
%
% Additional parameters can be given in a parameter-value list, the parameters
% are
%     headerString : the parameter passed to HeaderObject
%           xlabel : the x label for the plots
%           ylabel : the y label for the plots
%        mfileName : the name of the mfile generating the plots, this ends up in
%                    the title
%       plotParams : a cell array consisting of a parameter-value list that
%                    will be given to the function represented by plotTypeHdl.
%                    E.g. {'LineStyle' '-', 'Marker', 'none'}
%                    See the help for the requested plot type for all
%                    possible options
%      plotTypeHdl : the type of plot for the individual plots, given as
%                    a function handle of the constructor of the plot type,
%                    e.g. @XYPlotObject
%     subsequences : boolean, whether the data cells contain one vector per
%                    subsequence of ds, if so all labels are takes the same
%                    and information about the subsequences is added to the
%                    plots
%       plotString : when subsequences is false, these strings are added to
%                    the plots

% Created by: Ramses de Norre

%% Parameter checking
if ~isa(ds, 'dataset')
    error('Third argument must be a dataset');
end

if ~(iscell(Xdata) && iscell(Ydata)) || ~(length(Xdata) == length(Ydata))
    error(['Xdata and Ydata must be cell arrays of the same length whose ' ...
        'elements are vectors with data points']);
end

defParam.headerString = 'default';
defParam.xlabel       = {'x'};
defParam.ylabel       = {'y'};
defParam.mfileName    = mfilename;
defParam.plotParams   = 'undef';
defParam.plotTypeHdl  = @XYPlotObject;
defParam.subsequences = true;
defParam.plotString   = '';

try
    param = processParams(varargin, defParam);
catch
    error('Something went wrong with the parameter list, please check your syntax');
end

% if xlabel, ylabel or plotString are not big enough, we just repmat them
if ~param.subsequences
    param.xlabel = fixLength(Xdata, param.xlabel);
    param.ylabel = fixLength(Xdata, param.ylabel);
    param.plotString = fixLength(Xdata, param.plotString);
end

if ~isa(param.xlabel, 'cell') || ~isa(param.xlabel, 'cell')
    error('xlabel and ylabel must be cells.');
end

%% Plotting
positions = {...
%[ left     bottom   width    height]
[  0.13     0.5081   0.2065   0.3175] ...
[  0.4026   0.5081   0.2065   0.3175] ...
[  0.6751   0.5081   0.2065   0.3175] ...
[  0.13     0.13     0.2065   0.3175] ...
[  0.4026   0.13     0.2065   0.3175] ...
[  0.6751   0.13     0.2065   0.3175] };
headerPosition = [ 0.13  0.9  1  0.1 ];
dateStringPosition = [0.1 0.1 0.001 0.001];

if param.subsequences
    nplots = ds.nsub;
    xlabel = repmat(param.xlabel, 1, nplots);
    ylabel = repmat(param.ylabel, 1, nplots);
else
    nplots = length(Xdata);
    xlabel = param.xlabel;
    ylabel = param.ylabel;
end
plotsPerPage = 6;

for currentPlot = 1:nplots
    if mod(currentPlot-1, plotsPerPage)==0
        defaultPage(sprintf('%s: %s', param.mfileName, ds.title'));
        panel = Panel('position', dateStringPosition, 'axes', false, ...
            'nodraw');
        textbox = textBoxObject([' ' datestr(now) ' '], 'Rotation', 90, ...
            'Margin', 0.1, 'FontSize', 8, 'LineStyle', 'none', ...
            'BackgroundColor', 'none');
        addTextBox(panel, textbox);
        subplot('position', headerPosition, 'Visible', 'off');
        header = HeaderObject(param.headerString, ds);
        panel = Panel('position', headerPosition, 'axes', false, ...
            'nodraw');
        addTextBox(panel, header);
    end
    subplot('position', [positions{mod((currentPlot-1), plotsPerPage)+1}]);
    panel = Panel('xlabel', xlabel{currentPlot}, ...
        'ylabel', ylabel{currentPlot}, 'nodraw');
    plot = param.plotTypeHdl(Xdata{currentPlot}, Ydata{currentPlot});
    if ~isequal(param.plotParams,'undef')
        try
            for n=1:2:length(param.plotParams)-1
                plot = set(plot, param.plotParams{n}, param.plotParams{n+1});
            end
        catch
            error(['ERROR: Something went wrong with the plotObject ' ...
                'parameter list, please check your syntax']);
        end
    end
    panel = addPlot(panel, plot);
    
     % Philip likes the y axis to begin/end on zero if possible
     ylim = axis;
     ylim = ylim(3:4); % extract y data
     if all(ylim >= 0)
         panel = set(panel, 'ylim', [0 Inf]);
     elseif all(ylim <= 0)
         panel = set(panel, 'ylim', [-Inf 0]);
     end
    
    if param.subsequences
        subSeqString = sprintf('%d %s', ds.indep.Values(currentPlot), ...
            ds.indep.Unit);
        textBox = textBoxObject(sprintf('SubSeq: %d\nIndepVal: %s', ...
            currentPlot,subSeqString), 'LineStyle', 'none', ...
            'BackgroundColor', 'none');
        addTextBox(panel, textBox);
    elseif ~isempty(param.plotString)
        textBox = textBoxObject(param.plotString{currentPlot}, ...
            'LineStyle', 'none', 'BackgroundColor', 'none');
        addTextBox(panel, textBox);
    end
end


function B = fixLength(A, B)
if ~iscell(B)
    B = {B};
end
Alength = length(A);
Blength = length(B);
if ~isequal(Alength, Blength)
    B = repmat(B, 1, ceil(Alength/Blength));
end
