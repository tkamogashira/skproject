function GrabPoints(Ah);
% GrabPoints - context menu for grabbing data points in plot
%   helper function for IDpoints

% create uicontext menu for axes and all lines in it. Callback does the
% real work; it creates the menu items at the time of rendering the uimenu.
hcm = uicontextmenu('callback', @local_findnearest, ...
    'userdata', struct('hAx', Ah));
set(gca,'uicontextmenu', hcm);
set(findobj(gca,'type','line', '-or', 'type', 'patch'),'uicontextmenu', hcm);


%==============
function P = local_findnearest(cb, XX);
% Here's the action:
%   - spot closest datapoint in the axes
%   - retrieve the ID information of the point as previously stored by IDpoints
%   - create the "title" (top most) item of the context menu
%   - create the remaining, user-specified items.
%
% find axes
hAx = get(cb, 'userdata'); hAx = hAx.hAx;
% collect all line objects in axes that have non-empty markers
hLi = findobj(hAx, 'type', 'line', '-not', 'marker', 'none');
% find nearest datapoint among all the points of the lines hLi
axPos = getposinUnits(hAx,'centimeters'); 
DX = diff(xlim(hAx)); DY = diff(ylim(hAx)); 
YoverX2 = (axPos(4)*DX/axPos(3)/DY)^2; % squared aspect ratio between data & physical coordinates
XYclick = get(hAx,'currentpoint'); % pointer pos in data coordinates
[Xclick,Yclick] = deal(XYclick(1,1),XYclick(1,2));
ihitLi = []; ihitPt = []; minminDist = inf; Xnear = []; Ynear = [];
for ii=1:numel(hLi),
    X = get(hLi(ii), 'Xdata'); Y = get(hLi(ii), 'Ydata');
    [minDist, imin] = min((X-Xclick).^2+YoverX2*(Y-Yclick).^2);
    if minDist<minminDist,
        ihitLi = ii; 
        ihitPt = imin; 
        minminDist = minDist;
        Xnear = X(imin); 
        Ynear = Y(imin);
    end
end
% clear any previous menu items of uicontext menu
delete(get(cb,'children'));
% tmp highlight nearest point
CA = gca; axes(hAx); qq=xplot(Xnear, Ynear, 'kp', 'markersize', 10); pause(0.2); delete(qq); axes(CA);
% retrieve info stored  for the line this point belongs to
LinInfo = private_StorePointIDs(hLi(ihitLi));
% get ID of current point; first extract element of pointID, then pass it to ID2string
if iscell(LinInfo.pointID), 
    pointID = LinInfo.pointID{ihitPt};
else
    pointID = LinInfo.pointID(ihitPt);
end
% the complete ID of this point collected in a cell array:
ID = {LinInfo.GenID{:}, pointID};
% create the uimenus by passing the ID to the callbacks
uimenu(cb,'label', LinInfo.ID2string(ID{:}), 'position', 1, ... % upper label: the "title"; selecting it assigns ...
    'callback', {@stripCallback @local_ID2workspace ID{:}}); % ...   ID args to variable 'IDcell' in ML workspace
uimenu(cb,'label', vector2str([Xnear Ynear]), 'position', 2, ...
    'callback', {@stripCallback @disp mat2str([Xnear Ynear])}); % 2nd label: X & Y coordinates of datapoint ...
for icb = 1:LinInfo.Ncallback,
    item = LinInfo.MenuItem(icb);
    lbl = item.Label;
    % chececk for trailing '-', indicating a sepator 
    if lbl(1)=='-',
        lbl = lbl(2:end);
        SepVal = 'on';
    else, 
        SepVal = 'off';
    end
    hu=uimenu(cb,'label', lbl, 'Callback', {@stripCallback item.Callback ID{:}}, 'position', icb+2, 'separator', SepVal);
    if icb==1, set(hu,'separator','on'); end
end
% if it's a line the user has clicked on, append a free line-paste menu item 
if isequal('line', get(gco,'type'))
    LineCopyMenu(cb, gco, 'separator', 'on');
end

function local_ID2workspace(varargin);
% declare variable 'IDcell' in Matlab workspace, containing the ID
% parameters of the clicked point.
GLnam = 'a______export_IDcell';
eval(['global ' GLnam]); eval([GLnam ' = varargin;']);
evalin('base',['global ' GLnam '; IDcell = ' GLnam '; display(IDcell);']);
eval(['clear global ' GLnam]);







