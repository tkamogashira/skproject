function [plotFreq, trfPH, isSign, carAmp] = orange(FN,iSeq, plotArg);
% ORANGE - carrier-phase analysis of BN data

global OrangePlotGain
persistent CompDelay DefArgs
phJump = 0;

if nargin<2,
   if nargin==1,
      phJump = FN;
   end
   FN = DefArgs{1};
   iSeq = DefArgs{2};
end

if isempty(CompDelay),
   CompDelay = 0;
end
if isequal(FN,'setdelay'),
   CompDelay = iSeq;
   return;
elseif isequal(FN,'setdefargs'),
   DefArgs = {iSeq, plotArg}
   return;
end


if (nargin<3) | iscell(iSeq), 
   plotArg= 'b'; 
   try,    delete(3); 
   end
end

if iscell(iSeq), % recursive, cell-wise call; plot only when data are complete
   if ishandle(2),
      f2;
      subplot(3,1,3);
      cla;
   end
   parts = []; plotFreq = []; trfPH= []; isSign = []; origin = []; carAmp = {};
   % remove char elements
   qqqq={};
   for ii=1:length(iSeq),
      if ~ischar(iSeq{ii}), qqqq = {qqqq{:} iSeq{ii}}; end;
   end
   iSeq = qqqq;
   for ii=1:length(iSeq),
      [pf, tf, ns, carAmp{ii}] = orange(FN, iSeq{ii});
      origin = [origin ones(1,length(pf))*ii]; % remember where the components come from
      plotFreq = [plotFreq pf];
      trfPH = [trfPH tf];
      isSign = [isSign ns];
      ppff{ii} = pf;
   end
   % sort all info by freq
   [plotFreq sortIndex] = sort(plotFreq);
   trfPH = trfPH(sortIndex);
   origin = origin(sortIndex);
   isSign = isSign(sortIndex);
   % unwrap sorted phases - only significant ones count!!
   trfPH(find(isSign)) = unwrap(trfPH(find(isSign)));
   % f4; plot(trfPH(find(isSign)),'x'); pause;;
   % now re-group and plot
   localSelectAxes; mmmmm = inf;
   for ii=1:length(iSeq),
      select = find(origin==ii); % indices of data from seq ii
      plotArg = [ploco(ii) ploma(ii)];
      ph = trfPH(select);
      if 1, ph=unwrap(ph); end
      ph = ph-2*pi*round(mean(ph/2/pi));
      localPlotPhase(plotFreq(select), ph, isSign(select), plotArg);
      Phases{ii} = ph;
      ISIS{ii} = isSign(select);
      if ishandle(2) & ~isempty(OrangePlotGain),
         ca = carAmp{ii};
         ca = ca-max(ca)+pmask(ISIS{ii});
         f2; subplot(3,1,1);
         YL = ylim;
         mmmmm = min([YL mmmmm, min(ca)]);
         xplot(ppff{ii}, ca, ['-' ploco(ii) ploma(ii)]);
      end
   end
   plotFreq = ppff;
   trfPH = Phases;
   isSign = ISIS;
   if ishandle(2),
      f2; subplot(3,1,1);
      try, ylim([mmmmm 0]); end;
   end
   return;
end

% single spt collection from here
[AmPhCo, CHist, PW, advice, Espec, critSpecLevel, BN] = Banana(FN, iSeq);

Nfreq = length(Espec);
dfreq = BN.DDfreq(1)*1e-3; % freq spacing in kHz
freqs = (0:Nfreq-1)*dfreq; % freq axis 

carIndex = BN.Kfreq+1;
carAmp = a2db(abs(Espec(carIndex)))-critSpecLevel-a2db(abs(BN.EE0)); % consider Tilt!
MM = 1:max(carIndex);
PH = -angle(Espec(carIndex));
PHstim = angle(BN.EE0);
compPhase = 2*pi*(real(CompDelay)*freqs(carIndex));

trfPH = rem(PH-PHstim+compPhase,2*pi);
trfPH = unwrap(trfPH);
while mean(trfPH)< pi, trfPH = trfPH+2*pi; end;
while mean(trfPH)> 1.5*pi, trfPH = trfPH-2*pi; end;
plotFreq = freqs(carIndex);

isSign = (a2db(abs(Espec(carIndex)))>=critSpecLevel); % significant or not according to Lord Rayleigh
if nargout>0, return; end;

localSelectAxes;
localPlotPhase(plotFreq, trfPH, notSign, plotArg);

% xplot(freqs(carIndex), PHstim ,[plotArg 'x']);
% xplot(freqs(carIndex), a2db(abs(Espec(carIndex))),[plotArg '.']);
% extend CH spectrum to show carrier

%--------locals--------------------
function localSelectAxes;
if ishandle(2),
   f2; 
   subplot(3,1,2);
   YL2 = ylim;
   subplot(3,1,3);
   set(gca,'ylimmode','auto');
   XL = xlim;
   % cla;
   hold on;
   xlim(XL);
   ylabel('Carrier phase (cycles)');
else
   f3; 
end


function localPlotPhase(plotFreq, trfPH, isSign, plotArg);
if ishandle(2),
   f2; subplot(3,1,3);
end
trfPH(~isSign) = NaN;
xplot(plotFreq, trfPH/2/pi , [plotArg '-'] );
grid on

if ishandle(1),
   f1; subplot(2,1,1); set(gca,'xticklabelmode','auto');
   XL = xlim;
   Cand = 1.1*max(plotFreq);
   xlim([0 max(XL(2),Cand)]);
   YL = ylim;
   ylim([-10 max(40,YL(2))]);
end

if ishandle(2),
   f2;
   subplot(3,1,2);
   YL2 = ylim;
   subplot(3,1,3);
   YL3 = ylim;
   yr2 = YL2(2)-YL2(1);
   yr3 = YL3(2)-YL3(1);
   % if (y3<=3),
   %    ylim()
   % end
end


