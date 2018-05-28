function y = standardSPs(Nsub, RepDur, Nrep, actChan, RecSide, dur_L, dur_R);
% standardSPs - returns SPstruct array containing a couple of standard stimparams
%  Syntax:
%    standardSPs(Nsub, RepDur, Nrep, actChan, RecSide, dur_L, dur_R);
%    Last two args are optional. Channles aer always stored in char format
%
%    See also SPstruct, ChannelChar

y(1) = SPstruct('Nsub', '# subsequences', '', Nsub);
y(2) = SPstruct('RepInt', 'Onset-onset interval between reps', 'ms', RepDur);
y(3) = SPstruct('Nrep', '# reps in subseq', 'ms', Nrep);
y(4) = SPstruct('DAchan', 'active D/A channels', '', channelChar(actChan));
y(5) = SPstruct('RecSide', 'recording side', '', channelChar(RecSide));
if nargin>5,
   y(6) = SPstruct('dur_L', 'left-chan duration', 'ms', channelChar(RecSide));
end
if nargin>6,
   y(7) = SPstruct('dur_R', 'right-chan duration', 'ms', channelChar(RecSide));
end
