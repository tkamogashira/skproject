function RX6seqplayPlot;
% RX6seqplayPlot - plot buffer contents of seq play (debug function)

SPinfo = RX6seqplayInit('status');

dt = 1/SPinfo.Fsam; % sample period in ms

% Left
samL = [];
iwav = SPinfo.XiwaveL;
offsets = SPinfo.OffsetL(iwav);
nsam = SPinfo.NsamL(iwav);
for ii=1:length(iwav),
  sam = sys3read('SamplesL', SPinfo.Dev, nsam(ii), offsets(ii), 'F32');
  samL = [samL sam];
end
% Right
samR = [];
iwav = SPinfo.XiwaveR;
offsets = SPinfo.OffsetR(iwav);
nsam = SPinfo.NsamR(iwav);
for ii=1:length(iwav),
  sam = sys3read('SamplesR', SPinfo.Dev, nsam(ii), offsets(ii), 'F32');
  samR = [samR sam];
end

% add a little jitter for visual clarity
samL = samL + 0.01*rand(size(samL));
samR = samR + 0.01*rand(size(samR));
% plot
dplot(dt,samL, 'o', 'markersize', 3);
xdplot(dt,samR, 'xr', 'markersize', 5);
xlabel('time (ms)')








