function MsgPending = MessagePending(MsgID)
% MessagePending - check arrival of Kmail message 
% MsgPending   = MessagePending(MsgID)
%     Confirm wether message has been read. Return 1 or 0.
%     MsgID is obtained when sending the message.
%
%     See also: Kmail, SendMessage, GetMessages, GetAllMessages

%check params
if ~isequal(1, nargin), error('function needs 1 args'); end
if ~isstruct(MsgID), error('struct needed as argument'); end

% Check KMail Status
if isequal(0, KMailStatus), error 'Network error!'; end

% This computer's mailbox
thisMailbox = strrep(CompuName, '-', '_');

sFileName = [thisMailbox '-' num2str(MsgID.Port) '-' MsgID.sRnd '.lmsg'];
sFileName = [KMailServer MsgID.DestComp '\' sFileName];
if exist(sFileName), MsgPending = 1;
else MsgPending = 0;
end