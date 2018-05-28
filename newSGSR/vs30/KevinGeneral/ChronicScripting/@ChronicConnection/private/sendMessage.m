function chronicConnection = sendMessage(chronicConnection, message, ignoreConnection)

if isequal(2, nargin)
    ignoreConnection = 0;
elseif ~isequal(3, nargin)
    error('sendMessage expects at most 2 arguments');
end
if ~ischar(message)
    error('sendMessage expects a string to send');
end

if isConnected(chronicConnection) | ignoreConnection %#ok<OR2>
    SendMessage(chronicConnection.JavaAlias, chronicConnection.sendPort, message);
else
    error('You need to be connected to the Java software to use this function.')
end