function [OK, Nrep, Interval, Order] = presentationCheck;

% reads & checks presentation part of most stimmenus 

global StimMenuStatus 
hh = StimMenuStatus.handles;

OK = 0;

Nrep = round(UIdoubleFromStr(hh.repsEdit,1));
Interval = UIdoubleFromStr(hh.IntervalEdit,1);
if isfield(hh, 'OrderButton'),
   Order = UIintFromToggle(hh.OrderButton)-1; % 0|1|2 = reverse|forward|random
else, Order = 1; % forward by convention
end

% any non-numerical input?
if ~checkNanAndInf([Nrep, Interval]), return; end;

mess = '';
if Nrep<1, mess = 'number of reps must be positive integer';
elseif Interval<0, mess = 'interval must be positive';
end

if UIerror(mess), return; end


OK = 1;