function rep=ET1report(din);

% function rep=ET1report(din);
% TDT ET1report. default din=1

if nargin<1, din=1; end;

rep=s232('ET1report', din);

