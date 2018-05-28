function status=DAstatus(Din);

% function status=DAstatus(Din);
% XBUS DAStatus, Din = device number
% returns status of DA converter:
%  0  IDLE
%  1  ARM
%  2  ACTIVE
% (these are not predefined constants in Matlab)

if nargin<1, Din=1; end;
status=s232('DAstatus', Din);
