function MsgID = BroadcastMessage (sMsg, Lifetime)
% BroadcastMessage - broadcast message over Kmail
%   MsgID     = BroadcastMessage (Msg, Lifetime)
%     Send message Msg to all computers
%     The returned MsgID is a struct containing:
%
%       - SrcComp   : Sending computer
%       - Msg       : The message itself
%       - Rnd       : A random number for uniqueness
%       - Lifetime  : How long does this message exist? Default 3600 s
%
%     MsgID = -1 if something went wrong.
% 
%     See also: Kmail, GetBroadcasts, SendMessage

% Check args

if nargin < 2, Lifetime = 3600; end

if ~isequal(1, nargin) & ~isequal(2, nargin), error('One or two arguments are required'); end
if ~isequal(1, size(sMsg, 1)), error('Message must be a string, not an array'); end
if ~ischar(sMsg), error('Message must be a string, not an array'); end

% Check KMail Status
if isequal(0, KMailStatus), error 'Network error!'; end

% The mailbox for this computer
thisMailbox = strrep(CompuName, '-', '_');

% Generate MsgID

c = clock;
sClock = num2str(c(1));
for i = 2:6
    sClock = [sClock '-' num2str(floor(c(i)))];
end
nRand = rand; nRand = nRand * 100000000; sRand = num2str(floor(nRand));

SrcComp = thisMailbox;
Rnd = [sClock '-' sRand];
Msg = sMsg;

MsgID = collectinstruct(SrcComp, Rnd, Msg, Lifetime);

% Send file to box; leave error handling to programmer

sFileName = [thisMailbox '-' num2str(Lifetime) '-' sClock '-' num2str(floor(nRand)) '.lbrc'];
fid = fopen([KMailServer 'broadcast\' sFileName],'w');
fprintf(fid, '%s', sMsg);
fclose(fid);

if ~exist([KMailServer 'broadcast\' sFileName]), MsgID = -1; end