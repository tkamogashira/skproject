function S = THRcurve(Freq, BurstDur, NonBurstDur, MinSPL, MaxSPL, StartSPL, StepSPL, DAchan, SpikeDiffCrit, MaxNpres);
% THRcurve - adaptive measurement of tonal threshold for a range of
% frequencies
% Usage:
%   THRrec(EXP, ToneFreq, BurstDur, NonBurstDur, MinSPL, MaxSPL, StartSPL,
%   StepSPL, DAchan, SpikeDiffCrit, MaxNpres);


% Load circuit
dev = 'RX6_1';%dev='RP2'とするとできるか？
Fsam = sys3loadCircuit('THR', dev, 110);%THRの場合はFs=110Hz程度でよいのか？　THR.rcxという回路をloadする。
sys3run(dev); % in fact still halted until setting 'Run' to 1

% testThr = nan;
% while isnan(testThr),
%     s = THRrec(dev, EXP, Freq(1), BurstDur, NonBurstDur, ...
%         MinSPL, MaxSPL, StartSPL, 3, DAchan, SpikeDiffCrit, 2*MaxNpres);
%     testThr = s.Thr;
% end
%s
dynStartSPL = StartSPL; %testThr;
% Create plot
Thr = nan(size(Freq));
h = plot(Freq,Thr,'YDataSource','Thr');

for ifreq=1:numel(Freq),
    sys3trig(1, dev); % reset buffers, etc
    S(ifreq) = THRrec(dev, Freq(ifreq), BurstDur, NonBurstDur, ...
        MinSPL, MaxSPL, dynStartSPL, StepSPL, DAchan, SpikeDiffCrit, MaxNpres);% THRrec.mがキーとなるファイル。
    if ~isnan(S(ifreq).Thr),
        dynStartSPL = S(ifreq).Thr;
    end
    Thr(ifreq) = S(ifreq).Thr;
    % Attempt to force resetting the timing of play action
    sys3halt(dev); 
    sys3run(dev);
    % Refresh plot
    refreshdata(h,'caller') % Evaluate y in the function workspace
    drawnow
end
sys3halt(dev);

% plot
% plot(Freq,Thr);

