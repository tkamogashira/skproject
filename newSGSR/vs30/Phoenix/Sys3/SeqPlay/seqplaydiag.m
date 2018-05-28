function rx6seqplaydiag(NCount)
% RX6seqplaydiag - diagnostics for seqplay functionality : debug circuit only!

if nargin<1, NCount = 10; end

SPinfo = RX6seqplayInit('status');

Tick = sys3getpar('Tick')
PlayTick = sys3read('PlayTick', SPinfo.Dev, NCount, 0, 'I32')

Going = sys3getpar('Going')

CurrentOffsetL = sys3getpar('CurrentOffsetL')
CurrentOffsetR = sys3getpar('CurrentOffsetR')

OffsetIdxL = sys3getpar('OffsetIdxL')
OffsetIdxR = sys3getpar('OffsetIdxR')

SwitchListL15 = sys3read('SwitchListL', SPinfo.Dev, 20, 0, 'I32')
SwitchListR15 = sys3read('SwitchListR', SPinfo.Dev, 20, 0, 'I32')

SwitchL = sys3read('SwitchL', SPinfo.Dev, NCount, 0, 'I32')
SwitchR = sys3read('SwitchR', SPinfo.Dev, NCount, 0, 'I32')



OffsetsL15 = sys3read('OffsetsL', SPinfo.Dev, 20, 0, 'I32')
OffsetsR15 = sys3read('OffsetsR', SPinfo.Dev, 20, 0, 'I32')

PlayOffsetsL = sys3read('PlayedOffsetsL', SPinfo.Dev, NCount, 0, 'I32');    % effectively played offsets
PlayOffsetsR = sys3read('PlayedOffsetsR', SPinfo.Dev, NCount, 0, 'I32');

RX6seqplayReview('L', NCount);
RX6seqplayReview('R', NCount);
set(gcf,'pos',[237   412   448   300])

SPinfo = RX6seqplayinit('status')

figure;
set(gcf,'pos',[573    96   448   567])
subplot(2,1,1)
plot(PlayTick, 0.2+SwitchL, 'bv');
xplot(PlayTick, SwitchR, 'ro');
xlabel('tick time')
ylabel('Switch times')

grid on
subplot(2,1,2)
plot(PlayTick, 0.2+PlayOffsetsL+PlayTick, 'bv');
xplot(PlayTick, PlayOffsetsR+PlayTick, 'ro');
xplot(xlim,0.2+SPinfo.OffsetL'*[1 1],'b')
xplot(xlim,SPinfo.OffsetR'*[1 1],'r')
ylabel('Waveform index')
xlabel('tick time')
grid on;



