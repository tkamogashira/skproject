function argOut = KStructPlot(varargin)
% KStructPlot - Create a plot using the fields of a structure-array
%   KStructPlot(S1, XFieldNames1, YFieldNames1, S2, XFieldNames2, YFieldNames2,
%               ..., parameters)
%
%   The data for the plots is contained in the structures S1, S2, .... The
%   fields containing X and Y data are indicated in XFieldNames and
%   YFieldNames parameters.
%
%   Each row of these data columns can contain a scalar, represented by a
%   dot in the plot, or a vector, represented by a line.
%
%   Different structures get different colors in the plot.
%
%   Parameters:
%         colors          : the colors used for different structures
%         linestyles      : the linestyles used for different structures
%         markers         : the markers used for different structures,
%                           appending an 'f' to a marker symbol makes it filled
%		  markersizes	  : MarkerSize for points
%         execevalfnc     : Matlab statement to execute when clicking on a
%                           datapoint or curve. Fieldnames in these statements
%                           must be enclosed between dollar signs and for
%                           branched structures fieldnames can be given using
%                           the dot as a fieldname separator
%         animalidfield   : the name of the field that identifies the animal for
%                           a given structure-array row. A cell-array of strings
%                           can be supplied if this field is different for
%                           different structure-arrays
%         cellidfield     : the name of the field containing cell id's
%         totalidfields   : TODO
%         dispstats       : display statistics (animals, cells, ...)
%         indexexpr       : condition for including an index
%         intersectfields : only include indexes from the intersection of these
%                           fields
%         info            : TODO
%         xlim            : two element vector giving the lower and upper x
%                           limits
%         ylim            : two element vector giving the lower and upper y
%                           limits
%         gutter          : boolean, whether or not to display a gutter
%                           with points that are not inside the plot range
%         johnson         : yes/[no], whether or not to plot in the Johnson
%                           scale
%     ignoreTotalIDFields : yes/[no], whether we should try to deduce the
%                           totalidfields or not
%		  returnstruct	  : return plotted data in struct
%		  fitfnc          :	fit a cubic spline function through data
%							'none' or 'spline'
%		  fitsampleratio  : Ratio which defines oversampling of fit function 
%							to be plotted.
%		  title			  : Plot title
%		  xlabel/ylabel   : Axis labels
%         logX/logY       : Axis in log scale (yes/no)
%         logXformat/logYformat :	Useful in situations where the X-as is in log scale. 
%									Set to 'auto' for matlab labels or leave blank to use  
%									xlog125 as labels 
%		  xTickLabels     : Print a user defined string on the xTicks 
%         legend          : Add a user defined legend instead of the struct
%                           names
%         legendParam     : Change the default options for the legend
%
%   Run Kstructplot() without arguments to see default values for these
%   parameters.
%	OUTPUT:
%		argOut:	Struct containing plotted values in the same format as
%					the input struct array. If returnstruct == true
%
%
% SEE ALSO panel legend	


%% ---------------- CHANGELOG -----------------------
%  Mon Jan 31 2011  Abel   
%   bugfix in localGetButtonDownFcn: always row vector: '' -> should be .'
%	bugfix in localGetButtonDownFcn: param.totalidfields is cell array
%  Tue Feb 1 2011  Abel   
%   bugfix: ignoreTotalIDFields = 'yes' was not checked in localGetButtonDownFcn
%  Thu Feb 3 2011  Abel   
%   Added function output:
%		argOut: Struct array containing plotted values in the same format as
%		the input struct array. If returnstruct == true
%  Fri Feb 4 2011  Abel   
%   bugfix in output struct
%	added support for by-inputstruct-execevalfnc 
%  Tue Feb 8 2011  Abel   
%   - Added test for number of input elements in a cell input parameter
%  Thu Feb 10 2011  Abel   
%   - bugfix output struct when no input name can be retrieved
%  Thu Feb 10 2011  Abel   
%   - Added markersize option
%	- Added spline fitting
%  Mon Feb 28 2011  Abel   
%   - Added extra plotting options: title, x&y-label,..etc.
%  Fri Mar 4 2011  Abel   
%   - Added option to keep standard matlab log-scale
%  Fri Apr 8 2011  Abel   
%   - Added reverseX/Y option
%  Thu Apr 14 2011  Abel   
%   - Bugfix in totalidfield filename retrieval
%  Tue Apr 19 2011  Abel   
%   - Added legendObject support


%% Defaults
defaultParams.colors              = {'b'; 'g'; 'r'; 'c'; 'm'; 'y'};
defaultParams.linestyles          = {'-'};
defaultParams.markers             = ...
    {'o'; '^'; 'v'; '*'; '+'; 'x'; '<'; '>'; 's'; 'd'; 'p'; 'h'};
defaultParams.markersizes		  = {6};
defaultParams.execevalfnc         = '';
defaultParams.animalidfield       = {};
defaultParams.cellidfield         = {};
defaultParams.totalidfields       = {'ds.filename', 'ds.seqid'};
defaultParams.dispstats           = 'yes';
defaultParams.indexExpr           = '';
defaultParams.intersectfields     = {'',''};
defaultParams.info                = 'yes';
defaultParams.xlim                = [-inf, inf];
defaultParams.ylim                = [-inf, inf];
defaultParams.gutter              = false;
defaultParams.johnson             = 'no';
defaultParams.ignoreTotalIDFields = 'no';
defaultParams.returnstruct        = false;
defaultParams.fitfnc			  = {'none'};
defaultParams.fitsampleratio	  = 5;
defaultParams.title		          = '';
defaultParams.xlabel			  = '';
defaultParams.ylabel			  = '';
defaultParams.logX				  = '';
defaultParams.logY				  = '';
defaultParams.xTickLabels		  = '';
defaultParams.logXformat		  = '';
defaultParams.logYformat		  = '';
defaultParams.reverseX			  = '';
defaultParams.reverseY            = '';
defaultParams.legend              = '';
defaultParams.legendParam         = '';

% Variables used in script
defaultParams.checkfornoe = {'execevalfnc', 'indexExpr', 'legend'};
defaultParams.plotoptions = {'title',...
	'xlabel',...
	'ylabel',...
	'logX',...
	'logY',...
	'xTickLabels',...
	'logXformat',...
	'logYformat',...
	'reverseX',...
	'reverseY'};

% Return factory defaults?
argOut = []; % standard, return nothing
if nargin < 1
    argOut = defaultParams;
    return
end

%% main function
% parse input
inputNames = cell(1, nargin);
for cArgin = 1:nargin
    inputNames{cArgin} = inputname(cArgin); % get the names of the arguments
	if isempty(inputNames{cArgin})
		inputNames{cArgin} = sprintf('Unknown_%d', cArgin);
	end
end

% parse input params and load data
[data, params, stats] = localLoadData(varargin, inputNames, defaultParams);
dataLength = length(data);

% initialize plot objects
XYPlotLines = repmat(XYPlotObject(), 1, dataLength);
XYPlotPoints = repmat(XYPlotObject(), 1, dataLength);

% start loop over input structures 
for cStruct = 1:dataLength
% collect aditional info
    sortedCellData = localSortCellData(data(cStruct), params);
        
    stats(cStruct).nDots = 0;
    for cRow = 1:length(data(cStruct).rows)
        X = data(cStruct).rows(cRow).X;
        Y = data(cStruct).rows(cRow).Y;
        % Count only the points that are inside the given x and y limits
        stats(cStruct).nDots = stats(cStruct).nDots + ...
            length(X( X >= params.xlim(1) & X <= params.xlim(2) & ...
                    Y >= params.ylim(1) & Y <= params.ylim(2) ));
    end
    
    stats(cStruct).nCells = 0;
    for cRow = 1:length(sortedCellData)
        X = sortedCellData(cRow).X;
        Y = sortedCellData(cRow).Y;
        % Count only the cells that have points inside the given x and y limits
        if length(X( X >= params.xlim(1) & X <= params.xlim(2) & ...
            Y >= params.ylim(1) & Y <= params.ylim(2) )) >= 1
            stats(cStruct).nCells = stats(cStruct).nCells + 1;
        end
    end
    
	if params.gutter
		params.gutterLimits = calcGutterLimits(params.xlim, params.ylim);
	else
		params.gutterLimits = {params.xlim, params.ylim};
	end

% Create plot objects    
    colorIdx = rotIdx( cStruct, length(params.colors) );
    markerIdx = rotIdx( cStruct, length(params.markers) );
    lineIdx = rotIdx( cStruct, length(params.linestyles) );
	markersizeIdx = rotIdx( cStruct, length(params.markersizes) );
	fitfncIdx = rotIdx( cStruct, length(params.fitfnc) );

    % We create 2 layers: 
    % - one layer for the connecting lines
    % - one layer for the dots (with point & click functionality)

    sortedX = {sortedCellData.X}';
    sortedY = {sortedCellData.Y}';
    
    % Adding an 'f' to a Marker symbol gives it the color of the border
    if length(params.markers{markerIdx}) > 1 && ...
            isequal(params.markers{markerIdx}(2), 'f')
        markerFaceColor = params.colors{colorIdx};
    else
         markerFaceColor = 'none';
    end
    
    X = {data(cStruct).rows(:).X}';
    Y = {data(cStruct).rows(:).Y}';
    
    % Inverting of Y data is done here, the other adjustments for the
    % Johnson scale are done in localPlotPanel
	if isequal(params.johnson, 'yes')
        Y = cellfun(@(y) 1 - y, Y, 'UniformOutput', false);
        sortedY = cellfun(@(y) 1 - y, sortedY, 'UniformOutput', false);
	end
	
	if params.gutter
		[X, Y] = createGutter(X, Y, params.xlim, params.ylim, ...
			params.gutterLimits);
	end
	
	%by Abel: fit cubic spline
	if strcmp(params.fitfnc{fitfncIdx}, 'spline')
		[sortedX, sortedY] = fitSpline_(sortedX, sortedY, params.fitsampleratio);
	end
	
    % dots
    XYPlotPoints(cStruct) = XYPlotObject(X, Y, ...
        'color', params.colors{colorIdx}, ...
        'marker', params.markers{markerIdx}(1), ...
        'markerfacecolor', markerFaceColor, ...
        'linestyle', 'none', ...
        'ButtonDownFcn', {data(cStruct).rows(:).buttonDownFcn}.',...
		'MarkerSize', params.markersizes{markersizeIdx} );
    
    % Connecting lines
    XYPlotLines(cStruct) = XYPlotObject(sortedX, sortedY, ...
        'color', params.colors{ colorIdx }, 'marker', 'none', ...
        'linestyle', params.linestyles{ lineIdx });

	% By Abel: return the plotted data in the original format of the input
	% struct. Gutter should not be included
	if (params.returnstruct)
		name = data(cStruct).name;
		if isfield(argOut, name)
			name = sprintf('%s_%d', data(cStruct).name, cStruct);
		end
		argOut.(name) = returnPlottedData(X, Y, data(cStruct), params.xlim, params.ylim);
	end
	

end

%% Add all generated plot objects to a KPlot panel
panel = localPlotPanel(XYPlotLines, XYPlotPoints, {data(:).XFieldNames}, ...
    {data(:).YFieldNames}, {data(:).name}, params);
if isequal('y', lower(params.info(1)))
    localPlotStats(panel, {data(:).name}', stats);
end


%% createGutter
function [X Y] = createGutter(X, Y, xlim, ylim, gutterLimits)
for n = 1:length(X)
    x = X{n};
    y = Y{n};
    x(x <= xlim(1)) = gutterLimits{1}(1);
    x(x >= xlim(2)) = gutterLimits{1}(2);
    y(y <= ylim(1)) = gutterLimits{2}(1);
    y(y >= ylim(2)) = gutterLimits{2}(2);
    X{n} = x;
    Y{n} = y;
end
%%

%% gutterLimits
function gutterLimits = calcGutterLimits(xlim, ylim)
xglim = xlim;
yglim = ylim;
xdiff = abs(diff(xlim))*.02;
ydiff = abs(diff(ylim))*.02;

xglim(1) = xglim(1) - xdiff;
yglim(1) = yglim(1) - ydiff;
xglim(2) = xglim(2) + xdiff;
yglim(2) = yglim(2) + ydiff;

gutterLimits = { xglim, yglim};
%%

%% localLoadData
function [data, params, stats] = localLoadData(varargin, inputNames, defaultParams)
% Get Structures, fieldnames and extra arguments from the command line
% parameters.

% Parse varargin
structIn = {};    % the structures themselves
XFieldNames = {}; % fieldnames for X data
YFieldNames = {}; % fieldnames for Y data
cStruct = 0;      % number of handled plot
while ~isempty(varargin) && isstruct(varargin{1})
    cStruct = cStruct + 1;
    % Format is: KStructPlot(S1, XFiendNames1, YFieldNames1, S2,
    % XFiendNames2, YFieldNames2, ..., parameters)
    if ~ischar(varargin{2}) || ~ischar(varargin{3})
        error(['Wrong arguments for ' mfilename '.']);
    end
    structIn{cStruct} = varargin{1};
    XFieldNames{cStruct} = varargin{2};
    YFieldNames{cStruct} = varargin{3};
    % move on
    
	%by abel: replace { {} } by ()
	%varargin = {varargin{4:end}};
	varargin = varargin(4:end);
end

% Determine filename if it is not set manually, we look for options ds, ds1
% and ds2
strings = varargin(cellfun(@(s) isa(s, 'char'), varargin));
if ~ismember('totalidfields', strings)
    defaultParams.totalidfields = {};
    for cStruct = 1:length(structIn)
        S = structIn{cStruct};
        possibilities = {{'ds.filename', 'ds.seqid'}, ...
            {'ds1.filename', 'ds1.seqid'}, {'ds2.filename', 'ds2.seqid'}};
        possibilityIdx = [possibilities{isfield(S, {'ds', 'ds1', 'ds2'})}];
        if ~isempty(possibilityIdx)
            defaultParams.totalidfields{cStruct} = possibilityIdx;
        end
    end
end

params = processParams(varargin, defaultParams);

%By Abel: Check if the number of inputs in cells equals the number of
%structs
for noe = 1:length(params.checkfornoe)
	isCell = iscell(params.(params.checkfornoe{noe}));
	nCell = length(params.(params.checkfornoe{noe}));
	if isCell && nCell ~= length(structIn)
		error('The number of cell elements in option:%s is not equal to the number of input structs:%d', params.checkfornoe{noe}, length(structIn)); 
	end
end

% load the data for the structs
data = [];
stats = [];
for cStruct = 1:length(structIn)
    data(cStruct).rows = localGetStructData(structIn{cStruct}, ...
        XFieldNames{cStruct}, YFieldNames{cStruct}, params, cStruct);
    data(cStruct).XFieldNames = XFieldNames{cStruct};
    data(cStruct).YFieldNames = YFieldNames{cStruct};
    data(cStruct).name = inputNames{(cStruct-1)*3+1};
end

for cStruct = 1:length(structIn)
    if ~isempty(params.animalidfield)
        if ~isequal(length(params.animalidfield), length(structIn))
            error('You must specify as many animalidfields as there are structs.');
        end
        [values, names] = destruct(structIn{cStruct});
        identifiers = {values{:, ...
            cellfun(@(c) isequal(c,params.animalidfield{cStruct}), names)}}; %#ok<CCAT>
        % Only if the numbers in the identifier differ, do they
        % represent different animals
        stats(cStruct).nAnimals = ...
            length(unique(regexprep(unique(identifiers), '[^0-9]', '')));
    else
        stats(cStruct).nAnimals = length(unique(regexprep( ...
            unique({data(cStruct).rows.fileName}), '[^0-9]', '')));
    end
end
%%

%% localGetStructData
function data = localGetStructData(structIn, XFieldNames, YFieldNames, ...
    params, cStruct)
% fill a structure with essential information from structIn
dollarPosX = strfind(XFieldNames, '$');
isDollarXEmpty = isempty(dollarPosX);
dollarPosY = strfind(YFieldNames, '$');
isDollarYEmpty = isempty(dollarPosY);

data = repmat(struct('X', [], 'Y', []), 1, length(structIn));
for cRow = 1:length( structIn )    
    if isDollarXEmpty
        data(cRow).X = retrieveField( structIn(cRow), XFieldNames );
        data(cRow).X = data(cRow).X{:};
    else
        data(cRow).X = eval(parseExpression( XFieldNames, 'structIn(cRow)' ) );
    end
    
	if isDollarYEmpty
		data(cRow).Y = retrieveField( structIn(cRow), YFieldNames );
		data(cRow).Y = data(cRow).Y{:};
	else
		data(cRow).Y = eval( parseExpression( YFieldNames, 'structIn(cRow)' ) );
	end

    % before checking vector lenghts, process intersectfields
    if ~isempty(params.intersectfields{1}) && ~isempty(params.intersectfields{2})
        original{1} = retrieveField(structIn(cRow), params.intersectfields{1});
        original{2} = retrieveField(structIn(cRow), params.intersectfields{2});
        
        if ~isequal(size(original{1}), size(data(cRow).X)) || ...
                ~isequal(size(original{2}), size(data(cRow).Y))
            error('Intersect fields should have the same sizes as the data fields.');
        end
        
        I = intersect(original{1}, original{2});
        idx1 = zeros(1, length(I));
        idx2 = zeros(1, length(I));
        for i=1:length(I)
            idx1(i) = find(original{1} == I(i));
            idx2(i) = find(original{2} == I(i));
        end
        % Now limit the data to these indices
        data(cRow).X = data(cRow).X(idx1);
        data(cRow).Y = data(cRow).Y(idx2);
    end

    % make row vectors
    if ~isequal( 1, size(data(cRow).X, 1) )
        if ~isequal( 1, size(data(cRow).X, 2) )
            error('XData and YData should be vectors or scalars.');
        end

        data(cRow).X = data(cRow).X';
        data(cRow).Y = data(cRow).Y';
    end

    if ~isequal( size(data(cRow).X), size(data(cRow).Y) )
        error('XData and YData should have the same size');
    end
    
    if ~isempty(params.indexExpr)
        if isa(params.indexExpr, 'cell')
            indexExprOK = find(eval(parseExpression(params.indexExpr{cStruct}, 'structIn(cRow)')));
        else
            indexExprOK = find(eval(parseExpression(params.indexExpr, 'structIn(cRow)')));
        end
        data(cRow).X = data(cRow).X(indexExprOK);
        data(cRow).Y = data(cRow).Y(indexExprOK);
    end
    
    % determine filename
	%by Abel:
	%Format for totalidfields: structIn = single struct array with identical totalidfields
	% if totalidfields is defined for each input struct array ->
	% totalidfields = param.totalidfields{cStruct} and
	% length(param.totalidfields)  = cStruct since param.totalidfields = {
	% {id1, id2}, ...cStruct }
	% if totalidfields is identical for each input struct array (defined
	% only once) then length(param.totalidfields) = 1 since
	% param.totalidfields = {{id1, id2}}
	
    if ~strcmpi(params.ignoreTotalIDFields, 'yes')
        if ~isempty(params.totalidfields)
			if length(params.totalidfields) > 1
				totalidfields = params.totalidfields{cStruct};
			else
				totalidfields = params.totalidfields{1};
			end
			
			if ~iscell(totalidfields)
				totalidfields = { totalidfields };
			end
			
            filePos = strfind(totalidfields, 'filename');
			
			if ~iscell(filePos)
				filePos = {filePos};
			end
			
            for cId = 1:length(filePos)
                if ~isempty(filePos{cId})
                    fileName = retrieveField(structIn(cRow), totalidfields{cId});
                    data(cRow).fileName = fileName{:};
                end
            end
        else
            data(cRow).fileName = '';
        end
    else
        data(cRow).fileName = '';
    end

    data(cRow).cellId = ''; % initialize; fill in in next loop
    
	%by Abel: added "cStruct" index of structure array needed to retrieve params
    data(cRow).buttonDownFcn = localGetButtonDownFcn(structIn(cRow), ...
        data(cRow).fileName, params, cStruct);
end

% derive unique cell identifier from parameter cellidfields
for cId = 1:length(params.cellidfield)
    newField = retrieveField( structIn, params.cellidfield{cId} );
    for cRow = 1:length( structIn )
        if ~ischar(newField{cRow})
            newField{cRow} = num2str(newField{cRow});
        end
        data(cRow).cellId = [data(cRow).cellId '-' newField{cRow}];
    end
end
data = data';
%%

%% localMergeRows
function data = localMergeRows(data)
% merge rows coming from the same cell; use data.cellidfields to determine
% rows coming from the same cell.
cRow = 1;
while cRow < length(data)
    % if this and next row are from the same cell, merge them
    if isequal( data(cRow).cellId, data(cRow+1).cellId )
        %merge
        data(cRow).X = [data(cRow).X data(cRow+1).X];
        data(cRow).Y = [data(cRow).Y data(cRow+1).Y];
        %delete row
        data = [data(1:cRow); data(cRow+2:end)];
    else
    % else, go on to the next row
        cRow = cRow+1;
    end
end

% then sort all vectors
for cRow=1:length(data)
    [data(cRow).X idx] = sort(data(cRow).X);
    data(cRow).Y = data(cRow).Y(idx);
end
%%

%% localGenerateAxisLabels
function label = localGenerateAxisLabels(Fields)
% Generate axes labels from the fieldnames
if  length(Fields) > 1  &&  isequal(Fields{:})
    Fields = unique(Fields);
end
NFields = length(Fields);
labelParts = VectorZip( Fields, repmat({' and '}, 1, NFields) );
labelParts(end) = [];
label = cat(2, labelParts{:});
%%

%% localGetButtonDownFcn
function buttonDownFcn = localGetButtonDownFcn(structIn, structName, params, cStruct)
%  cycle through the rows of the structure array
if ~isempty(params.execevalfnc)
	if iscell(params.execevalfnc)
		buttonDownFcn = params.execevalfnc{cStruct};
	else
		buttonDownFcn = params.execevalfnc;
	end
	
    % parse parameters enclosed by dollar signs
    dollarPos = strfind(buttonDownFcn, '$');
    if ~isequal( 0, mod( length(dollarPos), 2 ) )
        error(['Could not parse params.execevalfnc: expression shouldn''t'...
            'contain odd amount of dollar signs.']);
    end
    while dollarPos
        % first evaluate the parsed field, and convert to a string
        parsedField = retrieveField(structIn, ...
            buttonDownFcn( (dollarPos(1)+1):(dollarPos(2)-1) ));
        parsedField = parsedField{:};
        if ischar(parsedField)
            parsedField = [ '''' parsedField '''' ];
        else
            parsedField = num2str(parsedField);
        end
        % then, put in the buttonDownFcn for that row
        buttonDownFcn = [buttonDownFcn( 1:(dollarPos(1)-1) ) parsedField ...
            buttonDownFcn( (dollarPos(2)+1):end )];
        % and continue the loop...
        dollarPos = strfind(buttonDownFcn, '$');
    end
else
    if ~strcmpi(params.ignoreTotalIDFields, 'yes') && ~isempty(params.totalidfields)
        % get the information to be shown
				
		%by Abel: totalidfields are saved for each input struct separately:
		%cStruct = cell index
		totalIdFields = params.totalidfields{cStruct};
		
        args = {};
        for cField = 1:length(totalIdFields)
            try
                idField = retrieveField(structIn, totalIdFields{cField});
                args = [args, {totalIdFields{cField}, idField{:} }] ;
            catch
                % do nothing
            end
        end
        % if any of the information is numeric, convert to string
        Nidx = find(cellfun('isclass', args, 'double'));
        for idx = Nidx(:)'
            args{idx} = num2str(args{idx}, '%.2f ');
        end

        Txt = [ sprintf(['\\bf\\fontsize{9}Datapoint from %s has following ID'...
            'parameters: \\rm'], structName), sprintf('\\it%s\\rm : %s\n', args{:}) ];
        Txt = regexprep(Txt, '\n', ''', ''');
        buttonDownFcn = ['msgbox({''' Txt '''}'', upper(''' mfilename '''),'...
            'struct(''WindowStyle'', ''non-modal'', ''Interpreter'', ''tex''));'];
    else
        buttonDownFcn = '';
    end
end
%%

%% localSortCellData
function sortedCellData = localSortCellData(data, params)
% if cellidfields is not empty, we need to merge data from unique cells
% (draw lines between points from the same cell)
if ~isempty(params.cellidfield)
    % sort the structure on cellId
    sortedCellData = structsort(data.rows, 'cellId');
    % merge the rows coming from the same cell
    sortedCellData = localMergeRows(sortedCellData);
else
    sortedCellData = data.rows;
end
%%

%% localPlotPanel
function panel = localPlotPanel(XYPlotLines, XYPlotPoints, XFieldNames, ...
    YFieldNames, structNames, params)
% Add all generated plot objects to a KPlot panel

if isequal(params.johnson, 'yes')
    logY = 'yes';
    reverseY = 'yes';
    ylim = [1e-3 1];
    yTicks = 0 : .1 : 1;
    yTickLabels = 1 : -.1 : 0;
else
    logY = 'no';
    reverseY = 'no';
    ylim = [0 0];
    yTicks = {};
    yTickLabels = {};
end

panel = Panel('logY', logY, 'reverseY', reverseY, 'ylim', ylim, ...
    'yTicks', yTicks, 'yTickLabels', yTickLabels, 'nodraw');
for cPlot = 1:length(XYPlotLines)
    panel = addPlot(panel, XYPlotLines(cPlot), 'noredraw');
    panel = addPlot(panel, XYPlotPoints(cPlot), 'noredraw');
end

if params.gutter
    gutterLineStyle = ':';
else
    gutterLineStyle = 'none';
end

xglim = params.gutterLimits{1};
yglim = params.gutterLimits{2};
xlim = params.xlim;
ylim = params.ylim;
panel = addPlot(panel, XYPlotObject({[xglim(1) xglim(2)]}, ...
    {[ylim(1) ylim(1)]}, 'color', 'k', 'marker', 'none', ...
    'linestyle', gutterLineStyle), 'noredraw');
panel = addPlot(panel, XYPlotObject({[xglim(1) xglim(2)]}, ...
    {[ylim(2) ylim(2)]}, 'color', 'k', 'marker', 'none', ...
    'linestyle', gutterLineStyle), 'noredraw');
panel = addPlot(panel, XYPlotObject({[xlim(1) xlim(1)]}, ...
    {[yglim(1) yglim(2)]}, 'color', 'k', 'marker', 'none', ...
    'linestyle', gutterLineStyle), 'noredraw');
panel = addPlot(panel, XYPlotObject({[xlim(2) xlim(2)]}, ...
    {[yglim(1) yglim(2)]}, 'color', 'k', 'marker', 'none', ...
    'linestyle', gutterLineStyle), 'noredraw');

% set labels
XLabel = localGenerateAxisLabels(XFieldNames);
YLabel = localGenerateAxisLabels(YFieldNames);
panel = set(panel, 'xlabel', XLabel, 'ylabel', YLabel, 'noredraw');
panel = set(panel, 'xlim', [xglim(1) xglim(2)], 'ylim', [yglim(1) yglim(2)], ...
    'noredraw');

% adjust position to dispstats
switch lower(params.dispstats)
    case 'no'
        AxPos = [0.10 0.10 0.80 0.80];
    case 'yes'
        AxPos = [0.08 0.08 0.70 0.84]; 
    otherwise
        error('Argument dispstats should be ''yes'' or ''no''.');
end
panel = set(panel, 'position', AxPos, 'ticksdir', 'out', 'noredraw');

% by abel: Add additional options to the panel if they were specified by
% the user
options = params.plotoptions;
for n = 1:length(options)
	if ~isempty(params.(options{n}))
		try
			panel = set(panel, options{n}, params.(options{n}), 'noredraw');
		catch errorSetPanel
			warning('SGSR:Critical', 'Error while setting plot option:%s\nLook at doc panel for valid options.\n', options{n});
			disp(getReport(errorSetPanel));
		end
	end
end

% Draw
defaultPage('KStructPlot');
panel = redraw(panel);
hdl = gcf;
set(hdl, 'name', ['Figure ' num2str(hdl) ': KStructPlot']);

% Add legend
legendHdls = getFirstHandles(panel);
% keep even entries only (they contain the markers) and exclude the gutter
% markers
legendHdls = legendHdls(2:2:end-4);
[legendHdls, nanIdx] = denan(legendHdls);
allHdls = getHandles(panel);
labels = repmat({''}, 1, length(allHdls));
idx = ismember(allHdls, legendHdls);

if ~isempty(params.legend)
	labels(idx) = params.legend;
else
	labels(idx) = structNames(nanIdx);
end

if isempty(params.legendParam)
	lObj = legendObject('textlabels', labels);
else
	lObj = legendObject('textlabels', labels, params.legendParam{:});
end

panel = addLegend(panel, lObj);


%% localPlotStats
function localPlotStats(panel, structNames, stats)

structLabels = [];
nAnimals = [];
nCells = [];
nDots = [];
for cStruct = 1:length(structNames)
    structLabels = [structLabels structNames{cStruct} ', '];
    nCells = [nCells num2str(stats(cStruct).nCells) ', '];
    nAnimals = [nAnimals num2str(stats(cStruct).nAnimals) ', '];
    nDots = [nDots num2str(stats(cStruct).nDots) ', '];
end
structLabels = structLabels(1:end-2);
nAnimals = nAnimals(1:end-2);
nCells = nCells(1:end-2);
nDots = nDots(1:end-2);

statsText = {'\bfStatistics\rm'; ...
    ['\it', structLabels, '\rm']; ...
    ['\it#Animals:\rm ', nAnimals]; ...
    ['\it#Cells:\rm ', nCells]; ...
    ['\it#Dots:\rm ', nDots]; ...
    ''; ...
    ['\bfDate:\rm ', date]};

%generate new axes object
axes('Position', [0.80 0.70 0.15 0.25], 'Visible', 'off');

%add text box to the object
text(0, 0.5, statsText, 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
    'Color', 'k', 'FontSize', 8, 'Interpreter', 'tex');

%make panel object the current axes object again and the first child of the cfg
%object.
axes(getHdl(panel));
%%

%% returnPlottedData
% by Abel: Return the plotted data in the original format of the input struct 
function dataStruct = returnPlottedData (X, Y, data, xlim, ylim)
dataStruct = [];

% - Determine cleaned fieldnames
xField = cleanFields_(data.XFieldNames);
yField = cleanFields_(data.YFieldNames);
if (strcmp(xField, yField))
	yField = [yField '_modified'];
end

% - Build and return struct 
for n=1:length(X)
	
	if isempty(X{n})
		x = nan;
		[x, y] = deal(nan);
	else
		[x, y] = deal(X{n}, Y{n});
		outOfXlim = any(x < xlim(1)) || any(x > xlim(2));
		outOfYlim = any(y < ylim(1)) || any(y > ylim(2));
		if outOfXlim || outOfYlim
			[x, y] = deal(nan);
		end
	end

	cmd{1} = ['dataStruct(' num2str(n) ').' xField '=' '[x];'];
	cmd{2} = ['dataStruct(' num2str(n) ').' yField '=' '[y];'];
	cmd{3} = ['dataStruct(' num2str(n) ').name=[''' data.name '''];'];
	eval(cmd{1});
	eval(cmd{2});
	eval(cmd{3});
end
%%

%% cleanFields
% by Abel: remove any matlab code and delimiters from input and return clean leaf
% name.
function fieldName = cleanFields_(fieldName)
dollarPos = strfind(fieldName, '$');

if isempty(dollarPos)
	return;
end

if ~isequal( 0, mod( length(dollarPos), 2 ) )
	error('Could not parse fieldName: %s expression shouldn''t contain odd amount of dollar signs.', fieldName);
end

%remove all before first '$' and all behind second '$'
idx = [ (dollarPos(1) +1):(dollarPos(2) -1)];
fieldName  = fieldName(idx);
%%

%% fitSpline
% by Abel: fit cubic spline
%Spline-fitting requires at least two datapoints. Spline-fitting is done on all datapoints,
%but sampling is only done on intervals between included datapoints. This is to avoid
%extreme curves near the end ...
function [X, Y] =  fitSpline_(X, Y, fitRatio)	

%return if X a single point
if size(X, 2) == 1
	return
end

%generate X-values for fit based on average increment of the X values and
%a ratio X data versus X fitted values
for n=1:length(X)
	avgXincrement = mean(diff(X{n}));
	minX = min(X{n});
	maxX = max(X{n});
% 	minY = min(Y{n});
% 	maxY = max(Y{n}); 
	xFit = minX:avgXincrement/fitRatio:maxX;
	
	%fit spline
%	pp = spline(X{n}, [minY, Y{n}, maxY]);
 	pp = spline(X{n}, Y{n});
	X{n} = xFit;
	Y{n} = ppval(pp,xFit);
end

%%
	