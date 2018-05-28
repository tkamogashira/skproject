function rstool(x,y,model,alpha,xname,yname)
%RSTOOL Interactive fit and plot of a multidimiensional response surface (RSM).
%   RSTOOL(X,Y,MODEL,ALPHA) is a prediction plot that provides a 
%   multiple input polynomial fit to (X,y) data. It plots a 100(1 - ALPHA) 
%   percent global confidence interval for predictions as two red curves. 
%   The default model is linear. MODEL can be following strings:
%   interaction - includes constant, linear, and cross product terms.
%   quadratic - interactions plus squared terms.
%   purequadratic - includes constant, linear and squared terms.
%   The default value for ALPHA is 0.05, which produces 95% confidence 
%   intervals.
%
%   RSTOOL(X,Y,MODEL,ALPHA,XNAME,YNAME) The optional inputs XNAME and 
%   YNAME contain strings for the X and Y variables respectively.
%
%   Drag the dotted white reference line and watch the predicted
%   values update simultaneously. Alternatively, you can get a specific
%   prediction by typing the "X" value into an editable text field.
%   Use the pop-up menu labeled model to interactively change the model.
%   Use the pop-up menu labeled Export to move specified variables to
%   the base workspace.
   
%   B.A. Jones 1-30-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.14 $  $Date: 1998/05/26 20:52:39 $

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
   lin_fig = findobj(0,'Tag','linfig');
   if strcmp(action,'down')
       set(lin_fig,'WindowButtonMotionFcn','rstool(''motion'',1)');
    end

   k = gcf;
   idx = find(lin_fig == k);
   if isempty(idx)
      return
   end
   lin_fig = lin_fig(idx);      
   ud = get(lin_fig,'Userdata');
   
   rmse          = ud.rmse;
   residuals     = ud.residuals;
   alpha         = ud.alpha;
   crit          = ud.crit;
   popup         = ud.popup;
   modelpopup    = ud.modelpopup;
      
   Rinv          = ud.Rinv;
   beta          = ud.beta;
   model         = ud.model;
   xfit          = ud.xfit;
   x_field       = ud.x_field;
   lin_axes      = ud.lin_axes;
   xsettings     = ud.xsettings;
   y_field1      = ud.y_field(1);
   y_field2      = ud.y_field(2);
   fitline       = ud.fitline;
   reference_line= ud.reference_line;
   last_axes     = ud.last_axes;  
   x             = ud.x;
   y             = ud.y;  
   [m,n]         = size(x);

   xrange         = zeros(n,2);
   yrange         = zeros(n,2);
   newx           = zeros(n,1);
   for k = 1:n         
      xrange(k,1:2) = get(lin_axes(k),'XLim');
      yrange(k,1:2) = get(lin_axes(k),'YLim');
   end
   newy = str2double(get(y_field1,'String'));  
end

switch action

case 'start'

if nargin < 4, 
    alpha = 0.05;
end
if isempty(alpha)
    alpha = 0.05;
end

if nargin >= 5
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

if nargin == 6
   ystr = yname;
else
   ystr = 'Predicted Y';
end

ud.usermodel = [];
if nargin < 3
   model = 'linear';
   mval  = 1;
   name  = 'Linear';
elseif isempty(model)
   model = 'linear';
   mval  = 1;
   name  = 'Linear';
elseif strcmp(model,'purequadratic') | strcmp(model,'p'),
   mval  = 2;
   name  = 'Pure Quadratic';
elseif strcmp(model,'interaction') | strcmp(model,'i'),
   mval  = 3;
   name  = 'Interactions';
elseif strcmp(model,'quadratic') | strcmp(model,'q'),
   mval  = 4;
   name  = 'Full Quadratic';
elseif ~isstr(model)
   mval  = 5;
   name  = 'UserSpecified';
   ud.usermodel = model;
else
   if any(exist(model,'file') == [2 3])
      mval  = 5;
      name  = model;
      ud.usermodel = model;
   else
      error(['Cannot find MODEL ' model '.']);
   end
end

[m,n]  = size(x);

design = x2fx(x,model);

% Fit response surface model design
if size(design,2) > size(x,1)
    s = ['Your data is insufficient to fit a ',name, ' model.'];
    error(s);
end
[Q, R] = qr(design,0);
if rcond(R) < 1E-12
    s = ['Your data is insufficient to fit a ',name, ' model.'];
    error(s);
end

beta = R\(Q'*y);
Rinv = R\eye(size(R));

yhat = design*beta;
residuals = y - yhat;

p = length(beta);
df = max(size(y)) - p;

rmse = sqrt(sum(residuals.*residuals)./df);
crit = sqrt(p*finv(1 - alpha,p,df))*rmse;

% Set positions of graphic objects
maxx = max(x);
minx = min(x);
xrange = maxx - minx;
maxx = maxx + 0.025 .* xrange;
minx = minx - 0.025 .* xrange;
xrange = 1.05*xrange;

yfieldp = [.01 .45 .13 .04];

x_field        = zeros(n,1);
lin_axes       = zeros(n,1);
fitline        = zeros(3,n);
reference_line = zeros(n,2);

xfit      = xrange(ones(41,1),:)./40;
xfit(1,:) = minx;
xfit      = cumsum(xfit);

avgx      = mean(x);

xsettings = avgx(ones(42,1),:);

lin_fig = figure('Units','Normalized','Interruptible','on',...
             'Position',[0.05 0.45 0.90 0.5],...
             'Name',['Prediction Plot of ',name,' Model'],'Tag','linfig');
fcolor = get(lin_fig,'Color');
set(lin_fig,'BusyAction','queue','WindowButtonMotionFcn','rstool(''motion'',0)');
set(lin_fig,'WindowButtonDownFcn','rstool(''down'')');
set(lin_fig,'WindowButtonUpFcn','rstool(''up'')','Interruptible','on');

yextremes = zeros(n,2);

for k = 1:n
   % Create an axis for each input (x) variable
   axisp   = [.18 + (k-1)*.80/n .22 .80/n .68];
   lin_axes(k) = axes;
   set(lin_axes(k),'XLim',[minx(k) maxx(k)],'Box','on','NextPlot','add',...
        'DrawMode','fast','Position',axisp,'Gridlinestyle','none');

   if k>1
      set(lin_axes(k),'Yticklabel',[]);
   end

   % Calculate y values for fitted line plot.
   ith_x      = xsettings;
   ith_x(1:41,k) = xfit(:,k);
   
   ith_x(42,k)  = avgx(k);
    
   xpred = x2fx(ith_x,model);

   yfit       = xpred(1:41,:)*beta;
   newy       = xpred(42,:)*beta;

   xi         = xfit(:,k);
   
   % Calculate y values for confidence interval lines.
   E = xpred(1:41,:)*Rinv;
   dy = (sqrt(sum((E.*E)'))*crit)';

   % Plot prediction line with confidence intervals
   set(0,'CurrentFigure',lin_fig);
   set(lin_fig,'CurrentAxes',lin_axes(k));
   fitline(1:3,k) = plot(xi,yfit,'g-',xi,yfit-dy,'r--',xi,yfit+dy,'r--');
   xl = get(lin_axes(k),'Xlim');
   xr = diff(xl);
   xt = get(lin_axes(k),'XTick');
   lowtick = xl(1) + .1*xr;
   hitick  = xl(2) - .1*xr;
   xt = xt(find(xt>lowtick & xt<hitick));
   set(lin_axes(k),'Xtick',xt);
   % Calculate data for vertical reference lines
   yextremes(k,:) = get(gca,'YLim');

   xvert = ones(size(yextremes)) * avgx(k);

   E = xpred(42,:)*Rinv;
   newdeltay = sqrt(E*E')*crit;

end  % End of the plotting loop over all the axes.
    
ymin = min(yextremes(:,1));
ymax = max(yextremes(:,2));
   
%   Create Reference Lines
for k = 1:n
   set(lin_axes(k),'YLim',[ymin ymax]);
   xlimits = get(lin_axes(k),'XLim');
   %   Create Reference Lines
   xvert = ones(size(yextremes(k,:))) * avgx(k);
   set(lin_fig,'CurrentAxes',lin_axes(k));
   reference_line(k,1) = plot(xvert,[ymin ymax],'--','Erasemode','xor');
   reference_line(k,2) = plot(xlimits,[newy newy],':','Erasemode','xor');
   set(reference_line(k,1),'ButtonDownFcn','rstool(''down'')');
end

uihandles = MakeUIcontrols(xstr,lin_fig,newy,newdeltay,ystr,avgx,mval);
ud.popup = uihandles.popup;
ud.modelpopup = uihandles.modelpopup;
ud.x_field = uihandles.x_field; 
ud.y_field  = uihandles.y_field;

ud.texthandle = [];
ud.model = model;   
ud.xfit = xfit;
ud.residuals = residuals;
ud.lin_axes = lin_axes;
ud.xsettings = xsettings;
ud.fitline = fitline;
ud.reference_line = reference_line;
ud.last_axes = zeros(1,n);
ud.x = x;
ud.y = y;
ud.Rinv = Rinv;
ud.rmse = rmse;
ud.crit = crit;
ud.beta = beta;
ud.alpha = alpha;
set(lin_fig,'UserData',ud,'HandleVisibility','callback');
% Finished with plot startup function.

case 'motion',
   p = get(lin_fig,'CurrentPoint');
   k = floor(1+n*(p(1)-0.18)/.80);
   if k < 1 | k > n | p(2) > 0.90 | p(2) < 0.22
      return
   end
   newx(k) = str2double(get(x_field(k),'String'));        
   maxx = xrange(k,2);
   minx = xrange(k,1);
   set(lin_fig,'CurrentAxes',lin_axes(k));
   if flag == 0,
        cursorstate = get(lin_fig,'Pointer');
        cp = get(lin_axes(k),'CurrentPoint');
        cx = cp(1,1);
        cy = cp(1,2);
        fuzz = 0.02 * (maxx - minx);
        online = cx > newx(k) - fuzz & cx < newx(k) + fuzz;
        if online & strcmp(cursorstate,'arrow'),
            cursorstate = 'crosshair';
        elseif ~online & strcmp(cursorstate,'crosshair'),
            cursorstate = 'arrow';
        end
        set(lin_fig,'Pointer',cursorstate);
        return
   elseif flag == 1,
       if last_axes(k) == 0
          return;
       end
        cp = get(lin_axes(k),'CurrentPoint');
        cx=cp(1,1);
        if cx > maxx
            cx = maxx;
        end
        if cx < minx
            cx = minx;
        end

        xrow  = xsettings(1,:);
        xrow(k) = cx;
      
        drow = x2fx(xrow,model);
        yrow = drow*beta;
        E = drow*Rinv;
        deltay = sqrt(E*E')*crit;

        xsettings(:,k) = cx(ones(42,1));
        ud.xsettings = xsettings;            
        set(lin_fig,'Userdata',ud);       
        set(x_field(k),'String',num2str(cx));
        set(y_field1,'String',num2str(yrow));      
        set(y_field2,'String',num2str(deltay));      
        set(reference_line(k,1),'XData',cx*ones(2,1));
        set(reference_line(k,2),'YData',[yrow; yrow]);
       
   end  % End of code for dragging reference lines

case 'down',
   p = get(lin_fig,'CurrentPoint');
   k = floor(1+n*(p(1)-0.18)/.80);
   if k < 1 | k > n | p(2) > 0.90 | p(2) < 0.22
      return
   end
   ud.last_axes(k) = 1;
   set(lin_fig,'Pointer','crosshair');
   xrange = get(lin_axes(k),'Xlim');
   maxx = xrange(2);
   minx = xrange(1);
       
    cp = get(lin_axes(k),'CurrentPoint');
    cx=cp(1,1);
    if cx > maxx
       cx = maxx;
    end
    if cx < minx
       cx = minx;
    end

    xrow  = xsettings(1,:);
    xrow(k) = cx;
    drow = x2fx(xrow,model);
    yrow = drow*beta;
    E = drow*Rinv;
    deltay = sqrt(E*E')*crit;
      

    xsettings(:,k) = cx(ones(42,1));
    ud.xsettings = xsettings;            
    set(lin_fig,'Userdata',ud);       
    set(x_field(k),'String',num2str(cx));
    set(y_field1,'String',num2str(yrow));      
    set(y_field2,'String',num2str(deltay));      
    set(reference_line(k,1),'XData',cx*ones(2,1));
    set(reference_line(k,2),'YData',[yrow; yrow]);

case 'up',
   p = get(lin_fig,'CurrentPoint');
   k = floor(1+n*(p(1)-0.18)/.80);
   lk = find(last_axes == 1);
   if isempty(lk)
      return
   end
   if k < lk
      set(x_field(lk),'String',num2str(xrange(lk,1)));
   elseif k > lk
      set(x_field(lk),'String',num2str(xrange(lk,2)));
   end

   cx    = str2double(get(x_field(lk),'String'));  
   xrow  = xsettings(1,:);
   xrow(lk) = cx;
   xsettings(:,lk) = cx(ones(42,1));

   set(reference_line(lk),'XData',cx*ones(2,1));
   
   ymax = zeros(n,1);
   ymin = zeros(n,1);

   for ix = 1:n       
     % Calculate y values for fitted line plot.
     ith_x      = xsettings;
     ith_x(1:41,ix) = xfit(:,ix);
   
     ith_x(42,lk)  = cx;
    
     xpred = x2fx(ith_x,model);
     yfit       = xpred(1:41,:)*beta;
     cy         = xpred(42,:)*beta;

     E  = xpred(1:41,:)*Rinv;
     dy = (sqrt(sum((E.*E)'))*crit)';

     E = xpred(42,:)*Rinv;
     dcy = sqrt(E*E')*crit;
            
     ud.xsettings = xsettings;            
     set(fitline(1,ix),'Ydata',yfit);
     set(fitline(2,ix),'Ydata',yfit-dy);
     set(fitline(3,ix),'Ydata',yfit+dy);
     ymax(ix) = max(yfit+dy);
     ymin(ix) = min(yfit-dy);         
   end
   
   for ix = 1:n
      set(lin_axes(ix),'Ylim',[min(ymin) max(ymax)]);
      set(reference_line(ix,1),'Ydata',[min(ymin) max(ymax)]);
      set(reference_line(ix,2),'YData',[cy cy]);
   end

   ud.last_axes = zeros(n,1);
   set(y_field1,'String',num2str(cy));
   set(y_field2,'String',num2str(dcy));
   set(lin_fig,'WindowButtonMotionFcn','rstool(''motion'',0)','Pointer','arrow','Userdata',ud);

case 'edittext',
   cx    = str2double(get(x_field(flag),'String'));  
   if isempty(cx)
       set(x_field(flag),'String',num2str(xsettings(1,flag)));
       % Create Bad Settings Warning Dialog.
       warndlg('Please type only numbers in the editable text fields.');
       return
   end  
   
   xl = get(lin_axes(flag),'Xlim');
   if cx < xl(1) | cx > xl(2)
       % Create Bad Settings Warning Dialog.
       warndlg('This number is outside the range of the data for this variable.');
       set(x_field(flag),'String',num2str(xsettings(1,flag)));
       return
   end
   
   xrow  = xsettings(1,:);
   xrow(flag) = cx;
   xsettings(:,flag) = cx(ones(42,1));
   ud.xsettings = xsettings;            

   set(reference_line(flag,1),'XData',cx*ones(2,1));
   
   ymax = zeros(n,1);
   ymin = zeros(n,1);

   for ix = 1:n       

      % Calculate y values for fitted line plot.
      ith_x      = xsettings;
      ith_x(1:41,ix) = xfit(:,ix);
   
      ith_x(42,flag)  = cx;
    
      xpred = x2fx(ith_x,model);
      yfit       = xpred(1:41,:)*beta;
      cy         = xpred(42,:)*beta;

      E  = xpred(1:41,:)*Rinv;
      dy = (sqrt(sum((E.*E)'))*crit)';

      E = xpred(42,:)*Rinv;
      dcy = sqrt(E*E')*crit;

      set(fitline(1,ix),'Ydata',yfit);
      set(fitline(2,ix),'Ydata',yfit-dy);
      set(fitline(3,ix),'Ydata',yfit+dy);
      ymax(ix) = max(yfit+dy);
      ymin(ix) = min(yfit-dy);         
   end
   
   for ix = 1:n
      set(lin_axes(ix),'Ylim',[min(ymin) max(ymax)]);
      set(reference_line(ix,1),'Ydata',[min(ymin) max(ymax)]);
      set(reference_line(ix,2),'YData',[cy cy]);
   end
   set(lin_fig,'Userdata',ud);       
   set(y_field1,'String',num2str(cy));
   set(y_field2,'String',num2str(dcy));

case 'output',
    bmf = get(lin_fig,'WindowButtonMotionFcn');
    bdf = get(lin_fig,'WindowButtonDownFcn');
    set(lin_fig,'WindowButtonMotionFcn','');
    set(lin_fig,'WindowButtonDownFcn','');

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
          promptstr = 'Enter names for the regression statistics or use the defaults:';
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
               'Callback','rstool(''toworkspace'');close(gcbf)',...
               'String','OK');

    set(lin_fig,'UserData',ud);
    set(dlghandle,'HandleVisibility','off')
    set(lin_fig,'WindowButtonMotionFcn',bmf);
    set(lin_fig,'WindowButtonDownFcn',bdf);

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
          assignin('base',s,rmse)
       case 4,
          assignin('base',s,residuals)
       case 5,
          cpos=findstr(s,',');
          assignin('base',s(1:cpos(1)-1),beta)
          assignin('base',s((cpos(1)+1):(cpos(2)-1)),rmse)
          assignin('base',s((cpos(2)+1):end),residuals)
    end

case 'changemodel',
   cases = get(modelpopup,'Value');
   if cases == 1
      model = 'linear';
   elseif cases == 2
      model = 'purequadratic';
   elseif cases == 3
      model = 'interaction';
   elseif cases == 4
      model = 'quadratic';
   elseif cases == 5
      if isstr(model)
         if isempty(ud.usermodel)
            disp('Call RSTOOL with a numeric model matrix to use the User Specified model.');
            disp('See the help for X2FX.');            
            disp('Fitting a linear model.');
            model = 'linear';
            set(modelpopup,'Value',1);
         else
            model = ud.usermodel;
			if isstr(ud.usermodel)
			   set(lin_fig,'Name',['Prediction Plot of ',ud.usermodel,' Model'])
            else
	           set(lin_fig,'Name',['Prediction Plot of User Specified Model'])
			end
         end
      end
   end
    
   design = x2fx(x,model);

   % Fit response surface model design
   [Q, R] = qr(design,0);
   if rcond(R) < 1E-12
       % Create Model Warning Figure.
       s = ['Your data is insufficient to fit a ',model, ' model. Reseting to previous model.'];
       warndlg(s);
       mval = get(modelpopup,'Userdata');
       set(modelpopup,'Value',mval);

       if mval == 1
          set(lin_fig,'Name','Prediction Plot of Linear Model')
       elseif mval == 2
          set(lin_fig,'Name','Prediction Plot of Pure Quadratic Model')
       elseif mval == 3
          set(lin_fig,'Name','Prediction Plot of Interactions Model')
       elseif mval == 4
          set(lin_fig,'Name','Prediction Plot of Full Quadratic Model')
       end
       drawnow;
       return;
    end
    beta = R\(Q'*y);
    Rinv = R\eye(size(R));

    yhat = design*beta;
    residuals = y - yhat;

    p = length(beta);
    df = max(size(y)) - p;

    rmse = sqrt(sum(residuals.*residuals)./df);
    crit = sqrt(p*finv(1 - alpha,p,df))*rmse;

    ymax = zeros(n,1);
    ymin = zeros(n,1);
    
   for k = 1:n
      % Calculate y values for fitted line plot.
      ith_x      = xsettings;
      ith_x(1:41,k) = xfit(:,k);
   
      ith_x(42,k)  = xsettings(1,k);
      xpred      = x2fx(ith_x,model);

      yfit       = xpred(1:41,:)*beta;
      newy       = xpred(42,:)*beta;

      xi         = xfit(:,k);
   
      % Calculate y values for confidence interval lines.
      E = xpred(1:42,:)*Rinv;
      dy = (sqrt(sum((E.*E)'))*crit)';
      dcy = dy(42);
      dy = dy(1:41);

      % Plot prediction line with confidence intervals
      set(0,'CurrentFigure',lin_fig);
      set(lin_fig,'CurrentAxes',lin_axes(k));
      set(fitline(1,k),'Xdata',xi,'Ydata',yfit);
      set(fitline(2,k),'Xdata',xi,'Ydata',yfit-dy);
      set(fitline(3,k),'Xdata',xi,'Ydata',yfit+dy);
      ymax(k) = max(yfit+dy);
      ymin(k) = min(yfit-dy);         
    end
   
   for ix = 1:n
      set(lin_axes(ix),'Ylim',[min(ymin) max(ymax)]);
      set(reference_line(ix,1),'Ydata',[min(ymin) max(ymax)]);
      set(reference_line(ix,2),'YData',[newy; newy]);
   end
   
   set(y_field1,'String',num2str(newy));
   set(y_field2,'String',num2str(dcy));

   if cases == 1
      set(lin_fig,'Name','Prediction Plot of Linear Model')
   elseif cases == 2
      set(lin_fig,'Name','Prediction Plot of Pure Quadratic Model')
   elseif cases == 3
      set(lin_fig,'Name','Prediction Plot of Interactions Model')
   elseif cases == 4
      set(lin_fig,'Name','Prediction Plot of Full Quadratic Model')
   end
   set(modelpopup,'Userdata',cases);
   ud.crit      = crit;
   ud.rmse      = rmse;
   ud.Rinv      = Rinv;
   ud.beta      = beta;
   ud.model     = model;
   ud.residuals = residuals;
   set(lin_fig,'Userdata',ud);   
end

function uihandles = MakeUIcontrols(xstr,lin_fig,newy,newdeltay,ystr,avgx,mval)
% Local function for Creating uicontrols for rstool.
fcolor = get(lin_fig,'Color');
yfieldp = [.01 .45 .10 .04];
uihandles.y_field(1) = uicontrol(lin_fig,'Style','text','Units','normalized',...
         'Position',yfieldp + [0 .14 0 0],'String',num2str(newy),...
         'ForegroundColor','k','BackgroundColor',fcolor);

uihandles.y_field(2) = uicontrol(lin_fig,'Style','text','Units','normalized',...
         'Position',yfieldp,'String',num2str(newdeltay),...
         'ForegroundColor','k','BackgroundColor',fcolor);

uihandles.popup     = uicontrol(lin_fig,'Style','Popup','String',...
              'Export|Parameters|RMSE|Residuals|All','Value',1,...
              'Units','normalized','Position',[0.01 0.14 0.13 0.05],...
              'CallBack','rstool(''output'')');

uihandles.modelpopup   = uicontrol(lin_fig,'Style','Popup','String',...
              'Linear|Pure Quadratic|Interactions|Full Quadratic|User Specified','Value',mval,...
              'Units','normalized','Position',[0.01 0.08 0.13 0.05],...
              'CallBack','rstool(''changemodel'')','Userdata',mval);

uicontrol(lin_fig,'Style','text','Units','normalized',...
         'Position',yfieldp + [0 .07 -0.01 0],'String',' +/-',...
       'ForegroundColor','k','BackgroundColor',fcolor);

uicontrol('Style','Pushbutton','Units','normalized',...
               'Position',[0.01 0.02 0.13 0.05],'Callback','close','String','Close');

uicontrol(lin_fig,'Style','text','Units','normalized',...
        'Position',yfieldp + [0 0.21 0 0],'BackgroundColor',fcolor,...
        'ForegroundColor','k','String',ystr);

n = length(xstr);
for k = 1:n
   xfieldp = [.18 + (k-0.5)*.80/n - 0.5*min(.5/n,.15) .09 min(.5/n,.15) .07];
   xtextp  = [.18 + (k-0.5)*.80/n - 0.5*min(.5/n,.18) .02 min(.5/n,.18) .05];
   uicontrol(lin_fig,'Style','text','Units','normalized',...
        'Position',xtextp,'BackgroundColor',fcolor,...
        'ForegroundColor','k','String',xstr{k});

   uihandles.x_field(k)  = uicontrol(lin_fig,'Style','edit','Units','normalized',...
         'Position',xfieldp,'String',num2str(avgx(k)),...
         'BackgroundColor','white','CallBack',['rstool(''edittext'',',int2str(k),')']);
end
