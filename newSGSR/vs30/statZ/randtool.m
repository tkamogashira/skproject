function randtool(action,flag);
%RANDTOOL Demonstration of many random number generators.
%   RANDTOOL(ACTION) creates a histogram of random samples from many
%   distributions. This is a demo that displays a histograms of random
%   samples from the distributions in the Statistics Toolbox. 
%
%   Change the parameters of the distribution by typing in a new
%   value or by moving a slider.
%
%   Output the current sample to a variable in the workspace by pressing
%   the output button.
%
%   Change the sample size by typing any positive integer in the
%   sample size edit box.
%
%   Change the distribution type using the popup menu.

%   B.A. Jones 3-22-93
%   Z. You 7-25-96
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.19 $  $Date: 1998/07/06 16:21:51 $

if nargin < 1
    action = 'start';
end

%On recursive calls get all necessary handles and data.
if ~strcmp(action,'start')   
   childList = allchild(0);
   rand_fig = childList(find(childList == gcf));
   ud = get(rand_fig,'Userdata');

   popupvalue = get(ud.popup,'Value');

   switch action
      case {'setpfield', 'setpslider', 'setphi', 'setplo'}
         ud = feval(action,flag,ud);
      case 'changedistribution', 
         ud = changedistribution(ud);
      case 'setsample',
         ud=updategui(ud,[]); 
      case 'output',
         outrndnum(ud); 
   end
   set(rand_fig,'UserData',ud);
end
% Initialize all GUI objects. Plot Normal CDF with sliders for parameters.
if strcmp(action,'start'),
   % Set positions of graphic objects
   axisp   = [.18 .3 .8 .58];
   % Create cell array of positions for parameter controls.
   pos{1,1} = [.18 .08 .10 .05];
   pos{2,1} = pos{1,1} + [.15 .06 0 0];
   pos{3,1} = pos{2,1} + [0 -0.13 0 0];
   pos{4,1} = pos{1,1} + [.11 -0.07 -0.07 0.13];
   pos{5,1} = pos{1,1} + [0 0.05 0 0];

   pos{1,2} = [.46 .08 .10 .05];
   pos{2,2} = pos{1,2} + [.15 .06 0 0];
   pos{3,2} = pos{2,2} + [0 -0.13 0 0];
   pos{4,2} = pos{1,2} + [.11 -0.07 -0.07 0.13];
   pos{5,2} = pos{1,2} + [0 0.05 0 0];

   pos{1,3} = [.74 .08 .10 .05];
   pos{2,3} = pos{1,3} + [.15 .06 0 0];
   pos{3,3} = pos{2,3} + [0 -0.13 0 0];
   pos{4,3} = pos{1,3} + [.11 -0.07 -0.07 0.13];
   pos{5,3} = pos{1,3} + [0 0.05 0 0];

   % Distribution Data
   ud.distcells.name = {'Beta','Binomial','Chisquare','Discrete Uniform',...
   'Exponential', 'F', 'Gamma', 'Geometric', 'Lognormal', 'Negative Binomial',...
   'Noncentral F', 'Noncentral T', 'Noncentral Chi-square', 'Normal', ...
   'Poisson', 'Rayleigh', 'T', 'Uniform', 'Weibull'};

   ud.distcells.rvname = {'betarv','binorv','chi2rv','unidrv', 'exprv',...
       'frv', 'gamrv', 'georv', 'lognrv', 'nbinrv', 'ncfrv', 'nctrv', ...
       'ncx2rv', 'normrv', 'poissrv', 'raylrv', 'trv', 'unifrv', 'weibrv'};

   ud.distcells.parameters = {[2 2], [10 0.5], 2, 20, 1, ...
   [5 5], [2 2], 0.5, [0.5 0.25], [2 0.6], [5 5 1], ...
   [5 1], [5 1], [0 1],  5,  2,  5, ...
   [0 1], [2 2]};

   ud.distcells.pmax = {[Inf Inf], [Inf 1], Inf, Inf, Inf, ...
   [Inf Inf], [Inf Inf], 1-eps, [Inf Inf], [Inf 1], [Inf Inf Inf], ...
   [Inf Inf], [Inf Inf], [Inf Inf], Inf, Inf, Inf, ...
   [Inf Inf], [Inf Inf]};

   ud.distcells.pmin = {[0 0], [1 0], 1, 1, 0, ...
   [1 1], [0 0], 0, [-Inf 0], [1 0], [1 1 0], ...
   [1 0], [1 0], [-Inf 0], 0, 0, 1, ...
   [-Inf -Inf], [0 0]}; 

   ud.distcells.phi = {[4 4], [10 1], 10, 20, 2,...
   [10 10], [5 5], 0.99, [1 0.3], [3 0.99], [10 10 5], ...
   [10 5], [10 5], [2 2], 5, 5, 10, ...
   [0.5 2], [3 3]};

   ud.distcells.plo = {[0.5 0.5], [1 0], 1, 1, 0.5,...
   [5 5], [2 2], 0.25, [0 0.1], [1 0.5], [5 5 0], ...
   [2 0], [2 0], [-2 0.5], 1, 1, 2, ...
   [0 1], [1 1]}; 

   ud.distcells.discrete = [0 1 0 1 0 0 0 1 0 1 0 0 0 0 1 0 0 0 0];

   ud.distcells.intparam = {[0 0 0], [1 0 0], [1 0 0], [1 0 0], [0 0 0],...
   [1 1 0], [0 0 0], [0 0 0], [0 0 0], [1 0 0], [1 1 0], [1 1 0], ...
   [1 0 0], [0 0 0], [0 0 0], [0 0 0], [1 0 0], [0 0 0], [0 0 0]};

   % Set axis limits and data
   rand_fig = figure('Tag', 'randfig');
   figcolor  = get(rand_fig,'Color');
   set(rand_fig,'Units','Normalized','Backingstore','off');
   rand_axes = axes;
   xrange = [-8 8];
   set(rand_axes,'DrawMode','fast',...
      'Position',axisp,'XLim',xrange,'Box','on');
   paramtext  = str2mat('Mu','Sigma','  ');

% Define graphics objects
   for idx = 1:3
       nstr = int2str(idx);
       ud.pfhndl(idx) =uicontrol('Style','edit','Units','normalized','Position',pos{1,idx},...
          'String',num2str(ud.distcells.parameters{14}(2-rem(idx,2))),'BackgroundColor','white',...
          'CallBack',['randtool(''setpfield'',',nstr,')']);
         
       ud.hihndl(idx)   =uicontrol('Style','edit','Units','normalized','Position',pos{2,idx},...
         'String',num2str(ud.distcells.phi{14}(2-rem(idx,2))),'BackgroundColor','white',...
         'CallBack',['randtool(''setphi'',',nstr,')']);
         
       ud.lohndl(idx)   =uicontrol('Style','edit','Units','normalized','Position',pos{3,idx},...
         'String',num2str(ud.distcells.plo{14}(2-rem(idx,2))),'BackgroundColor','white',... 
         'CallBack',['randtool(''setplo'',',nstr,')']);

       ud.pslider(idx)=uicontrol('Style','slider','Units','normalized','Position',pos{4,idx},...
         'Value',ud.distcells.parameters{14}(2-rem(idx,2)),'Max',ud.distcells.phi{14}(2-rem(idx,2)),...
         'Min',ud.distcells.plo{14}(2-rem(idx,2)),'Callback',['randtool(''setpslider'',',nstr,')']);

       ud.ptext(idx) =uicontrol('Style','text','Units','normalized','Position',pos{5,idx},...
         'BackgroundColor',figcolor,'ForegroundColor','k','String',paramtext(idx,:));
   end      

   set(ud.pfhndl(3),'Visible','off');
   set(ud.hihndl(3),'Visible','off');
   set(ud.lohndl(3),'Visible','off');
   set(ud.pslider(3),'Visible','off');
   set(ud.ptext(3),'Visible','off');

   ud.popup=uicontrol('Style','Popup','String',...
'Beta|Binomial|Chi-square|Discrete Uniform|Exponential|F|Gamma|Geometric|Lognormal|Negative Binomial|Noncentral F|Noncentral T|Noncentral Chi-square|Normal|Poisson|Rayleigh|T|Uniform|Weibull',...
        'Units','normalized','Position',[.31 .9 .25 .06],'UserData','popup','Value',14,...
        'CallBack','randtool(''changedistribution'')');

   ud.samples_field = uicontrol('Style','edit','Units','normalized',...
         'Position',[.71 .9 .15 .06], 'String','100',...
         'BackgroundColor','white',...
         'CallBack','randtool(''setsample'',1)');

   resample_button = uicontrol('Style','Pushbutton',...
         'Units','normalized','Position',[.01 .15 .13 .05],...
         'Callback','randtool(''setsample'',1)','String','Resample');

   output_button = uicontrol('Style','Pushbutton','Units','normalized',...
         'Position',[.01 .08 .13 .05],...
         'Callback','randtool(''output'',2);','String','Output');
       
   close_button = uicontrol('Style','Pushbutton','Units','normalized',...
               'Position',[0.01 0.01 0.13 0.05],'Callback','close','String','Close');

ud = updategui(ud,[]);

set(rand_fig,'UserData',ud,'HandleVisibility','callback',...
    'InvertHardCopy', 'on', 'PaperPositionMode', 'auto')
end
% End of initialization.
% END OF randtool MAIN FUNCTION.

% Begin of helper function 
% Supply x-axis range for each distribution. GETXDATA
function xrange = getxdata(popupvalue,ud)
phi = ud.distcells.phi{popupvalue};
plo = ud.distcells.plo{popupvalue};
parameters = ud.distcells.parameters{popupvalue};
switch popupvalue
    case 1, % Beta 
       xrange  = [0 1];
    case 2, % Binomial 
       xrange  = [0 phi(1)];
	case 3, % Chi-square
       xrange  = [0 phi + 4 * sqrt(2 * phi)];
    case 4, % Discrete Uniform
       xrange  = [0 phi];
    case 5, % Exponential
       xrange  = [0 4*phi];
    case 6, % F 
       xrange  = [0 finv(0.995,plo(1),plo(1))];
    case 7, % Gamma
       hixvalue = phi(1) * phi(2) + 4*sqrt(phi(1) * phi(2) * phi(2));
       xrange  = [0 hixvalue];
    case 8, % Geometric
       hixvalue = geoinv(0.99,plo(1));
       xrange  = [0 hixvalue];       
    case 9, % Lognormal
       xrange = [0 logninv(0.99,phi(1),phi(2))];
    case 10, % Negative Binomial
       xrange = [0 nbininv(0.99,phi(1),plo(2))];
    case 11, % Noncentral F
       xrange = [0 phi(3)+30];
    case 12, % Noncentral T
       xrange = [phi(2)-14 phi(2)+14];
    case 13, % Noncentral Chi-square
       xrange = [0 phi(2)+30];
    case 14, % Normal
       xrange   = [plo(1) - 3 * phi(2) phi(1) + 3 * phi(2)];
    case 15, % Poisson
      xrange  = [0 4*phi(1)];
    case 16, % Rayleigh
       xrange = [0 raylinv(0.995,phi(1))];
    case 17, % T
       lowxvalue = tinv(0.005,plo(1));
       xrange  = [lowxvalue -lowxvalue];
    case 18, % Uniform
       xrange  = [plo(1) phi(2)];
    case 19, % Weibull
       xrange  = [0 weibinv(0.995,plo(1),plo(2))];
end
% END of helper function

% BEGIN CALLBACK FUNCTIONS.
% Callback for changing probability distribution function. CHANGEDISTRIBUTION
function ud = changedistribution(ud)
text1 = {'A','Trials','df','Number','Lambda','df1','A','Prob','Mu','R','df1','df',...
            'df','Mu','Lambda','B','df','Min','A'}; 
text2 = {'B','Prob',[],[],[],'df2','B',[],'Sigma','Prob','df2','delta','delta',...
            'Sigma',[],[],[],'Max','B'};

popupvalue = get(ud.popup,'Value');
set(ud.ptext(1),'String',text1{popupvalue});
name       = ud.distcells.name{popupvalue};
parameters = ud.distcells.parameters{popupvalue};
pmax       = ud.distcells.pmax{popupvalue};
pmin       = ud.distcells.pmin{popupvalue};
phi        = ud.distcells.phi{popupvalue};
plo        = ud.distcells.plo{popupvalue};

nparams = length(parameters);
if nparams > 1
    set(ud.ptext(2),'String',text2{popupvalue});
    if popupvalue == 11
           set(ud.ptext(3),'String','delta');
    end
end

offs = [(nparams+1):3];
ons = [1:nparams];
if ~isempty(offs)
	set(ud.ptext(offs),'Visible','off');
    set(ud.pslider(offs),'Visible','off');
    set(ud.pfhndl(offs),'Visible','off');
    set(ud.lohndl(offs),'Visible','off');
    set(ud.hihndl(offs),'Visible','off');
end
if ~isempty(ons)
	set(ud.ptext(ons),'Visible','on');
    set(ud.pslider(ons),'Visible','on');
    set(ud.pfhndl(ons),'Visible','on');
    set(ud.lohndl(ons),'Visible','on');
    set(ud.hihndl(ons),'Visible','on');
end

for idx = 1:nparams
    set(ud.pfhndl(idx),'String',num2str(parameters(idx)));
    set(ud.lohndl(idx),'String',num2str(plo(idx)));
    set(ud.hihndl(idx),'String',num2str(phi(idx)));
    set(ud.pslider(idx),'Min',plo(idx),'Max',phi(idx),'Value',parameters(idx));
end

xrange = getxdata(popupvalue,ud);
set(gca,'Xlim',xrange);

ud=updategui(ud,xrange);

% End of changedistribution function.

% Callback for controlling lower bound of the parameters using editable
% text boxes.
function ud = setplo(fieldno,ud)
popupvalue = get(ud.popup,'Value');
intparam = ud.distcells.intparam{popupvalue}(fieldno);
cv   = str2double(get(ud.lohndl(fieldno),'String'));
pv = str2double(get(ud.pfhndl(fieldno),'String'));
cmax = str2double(get(ud.hihndl(fieldno),'String'));

if cv >= cmax
  set(ud.lohndl(fieldno),'String',get(ud.pslider(fieldno),'Min'));
elseif cv > pv
  set(ud.lohndl(fieldno),'String',num2str(cv));
  set(ud.pslider(fieldno),'Min',cv);
  set(ud.pfhndl(fieldno),'String',num2str(cv));
  ud = setpfield(fieldno,ud);
else
  pmin = ud.distcells.pmin{popupvalue}(fieldno);
  pmax = ud.distcells.pmax{popupvalue}(fieldno);
  if cv > pmin & cv < pmax,
    if intparam
        cv = round(cv);
        set(ud.lohndl(fieldno),'String',num2str(cv));
    end
    set(ud.pslider(fieldno),'Min',cv);
    ud.distcells.plo{popupvalue}(fieldno) = cv;
  else
    set(ud.lohndl(fieldno),'String',num2str(ud.distcells.plo{popupvalue}(fieldno)));
  end
end
xrange = getxdata(popupvalue,ud);
ud = updategui(ud,xrange);

% Callback for controlling upper bound of the parameters using editable text boxes.
function ud = setphi(fieldno,ud)
popupvalue = get(ud.popup,'Value');
intparam = ud.distcells.intparam{popupvalue}(fieldno);
cv   = str2double(get(ud.hihndl(fieldno),'String'));
pv = str2double(get(ud.pfhndl(fieldno),'String'));
cmin = str2double(get(ud.lohndl(fieldno),'String'));

if cv <= cmin
  set(ud.hihndl(fieldno),'String',get(ud.pslider(fieldno),'Max'));
elseif cv < pv
  set(ud.hihndl(fieldno),'String',num2str(cv));
  set(ud.pslider(fieldno),'Max',cv);
  set(ud.pfhndl(fieldno),'String',num2str(cv));
  ud = setpfield(fieldno,ud);
else
  pmin = ud.distcells.pmin{popupvalue}(fieldno);
  pmax = ud.distcells.pmax{popupvalue}(fieldno);
  if cv > pmin & cv < pmax,
    if intparam
        cv = round(cv);
        set(ud.hihndl(fieldno),'String',num2str(cv));
    end
    set(ud.pslider(fieldno),'Max',cv);
    ud.distcells.phi{popupvalue}(fieldno) = cv;
  else
    set(ud.hihndl(fieldno),'String',num2str(ud.distcells.phi{popupvalue}(fieldno)));
  end
end
xrange = getxdata(popupvalue,ud);
ud=updategui(ud,xrange);

% Callback for controlling the parameter values using sliders.
function ud = setpslider(sliderno,ud)
popupvalue = get(ud.popup,'Value');
intparam = ud.distcells.intparam{popupvalue}(sliderno);

cv = get(ud.pslider(sliderno),'Value');
if intparam
    cv = round(cv);
end
set(ud.pfhndl(sliderno),'String',num2str(cv));
ud.distcells.parameters{popupvalue}(sliderno) = cv;
ud=updategui(ud,[]);

% Callback for controlling the parameter values using editable text boxes.
function ud = setpfield(fieldno,ud)
popupvalue = get(ud.popup,'Value');
intparam = ud.distcells.intparam{popupvalue}(fieldno);
cv = str2double(get(ud.pfhndl(fieldno),'String'));
pmin = ud.distcells.pmin{popupvalue}(fieldno);
pmax = ud.distcells.pmax{popupvalue}(fieldno);
phivalue = str2double(get(ud.hihndl(fieldno),'String'));
plovalue = str2double(get(ud.lohndl(fieldno),'String'));
if cv > pmin & cv < pmax,
    if intparam
       cv = round(cv);
       set(ud.pfhndl(fieldno),'String',num2str(cv));
    end
    set(ud.pslider(fieldno),'Value',cv);
    ud.distcells.parameters{popupvalue}(fieldno) = cv;
    if (cv >= phivalue), 
        set(ud.hihndl(fieldno),'String',num2str(cv));
        ud = setphi(fieldno,ud); 
        set(ud.pslider(fieldno),'Max',cv);
        return; % this return is to avoid using updategui twice.
    end
    if (cv <= plovalue), 
        set(ud.lohndl(fieldno),'String',num2str(cv));
        ud = setplo(fieldno,ud); 
        set(ud.pslider(fieldno),'Min',cv);
        return; 
    end
else
    set(ud.pfhndl(fieldno),'String',num2str(ud.distcells.parameters{popupvalue}(fieldno)));
end
xrange = getxdata(popupvalue,ud);
updategui(ud, xrange);

% Update graphic objects in GUI. UPDATEGUI
function ud=updategui(ud,xrange)

if isempty(xrange)
   xrange = get(gca,'Xlim');
end

popupvalue = get(ud.popup,'Value');

name = ud.distcells.name{popupvalue};
nparams = length(ud.distcells.parameters{popupvalue});
samples = floor(str2double(get(ud.samples_field,'String')));
if samples <= 0
   samples = 100;
   set(ud.samples_field,'String','100');
   warning('Sample size must be positive. It is re-set to its default value(100).');
end

for idx = 1:nparams
    pval(idx) = str2double(get(ud.pfhndl(idx),'String'));
end

switch nparams
  case 1, random_numbers = random(name,pval(1),samples,1);
  case 2, random_numbers = random(name,pval(1),pval(2),samples,1);
  case 3, random_numbers = random(name,pval(1),pval(2),pval(3),samples,1);
end
ud.random_numbers = random_numbers;

% Create Histogram
minrn = min(random_numbers);
maxrn = max(random_numbers);
crn = random_numbers - minrn + realmin;
bins = floor(sqrt(samples));
range = maxrn - minrn;
if ud.distcells.discrete(popupvalue)
  range = maxrn - minrn + 1; 
  crn = crn + 1;
  bins = range;
end

intrn = ceil(bins*crn/range);

%the above ceil function may push intrn to be one unit higher than bins
%due to floating point problem, we will set it back to bins.
if max(intrn) > bins
  intrn(intrn > bins) = bins;
end
counts = full(sparse(1,intrn,1));
binvec = (1:bins)';
binwidth = range/bins;

values = minrn + binvec*binwidth;

if ud.distcells.discrete(popupvalue)
  values = values - 0.5;
end

histogram = bar(values,counts,1);

%xrange   = [p1low - 3 * p2high p1high + 3 * p2high];
%yvalues =get(histogram,'Ydata');
%yrange = [0 1.3*max(max(yvalues))];
set(gca,'XLim',xrange)

text(-0.2,0.5,'Counts','Unit','Normalized','EraseMode','none');
text(0.45,-0.12,'Values','Unit','Normalized','EraseMode','none');
text(0.53, 1.08,'Samples','Unit','Normalized','EraseMode','none');

% output function
function outrndnum(ud)
prompt = 'Enter a variable name for the random numbers or use the supplied default.';
popupvalue = get(ud.popup,'Value');
def = {ud.distcells.rvname{popupvalue}};
title = 'Output random numbers';
rndstr = inputdlg(prompt,title,1,def);
if ~isempty(rndstr)
  assignin('base',rndstr{1}, ud.random_numbers);
end
