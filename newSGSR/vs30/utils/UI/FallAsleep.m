function FallAsleep;
% FALLASLEEP - suspend execution until WakeUp call
%
% See Also WAKEUP
waitfor(0,'recursionlimit');
% wakeup increases RL by one. Undo that
RL = get(0,'recursionlimit');
set(0,'recursionlimit',RL-1);
