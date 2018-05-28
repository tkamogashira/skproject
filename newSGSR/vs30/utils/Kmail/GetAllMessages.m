function argout = GetAllMessages()
% GetAllMessages - get all Kmail messages sent to this computer
%   Msgs      = GetAllMessages()
%     Returns a struct array with all messages directed at this computer.
%
%     The structs contains:
%
%        - msg      : message
%        - date     : datestring of the message
%        - sender   : computer name of sender
%        - port     : port at which the message was received
%
%     This command does not include broadcasts.
%
%     See also: Kmail, SendMessage, GetBroadcasts, GetMessages, CheckMessages

% Check KMail Status
if isequal(0, KMailStatus), error 'Network error!'; end

% The mailbox for this computer
thisMailbox = strrep(CompuName, '-', '_');

%look for messages
D = dir([KMailServer thisMailbox '\*.lmsg']);

%collect messages in array of structs
argout = [];
for i = 1:size(D, 1),
    tic;
    fid = fopen([KMailServer thisMailbox '\' D(i).name],'r');
    while (fid == -1) & (toc < 10),
        pause(0.5);
        fid = fopen([KMailServer thisMailbox '\' D(i).name],'r');
    end
    if toc > 10, error('File reading time-out'); end
    
    F = fread(fid);
    msg = char(F');
    date = D(i).date;
    S = words2cell(D(i).name, '-');
    sender = S{1};
    port = num2str(S{2});
    ArgOutEntry = CollectInStruct(msg, date, sender, port);
    argout = [argout ArgOutEntry];
    fclose(fid);

    %After reading, delete message
    delete([KMailServer thisMailbox '\' D(i).name]);
end