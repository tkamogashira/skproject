function cfs = BNcfs(FN,iSeq);
% BNcfs - return carrier freqs of  BN datasequence
[spt, pp, isub] = SGSRgetSpikeTimes(FN, iSeq, 'BN');
BN = prepareBNstim(pp);
cfs = (BN.DDfreq * BN.Kfreq);