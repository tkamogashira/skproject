function Hnew = rightaxis(H, Ytick, YtickLabel, varargin);
% rightAxis - add right Y-Axis to existing Axes system
%    rightaxis(H) adds a zero-width axes system to the axes with handle H.
%    The new axes has the same limits (YLIM) as the old one, and is linked
%    to it. RightAxis returns a handle to the new axes system, whose handle
%    visibility is set to 'off' to prevent accidentally plotting to it.
%
%    rightaxis(H, Xtick, XtickLabel) also specifies Xtick values and
%    corresponding labels.
%
%    rightaxis(H, Xtick, XtickLabel, Prop, Val , ...) specifies additional
%    property/value pais of the new axes.
%
%    See also linkaxes, doc Axes Properties.


if ~istypedhandle(H,'axes'),
    error('H must be single axes handle.');
end
figh = parentfigh(H);
P = get(H); % properties of existing axes system

if nargin<3,
    Ytick = P.YTick;
    YtickLabel = P.YTickLabel;
end

opos = P.Position;
newpos = opos+[opos(3) 0 1e-16-opos(3) 0];
Hnew = copyobj(H, P.Parent);
delete(get(Hnew,'Xlabel')); delete(get(Hnew,'Ylabel')); delete(get(Hnew,'Zlabel'));
cla(Hnew);
set(Hnew, 'parent', figh, 'position', newpos, 'YAxisLocation', 'right', ...
    'HandleVisibility', 'off', 'xtick', [], 'box', 'off', 'color', get(figh,'color'), ...
    'Ytick', Ytick, 'YtickLabel', YtickLabel, 'YTickMode', 'manual', ...
    varargin{:});
linkaxes([H Hnew], 'y');
% Position = [0.13 0.11 0.775 0.815]


% ActivePositionProperty = outerposition
% ALim = [0 1]
% ALimMode = auto
% AmbientLightColor = [1 1 1]
% Box = off
% CameraPosition = [0.5 0.5 9.16025]
% CameraPositionMode = auto
% CameraTarget = [0.5 0.5 0.5]
% CameraTargetMode = auto
% CameraUpVector = [0 1 0]
% CameraUpVectorMode = auto
% CameraViewAngle = [6.60861]
% CameraViewAngleMode = auto
% CLim = [0 1]
% CLimMode = auto
% Color = [1 1 1]
% CurrentPoint = [ (2 by 3) double array]
% ColorOrder = [ (7 by 3) double array]
% DataAspectRatio = [1 1 1]
% DataAspectRatioMode = auto
% DrawMode = normal
% FontAngle = normal
% FontName = Helvetica
% FontSize = [10]
% FontUnits = points
% FontWeight = normal
% GridLineStyle = :
% Layer = bottom
% LineStyleOrder = -
% LineWidth = [0.5]
% MinorGridLineStyle = :
% NextPlot = replace
% OuterPosition = [0 0 1 1]
% PlotBoxAspectRatio = [1 1 1]
% PlotBoxAspectRatioMode = auto
% Projection = orthographic
% Position = [0.13 0.11 0.775 0.815]
% TickLength = [0.01 0.025]
% TickDir = in
% TickDirMode = auto
% TightInset = [0.0392857 0.0404762 0.00892857 0.0190476]
% Title = [346.003]
% Units = normalized
% View = [0 90]
% XColor = [0 0 0]
% XDir = normal
% XGrid = off
% XLabel = [347.003]
% XAxisLocation = bottom
% XLim = [0 1]
% XLimMode = auto
% XMinorGrid = off
% XMinorTick = off
% XScale = linear
% XTick = [ (1 by 11) double array]
% XTickLabel = [ (11 by 3) char array]
% XTickLabelMode = auto
% XTickMode = auto
% YColor = [0 0 0]
% YDir = normal
% YGrid = off
% YLabel = [348.003]
% YAxisLocation = left
% YLim = [0 1]
% YLimMode = auto
% YMinorGrid = off
% YMinorTick = off
% YScale = linear
% YTick = [ (1 by 11) double array]
% YTickLabel = [ (11 by 3) char array]
% YTickLabelMode = auto
% YTickMode = auto
% ZColor = [0 0 0]
% ZDir = normal
% ZGrid = off
% ZLabel = [349.003]
% ZLim = [0 1]
% ZLimMode = auto
% ZMinorGrid = off
% ZMinorTick = off
% ZScale = linear
% ZTick = [0 0.5 1]
% ZTickLabel =
% ZTickLabelMode = auto
% ZTickMode = auto
% 
% BeingDeleted = off
% ButtonDownFcn =
% Children = []
% Clipping = on
% CreateFcn =
% DeleteFcn =
% BusyAction = queue
% HandleVisibility = on
% HitTest = on
% Interruptible = on
% Parent = [1]
% Selected = off
% SelectionHighlight = on
% Tag =
% Type = axes
% UIContextMenu = []
% UserData = []
% Visible = on
% 





