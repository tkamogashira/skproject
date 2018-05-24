function P=dB2P(dB);
% dB2P - convert dB to power ratio
%   DB2P(X) is the power ratio that corresponds to X dB, which is 10.^(X/10).

P = 10.^(0.1*dB);

