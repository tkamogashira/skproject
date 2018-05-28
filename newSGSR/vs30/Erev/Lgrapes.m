function [LL] = Lgrapes(gr, Wmin, Cdelay, plotArg, impGS, impPS);
% LGRAPES - align multiple grape outputs
if nargin<2, Wmin=1+i; end;
if nargin<3, Cdelay=0; end;
if nargin<4, plotArg='b'; end;
if nargin<5, impGS = 0; end;
if nargin<6, impPS = 0; end;
NN = 1e3; % # freq points after interpolation

if iscell(gr), % recursive call; use standard colors
   clf;
   for ii=1:length(gr),
      impgs = impGS(min(ii,end)); % imposed gain shift (plot only)
      impps = impPS(min(ii,end)); % idem phase
      LL{ii} = Lgrapes(gr{ii}, Wmin, Cdelay, ploco(ii), impgs, impps);
   end
   return;
end

%-------------------------------------------------------------------------
WminIndiv = imag(Wmin);
Wmin = real(Wmin);
Npatch = length(gr);
% determine freq range and select relevant data
for ii=1:Npatch,
   fcar = gr(ii).Fcar; % carrier freq in kHz
   % compute compensated phase in cycles (compensation by Cdely, not CDELAY)
   exPH{ii} = gr(ii).exComponentPhases + fcar*(Cdelay - gr(ii).CDELAY); 
   suPH{ii} = gr(ii).suComponentPhases + fcar*(Cdelay - gr(ii).CDELAY); 
   % weight factors (negative ones will be clipped to zero)
   Wex{ii} = 1e-6+(gr(ii).sumex); % weight factor for excitation
   Wex{ii}(find(Wex{ii}<WminIndiv(1))) = -1e10; % ignore insign components
   Wsu{ii} = 1e-6+(gr(ii).sumsu); % weight factor for suppression
   Wsu{ii}(find(Wsu{ii}<WminIndiv(end))) = -1e10; % ignore insign components
end
% interpolate to finer and uniform axis
minfreq = min(cat(1,gr.Fcar)); maxfreq = max(cat(1,gr.Fcar));
fAxis = linspace(minfreq, maxfreq,NN); % interpolating freq axis

exWeight = localSum({gr.Fcar}, Wex, fAxis); % averaged weight factor for excitatory components
suWeight = localSum({gr.Fcar}, Wsu, fAxis); % averaged weight factor for suppressive components
exWeight(1) = []; suWeight(1) = []; % applied to diffs

exSignif = find(exWeight>=Wmin(1)); % sample range of significant excitors
suSignif = find(suWeight>=Wmin(end)); % sample range of significant excitors

[exGainIP exGainShift] = localAlign({gr.Fcar}, {gr.exGain}, fAxis, Wex);
[suGainIP suGainShift] = localAlign({gr.Fcar}, {gr.suGain}, fAxis, Wsu);
[exPHaseIP exPHaseShift] = localAlign({gr.Fcar}, exPH, fAxis, Wex);
[suPHaseIP suPHaseShift] = localAlign({gr.Fcar}, suPH, fAxis, Wsu);

% conventional offsets
[exGainIP xGs] = localShift(exGainIP, exSignif, 'max'); % gain: max=0
[suGainIP sGs] = localShift(suGainIP, suSignif, 'max'); % gain: max=0
[exPHaseIP xPs] = localShift(exPHaseIP, exSignif, 'mean'); % phase: mean=0
[suPHaseIP sPs] = localShift(suPHaseIP, suSignif, 'mean'); % phase: mean=0

% apply shifts to individual patches
for ii=1:Npatch,
   xG{ii} = gr(ii).exGain + exGainShift(ii) + xGs;
   sG{ii} = gr(ii).suGain + suGainShift(ii) + sGs;
   xP{ii} = exPH{ii} + exPHaseShift(ii) + xPs;
   sP{ii} = suPH{ii} + suPHaseShift(ii) + sPs;
end

exCensor = nan+fAxis; exCensor(exSignif) = 0; exCensor(1) = [];
suCensor = nan+fAxis; suCensor(suSignif) = 0; suCensor(1) = [];
fAxis(1) = [];

% plot gains
f3;
subplot(2,1,1);
Thick = {'linewidth', 1.5};
Small = {'Markersize', 5};
xplot(fAxis, exCensor+exGainIP+impGS, [plotArg '-'], Thick{:}); 
xplot(fAxis, suCensor+suGainIP++impGS, [plotArg '-']); 

for ii=1:Npatch,
   xg = xG{ii}; sg = sG{ii};
   sumex = gr(ii).sumex; sumsu = gr(ii).sumsu; 
   xg(find(sumex<WminIndiv(1))) = nan; % exclude insignificant data points
   sg(find(sumsu<WminIndiv(end))) = nan; % exclude insignificant data points
   xplot(gr(ii).Fcar, impGS+xg, [ploma(ii) plotArg ], Thick{:});
   xplot(gr(ii).Fcar, impGS+sg, [ploma(ii) plotArg ], Small{:});
end
set(gca, 'xticklabel',[]);

% plot phases
subplot(2,1,2);
xplot(fAxis, exCensor+impPS+exPHaseIP, ['-' plotArg], Thick{:}); 
xplot(fAxis, suCensor+impPS+suPHaseIP, [':' plotArg]); 

for ii=1:Npatch,
   xp = xP{ii}; sp = sP{ii};
   sumex = gr(ii).sumex; sumsu = gr(ii).sumsu; 
   xp(find(sumex<WminIndiv(1))) = nan; % exclude insignificant data points
   sp(find(sumsu<WminIndiv(end))) = nan; % exclude insignificant data points
   xplot(gr(ii).Fcar, impPS+xp, [ploma(ii) plotArg ], Thick{:});
   xplot(gr(ii).Fcar, impPS+sp, [ploma(ii) plotArg], Small{:});
end
xlabel('Frequency (kHz)')

LL = CollectInStruct(fAxis, exGainIP, suGainIP, exPHaseIP, suPHaseIP);

%xplot(fAxis, exWeight, 'linewidth', 1.5); 
%xplot(fAxis, suWeight); 

%xplot(fAxis(2:end), QQ,'r');
% xplot(fAxis(2:end), exWeight);
% f2 ; xplot(fAxis(2:end), PHsuIP);




% --------------------------------------
function Y_IP = localInterpolate(X, Y, X_IP, substnan, downclip);
% interpolate to finer X-axis
Npatch = length(X);
for ii=1:Npatch,
   if iscell(Y), y = Y{ii}; else, y = Y*ones(size(X{ii})); end;
   Y_IP{ii} = interp1(X{ii}, y, X_IP); % interpolate quantity Y to include all x-values
   if nargin>3, % replace nans
      Y_IP{ii}(find(isnan(Y_IP{ii}))) = substnan;
   end
   if nargin>4, % clip small values
      Y_IP{ii}(find(Y_IP{ii}<downclip)) = downclip;
   end
end

function [Ytot, shift] = localAlign(X, Y, X_IP, W);
% align using the weighted average of increments

% interpolate to finer and uniform axis
doWeight = (nargin>=4); % trivial weights
Npatch = length(X);
Y_IP = localInterpolate(X,Y,X_IP);
% plot(Y_IP{1}); pause; delete(gcf);
if doWeight,
   W_IP = localInterpolate(X, W, X_IP, 0, 0); % 1st 0-> nan replaced by zeros; 2nd 0: downclip
else,
   W_IP = localInterpolate(X, 1, X_IP, 0, 0); % trivial weight factors, but only within covered range
end
% plot(X_IP, W_IP{1}, X_IP, W_IP{2}, 'rx'); pause; delete(gcf);
% compute weighted average of jumps (increments) over all patches
DY = 0; sumW = 1e-6;
for ii=1:Npatch,
   wip = W_IP{ii}(2:end);
   dd = wip.*diff(Y_IP{ii});
   inans = find(isnan(dd));
   dd(inans) = 0; % set out-of range increments to zero
   nonnull = find(dd~=0);
   MI = min(nonnull); MA = max(nonnull);
   dd([MI MA]) = 0;
   wip(inans) = 0; wip([MI MA]) = 0;
   DY = DY + dd; % add to grand jump store
   % xplot(X_IP(2:end), dd, [ploco(ii),'.']);
   sumW = sumW + wip; % sum of weights for normalization
end
% integrate normalized jumps
Ytot = cumsum(DY./sumW);
% xplot(X_IP(2:end), DY); pause; clf;
% for the individual patches, look what shift aligns them with Ytot
for ii=1:Npatch,
   wip = W_IP{ii};
   y_ip = Y_IP{ii};
   nonnan = find(~isnan(y_ip)); % indices of non-nan components
   nonnan(find(nonnan==length(y_ip))) = []; % last component out of range of Ytot
   if isequal(0,sum(wip)), shift(ii) = nan;
   else, shift(ii) = sum(wip(nonnan).*(Ytot(nonnan)-y_ip(nonnan)))/sum(wip);
   end
end


function Yav = localSum(X, Y, X_IP);
% interpolate and sum
Y_IP = localInterpolate(X,Y,X_IP,0);
Yav=0;
for ii=1:length(Y_IP),
   Yav = Yav + Y_IP{ii};
end

function [Y, sh] = localShift(Y,sr, mode);
% trivial shift: subtract mean or max evaluated over restricted sample range
if ~isempty(sr), sh = -feval(mode, Y(sr));
else, sh = 0; 
end
Y = Y+sh;





