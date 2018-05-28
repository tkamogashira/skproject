function act=ET1active(din);

% function act=ET1active(din);
% TDT ET1active. default din=1
% returns 1 if ET1 is recording events, 0 otherwise

if nargin<1, din=1; end;

act=s232('ET1active', din);

