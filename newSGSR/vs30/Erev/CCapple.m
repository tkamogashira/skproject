function S = CCapple(AA, icurve, cdelay, CF, plotArg, ampOffset, phasOffset, taboo);
% CCapple - composite amplitude and phase curves from apple data
%   syntax CCapple(AA, icurve, cdelay, CF, plotArg, ampOffset, phasOffset, taboo);
%   where AA is return values of apple
%   AA and icurve may also be corresponding cell arrays
%   when plotarg is 'Lr' only the line is plotted (in red), etc
%
%   AA may also be string as in 
%    CCapple('213/119',[1 2 3 4 5 6 7], cdelay, [], ploco(13), -15, 2);
%  In that case the apple data are retrieved from global Aset (see appleviewer)
%  Combine different apple sets:
%    CCapple('213/20&213/20a',{0 [1 2 4]}, cdelay, []);


Naxis = 1e2; % # points of interpolated amp & phase values

if nargin<2, icurve=0; end % all curves in AA
if nargin<3, cdelay=1; end % ms comp delay
if nargin<4, CF=[]; end 
if nargin<5, plotArg = ''; end 
if nargin<6, ampOffset = 0; end 
if nargin<7, phasOffset = 0; end 
if nargin<8, taboo = []; end  

if iscell(AA), % recursive calls
   clf;
   if isequal(0,icurve), icurve = repmat({0}, length(AA)); end
   if isequal(0,ampOffset), ampOffset = zeros(1,length(AA)); end
   if isequal(0,phasOffset), phasOffset = zeros(1,length(AA)); end
   S = [];
   for ii=1:length(AA),
      s = CCapple(AA{ii}, icurve{ii}, cdelay, CF, ploco(ii), ampOffset(ii), phasOffset(ii), taboo);
      S = [S s];
   end
   return;
end

%-----------------------single AA from here--------------------------
%--------------------------------------------------------------------
% check for pre-defined plot handles
if ~plotPanel('exist'),
   plotPanel('default', [2 1]); % default 2x1 panel configuration
end

showRawdata = 1;
if length(plotArg)>0,
   if isequal('L', plotArg(1)),
      showRawdata = 0;
      plotArg = plotArg(2:end);
   end
end
if ischar(AA), % string like '307/50a' or '307/50&307/50a'
   AA = sixapplecats(AA, icurve);
   icurve = 0; % all curves of the newly assembled AA join the analysis
end

if isequal(0,icurve), % all curves
   icurve = 1:length(AA);
end

if isempty(CF),
   try, % retrieving CF from aaple output
      CF = AA(1).CF;
   end
end

if isstruct(phasOffset), % phase offset is given in terms of the unwrapped phase at the CF=Fstim diagonal
   TargetCFphase = minloc(phasOffset.PHdiag, abs(phasOffset.CFdiag-CF));
   try, phasOffset = phasOffset.commonPhaseOffset; catch, phasOffset = 0; end
else,
   TargetCFphase = nan;
end

[Fmin, Fmax] = minmax([AA.Fcar]);
FreqAxis = linspace(Fmin,Fmax,Naxis);
dampWeights = zeros(1,Naxis-1);
dampMean = zeros(1,Naxis-1);
phWeights = zeros(1,Naxis);
phMean = zeros(1,Naxis);
skip = [];
for jj=icurve, 
   Aj = AA(jj); 
   isig = find(Aj.RScar<=0.001); % indices of significant components
   if length(isig)<2, skip = [skip jj]; continue; end
   freq = Aj.Fcar(isig); 
   % --ampl
   plotPanel(1);
   AMP = Aj.TRFamp(isig);
   amp = interp1(freq,AMP, FreqAxis);    % interpolate values; outside-range values are nan
   damp = diff(amp);
   iok = find(~isnan(damp)); 
   dampWeights(iok) = dampWeights(iok) + 1; % only non-nan values carry weight
   dampMean(iok) = dampMean(iok) + damp(iok); % average of amp-diff values
   % --phase
   PH = Aj.TRFphase(isig); 
   PH = delayPhase(PH, freq, cdelay-Aj.CDELAY, 0);
   ph = interp1(freq,PH, FreqAxis);    % interpolate values; outside-range values are nan
   iok = find(~isnan(ph)); 
   phWeights(iok) = phWeights(iok) + 1; % only non-nan values carry weight
   phMean(iok) = phMean(iok) + exp(2*pi*i*ph(iok)); % vector average of phase values
   % don't plot yet, but store - offsets depend on average
   rawFreq{jj} = freq;
   rawAmp{jj} = AMP;
   rawPhase{jj} = PH;
end; 
%--- finish the averaging operations
% amplitude
inon = find(dampWeights==0);
dampWeights(inon) = nan; % zero weight means no info, so ignore these values
dampMean = dampMean./dampWeights;
dampMean = localInterp(FreqAxis,dampMean,200);
istart = min(find(~isnan(dampMean))); % cumsum starts at first non-nan value or else everything will be NaN
ampMean = cumsum([0 dampMean(istart:end)]); % get relative amplitudes by integrating ampl differences
ampMean = [nan*ones(1,istart-1) ampMean]; % re-insert any prepending nans
ampMean = ampMean - max(ampMean); % convention: peak @ 0 dB 
% phase
inon = find(phWeights==0);
phWeights(inon) = nan; % zero weight means no info, so ignore these values
phMean = phMean./phWeights;
phMean = localInterp(FreqAxis, phMean,200);
phMean = unwrap(angle(phMean))/2/pi; % vector values -> angles -> cycles
phMean = phMean-round(mean(denan(phMean)));
% impose requested offsets
ampMean = ampMean+ampOffset;
if ~isnan(TargetCFphase), % move to align phase @ CF toward prescribed value
   cfph = minloc(phMean, abs(FreqAxis-CF));
   phShift = round(TargetCFphase-cfph);
   phasOffset = phasOffset + phShift;
end
phMean = phMean+phasOffset;

% plot the mean curves
%=amp
PlotPanel(1);
fr = localTaboo2nan(FreqAxis,taboo);
xplot(fr, ampMean, ['-' plotArg]);
[cf, dum, cfamp, cfph] = minloc(FreqAxis, abs(FreqAxis-CF), ampMean, phMean);
xplot(cf, cfamp, ['o' plotArg], 'markerfacecolor', 'w');
%xlim([min(FreqAxis) max(FreqAxis)]);
ylabel('Gain (dB)');
%=phase
PlotPanel(2);
xplot(fr, phMean, ['-' plotArg]);
xplot(cf, cfph, ['o' plotArg], 'markerfacecolor', 'w');
%xlim([min(FreqAxis) max(FreqAxis)]);
xlabel('Stimulus frequency (kHz)');
ylabel('Phase (cycle)');
% now plot the aligned stuff
for jj=icurve, 
   if ismember(jj,skip), continue; end
   freq = rawFreq{jj};
   % amplitude: align the means of the raw data to match that of the ampMean curve
   PlotPanel(1);
   AmpmeanValues = interp1(FreqAxis, ampMean, freq);
   [AmpmeanValues, inonnan] = denan(AmpmeanValues);
   meanAmpmean = mean(AmpmeanValues);
   meanAmp = mean(rawAmp{jj}(inonnan));
   rawAmp{jj} = rawAmp{jj} + meanAmpmean - meanAmp;
   AMP = rawAmp{jj};
   xplot(freq+pmask(showRawdata), AMP, [ploma(jj) plotArg]);
   ylim('auto'); YL = ylim; ylim([YL(1) 2]);
   grid on
   % phase: alignment here is a form of unwrapping - delegate to unwrapToMatch function
   PlotPanel(2);
   rawPhase{jj} = unwrapToMatch(rawFreq{jj}, rawPhase{jj}, FreqAxis, phMean);
   PH = rawPhase{jj};
   xplot(freq+pmask(showRawdata), PH, [ploma(jj) plotArg]);
end
S = collectInStruct(FreqAxis, ampMean, phMean, rawFreq, rawAmp, rawPhase, phWeights);

% equalize x limits
PlotPanel(1);
xlim('auto'); XL = xlim;
PlotPanel(2);
xlim(XL);

% mark CF..
title(['compensating delay: ' num2str(cdelay) ' ms']);
grid on

%======================================
function Y = localInterp(X,Y,maxgap);
% eliminate small enough nan islands by linear interpolation
inan = find(isnan(Y));
if isempty(inan), return; end % no gaps
N = length(Y);
ireal = find(~isnan(Y));
ijump = ireal(find(diff(ireal)>1)); % start of gaps
ijump2 = ireal(1+find(diff(ireal)>1)); % end of gaps
for ii=1:length(ijump),
   igap = ijump(ii)+1:ijump2(ii)-1;
   xgap = X(igap);
   gapwidth = max(xgap)-min(xgap);
   if xgap<maxgap,
      i0 = ijump(ii); i1 = ijump2(ii);
      ygap = interp1(X([i0 i1]), Y([i0 i1]), xgap);
      Y(igap) = ygap;
   end
end

function X = localTaboo2nan(X,taboo);
% sets taboo values of X to nan
for ii=1:size(taboo,1),
   itab = find(betwixt(X, taboo(ii,:)));
   X(itab) = nan;
end


%----------------------------------------------------------------------

