function SS1mode(din, mcode);

% function SS1mode(din, mcode); - TDT XBDRV SS1mode
% default din is 1
% MCODE: 0: quad   2-to-1 / 1-to-2
%        1: dual   4-to-1 / 1-to-4
%        2: single 8-to-1 / 1-to-8
% default mcode is 0

if nargin<1, din=1; end;
if nargin<2, mcode=0; end;
s232('SS1mode', din, mcode);

