function EyeDisplay(keyword, Dev, varargin);
% EyeDisplay - realtime display of Iscan data and definition of targets.
%   EyeDisplay opens a OUI for realtime display of X-Y eye coordinates
%   from the analog output of eye scan hardware.
%   ...to be continued ...

if nargin<1, keyword = 'init'; end
if nargin<2, Dev = ''; end

if isempty(Dev), Dev = 'RP2_2'; end

switch lower(keyword),
case 'init', 
   localInit(Dev, varargin{:}); % create the OUI and activate RP2 circuitry
   % localTrack(Dev); % start realtime display
case 'close',  
   localPatch('saveXY'); % save current positions of target frames
   if localInterrupt, 
      localPatch('clear'); % erase persistent variables
      delete(gcbf); % not displayng -> just close the figure
   else, localInterrupt(2); % interrupted localDraw will handle the deletion of the figure
   end
case 'keypress',
   if nargin<3, ch = get(gcf,'currentchar'); else, ch = varargin{1}; end
   localKeypress(ch, Dev);
case 'clickdown', localClickDown;
case 'clickup', localClickUp;
case 'movepatch', localPatch('move');
case 'showpatch', localPatch('show', Dev);
case 'resizepatch', localPatch('resize');
case 'maxrange', localScanLim(varargin{:});
case 'showdarange', 
   [maxVal, DAoffset] = localScanLim
case 'upload', localUpload(Dev);
otherwise, error(['Invalid keyword ''' keyword '''.']);
end
   
%======================================
function Z=localPatch(kw, varargin);
persistent X Y hpatch ipatch dx dy
CFN = 'IscanTargetWindows'; % cache file name
if isempty(X), 
   X = {[] [] []  [] [] []  [] [] [] };
   Y = {[] [] []  [] [] []  [] [] [] };
end
switch kw,
case 'handle',
   Z = hpatch(ipatch);
case 'draw',
   ipatch = varargin{1};
   Xi = X{ipatch}; Yi = Y{ipatch};
   if isempty(Xi), % stupid initial positions
      XY = fromCacheFile(CFN, 1);
      if ~isempty(XY), 
         cX = XY{1}; cY = XY{2}; 
         Xi = cX{ipatch}; Yi = cY{ipatch};
         X{ipatch} = Xi; Y{ipatch} = Yi; 
      end
   end
   if isempty(Xi), % stupid initial positions
      Xshift = 1.1*(ipatch-1);
      Xi = Xshift+[0 1 1 0]';
      Yi = [0 0 1 1]';
      X{ipatch} = Xi; Y{ipatch} = Yi; 
   end
   pcol = [1 0.7 0.7; 0.7 1 0.7; 0.7 0.7 1];
   hpatch(ipatch) = patch(Xi,Yi,pcol(ipatch,:));
   Z = hpatch(ipatch);
   ipStr = num2str(ipatch);
   pos = [0.85 0.8-0.1*ipatch 0.1 0.05];
   hh = uicontrol('tag', ['patch' ipStr 'Text'], 'style', 'text', 'units', 'normaliz', 'string', ipStr, 'position', pos, ...
      'fontsize', 14, 'backgroundcolor', pcol(ipatch,:));
case 'hittest',
   x = varargin{1}(1);
   y = varargin{1}(2);
   for ii=1:length(hpatch),
      Xi = X{ii}; Yi = Y{ii};
      Z = (x>min(Xi)) & (x<max(Xi)) & (y>min(Yi)) & (y<max(Yi));
      if Z, 
         dx = x-min(Xi);
         dy = y-min(Yi);
         ipatch = ii;
         return;
      end
   end
case 'select',
   selected = varargin{1};
   if selected, lw = 2;
   else, lw = 0.5;
   end
   set(hpatch(ipatch), 'linewidth', lw);
case 'move',
   cp = get(gca,'currentpoint');
   xy = cp(1,1:2);
   XL = xlim; YL = ylim;
   if (xy(1)<XL(1)) | (xy(1)>XL(2)), return; end % refuse to drag patch outside limits
   if (xy(2)<YL(1)) | (xy(2)>YL(2)), return; end % refuse to drag patch outside limits
   Xi = X{ipatch}; Yi = Y{ipatch};
   xmove = xy(1)-(min(Xi)+dx);
   ymove = xy(2)-(min(Yi)+dy);
   if all([xmove ymove]==0), return; end;
   xdata = xmove + Xi;
   ydata = ymove + Yi;
   set(hpatch(ipatch), 'xdata', xdata);
   set(hpatch(ipatch), 'ydata', ydata);
case 'resize',
   ch = get(gcf,'currentchar');
   if ~any(ch==',.'), return; end
   if isequal(',', ch), factor = 1.1; else, factor = 1/1.1; end
   xdata = get(hpatch(ipatch), 'xdata');
   ydata = get(hpatch(ipatch), 'ydata');
   xmean = mean(xdata);
   ymean = mean(ydata);
   xdata = xmean+factor*(xdata-xmean);
   ydata = ymean+factor*(ydata-ymean);
   set(hpatch(ipatch), 'xdata', xdata);
   set(hpatch(ipatch), 'ydata', ydata);
case 'update',
   X{ipatch} = get(hpatch(ipatch), 'xdata');
   Y{ipatch} = get(hpatch(ipatch), 'ydata');
   localUpload(nan, ipatch); % tell RP2 about changed position
case 'getXY',
   % only return non-empty values
   XX = {}; YY={};
   for ii=1:length(X), 
      if isempty(X{ii}), break; end
      XX{ii} = X{ii}; YY{ii} = Y{ii};
   end
   Z = {XX,YY};
case 'saveXY',
   tocachefile(CFN, -1, 1, {X,Y});
case 'show',
   % make patch handle first child of gca 
   ipatch = varargin{1};
   h = hpatch(ipatch);
   if isempty(h), return; end % nothing to show
   ch = get(gca, 'children');
   ii = find(h==ch);
   ch(ii) = [];
   set(gca, 'children', [h; ch]); 
case 'clear',
   % clear persistent varibels so they won't cause trouble upon ..
   % .. next call with different # patches etc
   X = []; Y = [];
   hpatch = []; ipatch = []; dx = [];  dy = [];
end % switch/case

function localClickDown;
cp = get(gca,'currentpoint');
if ~localPatch('hittest', cp(1,1:2)),
   return;
end
localPatch('select', 1); 
set(gcf, 'WindowButtonUpFcn', 'EyeDisplay clickup;');
set(gcf, 'WindowButtonMotionFcn', 'EyeDisplay movePatch;');
% set(gcf, 'KeyPressFcn', 'EyeDisplay resizePatch;');

function localClickUp;
% done dragging the patch
localPatch('update');
localPatch('select', 0); 
set(gcf, 'WindowButtonUpFcn', '');
set(gcf, 'WindowButtonMotionFcn', '');
% set(gcf, 'KeyPressFcn', 'eyedisplay stop;');

function IS = localInterrupt(is);
persistent IntStatus
drawnow;
if isempty(IntStatus), IntStatus = 0; end; 
if nargin==1, % reset
   IntStatus =  is;
end
IS = IntStatus;

function localKeypress(ch, Dev);
switch ch,
case {',' '.'}, % resize the patch
   localPatch('resize');
   localPatch('update');
case ' ', % toggle tracking
   if localInterrupt, localTrack(Dev);
   else,
      localInterrupt(1);
   end
case {'1' '2' '3' '4' '5' '6' '7' '8' '9'}, % showpatch
   localPatch('show', str2num(ch));
end

function localTrack(Dev);
% draw loop
m = 0; M = 12; 
Nline = 10;
hstack = nan+(1:Nline);
fade = linspace(0,1,Nline)';
pcol = fade*[0 0 0] + (1-fade)*[1 1 1];
iline = 0;
tic
localInterrupt(0); % reset interrupt status
hLED = findobj(gcf, 'tag', 'trackingLEDtext');
set(hLED, 'backgroundcolor', [1 0 0]);

while 1,
   iline = 1 + rem(iline, Nline);
   h_old = hstack(iline);
   Nbuf = sys3getpar('NX_eye', Dev); % count of sampled eye positions
   drawnow;  
   offset = max(0, Nbuf-M); % at most M+1 samples from buffer
   Nsam  = Nbuf-offset;
   try,
      X = sys3read('X_eye', Dev, Nsam, offset);
      Y = sys3read('Y_eye', Dev, Nsam, offset);
      % convert voltages to screen positions
      [X,Y] = localVolt2Screen(X,Y);
      % don't draw outside axes
      X(find(abs(X)>10)) = nan; Y(find(abs(Y)>10)) = nan;
   catch,
      offset, Nsam
      lasterr
      return
   end
   drawnow;  
   if ishandle(h_old), delete(h_old); end
   if ~isempty(X), hstack(iline) = line(X,Y, 'color', [1 0 0]); end;
   for ii=0:Nline-1,
      iiline = 1+rem(iline+ii, Nline);
      h = hstack(iiline);
      if ishandle(h), set(h, 'color', pcol(ii+1,:)); end
   end
   drawnow;  
   if localInterrupt, 
      for h = hstack(:).', if isOneHandle(h), delete(h); end; end
      set(hLED, 'backgroundcolor', 0.7*[1 1 1]);
      if isequal(2,localInterrupt), % close the figure
         % localPatch('clear'); % erase persistent variables
         delete(gcbf);
      end
      return; 
   end;
   if toc>inf, break; end
end

function localUpload(Dev, ipatch);
persistent lastDev
if isnan(Dev), Dev = lastDev; end;
lastDev = Dev;
XY = localPatch('getXY');
X = XY{1};  Y = XY{2};
if nargin<2, ipatch=1:length(X); end % default: all patch positions
for ii=ipatch,
   minx = min(X{ii});    maxx = max(X{ii});
   miny = min(Y{ii});    maxy = max(Y{ii});
   istr = num2str(ii);
   % convert screen pos to voltages
   [minx, miny] = localScreen2Volt(minx, miny);
   [maxx, maxy] = localScreen2Volt(maxx, maxy);
   sys3setpar(minx, ['minX' istr], Dev);  sys3setpar(maxx, ['maxX' istr], Dev);
   sys3setpar(miny, ['minY' istr], Dev);  sys3setpar(maxy, ['maxY' istr], Dev);
end

function localInit(Dev, circuitName, figh);
if nargin<2, circuitName = 'Eyetrack'; end
if nargin<3, figh = []; end
initBoardLEDs('init', Dev, circuitName); % load & run circuit
sys3trig(1,Dev); % reset counters and time
if isonehandle(figh), figure(figh);
else, % create new figure
   figure; figh = gcf;
   set(figh, 'position', [195   204   697   514], 'resize', 'off', ...
      'menubar', 'none', 'numbertitle', 'off', 'name', 'SCAN targets');
end
set(figh,'closereq', 'eyedisplay close;', 'doublebuff', 'on', 'keypressfcn', 'eyedisplay keypress;', 'WindowButtonDownFcn', 'EyeDisplay clickDown;');
axis equal; set(gca, 'posi', [-0.1  0.06   1.2*[0.7500    0.7750]]);
MAXlim = 10; % localScanLim; 
xlim(MAXlim*[-1 1]); ylim(MAXlim*[-1 1]); % set(gca,'xtick', -5:1:5,'ytick', -5:1:5);
grid on
% determine # target windows
WNDs = [];
for ii=1:3,
   try, 
      istr = num2str(ii);
      sys3getpar(['minX' istr], Dev);
      WNDs = [ii WNDs];
   catch, break;
   end
end
for ii = WNDs, localPatch('draw',ii); end
eyeDisplay upload; % upload patch positions to RP2
localInterrupt(1); % set interrupt status to "stopped"
hb1 = uicontrol('tag', 'trackingLEDtext', 'style', 'text', 'units', 'normaliz', 'string', '', ...
   'position', [0 0.1 0.01 0.8], 'backgroundcolor', [0 0 0]);

function [maxVal, Offset] = localScanLim(maxVal, Offset);
persistent MV OS
if isempty(MV), MV = 2; end
if isempty(OS), OS = [0, 0]; end
if nargin>0, MV = maxVal;
else,  maxVal = MV;
end
if nargin>1, OS = Offset;
else,  Offset = OS;
end

function [vx, vy]=localScreen2Volt(X,Y);
% convert screen pos to voltage
[maxVolt, Offset] = localScanLim;
vx = (X+10+Offset(1))/20*maxVolt;
vy = (Y+10+Offset(2))/20*maxVolt;

function [X, Y]=localVolt2Screen(vx,vy);
% convert voltage to screen pos
[maxVolt, Offset] = localScanLim;
X = 20*vx/maxVolt - 10 - Offset(1);
Y = 20*vy/maxVolt - 10 - Offset(2);








