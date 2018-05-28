function N=NsamPlay(W);
% Waveform/NsamPlay - played sample counts of waveform array
%   N=Nsam(W) is a matrix of played sample counts of the individual elements of W,
%   ie, N(n,m) = W(n,m).NsamPlay. The sample counts DO include reps.
%
%   See also Waveform/NsamStore, Waveform/TestNsam.

N = [W.NsamPlay];
N = reshape(N,size(W));

