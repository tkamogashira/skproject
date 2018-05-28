function stepwise(X,y,inmodel,alpha);
%STEPWISE Interactive tool for stepwise regression.
%   STEPWISE(X,Y,INMODEL,ALPHA) fits a regression model of Y on the
%   columns of X specified in the vector INMODEL. ALPHA is the significance  
%   for testing each term in the model. By default, 
%   ALPHA = 1 - (1 - 0.025).^(1/p) where p is the number of columns in X.
%   This translates to plotted 95% simultaneous confidence intervals
%   (Bonferroni) for all the coefficients.
%
%   The least squares coefficient is plotted with a green filled circle.
%   A coefficient is not significantly different from zero if its confidence
%   interval crosses the white zero line. Significant model terms are plotted 
%   using solid lines. Terms not significantly different from zero are plotted
%   with dotted lines.
%
%   Click on the confidence interval lines to toggle the state of the model
%   coefficients. If the confidence interval line is green the term is in the
%   model. If the the confidence interval line is red the term is not in the
%   model. Use the pop-up menu, Export, to move variables to the base
%   workspace. 
%
%   Reference: Draper, Norman and Smith, Harry, Applied Regression Analysis,
%   Second Edition, John Wiley & Sons, Inc. 1981 pp. 307-312.

%   Z. You 10-29-98,  B. Jones 6-14-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.17 $  $Date: 1998/10/29 15:26:06 $

if ~isstr(X) 
   action = 'start';
else
   action = X;
end

%On recursive calls get all necessary handles and data.
if ~strcmp(action,'start')
   flag = y;
   errorbar_fig = inmodel;
   table_fig = alpha(1);
   hist_fig = alpha(2);
   
   figure_handles = [errorbar_fig table_fig hist_fig];   
   histud = get(hist_fig,'UserData');
   u = get(errorbar_fig,'Userdata');
   
   X           = u.X;
   y           = u.y;
   inmodel     = u.inmodel;
   handles     = u.handles;
   bhandle     = u.bhandle;
   crit        = u.crit;
   outputpopup = u.outputpopup;
   scalebutton = u.scalebutton;
   instance    = u.instance;
   texthandle  = u.texthandle;
   [n, p] = size(X);
end

switch action
   
case 'start'
   [n, p]=size(X);
   colidx = 1:p;
   
   % Argument Checks
   if nargin < 3
      inmodel = colidx;
   end
   
   if nargin == 4
      sigprob = 1 - alpha/2;
   else
      sigprob = (0.975).^(1/p);
   end
   
   % Monitor Size information.
   screen = get(0,'ScreenSize');
   screenht = screen(4);
   screenwidth  = screen(3);
   
   % Do initial statistical calculations.
   mx = mean(X);
   X = (X - mx(ones(n,1),:));
   y = y - mean(y);
   sx = std(X);
   scaledx = X./sx(ones(n,1),:);
   
   df = n-2:-1:n-p-1;
   crit = tinv(sigprob,df);
   [beta, delta, tstats, stats] = FitModel(X,y,inmodel,crit);
   
   % Create the three windows for the Stepwise GUI
   table_fig = figure('Visible','off');
   hist_fig = figure('Visible','off');
   errorbar_fig = figure('Visible','off');
   whitebg(hist_fig,[0 0 0]);
   whitebg(errorbar_fig,[0 0 0]);
   %instance = length(findobj(0,'Tag','stepfig'))+1;
   instance = 1;
   %drawnow;
   figure_handles = [errorbar_fig table_fig hist_fig];
   
   % Set Up for Stepwise Plot Figure
   u = MakeErrorbarFigure(figure_handles,p,instance,screenht);
   u.texthandle = [];
   u.X          = X;
   u.y          = y;
   u.inmodel    = inmodel;
   u.crit       = crit;
   u.scaledx    = scaledx;
   
   yref = get(gca,'YLim');    
   plot([0 0],yref,'w-');
   
   % Make coefficients plot with error bars
   handles = plot([(beta-delta)'; (beta+delta)'],[colidx; colidx]);
   for k = 1:length(colidx),
      bhandle(k,1) = plot(beta(k),colidx(k),'.');
      parens = [int2str(k),',',int2str(errorbar_fig),',[',int2str(table_fig),' ',int2str(hist_fig),'])'];
      set(bhandle(k,1),'ButtonDownFcn',['stepwise(''click'',',parens],'MarkerSize',20)
      set(handles(k),'ButtonDownFcn',['stepwise(''click'',',parens],'LineWidth',2)
   end
   u.handles   = handles;
   u.bhandle   = bhandle;
   u.instance  = instance;
   notin = colidx;
   notin(inmodel) = [];
   UpdateCoefficientsPlot(beta,delta,inmodel,notin,handles,bhandle)
   
   % Set Up for Stepwise Parameter Data Table.
   MakeTableFigure(figure_handles,instance,p,screenht)
   WriteDataTable(beta,delta,p,figure_handles,inmodel,stats) 
   
   % Set Up for History Figure
   MakeHistoryFigure(inmodel,n,p,instance,stats,figure_handles);
   
   parens = ['[]',',',int2str(errorbar_fig),',[',int2str(table_fig),' ',int2str(hist_fig),'])']; 
   set(errorbar_fig,'WindowButtonMotionFcn',['stepwise(''stepmotion'',',parens])  
   set(table_fig,'WindowButtonMotionFcn',['stepwise(''datamotion'',',parens])
   
   set(hist_fig,'Visible','on','HandleVisibility','callback');
   set(table_fig,'Visible','on','HandleVisibility','callback');
   set(errorbar_fig,'Userdata',u,'Visible','on','HandleVisibility','callback');

   set(errorbar_fig,'DeleteFcn',['stepwise(''errorkill'',',parens])
   set(table_fig,'DeleteFcn',['stepwise(''tablekill'',',parens])
   set(hist_fig,'DeleteFcn',['stepwise(''histkill'',',parens])
   % End of initialization Phase
   
   
   % Callback for motion inside the Coefficients Table figure.
 case {'datamotion', 'stepmotion', 'histmotion'}
   ax = get(gcbf,'CurrentAxes');
   cp = get(ax,'CurrentPoint');
   cx = cp(1,1);
   cy = cp(1,2);
   if strcmp(action,'datamotion')
     online = (80 < cx) & (130 > cx) & (34 < cy) & (34+p*12 > cy);
   elseif strcmp(action,'stepmotion')
     if cy > 0.9 & cy < length(handles)+0.1
       xint = get(handles(round(cy)),'XData');
     else 
       xint = zeros(1,2);
     end
     online = (abs(cy-round(cy)) < 0.1) & (cx > xint(1)) & (cx < xint(2));
   else
     online = (abs(cx-round(cx)) < 0.02) & (round(cx) > 1);
   end
   togglecursor(online,gcbf);
   
 case {'errorkill', 'tablekill', 'histkill'}
   warndlg(['STEPWISE requires all three figure windows to' ...
	   ' run. The other windows have also been closed.']);
   if ~strcmp(action,'errorkill')
     set(errorbar_fig,'DeleteFcn','');
     close(errorbar_fig); 
   end
   if ~strcmp(action,'tablekill')
     set(table_fig,'DeleteFcn','');
     close(table_fig); 
   end
   if ~strcmp(action,'histkill')
     set(hist_fig,'DeleteFcn','');
     close(hist_fig); 
   end
 case 'output',
   bmf = get(errorbar_fig,'WindowButtonMotionFcn');
   bdf = get(errorbar_fig,'WindowButtonDownFcn');
   set(errorbar_fig,'WindowButtonMotionFcn','');
   set(errorbar_fig,'WindowButtonDownFcn','');
   
   outval = get(outputpopup,'Value');
   switch outval
   case 1,
      return,         
   case 2,
      promptstr = 'Enter names for the parameters or use the supplied default.'; 
      entrystr = 'beta';
   case 3,
      promptstr = 'Enter names for the confidence intervals or use the supplied default.';
      entrystr = 'betaci';
   case 4,
      promptstr = 'Enter names for the terms in the model or use the supplied default.';
      entrystr = 'in';
   case 5,
      promptstr = 'Enter names for the terms out of the model or use the supplied default.';
      entrystr = 'out';
   case 6,
      promptstr = 'Enter names for statistical outputs or use the defaults.';
      entrystr = 'beta,betaci,in,out';
   end
   
   dlghandle = dialog('Visible','off','WindowStyle','modal');
   
   set(dlghandle,'Units','pixels','Position',[100 300 400 100],'Visible','on');
   uicontrol(dlghandle,'Style','text','Units','pixels',...
      'Position',[10 75 380 20],...
      'String',promptstr);
   
   u.texthandle = uicontrol(dlghandle,'Style','edit','Units','pixels',...
      'String',entrystr,'HorizontalAlignment','center',...
      'Position',[50 40 300 20]);
   parens = ['[],',int2str(errorbar_fig),',[',int2str(table_fig),' ',int2str(hist_fig),'])'];
   ok_button = uicontrol('Style','Pushbutton','Units','pixels', ...
      'Position',[180 5 40 20], ...
      'Callback',['stepwise(''toworkspace'','parens ';close(gcbf)'], ...
      'String','OK');  
   
   set(dlghandle,'HandleVisibility','off')
   set(errorbar_fig,'UserData',u);
   set(errorbar_fig,'WindowButtonMotionFcn',bmf);
   set(errorbar_fig,'WindowButtonDownFcn',bdf);
   
case 'toworkspace',
   if get(scalebutton,'Value') == 1
      X = u.scaledx;
   end
   
   [beta, delta, tstats, stats] = FitModel(X,y,inmodel,crit);
   notin = 1:p;
   notin(inmodel) = [];
   
   outval = get(outputpopup,'Value');
   
   s = get(texthandle,'String');
   
   switch outval
   case 1,
      return,         
   case 2,
      assignin('base',s,beta);
   case 3,
      assignin('base',s,[beta-delta beta+delta]);
   case 4,
      assignin('base',s,inmodel);
   case 5,
      assignin('base',s,notin);
   case 6,
      cpos=findstr(s,',');
      assignin('base',s(1:cpos(1)-1),beta);
      assignin('base',s((cpos(1)+1):(cpos(2)-1)),[beta-delta  beta+delta]);
      assignin('base',s((cpos(2)+1):(cpos(3)-1)),inmodel);
      assignin('base',s((cpos(3)+1):end),notin);
   end
   
   set(outputpopup,'Value',1);
   
case 'click'
   cf = gcbf;
   figure(errorbar_fig);
   if ~isempty(inmodel) & any(inmodel == flag)
      k = find(inmodel==flag);
      u.inmodel(k) = [];
   else
      u.inmodel = sort([inmodel(:); flag]);
   end
   inmodel = u.inmodel;
   if get(scalebutton,'Value') == 1
      X = u.scaledx;
   end
   
   [beta, delta, tstats, stats] = FitModel(X,y,inmodel,crit);
   notin = 1:p;
   notin(inmodel) = [];
   UpdateCoefficientsPlot(beta,delta,inmodel,notin,handles,bhandle)
   set(errorbar_fig,'UserData',u);
   
   figure(table_fig);
   ch = findobj(table_fig,'Tag','text');
   delete(ch);
   WriteDataTable(beta,delta,p,figure_handles,inmodel,stats)
   
   figure(hist_fig);
   UpdateHistoryPlot(stats,inmodel,n,p,histud,figure_handles)
   figure(cf);   
   
   % Callback for Scale Inputs radio button.
case 'scale',
   if get(scalebutton,'Value') == 1
      X = u.scaledx;
   end
   [beta, delta, tstats, stats] = FitModel(X,y,inmodel,crit);
   notin = 1:p;
   notin(inmodel) = [];
   UpdateCoefficientsPlot(beta,delta,inmodel,notin,handles,bhandle)
   
   figure(table_fig);
   ch = findobj(table_fig,'Tag','text');
   delete(ch);
   WriteDataTable(beta,delta,p,figure_handles,inmodel,stats)
   
   figure(errorbar_fig);
   
case 'history',
   in = histud.instore;
   in = in(:,flag);
   in = in(find(~isnan(in)));
   set(hist_fig,'Pointer','watch');
   stepwise(X,y,in)
   set(hist_fig,'Pointer','arrow');
   
case 'close',
   set(table_fig,'DeleteFcn','')
   set(errorbar_fig,'DeleteFcn','')
   set(hist_fig,'DeleteFcn','')
   close(table_fig);
   close(errorbar_fig);
   close(hist_fig);
   
case 'help',
   dohelp;
end

function togglecursor(online, fighandle)
% toggle the cursor on and off the line

cursorstate = get(fighandle,'Pointer');
if online & strcmp(cursorstate,'arrow')
   set(fighandle,'Pointer','circle');
elseif ~online & strcmp(cursorstate,'circle'),
   set(fighandle,'Pointer','arrow');
end

function [beta, delta, tstats, stats] = FitModel(X,y,inmodel,crit);
% Local function for fitting stepwise regression model.
[n, p] = size(X);
colidx = 1:p;
notin  = colidx;
notin(inmodel) = [];

if ~isempty(inmodel)
   [Q,R]=qr(X(:,inmodel),0);
   b = R\(Q'*y);
   r = y - X(:,inmodel)*b;
   RI = R\eye(size(R));
   xtxid = (sum(RI'.*RI'))';
else
   r = y;
end
terms = length(inmodel);
if n-terms-1 == 0
   mse = 0;
else
   mse = r'*r./(n-terms-1);
end
rmse = sqrt(mse);
tss = y'*y;
rss = y'*y-r'*r;
if terms == 0
   prob = 1;
   r2   = 0;
   f    = 0;
elseif mse == 0
   f = Inf;
   prob = 0;
   r2 = 1;
   seb = 0;
   t = Inf;
else
   f   = (rss./terms)./mse;
   prob = 1-fcdf(f,terms,(n-terms-1));
   r2  = rss./tss;
   seb = sqrt(xtxid)*rmse;
   t = b./seb;
end

beta = zeros(p,1);
tstats = zeros(p,1);
delta = zeros(p,1);
if ~isempty(inmodel)
   delta(inmodel) = seb*crit(terms);
   beta(inmodel) = b;
   tstats(inmodel) = t;
end


for index = notin
   Xnew = [X(:,inmodel) X(:,index)];
   [Qadd, Radd] = qr(Xnew,0);
   bnew = Radd\(Qadd'*y);
   rnew = y - Xnew*bnew;
   RInew = Radd\eye(terms+1,terms+1);
   xtxidnew = (sum(RInew'.*RInew'))';
   if (n == terms+2)
     rmse1 = Inf;
   else
     rmse1 = sqrt(sum(rnew.*rnew)./(n-terms-2));
   end
   seb = sqrt(xtxidnew(terms+1))*rmse1;
   
   beta(index) = bnew(terms+1);
   tstats(index) = bnew(terms+1)./seb;
   delta(index) = seb*crit(terms+1);
end
delta(isnan(delta)) = 0;
stats = [rmse r2 f prob];

function u = MakeErrorbarFigure(figure_handles,p,instance,screenht)
% Local function for creating Errorbar Plot Figure and its Uicontrols.

errorbar_fig = figure_handles(1);
stepht = min(50*(p+1),480);
set(errorbar_fig,'Units','Pixels','Tag','stepfig', ...
   'Resize','off', 'Name',['Stepwise Plot #',int2str(instance)], ...
   'Interruptible', 'off',...;
    'Position',[5+30*(instance-1) screenht-stepht-30*instance-50 300 stepht]);

figpos  = get(errorbar_fig,'Position');
step_axes = axes;
set(step_axes,'NextPlot','add','DrawMode','fast','Units','Pixels',  ...
   'Tag','stepaxes','Box','on','Ydir','reverse','Ylim',[0.5 p+0.5], ...
   'Ytick',(1:p),'Position',[30 70 figpos(3)-40 figpos(4)-90], ...
   'FontSize',9,'FontName','Geneva');  

parens = ['[],',int2str(errorbar_fig),',[',int2str(figure_handles(2)),' ',int2str(figure_handles(3)),'])']; 

u.outputpopup = uicontrol(errorbar_fig,'Style','Popup','String',...
   'Export|Parameters|Confidence Intervals|Terms In|Terms Out|All',...
   'Value',1, 'Units','Pixels','Position',[190 10 100 20],... 
   'CallBack',['stepwise(''output'',', parens]);

u.scalebutton = uicontrol(errorbar_fig,'Style','radio','String',...
   'Scale Inputs','Units','Pixels','Position',[100 10 80 20],...
   'CallBack',['stepwise(''scale'',',parens]);

close_button = ...
   uicontrol('Style','Pushbutton','Units','Pixels','String','Close',... 
   'Position',[30 10 60 20],'Callback',['stepwise(''close'',',parens]);

xl = xlabel('Coefficients with Error Bars','Color','w');
yl = ylabel('Model Term Number');
set(xl,'FontSize',10,'FontName','Geneva');
set(yl,'FontSize',10,'FontName','Geneva');

function UpdateCoefficientsPlot(beta,delta,inmodel,notin,handles,bhandle)
% Local function for plotting coefficients with error bars.
p = length(beta);
for k = 1:p
   set(handles(k),'XData',[beta(k)-delta(k); beta(k)+delta(k)]);
   set(bhandle(k),'XData',beta(k));
end
xmax = max(beta+delta);
xmin = min(beta-delta);
xrange = xmax-xmin;
set(gca,'XLim',[xmin-0.05*xrange xmax+0.05*xrange]);

notsig = find(beta-delta<0 & beta+delta>0);
sig = 1:p;
sig(notsig) = [];
set(handles(inmodel),'Color','g');
set(bhandle(inmodel),'Color','g');

set(handles(notin),'Color','r');
set(bhandle(notin),'Color','r');

set(handles(sig),'LineStyle','-');
set(handles(notsig),'LineStyle',':');

function MakeTableFigure(figure_handles,instance,p,screenht)
% Local function for creating Parameters Table Figure and its Uicontrols.

table_fig = figure_handles(2);
fight = p*12 + 90;
figure(table_fig);
set(table_fig,'Units','Pixels', 'Color','k', 'Tag','datafig',...
    'Name',['Stepwise Table #',int2str(instance)],'Resize','off', ...
    'Interruptible', 'off',...
    'Position',[290+30*instance screenht-(fight+30*instance)-50 340 fight]);
ax = axes;
set(ax,'Units','Pixels','Position',[10 25 380 fight-25],'Color','k',...
   'Xlim',[0 340],'Ylim',[0 fight-25],'Visible','off');

parens = ['[],',int2str(figure_handles(1)),',[',int2str(table_fig),' ',int2str(figure_handles(3)),'])'];
uicontrol('Style','Pushbutton','Units','Pixels','String','Close', ...
   'Position',[10 5 100 20],'Callback',['stepwise(''close'',',parens]);

uicontrol('Style','Pushbutton','Units','Pixels','Position',[230 5 100 20],...
   'Callback',['stepwise(''help'',',parens],'String','Help');

function WriteDataTable(beta,delta,p,figure_handles,inmodel,stats)
% Local function for writing out all the entries in the Parameter Data Table.

figure(figure_handles(2));
fight = p*12 + 90;
h=text(180,fight-32,'Confidence Intervals');
set(h,'FontName','Geneva','FontSize',9,'Color','w');
colheads = str2mat('Column #','Parameter','Lower ','Upper');
colheads1 = str2mat('RMSE','R-square','F','P');
z = [10 80 175 245];
z1 = [10 80 195 265];
h = zeros(4,1);
l = zeros(4,1);
for k = 1:4
   h(k)=text(z(k),fight-45,colheads(k,:));
   set(h(k),'FontName','Geneva','FontSize',9,'Color','w');
   l(k)=text(z1(k),20,colheads1(k,:));
   set(l(k),'FontName','Geneva','FontSize',9,'Color','w');
end

x = fight-50;
h = zeros(4,p+1);
for params = 1:p
   z = [30 120 200 270];
   x = x - 12;
   row = [params beta(params) beta(params)-delta(params) beta(params)+delta(params)];
   parens = [int2str(params),',',int2str(figure_handles(1)),',[',int2str(figure_handles(2)),' ',int2str(figure_handles(3)),'])'];
   bdf = ['stepwise(''click'',',parens];
   for k = 1:4
      if k == 1,
         h(k,params) = text(z(k),x,sprintf('%4i',row(k)));
         set(h(k,params),'HorizontalAlignment','right',...
            'FontName','Geneva','FontSize',9,'Tag','text',...
            'ButtonDownFcn',bdf);
      else
         h(k,params) = text(z(k),x,sprintf('%11.4g',row(k)));
         set(h(k,params),'HorizontalAlignment','right','Tag','text',...
            'FontName','Geneva','FontSize',9,'ButtonDownFcn',bdf);
      end
      if ~isempty(inmodel) & any(inmodel == params)
         set(h(k,params),'Color','g');
      else
         set(h(k,params),'Color','r');
      end
   end
end
z = [35 120 205 290];
for k = 1:4
   h(k,p+1) = text(z(k),6,sprintf('%11.4g',stats(k)));
   set(h(k,p+1),'HorizontalAlignment','right','Tag','text',...
      'FontName','Geneva','FontSize',9,'Color','w');
end

function MakeHistoryFigure(inmodel,n,p,instance,stats,figure_handles)
% Local function for creating Stepwise History Figure.
screen = get(0,'ScreenSize');
screenht = screen(4);
screenwidth  = screen(3);

hist_fig = figure_handles(3);
figpos = get(hist_fig,'Position');
fight = figpos(4);
parens = ['[]',',',int2str(figure_handles(1)),',[',int2str(figure_handles(2)),' ',int2str(hist_fig),'])'];
if screenwidth > 970
   set(hist_fig,'WindowButtonMotionFcn',['stepwise(''histmotion'',',parens],...
      'Units','Pixels','Position',[670 screenht-280 300 200]);
else 
   set(hist_fig,'WindowButtonMotionFcn',['stepwise(''histmotion'',',parens],...
      'Units','Pixels','Position',[290+30*instance ...
         screenht-(fight+30*instance)-270 300 120]); 
end
set(hist_fig,'Tag','histfig','Interruptible', 'off', ...
    'Name',['Stepwise History #',int2str(instance)]);

trm  = n-1:-1:n-p-1;
trml = length(trm);
low  = 0.025;
hi   = 0.975;

histud.chi2crit = chi2inv([low(ones(trml,1),1) hi(ones(trml,1),1)],[trm' trm']); 
figure(figure_handles(3));

UpdateHistoryPlot(stats,inmodel,n,p,histud,figure_handles);
xlabel('Model Number');
ylabel('RMSE');

function UpdateHistoryPlot(stats,inmodel,n,p,histud,figure_handles)
% Local function for adding new rmse error bar to History Plot.

figure(figure_handles(3))
rmse = stats(1);
mse = rmse*rmse;
terms = length(inmodel);
rmseci  =  sqrt([(mse*sqrt((n-terms-1)./histud.chi2crit(terms+1,2))) ...
      (mse*sqrt((n-terms-1)./histud.chi2crit(terms+1,1)))]);

cirange = diff(rmseci);
ylhi = rmseci(2) + 0.1*cirange;
yllo = rmseci(1) - 0.1*cirange;

tmp = NaN;
tmp = tmp(ones(p,1),1);
tmp(1:terms) = inmodel;

if length(fieldnames(histud)) < 3
   histud.instore = tmp;
   num_mod = 1;
else  
   in = histud.instore;
   in = [in tmp];
   histud.instore = in;
   num_mod = length(histud.rmsehandle)+1;   
end
histud.rmsehandle(num_mod) = plot([num_mod num_mod],rmseci);

yl = get(gca,'Ylim');
yhi = max(ylhi,yl(2));
ylo = min(yllo,yl(1));
set(gca,'Xlim',[0.5 num_mod+0.5],'Xtick',(1:num_mod),'Ylim',[ylo yhi], ...
   'Position',[0.15 0.15 0.8 0.8],'NextPlot','add');
rmsedothndl = plot(num_mod,rmse,'.');

parens = [int2str(num_mod),',',int2str(figure_handles(1)),',[', ...
      int2str(figure_handles(2)),' ',int2str(figure_handles(3)),'])'];
bdf = ['stepwise(''history'',',parens];
set(histud.rmsehandle(num_mod),'ButtonDownFcn',bdf);
set(rmsedothndl,'MarkerSize',20,'ButtonDownFcn',bdf);
set(figure_handles(3),'UserData',histud);

function dohelp
str{1,1} = 'Stepwise Regression';
str{1,2} = { 'Stepwise Regression Interactive Graphic User Interface'
   ' ' 
   'The interface consists of three interactively linked figure windows:'
   '   * The Stepwise Regression Plot'
   '   * The Stepwise Regression Diagnostics Table'
   '   * The Stepwise History'
   ' '   
   'All three windows have hot regions. When your mouse is above' 
   'one of these regions, the pointer changes from an arrow to a circle.'
   'Mousing down at this point initiates some activity in the interface.'
   ' '   
   'To understand how to use a given window choose one of the items'
   'from the popup menu labelled Topics above.'
};

str{2,1} = 'Stepwise Plot';
str{2,2} = {
   'Stepwise Regression Plot'
   ' '
   'Coefficients and Confidence Intervals'
   ' '
   'This plot shows the regression coefficient and confidence interval for every'
   'term (in or out of the model.) The green lines represent terms in the model'
   'while red lines indicate that the term is not currently in the model.'
   ' '
   'Statistically significant terms are solid lines. Dotted lines show that '
   'the fitted coefficient is not significantly different from zero.'
   ' '
   'Clicking on a line in this plot toggles its state. That is, a term in the'
   'model (green line) gets removed (turns red), and terms out of the model' 
   '(red line) enter the model (turn green).'
   ' '
   'The coefficient for a term out of the model is the coefficient resulting from'
   'adding that term to the current model.'
   ' '
   'Scale Inputs'
   'Pressing the button labeled Scale Inputs centers and normalizes the columns'
   'of the input matrix to have a standard deviation of one.'
   ' '
   'Export'
   'This popup menu allows you to export variables from the stepwise function to'
   'the base workspace.'
   ' '
   'Close'
   'The Close button removes all the figure windows.'
};

str{3,1} = 'Stepwise Diagnostics';
str{3,2} = {
   'Stepwise Regression Diagnostics Table'
   ' '
   'Coefficients and Confidence Intervals'
   'The table at the top of the figure shows the regression coefficient and ' 
   'confidence interval for every term (in or out of the model.) The green rows' 
   'in the table represent terms in the model while red rows indicate terms not' 
   'currently in the model.'
   ' '
   'Clicking on a row in this table toggles the state of the corresponding term.' 
   'That is, a term in the model (green row) gets removed (turns red), and terms' 
   'out of the model (red rows) enter the model (turn green).'
   ' '
   'The coefficient for a term out of the model is the coefficient resulting from'
   'adding that term to the current model.'
   ' '
   'Additional Diagnostic Statistics'
   'There are also several diagnostic statistics at the bottom of the table:' 
   '   * RMSE - the root mean squared error of the current model.'
   '   * R-square - the amount of response variability explained by the model.'
   '   * F - the overall F statistic for the regression.'
   '   * P - the associated significance probability.'
   ' ' 
   'Close Button'
   'Shuts down all windows.'
   ' '
   'Help Button'
   'Activates on-line help.'
};

str{4,1} = 'Stepwise History';
str{4,2} = {
   'Stepwise History'
   ' '
   'Description'
   'This plot shows the RMSE and a confidence interval for every model generated' 
   'in the course of the interactive use of the other windows. '
   ' '
   'Recreating a Previous Model'
   'Clicking on one of these lines will re-create the current model at that point'
   'in the analysis using a NEW set of windows. You can thus compare the two' 
   'candidate models directly.'
};

for k = 1:4,
   str{k,2} = char(str{k,2});
end
helpwin(str,'Stepwise Regression','Stepwise Regression Help')
