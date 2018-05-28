function argout = GetMessages(sCompuName, nPort)
% GetMessages - get Kmail message from specified computer and port
%   Msgs  = GetMessages(sCompuName, Port)
%     Get messages from specified computer and port
%     Messages are returned in an array of structs containing:
%
%        - sCompuName : sender of the expected message; could be an alias
%        - date       : datestring of the message
%
%     This command does not include broadcasts.
%
%     See also: Kmail, SendMessage, GetBroadcasts, GetAllMessages, CheckMessages

%check params
if ~isequal(2, nargin), error ('Required arguments: sender and port'); end

if ~ischar(sCompuName), error('Computer name must be a string'); end
if ~isnumeric(nPort), error('Computer name must be astring'); end
if ~isequal(0, mod(nPort, 1)), error('Port must be a strictly positive integer'); end
if nPort <= 0, error('Port must be a strictly positive integer'); end

% Check KMail Status
if isequal(0, KMailStatus), error 'Network error!'; end

% This computer's mailbox
thisMailbox = strrep(CompuName, '-', '_');

%lookup sCompuName (could be an alias)
sCompuName = GetKMailCompName(sCompuName);

%look for messages
D = dir([KMailServer thisMailbox '\' lower(sCompuName) '-' num2str(nPort) '-*.lmsg']);

%collect messages in array of structs
argout = [];
for i = 1:size(D, 1)
    tic;
    fid = fopen([KMailServer thisMailbox '\' D(i).name],'r');
    while (fid == -1) & (toc < 10)
        pause(0.5);
        fid = fopen([KMailServer thisMailbox '\' D(i).name],'r');
    end
    if toc > 10
        error('File reading time-out'); 
    end
    
    F = fread(fid);
    msg = char(F');
    date = D(i).date;
    ArgOutEntry = CollectInStruct(msg, date);
    argout = [argout ArgOutEntry];
    fclose(fid);

    %After reading, delete message
    delete([KMailServer thisMailbox '\' D(i).name]);
end