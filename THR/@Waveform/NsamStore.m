function N=NsamStore(W);
% Waveform/NsamStore - stored sample counts of waveform array
%   N=Nsam(W) is a matrix of stored sample counts of the individual elements of W,
%   ie, N(n,m) = W(n,m).NsamStore. The sample counts do NOT include reps.
%
%   See also Waveform/NsamPlay.

N = [W.NsamPlay];
N = reshape(N,size(W));

