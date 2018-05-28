function Hdl = PutPlot(FigHdl, AxHdl, varargin)
%PUTPLOT   copy axes object on a figure
%   PUTPLOT(FigHdl, AxHdl) puts the axes object given by the handle AxHdl on the
%   figure with handle FigHdl. The axes object is copied.
%   PUTPLOT(FigHdl, AxHdl, LocStr) puts the axes object on the specified figure
%   with location specified by the character string LocStr. This string can be 'ul'
%   (Upper Left corner), 'll'(Lower Left corner), 'ur'(Upper Right corner) and 'lr'
%   (Lower Right corner).
%   PUTPLOT(FigHdl, AxHdl, NX, NY, N) puts the axes object on the specified figure
%   with location specified as a number in a grid. The grid elements of the abcis
%   is given by NX, the ordinate grid is specified by NY. The rectangles in the grid
%   are numbered from left to right and from top to bottom.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.
%
%   See also GETPLOT

%B. Van de Sande 28-04-2004

%Default parameters ...
DefParam.leftmargin   = 0.10;
DefParam.rightmargin  = 0.05;
DefParam.lowermargin  = 0.10;
DefParam.uppermargin  = 0.10;
DefParam.horaxspacing = 0.10;
DefParam.veraxspacing = 0.10;

%Checking input arguments ...
if (nargin == 1) & ischar(FigHdl) & strcmpi(FigHdl, 'factory'),
    disp('Properties and their factory defaults:')
    disp(DefParam);
    return;
elseif (nargin < 2), error('Wrong number of input arguments.'); end
if ~ishandle(FigHdl) | ~strcmpi(get(FigHdl, 'Type'), 'figure'), error('First argument should be handle of figure object.'); end
if ~ishandle(AxHdl) | ~strcmpi(get(AxHdl, 'Type'), 'axes'), error('Second argument should be handle of axes object.'); end

if (nargin == 2), 
    NX = 1; NY = 1; N = 1; Pidx = 1;
elseif (nargin == 3) | ischar(varargin{1}),
    LocStr = lower(varargin{1});
    if ~any(strcmp(LocStr, {'ul', 'll', 'lr', 'ur'})), error('Invalid location string.'); end
    NX = 2; NY = 2;
    switch LocStr
    case 'll', N = 3; %Axes object in lower left corner ...
    case 'ur', N = 2; %Axes object in upper right corner ...
    case 'ul', N = 1; %Axes object in upper left corner ...
    case 'lr', N = 4; %Axes object in lower right corner ...
    end
    Pidx = 2;
elseif (nargin == 5) | isnumeric(varargin{1}),
    [NX, NY, N] = deal(varargin{1:3});
    if (length(NX) ~= 1) | (NX <= 0)| (mod(NX, 1) ~= 0), error('Grid elements for abcis should be positive integer.'); end
    if (length(NY) ~= 1) | (NY <= 0)| (mod(NY, 1) ~= 0), error('Grid elements for ordinate should be positive integer.'); end
    if (length(N) ~= 1) | (N <= 0)| (mod(N, 1) ~= 0), error('Axes position should be positive integer.'); end
    if (N > (NX*NY)), error('Position doesn''t exist.'); end
    Pidx = 4;
else, error('Wrong number of input arguments.'); end   

%Retrieving properties and checking their values ...
Param = CheckPropList(DefParam, varargin{Pidx:end});
CheckParam(Param);

%Actual operations ...
Width  = (1 - Param.leftmargin - Param.rightmargin - Param.horaxspacing*(NX-1))/NX;
Height = (1 - Param.uppermargin - Param.lowermargin - Param.veraxspacing*(NY-1))/NY;
nX = mod((N-1),NX)+1;
nY = NY - floor((N-1)/NX);
X  = Param.leftmargin + (Param.horaxspacing + Width)*(nX-1);
Y  = Param.lowermargin + (Param.veraxspacing + Height)*(nY-1); 

Hdl = copyobj(AxHdl, FigHdl);
set(Hdl, 'Position', [X, Y, Width, Height]);

%----------------------------------------------------------------------------
function CheckParam(Param)

if ~isnumeric(Param.leftmargin) | (length(Param.leftmargin) ~= 1) | (Param.leftmargin < 0), 
    error('Invalid value for property leftmargin.'); 
end
if ~isnumeric(Param.rightmargin) | (length(Param.rightmargin) ~= 1) | (Param.rightmargin < 0), 
    error('Invalid value for property rightmargin.'); 
end
if ~isnumeric(Param.lowermargin) | (length(Param.lowermargin) ~= 1) | (Param.lowermargin < 0), 
    error('Invalid value for property lowermargin.'); 
end
if ~isnumeric(Param.uppermargin) | (length(Param.uppermargin) ~= 1) | (Param.uppermargin < 0), 
    error('Invalid value for property uppermargin.'); 
end
if ~isnumeric(Param.horaxspacing) | (length(Param.horaxspacing) ~= 1) | (Param.horaxspacing < 0), 
    error('Invalid value for property horaxspacing.'); 
end
if ~isnumeric(Param.veraxspacing) | (length(Param.veraxspacing) ~= 1) | (Param.veraxspacing < 0), 
    error('Invalid value for property veraxspacing.'); 
end

%----------------------------------------------------------------------------