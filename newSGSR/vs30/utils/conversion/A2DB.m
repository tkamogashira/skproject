function dB=A2dB(A);

% function dB=A2dB(A); - converts Amplitude ratio to dB

% avoid 'log of zero' warnings by adding a tiny constant
% to A; in this way A2dB(0)=-400 dB;
dB=20.*log10(A+1e-20); 
