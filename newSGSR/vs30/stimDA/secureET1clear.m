function [y, mess]=secureET1clear(Dev);
% secureET1clear - ET1clear with security check
if nargin<1, Dev=1; end;

y = 1;
mess = '';
while 1,
   % alternating calls to ET1stop and ET1clear to make
   % sure there is no order effect
   s232('ET1stop',Dev);
   s232('ET1clear',Dev);
   s232('ET1stop',Dev);
   s232('ET1clear',Dev);
   % check if status is inactive
   ET1status = s232('ET1active', Dev); % should return 0
   if ET1status, mess = 'ET1 still active'; end;
   % check if ET1report gives zero events
   Nevent = s232('ET1report',Dev);
   if Nevent, mess = [mess 'ET1 still loaded']; end;
   if ~(ET1status | Nevent), break; end;
end;
y = isempty(mess);
