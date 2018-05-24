function polarplus(theta, rho, varargin  )
%BARPLUS  create polar graph.
%   POLARPLUS(Theta, Rho) creates a graph
%   where the polar coordinates are specified by Theta and Rho. 
%
%   Hdls = BARPLUS(...) returns a vector of patch handles.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.
%
%   See also POLAR
%
% Kevin Spiritus 01-02-2006

%------------------------Properties and their default values-----------------------
DefProps.style      = 'bars';     %Draw edges around every bar or only around the total
                                  %histogram (values must be 'bars', 'outline' or 
                                  %'line') ...
DefProps.linecolor  = [0 0 0];    %The color of the polar graph ... 
DefProps.fillcolor  = 'b';
DefProps.linestyle  = '-';        %The style of the polar graph ...
DefProps.linewidth  = 0.5;        %The width of the polar graph in points ...
DefProps.gridcolor  = [0 0 0];
DefProps.gridstyle  = '-';
DefProps.gridsize   = 0;
%-------------------------------Main program--------------------------------------

if (nargin == 1) & ischar(theta) & strcmpi(theta, 'factory'),
   disp('Properties and their factory defaults:');
   disp(DefProps);
   return;
elseif nargin < 2,
   error('Requires 2 input arguments.')
end

if isstr(theta) | isstr(rho)
   error('Input arguments must be numeric.');
end
if ~isequal(size(theta),size(rho))
   error('THETA and RHO must be the same size.');
end

%Retrieving properties and checking their values ...
if nargin > 2, Props = CheckPropList(DefProps, varargin{:});
else Props = DefProps;
end

if ~iscolor(Props.linecolor), error('Invalid value for property linecolor.'); end
if ~iscolor(Props.gridcolor), error('Invalid value for property gridcolor.'); end
if ischar(Props.linecolor), Props.linecolor = ColSym2RGB(Props.linecolor); end
if ischar(Props.gridcolor), Props.gridcolor = ColSym2RGB(Props.gridcolor); end
if ~ischar(Props.linestyle) | ~ismember(Props.linestyle, {'none', '-', ':', '--', '-.'}), error('Invalid value for property linestyle.'); end
if ~ischar(Props.gridstyle) | ~ismember(Props.gridstyle, {'none', '-', ':', '--', '-.'}), error('Invalid value for property gridstyle.'); end
if ~isnumeric(Props.linewidth) | (length(Props.linewidth) ~= 1) | (Props.linewidth <= 0), error('Invalid value for property linewidth.'); end

cax = newplot;
next = lower(get(cax,'NextPlot'));
hold_state = ishold;

% Hold on to current Text defaults, reset them to the
% Axes' font attributes so tick marks use them.
fAngle  = get(cax, 'DefaultTextFontAngle');
fName   = get(cax, 'DefaultTextFontName');
fSize   = get(cax, 'DefaultTextFontSize');
fWeight = get(cax, 'DefaultTextFontWeight');
fUnits  = get(cax, 'DefaultTextUnits');
set(cax, 'DefaultTextFontAngle',  get(cax, 'FontAngle'), ...
   'DefaultTextFontName',   get(cax, 'FontName'), ...
   'DefaultTextFontSize',   get(cax, 'FontSize'), ...
   'DefaultTextFontWeight', get(cax, 'FontWeight'), ...
   'DefaultTextUnits','data')

% make a radial grid
hold on;
maxrho = max(abs(rho(:)));
hhh=plot([-maxrho -maxrho maxrho maxrho],[-maxrho maxrho maxrho -maxrho]);
set(gca,'dataaspectratio',[1 1 1],'plotboxaspectratiomode','auto')
v = [get(cax,'xlim') get(cax,'ylim')];
ticks = sum(get(cax,'ytick')>=0);
delete(hhh);

% check radial limits and ticks
rmin = 0; rticks = max(ticks-1,2);

if isequal(Props.gridsize, 0), rmax = v(4);
else rmax = Props.gridsize; end

if rmax > 80000, rmax = round(rmax/10000)*10000; 
elseif rmax > 8000, rmax = round(rmax/1000)*1000; 
elseif rmax > 800, rmax = round(rmax/100)*100;
elseif rmax > 80, rmax = round(rmax/10)*10; 
elseif rmax > 40, rmax = round(rmax/5)*5; 
else, rmax = round(rmax); end

if rticks > 5   % see if we can reduce the number
   if rem(rticks,2) == 0
      rticks = rticks/2;
   elseif rem(rticks,3) == 0
      rticks = rticks/3;
   end
end

% define a circle
th = 0:pi/50:2*pi;
xunit = cos(th);
yunit = sin(th);

% now really force points on x/y axes to lie on them exactly
inds = 1:(length(th)-1)/4:length(th);
xunit(inds(2:2:4)) = zeros(2,1);
yunit(inds(1:2:5)) = zeros(3,1);

% draw radial circles
c220 = cos(220*pi/180);
s220 = sin(220*pi/180);
rinc = (rmax-rmin)/rticks;
for i=(rmin+rinc):rinc:rmax
   hhh = plot(xunit*i,yunit*i,Props.gridstyle,'color',Props.gridcolor,'linewidth',1,...
      'handlevisibility','off');
   T = text((i+rinc/3.5)*c220,(i+rinc/3.5)*s220, ...
      ['  ' num2str(round(i))],'verticalalignment','bottom',...
      'handlevisibility','off');
   set(T, 'Color', Props.gridcolor);
end
set(hhh,'linestyle','-') % Make outer circle solid

% plot spokes
th = (1:6)*2*pi/12;
cst = cos(th); snt = sin(th);
cs = [-cst; cst];
sn = [-snt; snt];
plot(rmax*cs,rmax*sn,Props.gridstyle,'color',Props.gridcolor,'linewidth',1,...
   'handlevisibility','off')

% annotate spokes in degrees
rt = 1.1*rmax;
for i = 1:length(th)
   T = text(rt*cst(i),rt*snt(i),int2str(i*30),...
      'horizontalalignment','center',...
      'handlevisibility','off');
   set(T, 'Color', Props.gridcolor);
   if i == length(th)
      loc = int2str(0);
   else
      loc = int2str(180+i*30);
   end
   T = text(-rt*cst(i),-rt*snt(i),loc,'horizontalalignment','center',...
      'handlevisibility','off');
   set(T, 'Color', Props.gridcolor);
end

% set view to 2-D
view(2);

% Reset defaults.
set(cax, 'DefaultTextFontAngle', fAngle , ...
   'DefaultTextFontName',   fName , ...
   'DefaultTextFontSize',   fSize, ...
   'DefaultTextFontWeight', fWeight, ...
   'DefaultTextUnits',fUnits );

% transform data to Cartesian coordinates.
nbin = size(theta,2);

X = rho.*cos(theta);
Y = rho.*sin(theta);   

xx1 = rho.*cos(theta-pi/nbin);
xx2 = rho.*cos(theta+pi/nbin);
yy1 = rho.*sin(theta-pi/nbin);   
yy2 = rho.*sin(theta+pi/nbin);   


switch Props.style
case 'bars'
   for phi = 1:nbin,
      q = patch([0 xx1(phi) xx2(phi)], [0 yy1(phi) yy2(phi)], Props.fillcolor);
      set(q, 'EdgeColor', Props.linecolor, ...
         'LineStyle', Props.linestyle, ...
         'LineWidth', Props.linewidth );
   end
case 'outline'
   X = [];   for phi = 1:nbin, X = [X xx1(phi) xx2(phi)]; end
   Y = [];   for phi = 1:nbin, Y = [Y yy1(phi) yy2(phi)]; end
   
   if isequal('none', Props.fillcolor),
      q = patch([X(:)], [Y(:)], 'b', 'FaceColor', 'none');
   else
      q = patch([X(:)], [Y(:)], Props.fillcolor);
   end
       
   set(q, 'EdgeColor', Props.linecolor, ...
      'LineStyle', Props.linestyle, ...
      'LineWidth', Props.linewidth );
case 'line'
   if isequal('none', Props.fillcolor),
      q = patch([X(:)], [Y(:)], 'b', 'FaceColor', 'none');
   else
      q = patch([X(:)], [Y(:)], Props.fillcolor);
   end
   set(q, 'EdgeColor', Props.linecolor, ...
      'LineStyle', Props.linestyle, ...
      'LineWidth', Props.linewidth );
end