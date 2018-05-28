function argout = GetMessage(sCompuName, nPort)
% GetMessage - get one message from specified computer and port
%   Msg  = GetMessage(sCompuName, Port)
%     Get the oldest message from specified computer and port
%     The message is returned in a struct containing:
%
%        - message    : the message
%        - date       : datestring of the message
%
%     If no messages are pending, an empty array is returned.
%
%     This command does not include broadcasts.
%
%     See also: Kmail, SendMessage, GetBroadcasts, GetAllMessages, CheckMessages

%check params

if ~isequal(2, nargin)
    error ('Required arguments: sender and port');
end

if ~ischar(sCompuName)
    error('Computer name must be a string');
end
if ~isnumeric(nPort)
    error('Computer name must be a string');
end
if ~isequal(0, mod(nPort, 1)) | nPort <= 0
    error('Port must be a strictly positive integer');
end

% Check KMail Status
if isequal(0, KMailStatus)
    error 'Network error!';
end

% This computer's mailbox
thisMailbox = strrep(CompuName, '-', '_');

%lookup sCompuName (could be an alias)
sCompuName = GetKMailCompName(sCompuName);

%look for messages
D = dir([KMailServer thisMailbox '\' lower(sCompuName) '-' num2str(nPort) '-*.lmsg']);

%collect messages in array of structs
argout = [];

if ~isempty(D)
    D = structsort(D, 'date');
    tic;
    fid = fopen([KMailServer thisMailbox '\' D(1).name],'r');
    while (fid == -1) & (toc < 10)
        pause(1);
        fid = fopen([KMailServer thisMailbox '\' D(1).name],'r');
    end
    if toc > 1
        error('File reading time-out');
    end

    F = fread(fid);
    msg = char(F');
    date = D(1).date;
    ArgOutEntry = CollectInStruct(msg, date);
    argout = [argout ArgOutEntry];
    fclose(fid);

    %After reading, delete message
    delete([KMailServer thisMailbox '\' D(1).name]);
end