function [OK, polarity, ClickDur] = ClickParamCheck;

% reads & checks  click-parameter section a number of stimmenus

global StimMenuStatus
hh = StimMenuStatus.handles;

OK = 0;

% polarity: 1|2|3|4 = mono+|mono-|bi+|bi-
ipol = UIintFromToggle(hh.PolarityButton);
allpol = [1 -1 2 -2];
polarity =  allpol(ipol);

ClickDur = abs(UIdoubleFromStr(hh.ClickDurEdit, 2));

if isnan(ClickDur),
   UIerror('non-numerical values of numerical parameters');
   return;
end

if isinf(ClickDur),
   UIerror('too many values');
   return;
end

if any(ClickDur>10e3),
   mess = strvcat('Click duration exceeds','10000 us');
   UIerror(mess, [hh.ClickDurEdit]);
   return;
end

OK = 1;
