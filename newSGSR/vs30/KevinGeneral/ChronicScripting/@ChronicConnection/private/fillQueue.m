function chronicConnection = fillQueue( chronicConnection )
%FILLQUEUE Summary of this function goes here
%   Detailed explanation goes here

% Msgs = CheckMessages();
%
% filteredMsgs = [];
% expectedSender = GetKMailCompName(chronicConnection.JavaAlias);
% for i = 1:length(Msgs)
%     if isequal(chronicConnection.rcvPort, Msgs(i).port) & ...
%             isequal(lower(expectedSender), lower(Msgs(i).sender))
%         filteredMsgs = [filteredMsgs; Msgs(i)];
%     end
% end
%
% msgCount = length(filteredMsgs);
%
% for i = 1:msgCount

ctu = 1;
count = 0;
while ctu
    inMsg = getMessage(chronicConnection, 1);
    if ~isempty(inMsg)
        chronicConnection.msgQueue = [chronicConnection.msgQueue; inMsg.msg];
        count = mod(count + 1, 10);
        if isequal(0, count)
            pause(0.02);
        end
    else
        ctu = 0;
    end
end


% end