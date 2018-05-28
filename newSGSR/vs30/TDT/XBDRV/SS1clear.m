function SS1clear(din);

% function SS1clear(din) - TDT XBDRV SSclear
% default din is 1

if nargin<1, din=1; end;
s232('SS1clear', din);


