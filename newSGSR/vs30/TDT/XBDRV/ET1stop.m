function ET1stop(din);

% function ET1stop(din);
% TDT ET1stop. default din=1

if nargin<1, din=1; end;

s232('ET1stop', din);

