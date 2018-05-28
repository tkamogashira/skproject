function lc = IdfLimitChan(activeChan, varparam);
% LimitChan - determine limitchan from activechannel and the variables of left and right chan
if nargin<2, varparam = [1 1]; end
activeChan = channelNum(activeChan);
switch activeChan,
case 0, % return channel in which variable varies most
   if std(varparam(:,1))>=std(varparam(:,end)), lc = 1;
   else lc = 2;
   end
case {1,2},
   lc = activeChan;
end