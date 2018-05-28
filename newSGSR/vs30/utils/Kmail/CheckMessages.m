function argout = CheckMessages(sender, port)
% CheckMessages - check all Kmail message sent to this computer
%   Msgs      = CheckMessages()
%     Returns a struct array information about messages directed to this computer
%
%     The structs contains:
%
%        - date     : datestring of the message
%        - sender   : computer name of sender
%        - port     : port to which this message was sent
%
%     This command does not include broadcasts.
%     This command leaves all messages on the server.
%
%     See also: Kmail, SendMessage, GetBroadcasts, GetMessages, GetAllMessages

% Check params
if nargin < 1
    sender = '*';
end

if nargin < 2
    port = '*';
else
    port = num2str(port);
end

if nargin > 2
    error('This command takes at most two arguments!');
end

% Check KMail Status
if isequal(0, KMailStatus)
    error 'Network error!';
end

% The mailbox for this computer
thisMailbox = strrep(CompuName, '-', '_');

%look for messages
D = dir([KMailServer thisMailbox '\' sender '-' port '-*.lmsg']);

%collect messages in array of structs
if ~isempty(D)
    nMsg = size(D, 1);
    for i = 1:nMsg
        date = D(i).date;
        S = Words2cell(D(i).name, '-');
        sender = S{1};
        port = str2double(S{2});
        ArgOutEntry = CollectInStruct(date, sender, port);
        argout(i) = ArgOutEntry;
    end
else
    argout = [];
end