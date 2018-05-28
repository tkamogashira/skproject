function [figH, param] = plotPage(varargin)
%PLOTPAGE            Plots one or more KPlot() panels on a figure. Plots
%                    are devided over the figures by subplot()
% DESCRIPTION
%                    Plots are devided over the figures by subplot(). An
%                    optional header and DateString may be added.
% 
% INPUT
% 	defParam.headerObject = [];      %A headerObject panel 
% 	defParam.panelObjects = [];      %An array of panel()'s to be plotted
% 	defParam.dateStringObject = [];  %A Date string panel
% 	defParam.pageName = pageName;    %Title for the figure page
% 	defParam.pageFunction = defaultPage(''' pageName '''); %Function handle
% 	                                 %to create the figure. Default = defaultPage() 
% 	defParam.maxPlotsPerPage = 9;
% 	defParam.maxPlotsPerRow = 3;
% 	defParam.formatWide = true;
% 	defParam.nrofrows = 7;
% 	defParam.nrofcols = 6;
% 	defParam.plotpositions = [];     %Enter subplot() positions manually
% 	defParam.repeatHeader = false;   %Repeat HeaderObject() when starting a
% 	                                  new figure().
% 	defParam.intraHmarginFactor = 1; %Extra horizantal margin between plots
% 	defParam.intraVmarginFactor = 1; %Extra vertical margin between plots
%   defParam.startPosHeader = 2;     %Start header at subplot position
%
%
% OUTPUT
%   figH            %Array of figure handles
%   param           %struct of used parameters
%
% SEE ALSO
%         headerPanel  panel dateStringPanel


%% ---------------- CHANGELOG ------------------------
%  Wed Jun 8 2011  Abel   
%   Initial creation

%% ---------------- Default parameters ---------------
defParam.headerObject = [];
defParam.panelObjects = [];
defParam.dateStringObject = [];
%Set name of caller as default page name, use defaultPage are page creator
stack = dbstack('-completenames');
pageName = stack(end).name;
defParam.pageName = pageName;
defParam.pageFunction = ['defaultPage(''' pageName ''')'];
defParam.maxPlotsPerPage = 9;
defParam.maxPlotsPerRow = 3;
defParam.formatWide = true;
defParam.nrofrows = 7;
defParam.nrofcols = 6;
defParam.plotpositions = [];
defParam.repeatHeader = false;
defParam.intraHmarginFactor = 1;
defParam.intraVmarginFactor = 1;
defParam.startPosHeader = 2;

figH = [];

%% ---------------- Main function --------------------
% Return params if nargin<1 / factory
if nargin<1 || strcmpi('factory', varargin{1})
	figH = defParam;
	return;
end

%% Check arguments
%Get input params
param = getArguments(defParam, varargin);

%Type checks
param.gotHeader = ~isempty(param.headerObject) && isa(param.headerObject, 'Panel');
param.gotPanels = ~isempty(param.panelObjects) && isa(param.panelObjects, 'Panel');
param.gotDateString = ~isempty(param.dateStringObject) && isa(param.dateStringObject, 'Panel');
if ~param.gotPanels
	error('no data to plot, plz include ''panelObjects''');
end

%% Loop over plotPage() if nrOfPlots > maxPlotsPerPage
nrOfPlots = length(param.panelObjects);

if (nrOfPlots > param.maxPlotsPerPage)
	nrOfPlotsInLastLoop = mod(nrOfPlots, param.maxPlotsPerPage) -1;
	nrOfLoops = floor(nrOfPlots/param.maxPlotsPerPage) + ...
		(nrOfPlotsInLastLoop ~= 0); %if nrOfPlots is not n*param.maxPlotsPerPage
	                                %we do an extra loop with the remaining plots
	
	loopCount = 1;                                  
	while (loopCount <= nrOfLoops)
		start = (loopCount -1) * param.maxPlotsPerPage + 1;
		if loopCount < nrOfLoops
			stop = start + param.maxPlotsPerPage -1;
		else
			stop = start + nrOfPlotsInLastLoop;
		end
					
		%Get new params
		tempParam = param;
		tempParam.panelObjects = tempParam.panelObjects(start:stop);
		%first run with header (if defined). Sequential runs: repeatHeader?
		if start ~= 1 && ~param.repeatHeader && param.gotHeader
			tempParam.headerObject = [];
		end
		
		%Start loop
		figH = [figH plotPage(tempParam)];	
		loopCount = loopCount +1;
	end
	
	%return
	return;
end

%% Calculate the subplot positions
%Take userdefined if given
if ~isempty(param.plotpositions)
	plotPositions = param.plotpositions;
else
	[plotPositions, param] = calcPlotPos_(param);
end

%% Plot everything
%start Page
eval(param.pageFunction);
figH = [];
figCounter = 1;
%dateString
if param.gotDateString
	figH(figCounter) = subplot(param.nrofrows, param.nrofcols, param.nrofcols * param.nrofrows, 'Visible', 'off');
	redraw(param.dateStringObject);
	figCounter = figCounter + 1;
end


%header: save positions
%draw header last since the annotation('textbox') uses outer position
%params which may lead to problems? 
if param.gotHeader
	param.headPosition = plotPositions{1};
	plotPositions = plotPositions(2:end);
end

%Panels
% - Include extra margin space between plots if needed
gotMargin = param.intraHmarginFactor ~= 1 || param.intraVmarginFactor ~= 1;

for n=1:length(plotPositions)
	figH(figCounter) = subplot(param.nrofrows, param.nrofcols, [plotPositions{n}],...
		'ActivePositionProperty', 'OuterPosition');   
	%Using the OuterPosition property as the ActivePositionProperty is an 
	%effective way to prevent titles and labels from being overwritten when 
	%there are multiple axes in a figure.
	
	redraw(param.panelObjects(n));
	
	%Apply extra margins needed
	if gotMargin
		outerPosition = get(figH(figCounter), 'OuterPosition'); %[left bottom width height]
		outerPosition(3) = outerPosition(3) * param.intraHmarginFactor;
		outerPosition(4) = outerPosition(4) * param.intraVmarginFactor;
		set(figH(figCounter), 'OuterPosition', outerPosition);
	end
	
	figCounter = figCounter + 1;
end

%draw header last to avoid disappearance by subplot()
if param.gotHeader
	%'Visible', 'off' -> for text. To avoid a axes to be drawn before the
	%text is displayed
	figH(figCounter) = subplot(param.nrofrows, param.nrofcols, param.headPosition, 'Visible', 'off');
	
	%set Postiontion of header panel to the axis from subplot
	subPlotPos = get(figH(figCounter), 'Position');
	param.headerObject = set(param.headerObject, 'Position', subPlotPos, 'noredraw');
	
	redraw(param.headerObject);
	figCounter = figCounter + 1;
end

end
%% ---------------- Local functions ------------------
%% calcPlotPos: Calculates the subplot positions
function [plotPositions, param] = calcPlotPos_(param)

%Nr of plots
nrOfPlots = length(param.panelObjects);
plotPositions = {};
nrFirstCell = 1;
rowSpanPlots = [];

%If no header, remove first row from subplot
%Else reserve the first row for the header
if ~param.gotHeader
	param.nrofrows = param.nrofrows -1;
	rowSpanPlots = param.nrofrows;            %Total nr of rows available for the plot
else
	rowSpanPlots = param.nrofrows - 1;        %Total nr of rows available for the plot
	plotPositions{1} = [param.startPosHeader, abs(param.nrofcols - 1)]; %Position for header
	nrFirstCell = nrFirstCell + param.nrofcols;      %Shift remaining pos
end
nrOfCells = param.nrofcols * param.nrofrows;

%If only one plot just spread it over all cells
if nrOfPlots == 1
	plotPositions{end+1} = nrFirstCell:nrOfCells;
	return;
end

%Set nr of rows
nrOfRows = 1 + floor(nrOfPlots/param.maxPlotsPerRow);
if nrOfPlots ~= param.maxPlotsPerRow && mod(nrOfPlots, param.maxPlotsPerRow) == 0
	nrOfRows = nrOfRows -1;
end
	
% maxNrOfRows = param.maxPlotsPerPage / param.maxPlotsPerRow;

%Set max nr of plots
% Only one row needed -> just fill up the row 
if nrOfPlots < param.maxPlotsPerRow			%<3
	maxNrOfPlotsPerRow = nrOfPlots;			
elseif nrOfPlots < 2*param.maxPlotsPerRow -1	%<5
	maxNrOfPlotsPerRow = param.maxPlotsPerRow - 1;
else
	maxNrOfPlotsPerRow = param.maxPlotsPerRow;
end
rowSpan = rowSpanPlots/nrOfRows;
colIncrement = (param.nrofcols / maxNrOfPlotsPerRow) -1;
plotCounter = 0;

%Loop over rows
for row = [1:nrOfRows]
	%Loop over cols 
	for col=1:maxNrOfPlotsPerRow
		plotPositions{end+1} = incrementPositions_(nrFirstCell, colIncrement, rowSpan, param.nrofcols);
		nrFirstCell = nrFirstCell + colIncrement + 1;
		plotCounter = plotCounter + 1;
		
		if plotCounter == nrOfPlots
			break;
		end
		
	end
	%Add row to nrFirstCell
	nrFirstCell = nrFirstCell + ((rowSpan -1 ) * param.nrofcols);
end

end

function positions = incrementPositions_(start, colIncrement, rowSpan, nrOfCols)
rowNr = 1;
positions = [];
while (rowNr <= rowSpan)
	last = start+colIncrement;
	positions = [positions start:last];
	rowNr = rowNr + 1;
	start = start + nrOfCols;  %position at new row
end
end




