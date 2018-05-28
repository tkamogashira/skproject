function g=getAPlockstatus

% function g=getAPlockstatus
% tests the state of the APlock
% returns 0 if the lock is not available
% returns 1 if the lock is available

g=s232('getAPlockstatus');

