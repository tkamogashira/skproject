function chronicConnecton = reward(chronicConnection, amount)

if isConnected(chronicConnection)
    chronicConnecton = sendMessage(chronicConnection, ['reward' num2str(amount)]);
else
    error('You need to be connected to the Java software to use this function.')
end