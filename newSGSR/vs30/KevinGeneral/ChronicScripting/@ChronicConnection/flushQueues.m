function chronicConnection = flushQueues(chronicConnection)

FlushMessages(chronicConnection.rcvPort);
chronicConnection.msgQueue      = {};
chronicConnection.saccadeQueue  = [];