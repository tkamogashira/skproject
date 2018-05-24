function V = Spike_waveform(T, t, A, W, K, AN);
%   Spike_waveform - artificial action potential waveform
%   W = Spike_waveform(T, t, A, W, K) returns the waveform W.
%   Inputs
%      T: time axis in ms
%      t: peak time
%      A: amplitude
%      W: Width in ms
%      K: skewness(es)
%      N : linear Noise level.

[t, A, W, K] = sameSize(t, A, W, K);
if nargin<6,
    AN = 0;
end

V = 0;
N = numel(t);
for ii=1:N,
    tt = (T-t(ii));
    i1 = find(tt<0);
    i2 = find(tt>=0);
    w1 = exp(-(tt*K(ii)/W(ii)).^2);
    w2 = exp(-(tt/W(ii)).^2);
    w(i1) = w1(i1);
    w(i2) = w2(i2);
    V = V+A(ii)*w;
end

Noise = randn(size(V));
Nc = round(0.4*min(W)/diff(T(1:2)));
Noise = smoothen(Noise, Nc);
V = V + AN*Noise;
