function tbuf=ET1read16(din);

% function tbuf=ET1read16(din);
% TDT ET1read16. default din=1

if nargin<1, din=1; end;

tbuf=s232('ET1read16', din);

