function ET1blocks(din, numblocks);

% function ET1blocks(din);
% TDT ET1blocks. default din=1; numblocks=0;
% enables/disables block counting of ET1

if nargin<1, din=1; end;

rep=s232('ET1blocks', din, numblocks);

