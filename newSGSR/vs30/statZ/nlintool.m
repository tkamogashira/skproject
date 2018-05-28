function nlintool(x,y,model,beta0,alpha,xname,yname)
%NLINTOOL Interactive graphical tool for nonlinear fitting and prediction.
%   NLINTOOL(X,Y,MODEL,BETA0,ALPHA) is a prediction plot that provides a 
%   nonlinear curve fit to (x,y) data. It plots a 100(1 - ALPHA) percent
%   global confidence interval for predictions as two red curves. BETA0 is
%   a vector containing initial guesses for the parameters. 
%   The default value for ALPHA is 0.05, which produces 95% confidence
%   intervals. 
%
%   NLINTOOL(X,Y,MODEL,BETA0,ALPHA,XNAME,YNAME) The optional inputs XNAME  
%   and YNAME contain strings for the X and Y variables respectively.
%
%   You can drag the dotted white reference line and watch the predicted
%   values update simultaneously. Alternatively, you can get a specific
%   prediction by typing the "X" value into an editable text field.
%   Use the pop-up menu labeled Export to move specified variables to
%   the base workspace.
   
%   B.A. Jones 1-30-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.14 $  $Date: 1998/05/26 20:52:37 $

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

   %set(0,'showhiddenhandles','off')
   nlin_fig = findobj(0,'Tag','nlinfig');
   
   k = gcf;
   idx = find(nlin_fig == k);
   if isempty(idx)
      return
   end
   nlin_fig = nlin_fig(idx);      
   if strcmp(action,'down')
       set(nlin_fig,'WindowButtonMotionFcn','nlintool(''motion'',1)');
   end
   ud = get(nlin_fig,'Userdata');
   
   crit          = ud.crit;
   popup         = ud.popup;
   
   Rinv          = ud.Rinv;
   beta          = ud.beta;
   model         = ud.model;
   xfit          = ud.xfit;
   x_field       = ud.x_field;
   nlin_axes     = ud.nlin_axes;
   xsettings     = ud.xsettings;
   y_field1      = ud.y_field(1);
   y_field2      = ud.y_field(2);
   fitline       = ud.fitline;
   reference_line= ud.reference_line;
   last_axes     = ud.last_axes;  
   n             = size(x_field,2);

   xrange         = zeros(n,2);
   yrange         = zeros(n,2);
   newx           = zeros(n,1);

   for k = 1:n         
       xrange(k,1:2) = get(nlin_axes(k),'XLim');
       yrange(k,1:2) = get(nlin_axes(k),'YLim');
   end
   newy = str2double(get(y_field1,'String'));  
end

switch action

case 'start'

if nargin < 5, 
    alpha = 0.05;
end
if isempty(alpha)
   alpha = 0.05;
end

if nargin >= 6
   for k = 1:size(x,2)
      if isempty(xname)
         xstr{k} = ['X' int2str(k)];
      else
         xstr{k} = xname(k,:);
      end
   end
else
   for k = 1:size(x,2)
      xstr{k} = ['X' int2str(k)];
   end
end

if nargin == 7
   ystr = yname;
else
   ystr = 'Predicted Y';
end

% Fit nonlinear model
[ud.beta, loss, J] = nlinfit(x,y,model,beta0);
if rcond(J'*J) < 1E-12
    warndlg('Your model fit is poor. Use discretion with these results.');
end

yhat = feval(model,ud.beta,x);
residuals = y - yhat;

p = length(ud.beta);
df = max(size(y)) - p;

ud.rmse = sqrt(sum(residuals.*residuals)./df);
ud.crit = sqrt(p*finv(1 - alpha,p,df))*ud.rmse;

[Q R] = qr(J,0);
ud.Rinv = R\eye(size(R));

% Set positions of graphic objects
maxx = max(x);
minx = min(x);
xrange = maxx - minx;
maxx = maxx + 0.025 .* xrange;
minx = minx - 0.025 .* xrange;
xrange = 1.05*xrange;

[m,n]          = size(x);

nlin_axes      = zeros(n,1);
fitline        = zeros(3,n);
reference_line = zeros(n,2);

xfit      = xrange(ones(41,1),:)./40;
xfit(1,:) = minx;
xfit      = cumsum(xfit);

avgx      = mean(x);
xsettings = avgx(ones(41,1),:);

nlin_fig = figure('Units','Normalized','Interruptible','on','Position',[0.05 0.45 0.90 0.5],...
             'Name',['Nonlinear Fit of ',model,' Model'],'Tag','nlinfig');
set(nlin_fig,'BusyAction','queue','WindowButtonMotionFcn','nlintool(''motion'',0)', ...
             'WindowButtonDownFcn','nlintool(''down'')','WindowButtonUpFcn','nlintool(''up'')', ...
			 'Backingstore','off','WindowButtonMotionFcn','nlintool(''motion'',0)');

for k = 1:n
   % Create an axis for each input (x) variable
    axisp   = [.18 + (k-1)*.80/n .22 .80/n .68];

    nlin_axes(k) = axes;
    set(nlin_axes(k),'XLim',[minx(k) maxx(k)],'Box','on','NextPlot','add',...
        'DrawMode','fast','Position',axisp,'GridLineStyle','none');
    if k>1
       set(nlin_axes(k),'Yticklabel',[]);
    end

   % Calculate y values for fitted line plot.
   ith_x      = xsettings;
   ith_x(:,k) = xfit(:,k);
   [yfit, deltay] = PredictionsPlusError(ith_x,ud.beta,model,ud.crit,ud.Rinv);
 
   % Plot prediction line with confidence intervals
   set(nlin_fig,'CurrentAxes',nlin_axes(k));
   fitline(1:3,k) = plot(ith_x(:,k),yfit,'g-',ith_x(:,k),yfit-deltay,'r--',ith_x(:,k),yfit+deltay,'r--');

   % Calculate data for vertical reference lines
   yextremes(k,:) = get(gca,'YLim');
end  % End of the plotting loop over all the axes.

ymin = min(yextremes(:,1));
ymax = max(yextremes(:,2));
[newy, newdeltay] = PredictionsPlusError(avgx,ud.beta,model,ud.crit,ud.Rinv);

for k = 1:n
   set(nlin_axes(k),'YLim',[ymin ymax]);
   xlimits = get(nlin_axes(k),'XLim');
   %   Create Reference Lines
   xvert = ones(size(yextremes(k,:))) * avgx(k);
   set(nlin_fig,'CurrentAxes',nlin_axes(k));
   reference_line(k,1) = plot(xvert,[ymin ymax],'--','Erasemode','xor');
   reference_line(k,2) = plot(xlimits,[newy newy],':','Erasemode','xor');
   set(reference_line(k,1),'ButtonDownFcn','nlintool(''down'')');
end

uihandles = MakeUIcontrols(xstr,nlin_fig,newy,newdeltay,ystr,avgx);
ud.popup = uihandles.popup;
ud.x_field = uihandles.x_field; 
ud.y_field  = uihandles.y_field;

ud.texthandle = [];

ud.model = model;   
ud.xfit = xfit;
ud.residuals = residuals;
ud.nlin_axes = nlin_axes;
ud.xsettings = xsettings;
ud.fitline = fitline;
ud.reference_line = reference_line;
ud.last_axes = zeros(1,n);
set(nlin_fig,'UserData',ud,'HandleVisibility','callback');

% Finished with plot startup function.

case 'motion',
   p = get(nlin_fig,'CurrentPoint');
   k = floor(1+n*(p(1)-0.18)/.80);
   if k < 1 | k > n
      return
   end
   newx(k) = str2double(get(x_field(k),'String'));
   maxx = xrange(k,2);
   minx = xrange(k,1);
     
    if flag == 0,
       % Check for data consistency in each axis
       if n > 1,
          yn = zeros(n,1);
          for idx = 1:n
             y = get(reference_line(idx,2),'Ydata');
             yn(idx) = y(1);
          end
          % If data is inconsistent update all the plots.
          if diff(yn) ~= zeros(n-1,1)
             nlintool('up');
          end
       end
       % Change cursor to plus sign when mouse is on top of vertical line.
        cursorstate = get(nlin_fig,'Pointer');
        cp = get(nlin_axes(k),'CurrentPoint');
        cx = cp(1,1);
        cy = cp(1,2);
        fuzz = 0.02 * (maxx - minx);
        online = cx > newx(k) - fuzz & cx < newx(k) + fuzz;
        if online & strcmp(cursorstate,'arrow'),
            cursorstate = 'crosshair';
        elseif ~online & strcmp(cursorstate,'crosshair'),
            cursorstate = 'arrow';
        end
        set(nlin_fig,'Pointer',cursorstate);
        return
      elseif flag == 1,
        if last_axes(k) == 0
            return;
        end
        cp = get(nlin_axes(k),'CurrentPoint');
        cx=cp(1,1);
        if cx > maxx
            cx = maxx;
        end
        if cx < minx
            cx = minx;
        end

       xrow  = xsettings(1,:);
       xrow(k) = cx;
       [cy, dcy] = PredictionsPlusError(xrow,beta,model,ud.crit,Rinv);

        ud.xsettings = xsettings;            
        set(nlin_fig,'Userdata',ud);       
 
        set(x_field(k),'String',num2str(cx));
        set(reference_line(k,1),'XData',cx*ones(2,1));
        set(reference_line(k,2),'YData',[cy cy]);
      
        set(y_field1,'String',num2str(cy));
        set(y_field2,'String',num2str(dcy));

     end  % End of code for dragging reference lines

case 'down',
       p = get(nlin_fig,'CurrentPoint');
       k = floor(1+n*(p(1)-0.18)/.80);
       if k < 1 | k > n | p(2) > 0.90 | p(2) < 0.22
          return
       end
       ud.last_axes(k) = 1;
       set(nlin_fig,'Pointer','crosshair');
       cp = get(nlin_axes(k),'CurrentPoint');
       cx=cp(1,1);
	   xl = get(nlin_axes(k),'Xlim');
	   maxx = xl(2);
	   minx = xl(1);
       if cx > maxx
          cx = maxx;
       end
       if cx < minx
          cx = minx;
       end

       xrow  = xsettings(1,:);
       xrow(k) = cx;
       xsettings(:,k) = cx(ones(41,1));
       [cy, dcy] = PredictionsPlusError(xrow,beta,model,ud.crit,Rinv);

       ud.xsettings = xsettings;            
       set(nlin_fig,'Userdata',ud);       
 
       set(x_field(k),'String',num2str(cx));
       set(reference_line(k,1),'XData',cx*ones(2,1));
       set(reference_line(k,2),'YData',[cy cy]);
      
       set(y_field1,'String',num2str(cy));
       set(y_field2,'String',num2str(dcy));

       set(nlin_fig,'WindowButtonUpFcn','nlintool(''up'')');

case 'up',
   p = get(nlin_fig,'CurrentPoint');
   k = floor(1+n*(p(1)-0.15)/.80);
   lk = find(last_axes == 1);
   if isempty(lk)
      return
   end
   if k < lk
      set(x_field(lk),'String',num2str(xrange(lk,1)));
   elseif k > lk
      set(x_field(lk),'String',num2str(xrange(lk,2)));
   end
       
    set(nlin_fig,'WindowButtonMotionFcn','nlintool(''motion'',0)');

    cx    = str2double(get(x_field(lk),'String'));
    xrow  = xsettings(1,:);
    xrow(lk) = cx;
  
	[cy, dcy] = PredictionsPlusError(xrow,beta,model,crit,Rinv);
      
    xsettings(:,lk) = cx(ones(41,1));

    set(reference_line(lk,1),'XData',cx*ones(2,1));
    set(reference_line(lk,2),'YData',[cy cy]);
    ymax = zeros(n,1);
    ymin = zeros(n,1);
    ud.xsettings = xsettings;            
       
    for idx = 1:n
       ith_x      = xsettings;
       ith_x(:,idx) = xfit(:,idx);
	   [yfit, deltay] = PredictionsPlusError(ith_x,beta,model,crit,Rinv);
             
       set(fitline(1,idx),'Ydata',yfit);
       set(fitline(2,idx),'Ydata',yfit-deltay);
       set(fitline(3,idx),'Ydata',yfit+deltay);
       ymax(idx) = max(yfit+deltay);
       ymin(idx) = min(yfit-deltay);
    end         

    for ix = 1:n      
       ud.last_axes(ix) = 0;
       set(nlin_axes(ix),'Ylim',[min(ymin) max(ymax)])
       set(reference_line(ix,1),'Ydata',[min(ymin) max(ymax)]);
       set(reference_line(ix,2),'YData',[cy cy]);
    end
    set(nlin_fig,'Userdata',ud);       
         
    set(y_field1,'String',num2str(cy));
    set(y_field2,'String',num2str(dcy));

case 'edittext',
   cx    = str2double(get(x_field(flag),'String'));
   
   if isempty(cx)
      set(x_field(flag),'String',num2str(xsettings(1,flag)));
      % Create Bad Settings Warning Dialog.
      warndlg('Please type only numbers in the editable text fields.');
      return
   end  
   xl = get(nlin_axes(flag),'Xlim');
   if cx < xl(1) | cx > xl(2)
      % Create Bad Settings Warning Dialog.
      warndlg('This number is outside the range of the data for this variable.');
      set(x_field(flag),'String',num2str(xsettings(1,flag)));
      return
   end
   
   xrow  = xsettings(1,:);
   xrow(flag) = cx;
   [cy, dcy] = PredictionsPlusError(xrow,beta,model,crit,Rinv);

   xsettings(:,flag) = cx(ones(41,1));

   set(reference_line(flag,1),'XData',cx*ones(2,1));
   set(reference_line(flag,2),'YData',[cy cy]);
   
   ymax = zeros(n,1);
   ymin = zeros(n,1);
      
   for idx = 1:n
     ith_x          = xsettings;
     ith_x(:,idx)   = xfit(:,idx);
	 [yfit, deltay] = PredictionsPlusError(ith_x,beta,model,crit,Rinv);
            
     ud.xsettings = xsettings;            
     set(nlin_fig,'Userdata',ud);       
     set(fitline(1,idx),'Ydata',yfit);
     set(fitline(2,idx),'Ydata',yfit-deltay);
     set(fitline(3,idx),'Ydata',yfit+deltay);
     ymax(idx) = max(yfit+deltay);
     ymin(idx) = min(yfit-deltay);         
         
   end
   for ix = 1:n
       set(nlin_axes(ix),'Ylim',[min(ymin) max(ymax)]);
       set(reference_line(ix,1),'Ydata',[min(ymin) max(ymax)]);
       set(reference_line(ix,2),'YData',[cy cy]);
   end
   set(y_field1,'String',num2str(cy));
   set(y_field2,'String',num2str(dcy));


case 'output',
    bmf = get(nlin_fig,'WindowButtonMotionFcn');
    bdf = get(nlin_fig,'WindowButtonDownFcn');
    set(nlin_fig,'WindowButtonMotionFcn','');
    set(nlin_fig,'WindowButtonDownFcn','');

    outval = get(popup,'Value');
    switch outval
       case 1,
          return,         
       case 2,
          promptstr = 'Enter the variable name for the fitted parameters or use default:';
          entrystr = 'beta';
       case 3,
          promptstr = 'Enter the variable name for the RMSE of the fit or use default:';
          entrystr = 'rmse';
       case 4,
          promptstr = 'Enter the variable name for the residuals or use default:';
          entrystr = 'residuals';
       case 5,
          promptstr = 'Enter variable names or use the supplied names:';
          entrystr = 'beta,rmse,residuals';
    end
    dlghandle = dialog('Visible','off','WindowStyle','modal');

    set(dlghandle,'Units','pixels','Position',[100 300 400 100],'Visible','on');
    uicontrol(dlghandle,'Style','text','Units','pixels',...
          'Position',[10 75 380 20],...
          'String',promptstr);

    ud.texthandle = uicontrol(dlghandle,'Style','edit','Units','pixels',...
               'String',entrystr,'HorizontalAlignment','center',...
               'Position',[50 40 300 20]);

    ok_button = uicontrol('Style','Pushbutton','Units','pixels','Position',[180 5 40 20],...
               'Callback','nlintool(''toworkspace'');close(gcbf)',...
               'String','OK');

    set(nlin_fig,'UserData',ud);
    set(dlghandle,'HandleVisibility','off')
    set(nlin_fig,'WindowButtonMotionFcn',bmf);
    set(nlin_fig,'WindowButtonDownFcn',bdf);

case 'toworkspace',
    outval = get(popup,'Value');
    set(popup,'Value',1);
    s = get(ud.texthandle,'String');
 
    switch outval
       case 1,
          return,         
       case 2,
          assignin('base',s,beta)
       case 3,
          assignin('base',s,ud.rmse)
       case 4,
          assignin('base',s,ud.residuals)
       case 5,
          cpos=findstr(s,',');
          assignin('base',s(1:cpos(1)-1),beta)
          assignin('base',s((cpos(1)+1):(cpos(2)-1)),ud.rmse)
          assignin('base',s((cpos(2)+1):end),ud.residuals)
    end
end

function [y, deltay] = PredictionsPlusError(x,beta,model,crit,Rinv)
% Local function for Predicting a response with error bounds.

% Predict Response
y = feval(model,beta,x);
   
% Calculate Error Bounds.
deltay = zeros(size(x,1),length(beta));

for k = 1:length(beta),
    delta = zeros(size(beta));
    delta(k) = sqrt(eps)*beta(k);
    yplus = feval(model,beta+delta,x);
    ypred = feval(model,beta,x);
    J(:,k) = (yplus - ypred)/delta(k);
end

E = J*Rinv;
deltay = sqrt(sum((E.*E)')')*crit;

function uihandles = MakeUIcontrols(xstr,nlin_fig,newy,newdeltay,ystr,avgx)
% Local function for Creating uicontrols for nlintool.
fcolor = get(nlin_fig,'Color');
yfieldp = [.01 .45 .10 .04];
uihandles.y_field(1) = uicontrol(nlin_fig,'Style','text','Units','normalized',...
         'Position',yfieldp + [0 .14 0 0],'String',num2str(newy),...
         'ForegroundColor','k','BackgroundColor',fcolor);

uihandles.y_field(2) = uicontrol(nlin_fig,'Style','text','Units','normalized',...
         'Position',yfieldp,'String',num2str(newdeltay),...
         'ForegroundColor','k','BackgroundColor',fcolor);

uihandles.popup     = uicontrol(nlin_fig,'Style','Popup','String',...
              'Export|Parameters|RMSE|Residuals|All','Value',1,...
              'Units','normalized','Position',[0.01 0.10 0.13 0.07],...
              'CallBack','nlintool(''output'')');

uicontrol(nlin_fig,'Style','text','Units','normalized',...
         'Position',yfieldp + [0 .07 -0.01 0],'String',' +/-',...
       'ForegroundColor','k','BackgroundColor',fcolor);

uicontrol('Style','Pushbutton','Units','normalized',...
               'Position',[0.01 0.01 0.13 0.07],'Callback','close','String','Close');

uicontrol(nlin_fig,'Style','text','Units','normalized',...
        'Position',yfieldp + [0 0.21 0 0],'BackgroundColor',fcolor,...
        'ForegroundColor','k','String',ystr);

n = length(xstr);
for k = 1:n
   xfieldp = [.18 + (k-0.5)*.80/n - 0.5*min(.5/n,.15) .09 min(.5/n,.15) .07];
   xtextp  = [.18 + (k-0.5)*.80/n - 0.5*min(.5/n,.18) .02 min(.5/n,.18) .05];
   uicontrol(nlin_fig,'Style','text','Units','normalized',...
        'Position',xtextp,'BackgroundColor',fcolor,...
        'ForegroundColor','k','String',xstr{k});

   uihandles.x_field(k)  = uicontrol(nlin_fig,'Style','edit','Units','normalized',...
         'Position',xfieldp,'String',num2str(avgx(k)),...
         'BackgroundColor','white','CallBack',['nlintool(''edittext'',',int2str(k),')']);
end
