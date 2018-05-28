function WakeUp;
% WAKEUP - resume execution previously suspended by FallAsleep call
%
% See Also FALLASLEEP
RL = get(0,'recursionlimit');
% next line always changes RL; this resumes fallasleep ...
% ... FallAsleep will then undo the increment of RL
set(0,'recursionlimit', RL+1); 
drawnow;
