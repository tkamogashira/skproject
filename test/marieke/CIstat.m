% CIstat -  SAC peak significance
% script for the semi illiterate

% The code in this script is dataset- independent
% ds and other params are selected as in CIstatSample

% ---extract spike times---
SPT = AnWin(ds, AnaWindow); % retrieve spike times, restricted to analysis window
SPT = SPT(isub,:); % restrict to requested subsequence; all reps

% have a look at the sac (not needed for CI stats, but for getting the normalization)
Dur = diff(AnaWindow); % duration in ms - needed for normalization
[Sac, tau, Norm] = sptcorr(SPT, 'nodiag', 3, binwidth, Dur, 'DriesNorm');
figure; % open new fig
subplot(3,1,1);
plot(tau, Sac);
xlabel('tau (ms)');
ylabel('SAC');

% confidence level of peak sign, based on 100 Monte Carlo trials
% p is the confidence level. See help SACPeakSign.
[p, NcoScrambled, Ppdf, Pcdf, Nco] = SACPeakSign(SPT, binwidth, Ntrial);
% NcoScrambled is the X-axis of the Nco distrib (see help SACpeakSign)
% By applying Dries' normalization, it is turned into the X axis of the CI distribution
CIscrambled = NcoScrambled/Norm.DriesNorm;
subplot(3,1,2);
plot(CIscrambled,Pcdf);
ylim([-0.05 1.05]); % save visibility of horizontal asymptotes
xlabel('CI');
ylabel('cumulative CI distr');

% text box with summary
icenter = ceil(length(Sac)/2); % index of central Sac peak
CI = Sac(icenter);
subplot(3,1,3); set(gca,'xtick',[], 'ytick',[], 'box', 'on');
text(0.1, 0.8, [ds.title ' subseq ' num2str(isub) ' (' ds.x.ShortName ' = ' num2str(ds.xval(isub)) ' ' ds.xunit ')']);
text(0.1, 0.6, ['CI = ' num2str(CI)])
text(0.1, 0.4, ['Confidence level = ' num2str(100*p) ' % (N=' num2str(Ntrial) ')']);









