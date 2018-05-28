function polarPhColor(HIST, varargin  )
%BARPLUS  create polar graph.
%   POLARPLUS(thetaArray, Rho) creates a graph
%   where the polar coordinates are specified by thetaArray and Rho.
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
DefProps.LabelColor = [1 0 0];
% DefProps.indepval = [];
DefProps.delay = [];
DefProps.periods = [];
DefProps.runav = 0;
DefProps.freqs = [];
DefProps.maxfys = 0.4;			%Physical limit in [ms]



%-------------------------------Main program--------------------------------------
%
if (nargin < 1) || strcmpi(HIST, 'factory'),
   disp('Properties and their factory defaults:');
   disp(DefProps);
   return;
end
% elseif nargin < 2,
%    error('Requires 2 input arguments.')
% % end
%
% if isstr(theta) | isstr(rho)
%    error('Input arguments must be numeric.');
% end
% if ~isequal(size(theta),size(rho))
%    error('THETA and RHO must be the same size.');
% end

%Retrieving properties and checking their values ...
% if nargin > 2, Props = CheckPropList(DefProps, varargin{:});
% else
% Props = DefProps;
% end

Props = getarguments(DefProps, varargin);

if ~iscolor(Props.linecolor), error('Invalid value for property linecolor.'); end
if ~iscolor(Props.gridcolor), error('Invalid value for property gridcolor.'); end
if ischar(Props.linecolor), Props.linecolor = ColSym2RGB(Props.linecolor); end
if ischar(Props.gridcolor), Props.gridcolor = ColSym2RGB(Props.gridcolor); end
if ~ischar(Props.linestyle) | ~ismember(Props.linestyle, {'none', '-', ':', '--', '-.'}), error('Invalid value for property linestyle.'); end
if ~ischar(Props.gridstyle) | ~ismember(Props.gridstyle, {'none', '-', ':', '--', '-.'}), error('Invalid value for property gridstyle.'); end
if ~isnumeric(Props.linewidth) | (length(Props.linewidth) ~= 1) | (Props.linewidth <= 0), error('Invalid value for property linewidth.'); end


% %resample over the requested delays
% NFreq = size(HIST,2);
% for n=1:NFreq
% 	period = Props.periods(n); %period of fcar in [ms]
% 	%delay range within 0->period 
% 	delay = Props.delay(Props.delay >= 0);
% 	delay = delay(delay <= period);
% 	%phase bin centers
% 	binCenters = HIST(n).X;  %phase in cycles
% 	X = binCenters * period; %phase in time
% 	Y = HIST(n).Y;           %rate in spk/sec for X values
% 	%interp for delay range
% 	Yint =  interp1(X, Y, delay, 'cubic');
% 	HIST(n).X = delay;
% 	HIST(n).Y = Yint;
% end



% theta = (2*pi) * thetaArray;



defaultPage('PolarPlot');
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


%Get all values of an array by placing it into []
% rhoArray = HIST(:).Y;

maxrho = max(abs([HIST.Y]));
nrOfSubs = length(HIST);

hhh=plot([-nrOfSubs -nrOfSubs nrOfSubs nrOfSubs],[-nrOfSubs nrOfSubs nrOfSubs -nrOfSubs]);
set(gca,'dataaspectratio',[1 1 1],'plotboxaspectratiomode','auto')
v = [get(cax,'xlim') get(cax,'ylim')];
ticks = sum(get(cax,'ytick')>=0);
delete(hhh);

% check radial limits and ticks
rmin = 0; rticks = max(ticks-1,2);

% if isequal(Props.gridsize, 0)
% 	rmax = v(4);
% else
% 	rmax = Props.gridsize;
% end
rmax = nrOfSubs;

if rmax > 80000
	rmax = round(rmax/10000)*10000;
elseif rmax > 8000
	rmax = round(rmax/1000)*1000;
elseif rmax > 800
	rmax = round(rmax/100)*100;
elseif rmax > 80
	rmax = round(rmax/10)*10;
elseif rmax > 40
	rmax = round(rmax/5)*5;
else
	rmax = round(rmax);
end

% if rticks > 5   % see if we can reduce the number
%    if rem(rticks,2) == 0
%       rticks = rticks/2;
%    elseif rem(rticks,3) == 0
%       rticks = rticks/3;
%    end
% end

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
% rinc = (rmax-rmin)/rticks;
rinc = 1;

(rmin+rinc):rinc:rmax;

gotFreqs = ~isempty(Props.freqs);
if gotFreqs
	axesLabels = round(Props.freqs);
else
	axesLabels = (rmin+rinc):rinc:rmax;
end

for i=(rmin+rinc):rinc:rmax
	hhh = plot(xunit*i,yunit*i,Props.gridstyle,'color',Props.gridcolor,'linewidth',1,...
		'handlevisibility','off');
	textH(i) = text((i+rinc/3.5)*c220,(i+rinc/3.5)*s220, ...
		['  ' num2str(axesLabels(i))],'verticalalignment','bottom',...
		'handlevisibility','on');
	set(textH(i), 'Color', Props.LabelColor);
end
set(hhh,'linestyle','-') % Make outer circle solid

% plot spokes
%every 30 degree =12 parts 
% 2*pi/12 = seize each part
% 
th = (1:6)*2*pi/12;
%projection on X
cst = cos(th - pi/2);  %shift zero to bottom -> -90 degree (pi/2)
%project on Y
snt = sin(th - pi/2);  
%copy to negative side 
cs = [-cst; cst];
sn = [-snt; snt];
%plot
plot(rmax*cs,rmax*sn,Props.gridstyle,'color',Props.gridcolor,'linewidth',1,...
	'handlevisibility','off');

% annotate spokes in degrees
rt = 1.1*rmax;  %place 1.1 above outer ring 
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



nrOfColors = length([0:round(maxrho)]);
colors = colormap(Jet(nrOfColors));
n = nrOfSubs;
while n >= 1
% 	Period = 1000./Freq;  %Periods in [ms] 
	
	
	%resample to 360 points and draw per 1 degree 
	%remove edge effects by copying the first and last point + interp and
	%remove them again
	rho   = HIST(n).Y;
	
	%smooth by runav
	rho = runav(rho, Props.runav);
	
	%X-range
	theta = HIST(n).X;
	
	%copy first and last point
	y1 = rho(1);
	x1 = 1 + theta(1);
	y2 = rho(end);
	x2 = theta(end) - 1;
	newT = [x2, theta, x1];
	newR = [y2, rho, y1];
	%resample
	xrange = linspace(0,1,360);
	rRho = interp1(newT, newR, xrange);
	%save
	theta = xrange;
	rho = rRho;
	
	%Calculate the fysical limit: +/- 400 microsec.
	%Cycle to milli sec => theta * Period(fcar)
	%(400/Period) -> 400microsec in cycles
	%maxFysInCycles = Props.maxfys/(Props.periods(n) * 1000);
	
	%Calculate the fysical limit: +/- 400 microsec.
	%  => in degree
	%360 degr = 1 cycle
	%360 degr = 1/200hz = 2ms 
	%0.4ms = (360/2)*0.4 degr = 72 degr
% 	maxFysInDegree = (360/Props.periods(n))*Props.maxfys;
	maxFysInRad = (2*pi/Props.periods(n))*Props.maxfys;
	
	%shift zero to bottom
%  	maxFysInRad = maxFysInRad - 90;
	
	
	%Draw patches
	%Cycle to rad
	theta = (theta * (2*pi)); 
	%Cycle to degree
% 	theta = (theta * 360);
	
	% transform data to Cartesian coordinates.
	nbin = size(theta,2);
% 	
% 	X = rho.*cos(theta);
% 	Y = rho.*sin(theta);
% 	
	% xx1 = rho.*cos(theta-pi/nbin);
	% xx2 = rho.*cos(theta+pi/nbin);
	% yy1 = rho.*sin(theta-pi/nbin);
	% yy2 = rho.*sin(theta+pi/nbin);

	
	xx1 = n.*cos(theta-pi/nbin - pi/2);
	xx2 = n.*cos(theta+pi/nbin - pi/2);
	yy1 = n.*sin(theta-pi/nbin - pi/2);
	yy2 = n.*sin(theta+pi/nbin - pi/2);
	
	
% 	
% 	switch Props.style
% 		case 'bars'
			for phi = 1:nbin,

				q = patch([0 xx1(phi) xx2(phi)], [0 yy1(phi) yy2(phi)], colors(round(rho(phi)+1), :), 'EdgeAlpha', 0);
				%       q = patch([0 xx1(phi) xx2(phi)], [0 yy1(phi) yy2(phi)], Props.fillcolor);
				set(q, 'EdgeColor', Props.linecolor, ...
					'LineStyle', Props.linestyle, ...
					'LineWidth', Props.linewidth );
			end
			
			%plot white line at fysical limit
			%Put 0 at bottom -> shift over -90 degree (-pi/2)
			xx1 = n.*cos(maxFysInRad-pi/nbin - pi/2);
			xx2 = n.*cos(maxFysInRad+pi/nbin - pi/2);
			yy1 = n.*sin(maxFysInRad-pi/nbin - pi/2);
			yy2 = n.*sin(maxFysInRad+pi/nbin - pi/2);
			q = patch([0 xx1 xx2], [0 yy1 yy2], 'w', 'EdgeAlpha', 0);
			
			%plot white line at -fysical limit
			X = - maxFysInRad;
			xx1 = n.*cos(X-pi/nbin - pi/2);
			xx2 = n.*cos(X+pi/nbin - pi/2);
			yy1 = n.*sin(X-pi/nbin - pi/2);
			yy2 = n.*sin(X+pi/nbin - pi/2);
			q = patch([0 xx1 xx2], [0 yy1 yy2], 'w', 'EdgeAlpha', 0);			
			
% 		case 'outline'
% 			X = [];   for phi = 1:nbin, X = [X xx1(phi) xx2(phi)]; end
% 			Y = [];   for phi = 1:nbin, Y = [Y yy1(phi) yy2(phi)]; end
% 			
% 			if isequal('none', Props.fillcolor),
% 				q = patch([X(:)], [Y(:)], 'b', 'FaceColor', 'none');
% 			else
% 				q = patch([X(:)], [Y(:)], Props.fillcolor);
% 			end
% 			
% 			set(q, 'EdgeColor', Props.linecolor, ...
% 				'LineStyle', Props.linestyle, ...
% 				'LineWidth', Props.linewidth );
% 		case 'line'
% 			if isequal('none', Props.fillcolor),
% 				q = patch([X(:)], [Y(:)], 'b', 'FaceColor', 'none');
% 			else
% 				q = patch([X(:)], [Y(:)], Props.fillcolor);
% 			end
% 			set(q, 'EdgeColor', Props.linecolor, ...
% 				'LineStyle', Props.linestyle, ...
% 				'LineWidth', Props.linewidth );

	n = n -1;
end
myScale = linspace(0, 1, nrOfColors/10);
myTicks = linspace(0, maxrho, nrOfColors/10);
myTickLabels = cell(1,length(myTicks));
% myEvalStr = ['colorbar(''YTick'', myScale,''YTickLabel''']; 
for n = 1:length(myTicks)
	myTickLabels{n} = sprintf('%4.0f', myTicks(n));
end
% myEvalStr = myEvalStr(1:end-1);
% myEvalStr = [myEvalStr, ');'];
colorbar('YTick', myScale, 'YTickLabel', myTickLabels);
% eval(myEvalStr);

% th = (1:6)*2*pi/12;
% cst = cos(th); snt = sin(th);
% cs = [-cst; cst];
% sn = [-snt; snt];
% plot(rmax*cs,rmax*sn,Props.gridstyle,'color',Props.gridcolor,'linewidth',1,...
% 	'handlevisibility','off');



uistack(textH, 'top');
set(cax,'ytick', []);
set(cax,'xtick', []);


hold off;
end