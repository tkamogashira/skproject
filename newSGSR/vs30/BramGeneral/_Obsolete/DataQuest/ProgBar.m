function Hdl = ProgBar(varargin)
%PROGBAR    Display progression bar.
%   Hdl = PROGBAR(Caption, Str, Frac) creates and displays a progbar
%   of fractional length Frac. The handle to the progbar figure is
%   returned in Hdl. Frac should be between 0 and 1. The caption string
%   and the string above the progression bar must also be specified.
%   If Frac is a vector, multiple progression bars are displayed in
%   the figure.
%
%   PROGBAR(Hdl, Frac) will set the length of the bar in progbar Hdl
%   to the fractional length Frac.
%
%   PROGBAR(Hdl, Frac, Str) will update the title text in the progbar
%   figure, in addition to setting the fractional length to Frac.

%B. Van de Sande 18-06-2004
%Used WAITBAR.M as template ...

%Check input arguments ...
if (nargin == 3) & ischar(varargin{1}),
    [Caption, Str, Frac] = deal(varargin{:});
    Hdl = SetupProgBar(Caption, Str, Frac);
elseif any(nargin == [2, 3]) & ishandle(varargin{1}),
    [Hdl, Frac] = deal(varargin{1:2});
    if (nargin == 2), UpdateProgBar(Hdl, Frac);
    else, 
        Str = varargin{3};
        UpdateProgBar(Hdl, Frac, Str); 
    end   
else, error('Input arguments are not valid.'); end

if (nargout == 0), clear('Hdl'); end

%-----------------------------------------------------------------------------
function FigHdl = SetupProgBar(Caption, Str, Frac)

NBars = length(Frac);
Str   = cellstr(Str);
if (length(Str) == 1), Str = repmat(Str, NBars, 1);
elseif ~isequal(length(Str), NBars), error('Number of bars and number of title strings should be equal.'); end

%Create figure ...
oldRootUnits = get(0, 'Units'); set(0, 'Units', 'points');
ScreenSize = get(0, 'ScreenSize');
PointsPerPixel = 72/get(0, 'ScreenPixelsPerInch');
BtnHeight    = 23 * PointsPerPixel;
BtnWidth     = 60 * PointsPerPixel;
BarSpacing   = 35 * PointsPerPixel;
BarHeight    = 15 * PointsPerPixel; 
LowerSpacing = 15 * PointsPerPixel;
Width        = 360 * PointsPerPixel;
Height       = 2*LowerSpacing + BtnHeight + NBars*(BarSpacing+BarHeight);
Pos = [ScreenSize(3)/2-Width/2 ScreenSize(4)/2-Height/2 Width Height];

FigHdl = figure('Name', Caption, ...
      'Units', 'points', ...
      'BusyAction', 'queue', ...
      'Position', Pos, ...
      'Resize','off', ...
      'CreateFcn','', ...
      'NumberTitle','off', ...
      'IntegerHandle','off', ...
      'MenuBar', 'none', ...
      'Tag', mfilename,...
      'Interruptible', 'off', ...
      'Visible','off');

%Create cancel button ...  
BtnPos = [(Width-BtnWidth)/2, LowerSpacing, BtnWidth, BtnHeight];
CallBackFcn = 'close(gcf);';
BtnHdl = uicontrol('Parent', FigHdl, ...
      'Units', 'points', ...
      'Callback', CallBackFcn, ...
      'ButtonDownFcn', CallBackFcn, ...
      'Enable', 'on', ...
      'Interruptible', 'off', ...
      'Position', BtnPos, ...
      'String', 'Cancel', ...
      'Tag', 'CancelButton');

%Create progression bars ...
AxFontSize = get(0, 'FactoryAxesFontSize');
for n = 1:NBars,  
    AxPos = [.05*Width Height-n*(BarSpacing+BarHeight) .90*Width 15];
    AxHdl = axes('XLim', [0 100], 'YLim', [0 1],...
        'Box','on', ...
        'Units','Points',...
        'FontSize', AxFontSize,...
        'Position', AxPos,...
        'XTickMode','manual',...
        'YTickMode','manual',...
        'XTick',[],...
        'YTick',[],...
        'XTickLabelMode','manual',...
        'XTickLabel',[],...
        'YTickLabelMode','manual',...
        'YTickLabel',[], ...
        'Tag', sprintf('ProgBar%d', n));

    Xpatch = [0 Frac(n) Frac(n) 0]*100; Ypatch = [0 0 1 1];
    Xline = [100 0 0 100 100]; Yline = [0 0 1 1 0];
  
    PHdl = patch(Xpatch, Ypatch, 'r', 'EdgeColor', 'r', 'EraseMode', 'normal');
    LHdl = line(Xline, Yline, 'EraseMode', 'normal', 'Color', get(AxHdl, 'XColor'));
    
    title(Str{n});
end

set(FigHdl, 'HandleVisibility', 'callback', 'visible', 'on');
set(0, 'Units', oldRootUnits);

%Refresh output ...
drawnow;

%-----------------------------------------------------------------------------
function UpdateProgBar(Hdl, Frac, Str)

if ~strcmpi(get(Hdl, 'Tag'), mfilename), error('Invalid handle.'); end

NBars = length(findobj(Hdl, 'Type', 'axes'));
for n = 1:NBars,
    AxHdl = findobj(Hdl, 'Tag', sprintf('ProgBar%d', n));
    PtHdl = findobj(AxHdl, 'Type', 'patch');
    LnHdl = findobj(AxHdl, 'Type', 'line');
    
    set(PtHdl, 'XData', [0 Frac(n) Frac(n) 0]*100);
    set(LnHdl, 'XData', get(LnHdl, 'XData'));
    
    %Update title if necessary ...
    if (nargin > 2), set(get(AxHdl, 'title'), 'String', Str{n}); end
end    
  
%Refresh output ...
drawnow;

%-----------------------------------------------------------------------------