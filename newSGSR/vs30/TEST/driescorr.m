function [d, tau] = driescorr(DF, iseq, isub, binwidth, maxLag);
% driescorr - grand correlation among reps
%  syntax:
%     [ac, tau] = driescorr(DF, iseq, isub, binwidth, maxLag);
%  Inputs:
%    DF is datafile
%    iseq is seq number
%    isub is subseq number
%    binwidth in us
%    maxLag in ms
%  Outputs:
%    ac is normalized, "off-diagonal", autocorrelation function
%    tau is delay axis in ms
%
%  Use plot(tau,ac) to plot the autocorrelation function.

if nargin<5,
   maxLag = 10; % ms max lag of correlation functions
end

% get relevant parameters from datafile
idf = idfget(DF,iseq);
Nrep = idf.stimcntrl.repcount;
% Nrep = 10, 'debug'
dur = idf.stimcntrl.interval;
try, dur = idf.indiv.stim{1}.duration; end
% get spike times from datafile
spk = spkextractSeq(DF, iseq);
spk = {spk.spikeTime{isub,:}}; % spike arrival times in cell array

% bin the spikes of each rep
Nbin = round(1e3*dur/binwidth);
binCenters = 1e-3*binwidth*(-0.5+(1:Nbin+1)); % bincenters in ms
H = 0; % initialize grand histogram
diag_h = 0; % sum of indiv autocorr fnc's
NmaxLag = round(1e3*maxLag/binwidth);
for ii=1:Nrep,
   h = hist(spk{ii}, binCenters);
   h(end) = []; % remove garbage bin
   H = H + h;
   % compute autocorr function of current h and add it to sum
   ah = xcorr(h,h,NmaxLag);
   diag_h = diag_h +  ah;
end
% grand autocorr function
AH = xcorr(H,H,NmaxLag);
% normalization coeff
i0 = NmaxLag+1; % "middle index" coreesponding to zero delay of autocorr fnc
C = (Nrep-1)/Nrep*AH(i0); % see notes on normalization; AH(i0)=|H|^2
d = (AH-diag_h)/C;
tau = 1e-3*binwidth*(-NmaxLag:NmaxLag); % in ms


