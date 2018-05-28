function SS1select(din, chan, inpn);

% function SS1select(din, chan, inpn); - TDT XBDRV SS1select
% see XBDRV manual (page 1903) for details
% no defaults; all three params must be passed

if nargin<3, error('all three input params must be specified'); end;
s232('SS1select', din, chan, inpn);




