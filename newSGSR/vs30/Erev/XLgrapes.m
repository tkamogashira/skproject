function LL = XLgrapes(gr, Wmin, Cdelay, plotArg, impGS, impPS);
% XLGRAPES - align multiple grape outputs
%    usage: XLgrapes(gr, Wmin, Cdelay, plotArg, impGS, impPS);

if nargin<2, Wmin=[1 1]; end;
if nargin<3, Cdelay=0; end;
if nargin<4, plotArg='b'; end;
if nargin<5, impGS = 0; end;
if nargin<6, impPS = 0; end;
NN = 1e3; % # freq points after interpolation

if iscell(gr), % recursive call; use standard colors
   clf;
   for ii=1:length(gr),
      cdel = Cdelay; if iscell(cdel), cdel=cdel{ii}; end
      impgs = impGS(min(ii,end)); % imposed gain shift (plot only)
      impps = impPS(min(ii,end)); % idem phase
      LL(ii) = XLgrapes(gr{ii}, Wmin, cdel, [ploco(ii) ploma(ii)], impgs, impps);
   end
   return;
end

%---preprocessing--------------------------------------------------
Wminex = Wmin(1); Wminsu = Wmin(end);
Npatch = length(gr);
% determine freq range and select relevant data
for ii=1:Npatch,
   Wex{ii} = gr(ii).sumex; % weight factor for excitation
   isig = find(Wex{ii}>=Wminex);
   % remove all insignificant components
   Wex{ii} = Wex{ii}(isig);
   Fcar{ii} = gr(ii).Fcar(isig); % carrier freq in kHz
   exGN{ii} = gr(ii).exGain(isig);
   % compute compensated phase in cycles (compensation by Cdely, not CDELAY)
   fcar = Fcar{ii}; % carrier freq in kHz
   exPH{ii} = gr(ii).exComponentPhases(isig) + fcar*(Cdelay - gr(ii).CDELAY); 
   exPH{ii} = unwrap(2*pi*exPH{ii})/2/pi;
end
% interpolate to finer and uniform axis
minfreq = min(cat(1, Fcar{:})); maxfreq = max(cat(1,Fcar{:}));
fAxis = linspace(minfreq, maxfreq,NN); % interpolating freq axis

D = 0; W = 0;
Dp = 0;
for ii=1:Npatch,
   fcar = Fcar{ii}; % carrier freq in kHz
   [dy, w] = localDiffContrib(fcar, exGN{ii}, fAxis, Wex{ii});
   D = D + w.*dy; W = W + w;
   [dy, w] = localDiffContrib(fcar, exPH{ii}, fAxis, Wex{ii});
   Dp = Dp + w.*dy;
end

exGain = localIntegrate(fAxis, D, W);
exGain = exGain-max(exGain);
exPhase = localIntegrate(fAxis, Dp, W);
plmask = 0;
try, if plotArg(2)=='q', plmask = NaN; end; end
subplot(2,1,1);
xplot(fAxis, plmask+impGS+exGain, plotArg(1));
% xlabel('Frequency (kHz)');
ylabel('Gain (dB)');
subplot(2,1,2);
xplot(fAxis, plmask+impPS+exPhase, plotArg(1));
xlabel('Frequency (kHz)');
ylabel('Phase (cycles)');

for ii = 1:Npatch, 
   plotarg = plotArg;
   try, if plotarg(2)=='q', plotarg = [ploma(ii) ploco(ii)]; end; end
   fcar = Fcar{ii}; % carrier freq in kHz
   % gain
   subplot(2,1,1);
   osGN{ii} = impGS+localOffset(fAxis, exGain, fcar, exGN{ii}, Wex{ii});
   xplot(fcar, osGN{ii}+exGN{ii}, [plotarg]); 
   grid on;
   % phase
   subplot(2,1,2);
   osPH{ii} = impPS+localOffset(fAxis, exPhase, fcar, exPH{ii}, Wex{ii});
   xplot(fcar, osPH{ii}+exPH{ii}, [plotarg]); 
   grid on;
end;
subplot(2,1,2);
title(['compensating delay: ' num2str(Cdelay) ' ms']);

LL = CollectInStruct(fAxis, exGain, exPhase, Fcar, exGN, exPH, osGN, osPH, Wex);
%======================
function [dy, wnew]=localDiffContrib(x,y,xnew,w);
if length(x)<2, dy=0*xnew; wnew = 0*xnew; return; end;
ynew = interp1(x,y,xnew); % interpolates y values of sign components
dy = diff(ynew); % differentiate y values
dy = [dy dy(end)]; % provide last comp for matching length
dy(find(isnan(dy))) = 0; % outside range -> zero contribution to gradient
if nargout>1,
   wnew = interp1(x,w,xnew); % interpolate weights
   wnew(find(isnan(wnew))) = 0; % outside range -> zero weight
end

function y = localIntegrate(X, wdy, w);
isig = find(w>0); 
if isempty(isig), y=nan*X; return; end;
% restrict to significant components
x = X(isig); w = w(isig);
dy = wdy(isig)./w; % weighted average
dy = interp1(x,dy,X); % interpolate to full range
outside = find(isnan(dy)); % outside measured range
dy(outside) = 0;
y = cumsum(dy);
y(outside) = nan;

function os = localOffset(X, Y, x, y, w);
% find offset of y that optimally aligns y(x) with Y(X)
if sum(w)==0, os=0; return; end;
YY = interp1(X,Y,x); % the "ideal" y values
nin = find(~isnan(YY));
if ~isempty(nin),
   y = y(nin);
   w = w(nin);
   YY = YY(nin);
end
os =  (sum(YY.*w)-sum(y.*w))./sum(w);

