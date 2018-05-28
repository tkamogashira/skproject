function  Piece = applegroupdelay(AA, Show, Cdelay);
% APPLEGROUPDELAY - compute group delay from apple data
%   usage: Piece = applegroupdelay(AA, Show, xdelay), 
%   where AA is apple output. If Show then fits are plotted,
%   with phase tilted according to Cdelay (default = apple setting)
%
%   See also GRAPEDELAY

if nargin<2, Show=0; end
if nargin<3, Cdelay=nan; end

MaxPhaseDev = 0.1; % maximum deviation between stylized phase and real phase to be tolerated

Nzwuis = length(AA);
Piece = [];
for izwuis = 1:Nzwuis,
   aa = AA(izwuis);
   if ~isstruct(aa), continue; end
   if ~isfield(aa, 'CF'),
      try, warning(['Missing CF, iSeq = ' num2str(aa.iSeq)]);
      catch, aa
      end
      continue;
   end
   theCF = aa.CF;
   theiCell = aa.iCell;
   % partition in neighboring groups (pieces) of carrier freqs
   [FR, II, len, NN]=groupFcar(aa.Fcar, -aa.RScar, -0.001); % minus sign because of convention in groupCar fnc
   % FR{:}, II{:}, len, NN   
   for ipiece=1:NN,
      index = II{ipiece};
      Ncomp = len(ipiece);
      Fcar = FR{ipiece};
      SPL = aa.SPL(index);
      weights = 1./aa.RScar(index); % Rayleigh significance determines weight in polyfit
      Phase = aa.TRFphase(index);
      % weighted polyfit
      effweights = [0.25 ones(1,Ncomp-2) 0.025].*weights; % suppress weight of endpoints
      Coef = localWpolyfit(Fcar, Phase, effweights);
      DCoef = localWpolydiff(Coef); % phase -> group delay
      DCoef(end) = DCoef(end); 
      GroupDelay = -localWpolyval(DCoef, Fcar)+aa.CDELAY; % undo compensating delay of apple
      Weight = sum(weights)+0*weights;
      CF = theCF*ones(size(Fcar));
      iCell = theiCell*ones(size(Fcar));
      PolPhase = localWpolyval(Coef, Fcar); % stylized phase from poly
      goodEnough = (MaxPhaseDev>std(PolPhase-Phase));
      ijump = find(abs(PolPhase-Phase)>0.71*MaxPhaseDev); % indivual mismatches
      if Show, % show the phase and the fits in a plot
         if isnan(Cdelay), Cdelay = aa.CDELAY; end
         xdelay = Cdelay-aa.CDELAY;
         PH = Phase(:)+Fcar(:)*xdelay;
         subplot(2,1,1); % phase
         xplot(Fcar, PH, [ploma(ipiece) ploco(izwuis)]);
         xplot(Fcar(ijump), PH(ijump), 'o', 'markerfacecol', ploco(izwuis));
         plotfreq = linspace(min(Fcar), max(Fcar), 20);
         plotphase = interp1(Fcar, PolPhase, plotfreq);
         PH = plotphase(:)+plotfreq(:)*xdelay;
         if goodEnough, lineStyle = '-'; else, lineStyle = ':'; end; 
         xplot(plotfreq, PH, [lineStyle ploco(izwuis)]);
         PH = PolPhase(:)+Fcar(:)*xdelay;
         % xplot(Fcar, PH, ['*' ploco(izwuis)]);
         subplot(2,1,2); % group delay
         xplot(Fcar, GroupDelay, [lineStyle ploco(izwuis)]);
         xplot(Fcar, GroupDelay, [ploma(ipiece) ploco(izwuis)]);
         xplot(Fcar(ijump), GroupDelay(ijump), 'o', 'markerfacecol', ploco(izwuis));
      end
      % return the outcome
      if goodEnough,
         inonjump = setdiff(1:Ncomp, ijump);
         [CF, Fcar, SPL, Weight, GroupDelay, iCell] = ...
            localNonJumpin(inonjump, CF, Fcar, SPL, Weight, GroupDelay, iCell);
         Piece = [Piece CollectInStruct(CF, Fcar, SPL, Weight, GroupDelay, iCell)];
      end
   end
end
if Show,
   subplot(2,1,1); % phase
   ylabel('Phase (cycle)');
   title(['cell ' num2str(AA(1).iCell) '  ---  cdelay=' num2sstr(Cdelay) ' ms']);
   YL = ylim;
   % mark CF on the X-axis
   xplot(AA(1).CF, YL(1), 'x', 'markersize', 8); xplot(AA(1).CF, YL(1), 'o', 'markersize', 8);
   subplot(2,1,2); % group delay
   xlabel('Fcar (kHz)'); 
   ylabel('Group delay (ms)');
   YL = ylim;
   xplot(AA(1).CF, YL(1), 'x', 'markersize', 8); xplot(AA(1).CF, YL(1), 'o', 'markersize', 8);
end

%==================================
function Coef = localWpolyfit(Fcar, Phase, effweights);
Ncomp = length(Fcar);
% order of fitting polynomial
%f3;
for ii=1:max(1,Ncomp-4), % grab subrange of components and fit them
   irange = ii:min(Ncomp,ii+4);
   % xplot(Fcar(irange), Phase(irange), ['o' ploco(ii)])
   % 2nd-order polynomial, but temper x^2 term
   pol_1 = wpolyfit(Fcar(irange), Phase(irange), effweights(irange),1);
   pol_2 = wpolyfit(Fcar(irange), Phase(irange), effweights(irange),2);
   Coef(ii,:) = ([0 pol_1]+pol_2)/2;
   % RPhase = polyval(Coef(ii,:), Fcar(irange));
   % xplot(Fcar(irange), RPhase, ['*-' ploco(ii)])
end
% pause

function  DCoef = localWpolydiff(Coef); 
for ii=1:size(Coef,1),
   DCoef(ii,:) = polydiff(Coef(ii,:)); 
end

function Y = localWpolyval(Coef, X);
Ncomp = length(X);
% order of fitting polynomial
NN = size(Coef,1);
y = zeros(NN,Ncomp)+nan;
% dsiz(Coef,X,y)
for ii=1:NN, % grab subrange of components and fit them
   irange = ii:min(Ncomp,ii+4);
   YY = polyval(Coef(ii,:), X(irange)); YY = YY(:).';
   y(ii,irange) =YY;
end
for icomp=1:Ncomp,
   Y(icomp) = mean(denan(y(:,icomp)));
end


         
function  varargout = localNonJumpin(inonjump, varargin);
for ivar=1:nargin-1,
   varargout{ivar} = varargin{ivar}(inonjump);
end





