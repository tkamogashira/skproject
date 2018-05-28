function SyncClock
% SyncClock - attempt to synchronize clock prior to recording

if ~atBigscreen, return; end

UIinfo('synchronizing PC clock .. ')
if NTPsync,
   UIinfo('PC clock synchronized')
else,
   UIwarn('Clock synchronization disabled.');
   pause(2);
end



