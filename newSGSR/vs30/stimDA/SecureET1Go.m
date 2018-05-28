function [y, mess]=SecureET1Go;
% ET1go with security checks:
% - stop ET1 first
% - check status to see if ET1 is indeed stopped
% - repeat stop if stop was not processed
% - get # events using ET1report
% - issue a go and check if this increases
%   the # events reported
% - if not, issue another go, etc
% - check status to see if go is properly processed

y = 1;
Dev = 1;
mess = '';
% stop the ET1 and make sure it is stopped
while 1,
   s232('ET1stop',Dev);
   ET1status = s232('ET1active', Dev); % should return zero if stopped
   if ~ET1status, break; 
   else, mess = '#ET1stop failed ';
   end;
end
% get # events
N = s232('ET1report',Dev)+1; % target number of events
NN = -inf;
while NN<N,
   s232('ET1go',Dev); % this should increase the # events by 1 
   NN = s232('ET1report',Dev); % check # events
   if NN<N, mess = [mess '#ET1go failed']; end;
end
ET1status = s232('ET1active', Dev); % should return one if gone
if ~ET1status, error('malfunctioningET1 - ET1go is ignored'); end;

y = isempty(mess) & isequal(N,NN);