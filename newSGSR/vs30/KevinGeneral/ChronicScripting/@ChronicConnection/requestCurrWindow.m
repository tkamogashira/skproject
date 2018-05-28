function currWindow = requestCurrWindow( CC )

if isConnected(CC)
    FlushMessages(CC.rspPort);
    CC = sendMessage(CC, 'getcurrwindow');

    timeBegin = clock;
    timeNow = clock;
    currWindow = NaN;
    while isnan(currWindow) & etime(timeNow, timeBegin) < 15 %#ok<AND2>
    %while isnan(currWindow) & etime(timeNow, timeBegin) < CC.timeOut %%#ok<AND2>
        messageStruct = GetMessage(CC.JavaAlias, CC.rspPort);
        if ~isempty(messageStruct)
            newMessage = lower(messageStruct.msg);
            if isequal('currwin', newMessage(1:7))
                currWindow = str2double(newMessage(8:end))
            end
        end
        timeNow = clock;        
    end    
    
    if isnan(currWindow)
        error('Timeout while waiting for the current window.');
    else
        CC.currWindow = NaN;
    end
else
    error('You need to be connected to the Java software to use this function.')
end

