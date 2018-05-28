function [GrandCurves, DC] = alignBNdata(RR, minConf, compDelay);
% alignBNdata - shift patches of BN data while optimizing the overlap
%   SYNTAX : [GrandCurves, DC] = alignBNdata(RR, minConf);
%   Results will be plotted if no argouts are requested.

if nargin<2, minConf=-1; end;
if nargin<3, compDelay=RR{1}.compdelay; end;
extraDelay = compDelay-RR{1}.compdelay;

DF = 10; % Hz spacing

doPlot = (nargout<1);

Nset = length(RR); % RR is argout of banana call with cell-valued iSeq arg

minFreq = inf; maxFreq = -inf;
for ii=1:Nset,
   minFreq = min(minFreq,min(RR{ii}.Freq));
   maxFreq = max(maxFreq,max(RR{ii}.Freq));
end

Ndf = 1+round(1e3*(maxFreq-minFreq)/DF); % # components
icomp = zeros(Nset, Ndf); 
weight = zeros(Nset, Ndf);
gain = zeros(Nset, Ndf);
phase = zeros(Nset, Ndf);
origdata  = zeros(Nset, Ndf);

% interpolate data to finely spaced common grid
for ii=1:Nset,
   origfreq = [RR{ii}.Freq(:)']; % in kHz
   i0 = 1+round(min(origfreq-minFreq)*1e3/DF);
   i1 = 1+round(max(origfreq-minFreq)*1e3/DF);
   newfreq = minFreq + DF*(i0:i1)*1e-3;
   conf = RR{ii}.Conf(:)';
   if ~isempty(minConf),
      conf(find(conf<minConf)) = 0;
   else, 
      conf = conf*0;
      conf(RR{ii}.Reliable) = 1;
      minConf = 0;
   end
   if (ii==1) | (ii==Nset), wfactor=2; else wfactor=1; end;
   ofb = [0 origfreq 1e10]; % boundary terms to ensure interpolation
   weight(ii,i0:i1) = wfactor*interp1(ofb, [0 sqrt(conf) 0], newfreq);
   oldGain = RR{ii}.Gain(:)';
   gain(ii,i0:i1) = interp1(ofb, oldGain([1 1:end end]), newfreq);
   extraPhase = origfreq.*extraDelay; % in cycles
   extraPhase = extraPhase - round(extraPhase(1));
   RR{ii}.Phase = RR{ii}.Phase + extraPhase';
   oldPhase = RR{ii}.Phase';
   phase(ii,i0:i1) = interp1(ofb, oldPhase([1 1:end end]), newfreq);
end

% newfreq = minFreq+DF*(1:Ndf)*1e-3;
%f3; plot(newfreq', gain');
%f4; plot(newfreq', phase');
% pause; delete([3 4]);

% compute best-matching grand curves
Gain = localAlignRows(gain,weight);
Gain = Gain-max(Gain);
Phase = localAlignRows(phase,weight);
% plot Grand curves
Freq = minFreq + 1e-3*(0:Ndf)*DF;
Freq = Freq(1:length(Gain));
Outsiders = find((Freq<minFreq)|(Freq>maxFreq));
% Gain(Outsiders) = NaN;
% Phase(Outsiders) = NaN;

if doPlot,
   f3; subplot(2,1,1);
   plot(Freq, Gain,'-','linewidth',1);
   set(gca,'xticklabel',{});
   iCell = iseq2id(RR{1}.FN, -RR{1}.iSeq(1));
   iCell = strtok(iCell, '-');
   tttt = ['File ' RR{1}.FN ', cell ' iCell];
   title([tttt  '  ---  Comp delay = ' num2str(compDelay) ' ms;  min conf = ' num2str(minConf)]);
   grid on;
   ylabel('Gain (dB)');
   YL = ylim; ylim([YL(1) 0]);
   subplot(2,1,2);
   plot(Freq, Phase,'-','linewidth',1);
   xlabel('Frequency (kHz)');
   ylabel('Phase (cycles)');
   grid on;
end

% now determine DC shift of each patch to match grand curves
GG = Gain; GG(find(isnan(GG))) = 0; % remove NaNs as they will spoil computation below
PP = Phase; PP(find(isnan(PP))) = 0; % idem
for ii=1:Nset,
   sumw = 1e-10+sum(weight(ii,:));
   gainDC(ii) =  sum(weight(ii,:).*(GG - gain(ii,:)))/sumw;
   phaseDC(ii) = sum(weight(ii,:).*(PP - phase(ii,:)))/sumw;
end
if doPlot, f3; subplot(2,1,1); end;
for ii=1:Nset,
   shiftedGain = RR{ii}.Gain+gainDC(ii);
   % eleminate data points below confidence criterium
   shiftedGain(find(RR{ii}.Conf(:)<minConf)) = NaN;
   if doPlot,
      xplot(RR{ii}.Freq, shiftedGain, [ploco(ii) ploma(ii)]);
   end
end
if doPlot, f3; subplot(2,1,2); end;
for ii=1:Nset,
   shiftedPhase = RR{ii}.Phase+phaseDC(ii);
   % eleminate data points below confidence criterium
   shiftedPhase(find(RR{ii}.Conf(:)<minConf)) = NaN;
   if doPlot,
      xplot(RR{ii}.Freq, shiftedPhase,[ploco(ii) ploma(ii)]);
   end
end
if doPlot, % synchronize xlim
   if ishandle(2),
      f2; subplot(3,1,1); 
      XL = xlim
   else,
      f3; subplot(2,1,1); 
      XL1 = xlim;
      subplot(2,1,2); 
      XL2 = xlim;
      XL = [min(XL1(1),XL2(1)), max(XL1(2),XL2(2))];
   end;
   f3;
   subplot(2,1,1); 
   xlim(XL);
   subplot(2,1,2); 
   xlim(XL);
end

% return grand curves and individual DC shifts
GrandCurves = CollectInStruct(Freq, Gain, Phase);
DC = CollectInStruct(gainDC, phaseDC);


% -----------locals-------------
function am = localAlignRows(m,w);
% derivative is weighted sum of individual derivatives
% weight is geom mean of shifted weights
ww = sqrt(w(:,1:end-1).*w(:,2:end));
dm = diff(m,1,2).*ww;
rn = sum(ww);
ignore = find(sum(ww)==0);
dm = sum(dm)./(1e-10+rn);
am = cumsum([0 dm]);
am(ignore) = NaN;




