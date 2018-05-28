function ChronicConnection = connect(ChronicConnection)

%% Start from nothing
ChronicConnection = flushQueues(ChronicConnection);

%% Try connecting
ignoreConnection = 1;
ChronicConnection = sendMessage(ChronicConnection, 'ConnectChronic', ignoreConnection);

timeBegin = clock;
timeNow = clock;
while ~ChronicConnection.connected & etime(timeNow, timeBegin) < ChronicConnection.timeOut %#ok<AND2>
    ChronicConnection = processQueue(ChronicConnection);
    timeNow = clock;
end

if ~ChronicConnection.connected
    error('Could not connect to server. Is it listening?');
else
    disp('Succesfully connected to Java.');    
end

ChronicConnection = flushQueues(ChronicConnection);