function fsurfht(fun,xlim,ylim,varargin);
%FSURFHT Interactive contour plot of a function.
%   FSURFHT(FUN,XLIM,YLIM) is an interactive contour plot of the function
%   specified by the text variable FUN.  The x-axis limits are specified 
%   by XLIM = [XMIN XMAX] and the y-axis limits specified by YLIM.
%   FSURFHT(FUN,XLIM,YLIM,VARARGIN) allows for an arbitrary number of
%   optional parameters that you can supply to the function FUN. The first two
%   arguments of FUN are the x-axis variable and y-axis variable, respectively. 
%
%   There are vertical and horizontal reference lines on the plot whose 
%   intersection defines the current x-value and y-value. You can drag
%   these dotted white reference lines and watch the calculated z-values (at
%   the top of the plot) update simultaneously. Alternatively, you can get a 
%   specific z-value by typing the x-value and y-value into editable text
%   fields on the x-axis and y-axis respectively. 

%   B.A. Jones 5-23-93
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.10 $  $Date: 1998/05/26 20:52:37 $

if nargin > 2 
    action = 'start';
else
    action = fun;
end

%On recursive calls get all necessary handles and data.
if ~strcmp(action,'start')   
   
   surf_fig = findobj('Tag', 'surffig');
%findobj('Name', fun);
   f = get(surf_fig,'Userdata');

   x_field          = f(1);
   y_field          = f(2);
   z_field          = f(3);
   xtext            = f(4);
   ytext            = f(5);
   ztext            = f(6);
   response_surface = f(7);
   extra_parameters = f(8);
   surf_axes        = f(9);
   
   xgrid = get(xtext,'UserData');
   ygrid = get(ytext,'UserData');
   zgrid = get(ztext,'UserData');
   p     = get(extra_parameters,'UserData');
   fun   = get(response_surface,'String');
   h     = get(surf_axes,'UserData');
    
   vwitnessline = h(1);
   hwitnessline = h(2);

    xrange = get(surf_axes,'XLim');
    yrange = get(surf_axes,'YLim');

    newx = str2double(get(x_field,'String'));  
    newy = str2double(get(y_field,'String'));  
    extra = length(p);   
   
end

if strcmp(action,'start'),

% Create intial parameter values 
extra = length(varargin);
extrap = varargin;

% Set positions of graphic objects
axisp   = [.20 .15 .79 .74];

xfieldp = [0.53 0.00 0.13 0.05];
yfieldp = [0.02 0.50 .13 0.05];
zfieldp = xfieldp + [0 0.89 0 0];

surf_fig = figure;
whitebg(surf_fig, [0 0 0]);
set(surf_fig,'Units','Normalized', 'Tag', 'surffig', 'Name', fun);
fcolor = get(surf_fig,'Color');

surf_axes = axes;
set(surf_axes,'Parent', surf_fig);

%surf_axes = get(surf_fig,'CurrentAxes');

% Set axis limits and data
yvertical = [ylim(1) ylim(2)]';
xvertical = ones(size(yvertical)) * (xlim(1) + xlim(2))/2;
newx  = xvertical(1);
newy  = (ylim(1) + ylim(2))/2;

xvalues       = linspace(xlim(1),xlim(2),50);
yvalues       = linspace(ylim(1),ylim(2),50);
[xgrid ygrid] = meshgrid(xvalues,yvalues);
zgrid         = feval(fun,xgrid,ygrid,varargin{:});

% Define graphics objects        
x_field=uicontrol('Style','edit','Units','normalized','Position',xfieldp,...
         'String',num2str(newx),...
         'BackgroundColor','white','Userdata',newx,...
         'CallBack','fsurfht(''editX'')');
         
y_field=uicontrol('Style','edit','Units','normalized','Position',yfieldp,...
         'BackgroundColor','white','Userdata',newy,...
         'String',num2str(newy),'CallBack','fsurfht(''editY'')');

z_field=uicontrol('Style','text','Units','normalized','Position',zfieldp,...
         'String',num2str(NaN),'BackgroundColor','w');

xtext   =uicontrol('Style','text','Units','normalized',...
         'Position',xfieldp + [0 0.05 0 0],'BackgroundColor',fcolor,...
         'ForegroundColor','w','String','X Value','UserData',xgrid);
        
ytext   =uicontrol('Style','text','Units','normalized',...
        'Position',yfieldp + [0 0.05 0 0],'BackgroundColor',fcolor,...
        'ForegroundColor','w','String','Y Value','UserData',ygrid);

ztext   =uicontrol('Style','text','Units','normalized',...
        'Position',zfieldp + [0 0.05 0 0],'BackgroundColor',fcolor,...
        'ForegroundColor','w','String','Z Value','UserData',zgrid);



response_surface=uicontrol('Style','text','Visible','off',...
        'String',fun,'UserData','response_surface');

extra_parameters=uicontrol('Style','text','Visible','off','UserData',extrap);
           
%   Create Interactive Contour Plot
set(surf_fig,'Units','Normalized');

[contour_labels contour_handles]  = contour(xvalues,yvalues,zgrid);
clabel(contour_labels);
set(surf_axes,'Position',axisp,'XLim',xlim,'YLim',ylim,'Box','on');

set(surf_axes,'NextPlot','add','DrawMode','fast','GridLineStyle','none');
gcacolor = get(surf_axes,'Color');

%   Evaluate Z-field and Create Witness Lines
newz = feval(fun,newx,newy,varargin{:});
set(z_field,'String',num2str(newz));

xhorizontal = [xlim(1) xlim(2)]';
yhorizontal = newy * ones(size(xhorizontal));

vwitnessline = plot(xvertical,yvertical,'LineStyle','-.','EraseMode','xor','UserData','vertical_reference');
hwitnessline = plot(xhorizontal,yhorizontal,'LineStyle','-.','EraseMode','xor','UserData','horizontal_reference');

set(vwitnessline,'ButtonDownFcn','fsurfht(''down'',1)','Color',1-gcacolor);
set(hwitnessline,'ButtonDownFcn','fsurfht(''down'',1)','Color',1-gcacolor);

set(surf_fig,'Backingstore','off','WindowButtonMotionFcn','fsurfht(''motion'',0)');
set(surf_fig,'WindowButtonDownFcn','fsurfht(''down'')');

set(surf_fig,'Userdata',[x_field;y_field;z_field;xtext;ytext;ztext;...
    response_surface;extra_parameters;surf_axes]);
set(surf_axes,'UserData',[vwitnessline;hwitnessline]);

% End of initialization activities.
elseif strcmp(action,'motion'),
    if xlim == 0,
      cursorstate = get(surf_fig,'Pointer');
        cp = get(surf_axes,'CurrentPoint');
        cx = cp(1,1);
        cy = cp(1,2);
        fuzzx = 0.01 * (xrange(2) - xrange(1));
        fuzzy = 0.01 * (yrange(2) - yrange(1));
        online = cy > yrange(1) & cy < yrange(2) & cx > xrange(1) & cx < xrange(2) &...
           ((cy > newy - fuzzy & cy < newy + fuzzy) | (cx > newx - fuzzx & cx < newx + fuzzx));
        if online & strcmp(cursorstate,'arrow'),
            set(surf_fig,'Pointer','crosshair');
        elseif ~online & strcmp(cursorstate,'crosshair'),
            set(surf_fig,'Pointer','arrow');
        end
    
    elseif xlim == 1
        cp = get(surf_axes,'CurrentPoint');
        newx=cp(1,1);
        if newx > xrange(2)
            newx = xrange(2);
        end
        if newx < xrange(1)
            newx = xrange(1);
        end

        newy=cp(1,2);
        if newy > yrange(2)
            newy = yrange(2);
        end
        if newy < yrange(1)
            newy = yrange(1);
        end

	 newz = feval(fun,newx,newy,p{:});

     set(x_field,'String',num2str(newx));
     set(y_field,'String',num2str(newy));
     set(x_field,'UserData',newx);
     set(y_field,'UserData',newy);
     set(z_field,'String',num2str(newz));

     set(vwitnessline,'XData',newx*ones(size(yrange)),'YData',yrange);
     set(hwitnessline,'XData',xrange,'YData',newy*ones(size(xrange)));
     end

elseif strcmp(action,'down'),
    set(surf_fig,'Pointer','crosshair');
    cp = get(surf_axes,'CurrentPoint');
    newx=cp(1,1);
    if newx > xrange(2)
       newx = xrange(2);
    end
    if newx < xrange(1)
       newx = xrange(1);
    end

    newy=cp(1,2);
    if newy > yrange(2)
       newy = yrange(2);
    end
    if newy < yrange(1)
       newy = yrange(1);
    end

	newz = feval(fun,newx,newy,p{:});

    set(x_field,'String',num2str(newx));
    set(y_field,'String',num2str(newy));
    set(x_field,'UserData',newx);
    set(y_field,'UserData',newy);
    set(z_field,'String',num2str(newz));

    set(vwitnessline,'XData',newx*ones(size(yrange)),'YData',yrange);
    set(hwitnessline,'XData',xrange,'YData',newy*ones(size(xrange)));
   
    set(surf_fig,'WindowButtonMotionFcn','fsurfht(''motion'',1)');
    set(surf_fig,'WindowButtonUpFcn','fsurfht(''up'')');

elseif strcmp(action,'up'),
    set(surf_fig,'WindowButtonMotionFcn','fsurfht(''motion'',0)');
    set(surf_fig,'WindowButtonUpFcn','');
    
elseif strcmp(action,'editX'),    
    if isempty(newx) 
      newx = get(x_field,'Userdata');
      set(x_field,'String',num2str(newx));
       return;
   end
   if newx > xrange(2)
        newx = xrange(2);
        set(x_field,'String',num2str(newx));
    end
    if newx < xrange(1)
        newx = xrange(1);
        set(x_field,'String',num2str(newx));
    end

    newz = feval(fun,newx,newy,p{:});
	
    set(x_field,'Userdata',newx);
    set(z_field,'String',num2str(newz));
    set(vwitnessline,'XData',newx*ones(size(yrange)));

elseif strcmp(action,'editY'),
    if isempty(newy) 
      newy = get(y_field,'Userdata');
      set(y_field,'String',num2str(newy));
       return;
   end
    if newy > yrange(2)
        newy =  yrange(2);
        set(y_field,'String',num2str(newy));
    end
    if newy <  yrange(1)
        newy =  yrange(1);
        set(y_field,'String',num2str(newy));
    end

    newz = feval(fun,newx,newy,p{:});

    set(y_field,'Userdata',newy);
    set(z_field,'String',num2str(newz));
    set(hwitnessline,'XData',xrange,'YData',newy*ones(size(xrange)));

end     % End of long "case" statement.
