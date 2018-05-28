function Spitzer=readDat(fname,doPlot);

% compute area from Ymin 
% fill patch only if YMIN~=YMAX

diffColor = 0.8*[1 1 1]; % gray
minColor = 0.9*[1 1 1]; % lighter gray
dx = 5; % x resolution 

if nargin<2, doPlot=(nargout<1); end;
% find data file
if isnumeric(fname), % n-th mex file in list
   qq= what; fname=qq.mex{fname};
end
if isempty(findstr('.',fname)), % default extension is .dat
   fname = [fname '.dat'];
end
if isequal(0,exist(fname)),
   error(['File ''' fname ''' not found']);
end

% open file and read data into cell array Y
fid = fopen(fname,'rt');
if fid<1, error(['Unable to open file ''' fname '''']); end
N = 0; % counts line patches to be stored in Y{i}
while 1,
   [Line, EOF] = readln(fid);
   if isempty(Line), break; end;
   % try to read numbers from current line
   X = sscanf(Line,'%f')';
   if isempty(X), % delimiter
      N = N + 1;
      Y{N} = [];
   else,
      Y{N} = [Y{N}; X(2:3)];
   end
   if EOF, break; end;
end
fclose(fid);
checksize = [];
for ii=1:N,
   checksize = [checksize; size(Y{ii})];
end
Mc = mean(checksize);
if any(checksize(:,1)-Mc(1)),
   warning('Unequal number of datapoints across conditions');
elseif any(checksize(:,2)-Mc(2)),
   warning('Unequal number of datapoints across conditions');
end
ITDup = mean(diff(Y{1}(:,1)))>0; % direction of ITD variation
% upsampling and X-aligment by linear interpolation
Imin=inf; Imax=-inf; 
grandMinY = inf;
for ii=1:N,
   [Y{ii} i0 i1] = linupsample(dx,Y{ii});
   Imin = min(Imin,i0);
   Imax = max(Imax,i1);
   grandMinY = min(grandMinY, min(Y{ii}(:,2)));
end
X = dx*(Imin:Imax)';

% now visit all line patches and, for each x value, ...
% ... determine the min and max y value across patches
NI = Imax-Imin+1; % # different X-values
YMAX = -inf+zeros(NI,1); YMIN = inf+zeros(NI,1);
for ii=1:N,
   YY = Y{ii};
   Istart = 1+YY(1,1)-Imin;
   Iend = Istart+size(YY,1)-1;
   IS(ii) = Istart; IE(ii) = Iend;
   YMAX(Istart:Iend) = max(YMAX(Istart:Iend),YY(:,2));
   YMIN(Istart:Iend) = min(YMIN(Istart:Iend),YY(:,2));
end

% ---Compute Spitzer/Semple coeff----
% remove holes in between the patches, if any
holes = find(isinf(YMIN) | isinf(YMAX));
X(holes) = []; YMIN(holes) = []; YMAX(holes) = [];
% select only those parts under curve where YMIN and YMAX differ
ue = find(YMIN~=YMAX);
% now divide area under Ymin by area under Ymax
Armin = sum(YMIN(ue)-grandMinY); % evenly spaced, need no weighting
Armax = sum(YMAX(ue)-grandMinY); % evenly spaced, need no weighting
Spitzer = 1-Armin/Armax;

if ~doPlot, return; end;

figure; hold on
dontfill = find(YMIN==YMAX);
YMIN(dontfill) = grandMinY;
YMAX(dontfill) = grandMinY;
area(X,YMAX,grandMinY,'facecolor',diffColor,'edgecolor','none');
area(X,YMIN,grandMinY,'facecolor',minColor,'edgecolor','none');
CL = repmat('brg',1,100);
hold on;
for ii=1:N,
   YY = Y{ii};
   odd = rem(ii,2);
   if odd, plotarg = [CL(ii) '-'];
   else, plotarg = [CL(ii), '--'];
   end
   plot(dx*YY(:,1),YY(:,2), plotarg)
end
hold off
ds = upper(strtok(fname,'.'));
t1 = ['data set: ' ds ';']; 
t2 = ['\rho_S = ' num2str(Spitzer,2)];
tt = [t1 '   '  t2]; title(tt);
xlabel('ITD (\mus)'); ylabel('Spikes');
% arrow indicates direction of ITD movement
yl = ylim;
yarrow = yl(1) + 0.1*yl*[-1;1];
xarrow = 0;
if ITDup, arr = '\rightarrow';
else, arr = '\leftarrow';
end
text(xarrow,yarrow,arr,'HorizontalAlignment','center','fontweight','bold');

wwwww=0;

%----------------------------
function [yy, I0, I1]=linupsample(dx,y);
X=y(:,1); Y=y(:,2);
X0=min(X); X1=max(X);
I0=ceil(X0/dx); I1=floor(X1/dx);
II = (I0:I1)';
YY = interp1(X,Y,dx*II);
yy=[II YY];
%----------------------------
function [s, EOF]=readln(fid);
% READLN - reads one line from text file
N = 256;
s = blanks(N);
RET = char(10);
ii = 0; NN = N;
while 1,
   [c n] = fread(fid,1,'char');
   if n~=1, break; end;
   if c==RET, break; end;
   ii=ii+1;
   if ii>NN, % c does not fit in s; expand s
      s = [s blanks(N)];
      NN = NN + N;
   end
   s(ii) = c;
end
s = s(1:ii);
EOF = ~isequal(c,RET);
if ~EOF,
   [c n] = fread(fid,1,'char');
   if n~=1,
      EOF = 1;
   else, % undo read-ahead
      fseek(fid,-1,0);
   end
end








