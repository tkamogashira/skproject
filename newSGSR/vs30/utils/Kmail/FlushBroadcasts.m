function FlushBroadcasts()
% FlushBroadcasts - delete pending Kmail broadcasts
%   FlushBroadcasts
%     Delete all broadcasts
%
%     See also: Kmail, BroadcastMessage, GetBroadCasts

% Check KMail Status
if isequal(0, KMailStatus), error 'Network error!'; end

%delete dir
eval(['!rmdir ' KMailServer 'broadcast' ' /s /q']);

%recreate dir
[status, message] = mkdir(KMailServer, 'broadcast');
if isequal(status, 0), error message; end