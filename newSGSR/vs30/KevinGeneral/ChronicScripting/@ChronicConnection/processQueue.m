function chronicConnection = processQueue( chronicConnection )
%PROCESSQUEUE Summary of this function goes here
%   Detailed explanation goes here

chronicConnection = fillQueue(chronicConnection);

while length(chronicConnection.msgQueue) > 0
    newMessage = lower(chronicConnection.msgQueue{1});
    chronicConnection.msgQueue = {chronicConnection.msgQueue{2:end}}';
    
    if isequal('disconnect', newMessage)
        chronicConnection = disconnect(chronicConnection);
        break;
    elseif isequal('connectok', newMessage)
        chronicConnection.connected = 1;
        break;
    elseif isequal( 'saccade', newMessage(1:7) )
        newSaccade.oldWindow    = str2double(newMessage(8:10));
        newSaccade.newWindow    = str2double(newMessage(11:13));
        newSaccade.time         = str2double(newMessage(14:end));
        chronicConnection.saccadeQueue = [chronicConnection.saccadeQueue; newSaccade];
    end    
end

if ~isempty(chronicConnection.saccadeQueue)
    chronicConnection.saccadeQueue = structsort(chronicConnection.saccadeQueue, 'time');
end