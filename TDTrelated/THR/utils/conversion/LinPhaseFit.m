function [Ph0, Tau, ph, Dev]=LinPhaseFit(freq, ph, tauRange, W);
% LinPhaseFit - linear fit of phase data
%    [Ph0, Tau] = LinPhaseFit(Freq, Ph, [TauMin TauMax]) fits a straight line 
%         Ph = Ph0-Tau*Freq
%    to phase data Ph [cycles] corresponding to frequencies Freq.
%    The fit minimizes the "sum of squares on a circle" (see PhaseResidue)
%    and Tau is constrained between TauMin and TauMax [ms].
%
%    [Ph0, Tau] = LinPhaseFit(Freq, Ph, [TauMin TauMax], W) uses weight
%    factors W for the fit. That is, W(k) is used as a weight factor for
%    the squared difference between ph(k) and its fit (model) value.
%
%    [Ph0, Tau, Ph, Dev] = LinPhaseFit(Freq, Ph, [TauMin TauMax]) also 
%    returns the phase data Ph in a version that is unwrapped with respect 
%    to the fitted line, and the deviation between the data and the fit,
%    i.e., Dev = ph-(Ph0-Tau*Freq). Dev may be used to identify outliers.
%
%    See also PhaseResidue, unwrap, cunwrap, DelayPhase.

% P0 = [0; mean(tauRange)]; % starting values of Ph0 and Tau. (see help text)
% Res = @(P)(PhaseResidue(ph, polyval(P,freq,2))); % function to be minimized
% P = fmincon(Res,P0,[],[],[],[],[0; min(tauRange)], [1; max(tauRange)]);

if nargin<4, W=1; end % default: no weighting

% make phi x tau grid
N=20;
tauRange = -tauRange; % delay is minus slope
tau = linspace(min(tauRange),max(tauRange),N);
ph0 = linspace(0,1,N);
for ii=1:5,
    [bestPh0, bestTau] = local_fit(freq,ph, ph0,tau,W);
    [ph0,tau]=local_finer(ph0,tau,bestPh0,bestTau,tauRange);
end
% unwrap ph data w respect to fit
P = [bestTau, bestPh0];
Mph = polyval(P,freq); % modelled phase 
Mph = Mph-round(mean(Mph));
dph = mod(ph-Mph+0.5,1)-0.5; % phase difference projected into [-0.5,0.5] range
ph = Mph+dph;
P = wpolyfit(freq,ph,0*freq+W,1); % impose same size on Weight vector
[Ph0, Tau] = deal(P(2), -P(1));
Dev = ph-polyval(P,freq);

%======================================================
function [bestph0, bestTau] = local_fit(freq,ph, ph0,tau,W);
% brute force minimizer
BestRes = inf;
for itau=1:numel(tau), % tau loop
    for iph0=1:numel(ph0), % iph0 loop
        Mph = ph0(iph0)+tau(itau)*freq;
        Res = PhaseResidue(ph, Mph,W);
        if Res<BestRes,
            [bestph0, bestTau] = deal(ph0(iph0), tau(itau));
            BestRes=Res;
        end
    end
end

function [ph0,tau]=local_finer(ph0,tau,bestPh0,bestTau,tauRange);
N = numel(ph0);
dphi = max(diff(ph0));
ph0 = bestPh0+linspace(-dphi, dphi, N);
M = numel(tau);
dtau = max(diff(tau));
minTau = max(min(tauRange), bestTau-dtau);
maxTau = min(max(tauRange), bestTau+dtau);
tau = linspace(minTau, maxTau, M);


