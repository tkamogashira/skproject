function ArgOut = barplus(varargin)
%BARPLUS  create bar graph.
%   BARPLUS(BarCenters, BarLength) creates a bar graph where the bars are 
%   specified by their centers and lengths. This assumes that the width
%   of the bars is uniform.
%   BARPLUS(BarEdges, BarLength) creates a bar graph where the bars are 
%   specified by their edges and lengths.
%
%   Hdls = BARPLUS(...) returns a vector of patch handles.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.
%
%   See also BAR

%B. Van de Sande 14-08-2005

%------------------------Properties and their default values-----------------------
DefProps.style      = 'bars'; %Draw edges around every bar or only around the total
                              %histogram (values must be 'bars', 'outline' or 
                              %'line') ...
DefProps.barcolor   = 'b';    %The color of the bars (Values can be color symbols or
                              %RGB vectors. When supplying a matrix with the same
                              %number of rows as there are bars, then each bar gets
                              %a different color) ...
DefProps.barwidth   = 1;      %The with of the bars (values > 1 produce overlapping
                              %bars) ...
DefProps.linecolor  = 'k';    %The color of the bar edges or the outline ... 
DefProps.linestyle  = '-';    %The style of the bar edges ...
DefProps.linewidth  = 0.5;    %The width of the bar edges in points ...
DefProps.numtol     = 1e-4;   %Numerical tolerance ...

%-------------------------------Main program--------------------------------------
%Evaluate input arguments ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    disp('Properties and their factory defaults:');
    disp(DefProps);
    return;
else, [BarCenters, BarEdges, BarLengths, Props] = ParseArgs(DefProps, varargin{:}); end

%Actual creation of bar graph ...
if strcmpi(Props.style, 'bars'), %Creating patch for each individual bar ...
    NBars = length(BarEdges)-1; Hdls = zeros(NBars, 1);
    for n = 1:NBars,
        BarWidth = diff(BarEdges([n, n+1])); Frac = (BarWidth*(1-Props.barwidth)/2);
        X = [BarEdges([n n])+Frac, BarEdges([n n]+1)-Frac]; Y = [0, BarLengths([n n]), 0];
        Hdls(n) = patch(X, Y, Props.barcolor(n, :), 'edgecolor', Props.linecolor, ...
            'linestyle', Props.linestyle, 'linewidth', Props.linewidth);
    end
elseif strcmpi(Props.style, 'outline'), %Creating one patch for the whole histogram ...
    X = mmrepeat(BarEdges, 2); Y = [0, mmrepeat(BarLengths, 2), 0];
    Hdls = patch(X, Y, Props.barcolor, 'edgecolor', Props.linecolor, ...
        'linestyle', Props.linestyle, 'linewidth', Props.linewidth);
elseif strcmpi(Props.style, 'line'), %Creating one patch for the whole histogram ...
    X = [BarCenters(1) BarCenters BarCenters(end)]'; Y = [0 BarLengths 0];
    Hdls = patch(X, Y, Props.barcolor, 'edgecolor', Props.linecolor, ...
        'linestyle', Props.linestyle, 'linewidth', Props.linewidth);
end

%Setting axes properties related to the abcissa ...
set(gca, 'xtick', BarEdges(1:end-1) + diff(BarEdges)/2, 'xticklabelmode', 'auto', ...
    'xlim', BarEdges([1, end]));

%Return patch handles if requested ...
if (nargout > 0), ArgOut = Hdls; end

%------------------------------Local functions------------------------------------
function [BarCenters, BarEdges, BarLengths, Props] = ParseArgs(DefProps, varargin)

%Checking secondary mandatory input argument ...
NArgs = length(varargin); if (NArgs < 2), error('Wrong number of input arguments.'); end
if ~isnumeric(varargin{2}) | ~any(size(varargin{2}) == 1), error('Second argument should be numerical vector with bar lengths.'); end
BarLengths = varargin{2}(:)'; NBars = length(BarLengths);

%Retrieving properties and checking their values ...
Props = CheckPropList(DefProps, varargin{3:end});
Props = CheckProps(Props, NBars);

%Checking first mandatory input argument ...
if ~isnumeric(varargin{1}) | ~any(size(varargin{1}) == 1), error('First argument should be numerical vector with bar edges or centers.'); end
if (length(varargin{1}) == (NBars+1)), 
   BarEdges = varargin{1}(:)';
   BarCenters = [];
   for c = 1:Nbars,
      BarCenters = [BarCenters (BarEdges(c)+BarEdges(c+1))/2];
   end
elseif (length(varargin{1}) == NBars), 
   BarEdges = Centers2Edges(varargin{1}(:)', Props.numtol);
   BarCenters = varargin{1};
else, error('Number of bar lengths supplied is inconsistent with number of bar centers/edges given.'); end    

%---------------------------------------------------------------------------------
function Props = CheckProps(Props, NBars)

if ~any(strcmpi(Props.style, {'bars', 'outline', 'line'})), error('Property style should be ''bars'' or ''outline''.'); end

if ~iscolor(Props.barcolor), error('Invalid value for property barcolor.'); end
if ischar(Props.barcolor), Props.barcolor = ColSym2RGB(Props.barcolor); end
NCol = size(Props.barcolor, 1);
if strcmpi(Props.style, 'bars') & (NCol == 1), Props.barcolor = repmat(Props.barcolor, NBars, 1); end
if (NCol > 1) & (strcmpi(Props.style, 'outline') | ~isequal(NCol, NBars)), error('Incorrect number of colors supplied for bars.'); end

if ~isnumeric(Props.barwidth) | (length(Props.barwidth) ~= 1) | (Props.barwidth <= 0), error('Invalid value for property barwidth.'); end

if ~iscolor(Props.linecolor), error('Invalid value for property linecolor.'); end
if ~ischar(Props.linestyle) | ~ismember(Props.linestyle, {'none', '-', ':', '--', '-.'}), error('Invalid value for property linestyle.'); end
if ~isnumeric(Props.linewidth) | (length(Props.linewidth) ~= 1) | (Props.linewidth <= 0), error('Invalid value for property linewidth.'); end

if ~isnumeric(Props.numtol) | (length(Props.numtol) ~= 1) | (Props.numtol <= 0), error('Invalid value for property numtol.'); end

%---------------------------------------------------------------------------------
function BE = Centers2Edges(BC, NumTol)

%BinWidths = diff(BC); BinWidth = unique(BinWidths);
%if (length(BinWidth) ~= 1), error('Bar centers can only be specified when uniform bar width is used.'); end
BinWidth = GetBinWidth(BC, NumTol);
BE = [BC-BinWidth/2, BC(end)+BinWidth/2];

%---------------------------------------------------------------------------------
function BinWidth = GetBinWidth(BC, NumTol)

if (length(unique((round(diff(BC)/NumTol)*NumTol))) ~= 1), 
    error('Bar centers can only be specified when uniform bar width is used.'); 
end
BinWidth = mean(diff(BC));

%---------------------------------------------------------------------------------