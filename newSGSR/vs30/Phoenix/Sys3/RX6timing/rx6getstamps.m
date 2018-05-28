function [EventTime, N] = RX6getStamps;
% RX6getStamps - download timestamps from RX6 using the seqplay circuit
%    syntax: [EventTime, N] = RX6getStamps

SPinfo = RX6seqplayInit('status');

% Check CircuitID
if SPinfo.CircuitID ~= sys3getpar('CircuitIDOut', SPinfo.Dev)
   error('CircuitID does not match');
end

N = sys3getpar('Nevent', SPinfo.Dev);

SamStamp = sys3read('SamStamp', SPinfo.Dev, N,0,'I32'); % in samples
SubStamp = sys3read('SubStamp', SPinfo.Dev, N,0,'F32'); % in seconds

EventTime = SamStamp/SPinfo.Fsam+1e3*SubStamp; % in ms