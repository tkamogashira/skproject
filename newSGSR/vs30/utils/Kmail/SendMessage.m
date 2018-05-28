function MsgID = SendMessage (sCompuname, nPort, sMsg)
% SendMessage - send Kmail message to specified computer 
%   MsgID     = SendMessage (sCompuName, Port, Msg)
%     Send Msg to sCompuName at Port (positive integer). Aliases can be
%     used.
%     The returned MsgID is a struct containing:
%
%       - SrcComp   : Sending computer
%       - DestComp  : Receiving computer
%       - Port      : Receiving port (positive integer)
%       - Msg       : The message itself
%       - Rnd       : A random number for uniqueness
%
%     It can be used to confirm retrieval of the message.
%
%     MsgID = -1 if something went wrong.
% 
%     See also: Kmail, GetMessages, MessagePending, BroadcastMessage

% This computer's mailbox
thisMailbox = strrep(CompuName, '-', '_');

%lookup sCompuName (could be an alias)
sCompuname = GetKMailCompName(sCompuname);

% Generate MsgID
SrcComp = thisMailbox;
DestComp = sCompuname;
Port = num2str(nPort);
c = clock;
sRnd = [num2str(c(1)) '-' num2str(c(2)) '-' num2str(c(3)) '-' num2str(c(4)) '-' num2str(c(5)) '-' num2str(floor(c(6))) '-' num2str(floor(rand * 100000000))];
MsgID = CollectInStruct(SrcComp, DestComp, Port, sRnd, sMsg);

% Send file to box; leave error handling to programmer
sFileName = [KMailServer DestComp '\' thisMailbox '-' num2str(nPort) '-' sRnd];
fid = fopen([ sFileName '.tmp'],'w');
fprintf(fid, '%s', sMsg);
fclose(fid);

eval(['!ren ' sFileName '.tmp ' thisMailbox '-' num2str(nPort) '-' sRnd '.lmsg']);
if ~exist([sFileName '.lmsg'], 'file')
    MsgID = -1;
end