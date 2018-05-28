function ET1compare(din);

% function 1ET1compare(din);
% TDT ET1compare. default din=1
% Note: comparison mode not supported by TDT

if nargin<1, din=1; end;

rep=s232('ET1compare', din);

