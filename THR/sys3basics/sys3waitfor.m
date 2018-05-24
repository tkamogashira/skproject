function T = sys3waitfor(Tag, Comp, Val, Dev, Timeout)  
% sys3waitfor - wait for the running rco-component to reach a certain criterium.
%   T = sys3waitfor(Tag, Comp, Val, Dev, Timeout) keeps a running circuit "hanging" in a loop until
%   the comparison (e.g. <, >, ==, given by Comp) of Tag with Val is true.
%
%   Input args:
%      Tag: ParTag existing within loaded circuit
%     Comp: specifies how Val and Tag are compared, must be given as a string
%           examples: '>' ; '<=' ; '=='. 
%      Val: must be an integer with value Tag can get. If not, a time-out will result.
%      Dev: TDT device defaulting to sys3defaultDev.
%  Timeout: timout in seconds after which function returns anyway.
%           defaults to 5.000 seconds. If Timeout<0, abs(Timeout) is used
%           and the wait loop is made interruptible (by including a drawnow).
%
%   Output arg:
%    T equals 1 if the time-out was reached, zero if the criterium was met
%    within the time limit.
%
%   Examples:
%
%   sys3waitfor('curindex','<',400, 'RP2'); % waits till curindex value drops below 400
%   sys3waitfor('curindex','>=', 400);
%   sys3waitfor('curindex','==', 400);
%   sys3waitfor('curindex','<',400, '', 60); % 60 s time-out
%
%   See also sys3run, sys3Trig, sys3getpar, sys3setpar, sys3defaultDev.

t0 = clock; % hit stopwatch immediately

error(nargchk(3,5,nargin));
if nargin < 4, Dev = sys3defaultDev; end 
if nargin < 5, Timeout=5; end % 5 sec timeout

AllowInterrupt = (Timeout<0);
Timeout = abs(Timeout);

curTag = sys3getPar(Tag,Dev);
s = ['curTag ' Comp ' Val;'];
while ~eval(s) && (etime(clock,t0)<Timeout),
    if AllowInterrupt, drawnow; end
    curTag = sys3getPar(Tag,Dev);
end
T = (etime(clock,t0)>=Timeout);






