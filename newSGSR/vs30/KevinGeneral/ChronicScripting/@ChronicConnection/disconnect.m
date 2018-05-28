function chronicConnection = disconnect(chronicConnection)

chronicConnection = sendMessage(chronicConnection, 'disconnect');
chronicConnection.connected = 0;
chronicConnection = flushQueues(chronicConnection);