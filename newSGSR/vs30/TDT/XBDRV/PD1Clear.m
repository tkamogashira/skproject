function PD1Clear(din);

% function PD1Clear(din);
% XBDRV PD1clear; default din is 1

if nargin<1, din=1; end;

s232('PD1clear', din);


