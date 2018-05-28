function AxHdl = SubPlotPlus(varargin)
%SUBPLOTPLUS    create axes in tiled positions.
%   Hdl = SUBPLOTPLUS(nrOfRows, nrOfColumns, plotNr)
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.
%
%   See also SUBPLOT

%Bram Van de Sande 22-04-2005

%------------------------------------default parameters---------------------------------
DefParam.uppermargin  = 0.08;
DefParam.lowermargin  = 0.08;
DefParam.leftmargin   = 0.08;
DefParam.rightmargin  = 0.08;
DefParam.veraxspacing = 0.10;
DefParam.horaxspacing = 0.10;
DefParam.figurehandle = gcf;

%--------------------------------------main program-------------------------------------
%Evaluate input arguments ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    disp('Properties and their factory defaults:');
    disp(DefParam);
    return;
else, [nrOfRows, nrOfColumns, plotNr, Param] = ParseArgs(DefParam, varargin{:}); end

%Create axis object with requested value for position property ...
Width  = (1 - Param.leftmargin - Param.rightmargin - Param.horaxspacing*(nrOfColumns-1))/nrOfColumns;
Height = (1 - Param.uppermargin - Param.lowermargin - Param.veraxspacing*(nrOfRows-1))/nrOfRows;
nX = mod((plotNr-1),nrOfColumns)+1;
nY = nrOfRows - floor((plotNr-1)/nrOfColumns);
X  = Param.leftmargin + (Param.horaxspacing + Width)*(nX-1);
Y  = Param.lowermargin + (Param.veraxspacing + Height)*(nY-1);
Pos = [X, Y, Width, Height];
AxHdl = axes('Position', Pos, 'Parent', Param.figurehandle);

%----------------------------------------locals-----------------------------------------
function [nrOfRows, nrOfColumns, plotNr, Param] = ParseArgs(DefParam, varargin)

%Checking input arguments ...
if (length(varargin) < 3), error('Wrong number of input arguments.'); end
if ~isnumeric(varargin{1}) | (length(varargin{1}) ~= 1) | (varargin{1} < 0),
    error('First argument should be number of rows of figure.');
end
if ~isnumeric(varargin{2}) | (length(varargin{2}) ~= 1) | (varargin{2} < 0),
    error('Second argument should be number of columns of figure.');
end
if ~isnumeric(varargin{3}) | (length(varargin{3}) ~= 1) | (varargin{3} < 0) | (varargin{3} > prod([varargin{1:2}])),
    error('Third argument should be plot number.');
end
[nrOfRows, nrOfColumns, plotNr] = deal(varargin{1:3});

%Retrieving properties and checking their values ...
Param = CheckPropList(DefParam, varargin{4:end});
CheckParam(Param);

%---------------------------------------------------------------------------------------
function CheckParam(Param)

if ~isnumeric(Param.leftmargin) | (length(Param.leftmargin) ~= 1) | (Param.leftmargin < 0) | (Param.leftmargin > 1), 
    error('Invalid value for property ''leftmargin''.'); 
end
if ~isnumeric(Param.rightmargin) | (length(Param.rightmargin) ~= 1) | (Param.rightmargin < 0) | (Param.rightmargin > 1), 
    error('Invalid value for property ''rightmargin''.'); 
end
if ~isnumeric(Param.lowermargin) | (length(Param.lowermargin) ~= 1) | (Param.lowermargin < 0) | (Param.lowermargin > 1), 
    error('Invalid value for property ''lowermargin''.'); 
end
if ~isnumeric(Param.uppermargin) | (length(Param.uppermargin) ~= 1) | (Param.uppermargin < 0) | (Param.uppermargin > 1), 
    error('Invalid value for property ''uppermargin''.'); 
end
if ~isnumeric(Param.horaxspacing) | (length(Param.horaxspacing) ~= 1) | (Param.horaxspacing < 0) | (Param.horaxspacing > 1), 
    error('Invalid value for property ''horaxspacing''.'); 
end
if ~isnumeric(Param.veraxspacing) | (length(Param.veraxspacing) ~= 1) | (Param.veraxspacing < 0) | (Param.veraxspacing > 1), 
    error('Invalid value for property ''veraxspacing''.'); 
end
if ~isnumeric(Param.figurehandle) | (length(Param.figurehandle) ~= 1) | ~ishandle(Param.figurehandle) | ...
        ~strcmpi(get(Param.figurehandle, 'type'), 'figure'), 
    error('Invalid value for property ''figurehandle''.'); 
end

%---------------------------------------------------------------------------------------