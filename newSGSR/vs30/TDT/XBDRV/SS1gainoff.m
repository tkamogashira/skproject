function SS1gainoff(din);

% function SS1gainoff(din); - TDT XBDRV SS1gainoff
% default din is 1

if nargin<1, din=1; end;
s232('SS1gainoff', din);

