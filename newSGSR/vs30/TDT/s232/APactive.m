function Act=APactive

% function Act=APactive
% Checks status of the AP2
% returns 0 if busy; 1 if ready; 99 if error flag is pending
% see TDT's SISU guide.

Act=s232('APactive');

