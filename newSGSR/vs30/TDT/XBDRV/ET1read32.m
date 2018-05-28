function tbuf=ET1read32(din);

% function tbuf=ET1read32(din);
% TDT ET1read32. default din=1

if nargin<1, din=1; end;

tbuf=s232('ET1read32', din);

