function Phases = ApexTRF(AA, icell, cdelay, plotArg, phaseOffset, SPLlim);
% ApexTRF(AA);

if nargin<2, icell=[]; end
if nargin<3, cdelay = 3; end
if nargin<4, plotArg = ''; end
if nargin<5, phaseOffset = 0; end
if nargin<6, SPLlim = [-inf inf]; end

if isequal('*', phaseOffset),
   DF = AA(1).DF;
   switch AA(1).DF
   case 'A0128'
      phaseOffset = [0 1 1 0 1  1 1 1 1 0  1 1 1 0 1  1 0 1 1 2  1 1 1 1 0  1 0 0 0 0  5 0];
   case 'A0213',
      phaseOffset = [0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  1 1 -1 1 1  -1 1 0 1 -1  0 0 0 0 0  0 0 0 0 0  1 0 -1 0 6  -1 -1 -1 -1];
   case 'A0244',
      phaseOffset = [0 1 1 1 1  1 1 1 1 1  1 1 2 2 1  1 2 2 1 2  1 2 2 1 1  2 1 2 2 2  1 2 2];
   case 'A0306',
      phaseOffset = [0 0 0 0 0  0 0 1 0 0  0 0 3 2 1  0 0 2 2 0  0 1 0 1 0  1 1 1 1 1  1 1 -1 0 0  0 -1 0 -2 0   2 2];
   case 'A0307',
      phaseOffset = [0 -1 0 0 0  0 0 0 0 0  0 0 -1 -1 0  0 0 0 -1 0  0 0 0 1 0  0 0 0 0 0  0 0 1 0 1  1 0 0 0 0  1 1 -1 -1 -1  -1 -1 0 -1 -1  -1 0];
   case 'A0323',
      phaseOffset = [0 0 0 0 0  0 0 0 0 0  1 nan 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0];
   case 'A0428',
      phaseOffset = [0 1 0 1 2  1 1 2 1 2  1 2 2 -1 1  1 2];
   otherwise,
      error('Unkown exp - cannot supply phase offsets');
   end
end
% icell = -N: first N cells sorted according to CF
icellmax = inf;
if ~isempty(icell) & isnumeric(icell),
   if all(icell<0)
      icellmax = abs(icell);
      icell = []; % see next
   end
end

if isempty(icell), % multiple cells sorted according to CF
   CF = [AA.CF];
   [icell, iun] = unique([AA.iCell]); 
   [CF, isort] = sort(CF(iun));
   icell = icell(isort);
end
% only the first icellmax ones
if (icellmax<inf), icell=icell(1:icellmax); end

if length(icell)>1,
   phaseOffset(length(icell)+1)=0; % make sure there enough elements
   Phases = [];
   for ii = 1:length(icell),
      ph = ApexTRF(AA, icell(ii), cdelay, [ploco(ii) ploma(ii) '-'], phaseOffset(ii), SPLlim);
      Phases = [Phases; ph];
   end
   return
end

%---------single cell from here-------
if isempty(plotArg),
   plotArg = [ploco(1) ploma(1) '-'];
   figure
end
if isnumeric(icell),
   ihit = find([AA.iCell]==icell);
elseif ischar(icell);
   ihit = strmatch(icell, {AA.AAname});
end
%ihit    
AA = AA(ihit);
CF = unique([AA.CF]);
disp(['cell ' num2str(icell) '; CF = ' num2str(CF)]);

NY = length(AA);
% make sure phOffset is long enough
minCFdist = inf; CFphase = nan+CF;
Phases = [];
for ii=1:NY; 
   AAi = AA(ii);
   isig = find((AAi.RScar<=0.001) & (AAi.SPL(:)' >= SPLlim(1))  & (AAi.SPL(:)' <= SPLlim(2)) );
   if isempty(isig), continue; end
   freq = [AAi.Fcar]; freq = freq(isig);
   PH = AAi.TRFphase; PH = PH(isig);
   PH = phaseOffset + delayPhase(PH, freq, cdelay-AAi.CDELAY, 0);
   xplot(freq, PH, plotArg, 'markersize', 4); 
   ph = [CF+0*freq(:), freq(:), PH(:)];
   Phases = [Phases; ph];
   % which freq is closest to CF? remember its phase
   [CFdist iCF] = min(abs(CF-freq));
   if (CFdist<minCFdist),
      CFphase = PH(iCF);
      minCFdist = CFdist;
   end
end
xplot(CF, CFphase, ['wo'], 'markersize', 10, 'markerfacecolor', plotArg(1)); 
%xlim([0 5.5]);
title(['compensating delay: ' num2str(cdelay) ' ms']);
grid on
xlabel('Frequency (kHz)')
ylabel('Phase lag (cycle)')
if atkiwi, set(gcf,'pos',[222         278        1048         618]); end
xlog125([0.08 6]);


