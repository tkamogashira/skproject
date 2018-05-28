function argout = GetBroadcasts()
% GetBroadcasts - get all Kmail broadcasts
%   Brc   = GetBroadcasts()
%     Get broadcasted messages that are still alive.
%     Messages are returned in an array of structs containing:
%
%        - msg      : message
%        - date     : datestring of the message
%        - sender   : computername of the sender
%        - lifetime : in seconds
%
%     See also: Kmail, BroadcastMessage, GetMessages

%check params
if ~isequal(0, nargin), error ('No arguments allowed!!'); end

% Check KMail Status
if isequal(0, KMailStatus), error 'Network error!'; end

%look for messages
D = dir([KMailServer 'broadcast\*.lbrc']);

%collect messages in array of structs
argout = [];
for i = 1:size(D, 1),
    S = words2cell(D(i).name, '-');
    Lifetime = str2num(S{2});
    
    if (now - datenum(D(i).date)) * 24 * 3600 < Lifetime,    
        tic;
        fid = fopen([KMailServer 'broadcast\' D(i).name],'r');
        while (fid == -1) & (toc < 10),
            pause(0.5);
            fid = fopen([KMailServer 'broadcast\' D(i).name],'r');
        end
        if toc > 10, error('File reading time-out'); end
        
        F = fread(fid);
        msg = char(F');
        date = D(i).date;
        sender = S{1};
        ArgOutEntry = CollectInStruct(msg, date, sender, Lifetime);
        argout = [argout ArgOutEntry];
        
        fclose(fid);
    end
end