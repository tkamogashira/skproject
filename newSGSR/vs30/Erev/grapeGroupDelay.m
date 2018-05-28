function  Piece = grapegroupdelay(GG, Show, Cdelay);
% GRAPEGROUPDELAY - compute group delay from zwuis data
%   usage: Piece = grapegroupdelay(GG, Show, xdelay), 
%   where GG is grape output. If Show then fits are plotted,
%   with phase tilted according to Cdelay (default = grape setting)
%
%   See also GRAPEDELAY

if nargin<2, Show=0; end
if nargin<3, Cdelay=nan; end

if isfield(GG,'VSref'), % delegate to appleGroupDelay
   Piece = applegroupdelay(GG, Show, Cdelay);
   return
end

Nzwuis = length(GG);
Piece = [];
for izwuis = 1:Nzwuis,
   gg = GG(izwuis);
   if ~isstruct(gg), continue; end
   if ~isfield(gg, 'CF'),
      warning(['Missing CF, iSeq = ' num2str(gg.iSeq)]);
      continue;
   end
   theCF = gg.CF;
   theiCell = gg.iCell;
   % partition in neighboring groups (pieces) of carrier freqs
   [FR, II, len, NN]=groupFcar(gg.Fcar, gg.sumex, gg.MINCONF); % FR{:}, II{:}, len, NN   
   for ipiece=1:NN,
      index = II{ipiece};
      Ncomp = len(ipiece);
      Fcar = FR{ipiece};
      SPL = gg.SPL(index);
      weights = gg.sumex(index);
      Phase = gg.exComponentPhases(index);
      % order of fitting polynomial
      polOrder = 1; if Ncomp>10, polOrder=3; elseif Ncomp>4, polOrder=2; end
      % weighted polyfit
      effweights = [0.25; ones(Ncomp-2,1); 0.25].*weights; % suppress weight of endpoints
      Coef = wpolyfit(Fcar, Phase, effweights, polOrder);
      DCoef = polydiff(Coef); % phase -> group delay
      DCoef(end) = DCoef(end) -gg.CDELAY; % undo compensating delay of grape
      GroupDelay = -polyval(DCoef, Fcar);
      Weight = sum(weights)+0*weights;
      CF = theCF*ones(size(Fcar));
      iCell = theiCell*ones(size(Fcar));
      Piece = [Piece CollectInStruct(CF, Fcar, SPL, Weight, GroupDelay, iCell)];
      if Show, % show the phase and the fits in a plot
         if isnan(Cdelay), Cdelay = gg.CDELAY; end
         xdelay = Cdelay-gg.CDELAY;
         PH = Phase+Fcar*xdelay;
         xplot(Fcar, PH-mean(PH), [ploma(ipiece) ploco(izwuis)]);
         plotfreq = linspace(min(Fcar), max(Fcar), 20);
         plotphase = polyval(Coef, plotfreq);
         PH = plotphase+plotfreq*xdelay;
         xplot(plotfreq, PH-mean(PH), ['-' ploco(izwuis)]);
      end
   end
end
if Show,
   xlabel('Fcar (kHz)'); 
   ylabel('Phase (cycle)');
   title(['cell ' num2str(GG(1).iCell) '  ---  cdelay=' num2sstr(Cdelay) ' ms']);
   YL = ylim;
   xplot(GG(1).CF, YL(1), 'x', 'markersize', 8);
   xplot(GG(1).CF, YL(1), 'o', 'markersize', 8);
end
