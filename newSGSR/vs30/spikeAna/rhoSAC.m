function RHOSAC(DF, seq, maxiSub, binWidth, maxLag);
% RHOSAC - plot shuffled autocorrelograms of NRHO sequence
%   syntax: RHOSAC(ExpName, seq, binWidth, maxLag);
%   binWidth and maxLag in ms, defaulting to 0.05 and 5 ms, respectively.
%
%   Examples:
%     sac('A0241', '18-9')
%
%   Note
%   make sure to set datadir correctly, e.g., at kiwi type
%    datadir B:\SGSRwork\ExpData for analysis of ongoing experiment
%    datadir B:\SGSRwork\ExpData\dries for completed exp

if nargin <3, maxiSub = nan; end;
if nargin<4, binWidth = 0.05; end;
if nargin<5, maxLag = 5; end;

maxTol = 1e-8; % max deviation of two rho values to be counted equal
rhoJASA = [-1 0.5 0.87 0.97 0.992 0.997 1];
ploco = 'brgmkcbrgmkc';

DS = dataset(DF, seq);
if ~isequal(DS.varchan, DS.active),
   warning('Wrong D/A channel may be have been varied during data collection.');
end
SPT = AnWin(DS); 
Dur = DS.burstdur;
if isnan(maxiSub), maxiSub = DS.nrec; end

figure;
if atkiwi, set(gcf, 'position', [323   225   719   621]); end;
rho = DS.xval(1:maxiSub).';
% convert rho to phase-angle in stimulus space
phi = acos(rho);
% put mutual angle differences in matrix
dphi = diffMatrix(phi);
% convert these back to correlations
relrho = cos(dphi);
SZ = size(relrho); % needed for matrix <-> vector reshaping
relrho = maxTol*round(relrho/maxTol)
allRhos = unique(relrho(:)).'
Nrho = length(allRhos)
Ncorr = length(sptcorr([],[],maxLag, binWidth));

[dummy isort] = sort(relrho(:)); % find sorting order of relrho vector
[I, J] = ind2sub(SZ, isort);
LegStr = {}; Hmean = 0; Psac = []; rhoPlot = []; isac = 0; iplot = 0;
% find indices of rho that are closest to rhoJASA
iJASA = [];
for ii=1:length(rhoJASA), 
   [dum, iclosest] = min(abs(allRhos-rhoJASA(ii)));
   iJASA = [iJASA iclosest];
end
sacplotrho = allRhos(iJASA)

% compute all sacs and store them as rows in AllSacs
allSacs = zeros(Nrho,Ncorr);
Nmult = zeros(Nrho,1);
for icol = 1:maxiSub,
   for irow = 1:icol,
      rhoCurrent = relrho(icol, irow);
      irho = find(rhoCurrent==allRhos);
      if icol==irow,
         [H BC N] = sptcorr(SPT(icol,:), 'nodiag', maxLag, binWidth, Dur, 'DriesNorm'); 
      else,
         [H BC N] = sptcorr(SPT(icol,:), SPT(irow,:), maxLag, binWidth, Dur, 'DriesNorm'); 
      end
      % dsiz(H, BC, allSacs)
      allSacs(irho,:) = allSacs(irho,:) + H;
      Nmult(irho) = Nmult(irho)+1;
   end
end
% sum -> mean; plot
iplot = 0;
for irho=1:Nrho,
   allSacs(irho,:) = allSacs(irho,:)/Nmult(irho);
   rho = allRhos(irho);
   if ismember(rho, sacplotrho),
      iplot = iplot+1;
      subplot(1,2,1); 
      xplot(BC, allSacs(irho,:), ploco(iplot));
      LegStr = {LegStr{:} num2str(rho)};
      drawnow
   end
   [dum icenter] = min(abs(BC)); % index ~ zero lag
   Psac(irho) = allSacs(irho,icenter);
end

subplot(1,2,1); 
legend(LegStr{:},3);
xlabel('Delay (ms)');
ylabel('Normalized # coincidences.');

% rho vs lag-0 value
subplot(1,2,2); 
qq = sort(Nmult); penMult = qq(end-1);
heavy = pmask(Nmult>=penMult/2).';
plot(allRhos, Psac, 'o');
xplot(allRhos, Psac+heavy, '*');
xlim([-1 1]); ylim([0 inf]);
xlabel('\rho');
ylabel('Sac peak height');
grid on

Ptitle = [DS.title '  ' num2str(maxiSub) '/' num2str(DS.ncond) ' cond'  ];
title(Ptitle);
set(gcf, 'name', DS.seqid, 'numbertitle', 'off');

% enable line copying from fig to fig
LineCutandPaste init

% compute scaling re rho=1
Saxm1 = allSacs-1;
irho_1 = find(allRhos==1);
refScale = mean(Saxm1(irho_1,:).^2);
for irho=1:Nrho,
   Scale(irho) = mean(Saxm1(irho,:).*Saxm1(irho_1,:));
end
allRhos
Scale = Scale/refScale
xplot(allRhos, 1+Scale*(Psac(irho_1)-1), 'rx-');



