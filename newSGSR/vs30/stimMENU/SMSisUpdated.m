function isup=SMSisUpdated(SMS, prevSMS);
% compares SMS and prevSMS and returns false (=0) ...
% ... if they are essentially equal, i.e., if only the time...
% ... stamp differs

isup =1;
if isempty(prevSMS), return; end; % no previous SMS stored
% change time stamp of prevSMS 
% Note: PDP-11 compatible versions have date stored in different
% place than SGSR-style  stim menu paramters
if ~isPDP11compatible(SMS) & ~isPDP11compatible(prevSMS),
   prevSMS.GlobalInfo.today = SMS.GlobalInfo.today;
elseif isPDP11compatible(SMS) & isPDP11compatible(prevSMS),
   prevSMS.GlobalInfo.cmenu.stimcntrl.today = SMS.GlobalInfo.cmenu.stimcntrl.today;
end
% now the two should really be equal
isup = ~isequal(SMS, prevSMS);
