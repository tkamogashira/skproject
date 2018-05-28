function chronicConnecton = punish(chronicConnection, amount)

if isConnected(chronicConnection)
    chronicConnecton = sendMessage(chronicConnection, ['punish' num2str(amount)]);
else
    error('You need to be connected to the Java software to use this function.')
end