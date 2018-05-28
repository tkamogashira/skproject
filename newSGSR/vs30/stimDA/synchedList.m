function [Zlist, Nsync, Nswitch] = synchedList(playDBN, playRep, filtIndex, chan, IsSyncChan);
% synchedList - returns zipped list for TDT-seqplay style D/A and includes sample counts for synching

if ~any(size(playDBN)==1) & ~isempty(playDBN), error('playDBN must be vector'), end;
if ~isequal(size(playRep),size(playDBN)),
   error('playDBN and playRep must have equal sizes');
end

if ischar(chan), chan = channelNum(chan); end
global SGSR GLBsync

samP = samplePeriod(filtIndex);

% sync buffer(s)
Nsync = GLBsync.Nsync;
if IsSyncChan,
   DBNsync = GLBsync.DBN;
   REPsync = 1;
else,  % silence instead
   [DBNsync, REPsync] = SilenceList(Nsync, chan);
end

% switch buffer(s)
Nswitch = round(SGSR.switchDur*1e3/samP)-1; % ms->us->samples
[DBNswitch REPswitch] = silenceList(Nswitch, chan);

% concatenate
Zsync = vectorzip(DBNsync(:)', REPsync(:)');
Zswitch = vectorzip(DBNswitch(:)', REPswitch(:)');
Zplay = vectorzip(playDBN(:)', playRep(:)');
Zlist = [Zsync Zswitch Zplay  0];

