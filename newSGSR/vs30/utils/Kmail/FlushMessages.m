function FlushMessages(port)
% FlushMessages - delete pending Kmail messages sent to this computer
%   FlushMessages()
%     Delete all messages sent to this computer
%  
%   FlushMessages(port)
%     Delete all messages sent to this computer at the given port number
%
%     See also: Kmail, SendMessage, GetMessages, GetAllMessages

% Check params
if isequal(0, nargin)
    port = '?';
elseif isequal(1, nargin)
    port = num2str(port);
else
    error('This command takes at most one argument!');
end

% Check KMail Status
if isequal(0, KMailStatus), error 'Network error!'; end

% The mailbox for this computer
thisMailbox = strrep(CompuName, '-', '_');

% all files in the directory
D = dir([KMailServer thisMailbox '\' thisMailbox '-' port '*.lmsg']);
for i = 1:length(D)
    delete([KMailServer thisMailbox '\' D(i).name]);
end


% %delete dir
% eval(['!rmdir ' KMailServer thisMailbox ' /s /q']);
% 
% %recreate dir
% [status, message] = mkdir(KMailServer, thisMailbox);
% if isequal(status, 0), error message; end