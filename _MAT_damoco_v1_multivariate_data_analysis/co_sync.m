function SyncIn=co_sync(P1,P2,n,m)
% DAMOCO Toolbox, function CO_SYNC, version 17.01.11
% This function computes the n:m synchronization index from 
% (proto)phases P1 and P2
%
% Form of call SyncIn=co_sync(P1,P2,n,m)
% 
SyncIn = abs(mean(exp(1i*( n*P1 - m*P2) )));
end
