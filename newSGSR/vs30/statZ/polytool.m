function h = polytool(x,y,n,alpha,xname,yname)
%POLYTOOL Fits a polynomial to (x,y) data and displays an interactive graph.
%   POLYTOOL(X,Y,N,ALPHA) is a prediction plot that provides a Nth degree
%   polynomial curve fit to (x,y) data. It plots a 100(1 - ALPHA) percent
%   global confidence interval for predictions as two red curves. The
%   default value for N is 1 and the default value for ALPHA is 0.05,
%   which produces a linear model and 95% confidence intervals respectively. 
%
%   POLYTOOL(X,Y,N,ALPHA,XNAME,YNAME) The optional inputs XNAME and 
%   YNAME contain strings for the X and Y variables respectively.
%
%   H = POLYTOOL(X,Y,N,ALPHA,XNAME,YNAME) outputs a vector of handles, H,
%   to the line objects in the plot.
%
%   You can drag the dotted white reference line and watch the predicted
%   values update simultaneously. Alternatively, you can get a specific
%   prediction by typing the "X" value into an editable text field.
%   A pop-up menu at the top allows you to change the degree of the 
%   polynomial fit. Use the pop-up menu labeled Export to move 
%   specified variables to the base workspace.

   
%   B.A. Jones 3-15-93
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.13 $  $Date: 1998/05/28 20:13:57 $

if ~isstr(x) 
    action = 'start';
else
    action = x;
end

%On recursive calls get all necessary handles and data.
if ~strcmp(action,'start')

   if nargin == 2,
      flag = y;
   end
   
   poly_fig = findobj(0,'Tag','polyfig');
   k = gcf;
   idx = find(poly_fig == k);
   if isempty(idx)
      return
   end
   poly_fig = poly_fig(idx);
   poly_axes = get(poly_fig,'CurrentAxes');      
   ud = get(poly_fig,'Userdata');
   
   uiHandles    = ud.uicontrolHandles;
   x_field      = uiHandles.x_field;
   y_field      = uiHandles.y_field;
   degreetext   = uiHandles.degreetext;
   outputpopup  = uiHandles.outputpopup;

   stats        = ud.stats;
   x            = ud.data(:,1);
   y            = ud.data(:,2);
   
   fitline        = ud.plotHandles.fitline;
   reference_line = ud.plotHandles.reference_line;
 
   degree         = str2double(get(degreetext,'String'));
   
   xrange = get(poly_axes,'XLim');
   yrange = get(poly_axes,'YLim');

   newx = str2double(get(x_field,'String'));  
   newy = str2double(get(y_field(1),'String'));  
   deltay = str2double(get(y_field(2),'String'));
end

switch action

case 'start',

if nargin < 3, 
   degree = 1;
else
   if isempty(n)
      n = 1;
   end
   degree = n;
end

if degree == 1
    model = 'Linear';
elseif degree == 2
    model = 'Quadratic';
elseif degree == 3
    model = 'Cubic';
elseif degree == 4
    model = 'Quartic';
elseif degree == 5
    model = 'Quintic';
else
    model = [num2str(degree),'th Order'];
end   

if nargin < 4 | isempty(alpha), 
    alpha = 0.05;
end
if isempty(alpha)
   alpha = 0.05;
end

if nargin >= 5
   xstr = xname;
   if isempty(xname)
      xstr = 'X Values';
   end  
else
   xstr = 'X Values';
end

if nargin == 6
   ystr = yname;
else
   ystr = 'Y Values';
end


% Create plot figure and axes.
poly_fig = figure('Visible','off','Units','Normalized','Tag','polyfig');
whitebg(poly_fig,[0 0 0]);
set(poly_fig,'Name',['Prediction Plot of ',model,' Model']);
poly_axes = axes;

% Fit data.
obsm1 = max(size(y)) - 1;
stats.crit = tinv(1 - alpha/2,obsm1-(1:obsm1-1));
[stats.beta, stats.structure] = polyfit(x,y,degree);

% Call local function to create plots.
[ud.plotHandles, newx] = makeplots(x,y,stats,degree,poly_axes);
fitline = ud.plotHandles.fitline;
% Call local function to create uicontrols.
ud.uicontrolHandles = makeuicontrols(newx,xstr,ystr,stats,degree);
% Define the rest of the UserData components.
ud.stats = stats;
ud.data  = [x(:) y(:)];
ud.texthandle = [];

set(poly_fig,'Backingstore','off','WindowButtonMotionFcn','polytool(''motion'',0)',...
    'WindowButtonDownFcn','polytool(''down'')','UserData',ud,'Visible','on',...
	'HandleVisibility','callback');
% Finished with polytool initialization.

case 'motion',
    [minx, maxx] = plotlimits(xrange);
     
    if flag == 0,
        cursorstate = get(poly_fig,'Pointer');
        cp = get(poly_axes,'CurrentPoint');
        cx = cp(1,1);
        cy = cp(1,2);
        fuzz = 0.01 * (maxx - minx);
        online = cy > yrange(1) & cy < yrange(2) & cx > newx - fuzz & cx < newx + fuzz;
        if online & strcmp(cursorstate,'arrow'),
            set(poly_fig,'Pointer','crosshair');
        elseif ~online & strcmp(cursorstate,'crosshair'),
            set(poly_fig,'Pointer','arrow');
        end
    elseif flag == 1,
        cp = get(poly_axes,'CurrentPoint');
        newx=cp(1,1);
        if newx > maxx
            newx = maxx;
        end
        if newx < minx
            newx = minx;
        end

		[newy, deltay] = getyvalues(newx,stats,degree);
        set(x_field,'String',num2str(newx));
	    setyfields(newy,deltay,y_field)
	    setreferencelines(newx,newy,reference_line);
    end

case 'down',
    p = get(poly_fig,'CurrentPoint');
    if p(1) < .21 | p(1) > .96 | p(2) > 0.86 | p(2) < 0.18
       return
    end

    set(poly_fig,'Pointer','crosshair');
    cp = get(poly_axes,'CurrentPoint');
    [minx, maxx] = plotlimits(get(poly_axes,'Xlim'));
    newx=cp(1,1);
    if newx > maxx
       newx = maxx;
    end
    if newx < minx
       newx = minx;
    end
	[newy, deltay] = getyvalues(newx,stats,degree);
    set(x_field,'String',num2str(newx));
	setyfields(newy,deltay,y_field)
	setreferencelines(newx,newy,reference_line);
    set(gcf,'WindowButtonMotionFcn','polytool(''motion'',1)','WindowButtonUpFcn','polytool(''up'')');

case 'up',
    set(poly_fig,'WindowButtonMotionFcn','polytool(''motion'',0)','WindowButtonUpFcn','');

case 'edittext',
    if isempty(newx) 
      newx = get(x_field,'Userdata');
      set(x_field,'String',num2str(newx));
      warndlg('The X value must be a number. Resetting to previous value.');
      return;
    end

    [minx, maxx] = plotlimits(xrange);
    if newx > maxx
        newx = maxx;
        set(x_field,'String',num2str(newx));
    end
    if newx < minx
        newx = minx;
        set(x_field,'String',num2str(newx));
    end

    [newy, deltay] = getyvalues(newx,stats,degree);
	setyfields(newy,deltay,y_field)
	setreferencelines(newx,newy,reference_line);

case 'change_degree',
    maxdf = length(stats.crit);
    if degree >= maxdf+1
       degree = get(degreetext,'Userdata');
       set(degreetext,'String',num2str(degree));
       warndlg('Cannot fit model. Resetting to previous value.');
       return;
    end   
    if isempty(degree) 
       degree = get(degreetext,'Userdata');
       set(degreetext,'String',num2str(degree));
       warndlg('The polynomial degree must be a positive integer. Resetting to previous value.');
       return;
    end
    if floor(degree) ~= degree | degree <= 0
       degree = get(degreetext,'Userdata');
       set(degreetext,'String',num2str(degree));
       warndlg('The polynomial degree must be a positive integer. Resetting to previous value.');
       return;
    end
    [ud.stats.beta ud.stats.structure] = polyfit(x,y,degree);
	[minx maxx] = plotlimits(x);
    xfit = linspace(minx,maxx,41);
    [yfit, deltay] = getyvalues(xfit,ud.stats,degree);

    set(fitline(1),'XData',x,'YData',y,'Color','y','Marker','+');
    set(fitline(2),'XData',xfit,'YData',yfit,'Color','g','Linestyle','-');
    set(fitline(3),'XData',xfit,'YData',yfit-deltay,'Color','r','Linestyle','--');
    set(fitline(4),'XData',xfit,'YData',yfit+deltay,'Color','r','Linestyle','--');

	[miny maxy] = plotlimits([yfit+deltay;yfit-deltay]);

    set(poly_axes,'YLim',[miny maxy]);
	[newy, deltay] = getyvalues(newx,ud.stats,degree);
	setreferencelines(newx,newy,reference_line);
	
	setyfields(newy,deltay,y_field)

    set(degreetext,'UserData',degree);
 	switch degree
	   case 1
          model = 'Linear';
       case 2
          model = 'Quadratic';
       case 3
          model = 'Cubic';
       case 4
          model = 'Quartic';
       case  5
          model = 'Quintic';
       otherwise
          model = [num2str(degree),'th Order'];
    end   
    set(poly_fig,'Name',['Prediction Plot of ',model,' Model'],...
	   'UserData',ud);  

case 'output',
    bmf = get(poly_fig,'WindowButtonMotionFcn');
    bdf = get(poly_fig,'WindowButtonDownFcn');
    set(poly_fig,'WindowButtonMotionFcn','','WindowButtonDownFcn','');

    outval = get(outputpopup,'Value');
    switch outval
       case 1,
          return,         
       case 2,
          entrystr = 'beta';
       case 3,
          entrystr = 'betaci';
       case 4,
          entrystr = 'yhat';
       case 5,
          entrystr = 'yci';
       case 6,
          entrystr = 'residuals';
       case 7,
          entrystr = 'beta,betaci,yhat,yci,residuals';
       end

  promptstr = 'Enter names for the output variables or use the supplied default.';
  dlghandle = dialog('Visible','off','WindowStyle','modal');

  set(dlghandle,'Units','pixels','Position',[100 300 400 100],'Visible','on','Tag','polydlg');
  uicontrol(dlghandle,'Style','text','Units','pixels','Position',[10 75 380 20],...
          'String',promptstr);

  ud.texthandle = uicontrol(dlghandle,'Style','edit','Units','pixels',...
               'String',entrystr,'HorizontalAlignment','center','Position',[50 40 300 20]);

  ok_button = uicontrol('Style','Pushbutton','Units','pixels','Position',[180 5 40 20],...
               'Callback','polytool(''toworkspace'');close(gcbf)','String','OK');

  set(dlghandle,'HandleVisibility','off')
  set(poly_fig,'UserData',ud,'WindowButtonMotionFcn',bmf,'WindowButtonDownFcn',bdf);

case 'toworkspace'
    outval = get(outputpopup,'Value');
	structure = stats.structure;
	beta = stats.beta;
    R = structure.R;
    df = structure.df;
    rmse = structure.normr;
    Rinv = eye(size(R))/R;
    dxtxi = sum(Rinv'.*Rinv');
    dbeta = dxtxi*stats.crit(degree)*rmse;
    yhat = polyval(beta,x);

    s = get(ud.texthandle,'String');
 
    switch outval
       case 1,
          return,         
       case 2,
	      assignin('base',s,beta);
       case 3,
	      assignin('base',s,[beta-dbeta; beta+dbeta]);
       case 4,
	      assignin('base',s,newy);
       case 5,
	      assignin('base',s,[newy-deltay newy+deltay]);
       case 6,
	      assignin('base',s,y-yhat);
       case 7,
          cpos=findstr(s,',');
	      assignin('base',s(1:cpos(1)-1),beta);
	      assignin('base',s((cpos(1)+1):(cpos(2)-1)),[beta-dbeta; beta+dbeta]);
	      assignin('base',s((cpos(2)+1):(cpos(3)-1)),newy);
	      assignin('base',s((cpos(3)+1):(cpos(4)-1)),[newy-deltay newy+deltay]);
	      assignin('base',s((cpos(4)+1):end),y-yhat);
    end
    set(outputpopup,'Value',1);
	polydlg = findobj(0,'Tag','polydlg');
	if ~isempty(polydlg)
	    delete(polydlg)
    end
end

if nargout == 1
   h = fitline;
end

function setyfields(newy,deltay,y_field)
% SETYFIELDS Local function for changing the Y field values.
set(y_field(1),'String',num2str(newy));
set(y_field(2),'String',num2str(deltay));

function setreferencelines(newx,newy,reference_line)
% SETREFERENCELINES Local function for moving reference lines on polytool figure.
xrange = get(gca,'Xlim');
yrange = get(gca,'Ylim');
set(reference_line(1),'YData',yrange,'Xdata',[newx newx]);   % vertical reference line.
set(reference_line(2),'XData',xrange,'Ydata',[newy newy]);   % horizontal reference line.
 

function [yhat, deltay] = getyvalues(x,stats,degree)
% GETYVALUES Local function for generating Y predictions and confidence intervals.
[yhat, deltay]=polyval(stats.beta,x,stats.structure);
deltay = deltay*stats.crit(degree);


function [minx, maxx] = plotlimits(x)
% PLOTLIMITS   Local function to control the X-axis limit values.
maxx = max(x(:));
minx = min(x(:));
xrange = maxx - minx;
maxx = maxx + 0.025 * xrange;
minx = minx - 0.025 * xrange;

function [plotHandles, newx] = makeplots(x,y,stats,degree,poly_axes)
% MAKEPLOTS   Local function to create the plots in polytool.
[minx, maxx] = plotlimits(x);
xfit = linspace(minx,maxx,41)';
[yfit deltay] = getyvalues(xfit,stats,degree);

set(poly_axes,'UserData','poly_axes','XLim',[minx maxx],'Box','on');
set(poly_axes,'NextPlot','add','DrawMode','fast','Position',[.21 .18 .75 .72]);

% Plot prediction function with uncertainty bounds.
plotHandles.fitline = plot(x,y,'y+',xfit,yfit,'g-',xfit,yfit-deltay,'r--',...
                           xfit,yfit+deltay,'r--');
yrange = get(poly_axes,'YLim');
xrange = get(poly_axes,'XLim');

% Plot Reference Lines
newx = xfit(21);
newy = yfit(21);
reference_line(1) = plot([newx newx],yrange,'w--','Erasemode','xor');
reference_line(2) = plot(xrange,[newy newy],'w:','Erasemode','xor');
set(reference_line(1),'ButtonDownFcn','polytool(''down'')');
plotHandles.reference_line = reference_line;

function uicontrolHandles = makeuicontrols(newx,xstr,ystr,stats,degree)
% MAKEUICONTROLS   Local function to create uicontrols for polytool. 

if strcmp(computer,'MAC2')
  offset = -0.01;
else
  offset = 0;
end

fcolor = get(gcf,'Color');

xfieldp = [.50 .07 .15 .05];
yfieldp = [.01 .45 .13 .04]; 

[newy, deltay] = getyvalues(newx,stats,degree);

uicontrolHandles.x_field = uicontrol('Style','edit','Units','normalized','Position',xfieldp,...
         'String',num2str(newx),'BackgroundColor','white','UserData',newx,...
         'CallBack','polytool(''edittext'')','String',num2str(newx));

ytext=uicontrol('Style','text','Units','normalized',...
      'Position',yfieldp + [0 0.20 0 0],'String',ystr,...
	  'BackgroundColor',fcolor,'ForegroundColor','w');

uicontrolHandles.y_field(1)= uicontrol('Style','text','Units','normalized',...
         'Position',yfieldp + [0 .14 0 0],'String',num2str(newy),...
         'BackgroundColor',fcolor,'ForegroundColor','w');

uicontrol('Style','text','Units','normalized',...
         'Position',yfieldp + [0 .07 -0.01 0],'String',' +/-',...
         'BackgroundColor',fcolor,'ForegroundColor','w');

uicontrolHandles.y_field(2)= uicontrol('Style','text','Units','normalized',...
         'Position',yfieldp,'String',num2str(deltay),...
         'BackgroundColor',fcolor,'ForegroundColor','w');

uicontrol('Style','text','Units','normalized',...
     'Position',xfieldp - [0 0.07 0 0],'ForegroundColor','w',...
	 'BackgroundColor',fcolor,'String',xstr);

uicontrol('Style','Text','String','Degree','Units','normalized',...
        'Position',xfieldp + [-0.03 0.87+offset -0.05 0],'ForegroundColor','w',...
		'BackgroundColor',fcolor);

uicontrolHandles.degreetext=uicontrol('Style','Edit','String',num2str(degree),...
        'Units','normalized','Userdata',degree,'BackgroundColor','white',...
        'Position',xfieldp + [0.07 0.87 -0.10 0],...
        'CallBack','polytool(''change_degree'')');

uicontrolHandles.outputpopup=uicontrol('Style','Popup','String',...
        'Export|Parameters|Parameter CI|Prediction|Prediction CI|Residuals|All','Value',1,...
        'Units','normalized','Position',[0.01 0.07 0.17 0.05],...
        'CallBack','polytool(''output'')');

close_button = uicontrol('Style','Pushbutton','Units','normalized',...
               'Position',[0.01 0.01 0.17 0.05],'Callback','close','String','Close');
