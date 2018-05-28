function SAC(DF, seq, plotarg, AW);
% SAC - plot shuffled autocorrelogram
%   syntax: SAC(ExpName, seq);
%   Quick & dirty implementation, works only for 
%   NRHO datasets contaning only two sequences (rho = +1 and -1).
%
%   Examples:
%     sac('M0314', '5-3') opens new figure
%     sac('M0314', '5-3', 2) adds plots to current figure 
%         using different colors
%
%   Note
%   make sure to set datadir correctly, e.g., at kiwi 
%   type: datadir B:\SGSRwork\ExpData\philip

if nargin<3, plotarg = nan; end;
if nargin<4, AW = []; end% analysis window;

DS = dataset(DF, seq);
if isempty(AW)
end

[SPT, Dur] = AnWin(DS,AW); % extract spikes while applying analysis window, if any
[H1 BC N] = sptcorr(SPT(1,:), 'nodiag', 15, 0.05, Dur, 'DriesNorm'); 
[H2 BC N] = sptcorr(SPT(2,:), 'nodiag', 15, 0.05, Dur, 'DriesNorm'); 
[Hmin BC N] = sptcorr(SPT(1,:), SPT(2,:), 15, 0.05, Dur, 'DriesNorm'); 

Hplus = (H1+H2)/2;

if isnan(plotarg), 
   figure; 
   colf = 0;
else
   colf = 2*(plotarg-1);
end

xplot(BC, Hplus, ploco(1+colf));
xplot(BC, Hmin, ploco(2+colf));

if isnan(plotarg), 
   title(DS.title);
else
   Tit = get(get(gca, 'title'), 'string');
   title([Tit ' ' DS.title]);
end
xlabel('Delay (ms)');
ylabel('Normalized SAC and XAC');
