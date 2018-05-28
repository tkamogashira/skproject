function chronicConnecton = setSelectedAngle(chronicConnection, newAngle)

if chronicConnection.connected
    chronicConnecton = sendMessage(chronicConnection, ['setselectedangle' num2str(newAngle)]);
else
    error('You need to be connected to the Java software to use this function.')
end