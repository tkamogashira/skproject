function [msg, chronicConnection] = getMessage(chronicConnection, ignoreConnection)

if isequal(1, nargin)
    ignoreConnection = 0;
elseif ~isequal(2, nargin)
    error('wrong amount of arguments');
end

if chronicConnection.connected | ignoreConnection %#ok<OR2>
    msg = GetMessage(chronicConnection.JavaAlias, chronicConnection.rcvPort);
else
    error('Not connected!')
end