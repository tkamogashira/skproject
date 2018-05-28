function SS1gainon(din);

% function SS1gainon(din); - TDT XBDRV SS1gainon
% default din is 1

if nargin<1, din=1; end;
s232('SS1gainon', din);

