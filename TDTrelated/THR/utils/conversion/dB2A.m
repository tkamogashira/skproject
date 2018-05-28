function A=dB2A(dB);
% dB2A - convert dB to amplitude ratio
%    dB2A(X) is the amplitude ratio corresponding to the dB value X, which is 10.^(X/20)

A = 10.^(0.05*dB);
