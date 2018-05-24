function HP=artispikes
% artispikes


Dev = 'RP2';
Fsam = sys3loadCircuit('artispikes', Dev, 50); % sample rate ~ 50 kHz
dt = 1/Fsam; % ms sample period
Nsam = sys3getpar('NsamBuf', Dev);
Trefrac = 1.25; % ms refractory perios

T = (0:Nsam-1)*dt; % time axis in ms
Dur = max(T); % ms buffer Duration

Rate = 40; % sp/s
meanISI = 1e3/Rate; % mean ISI [ms]
Nmin = round(2e-3*Rate*Dur)
Isi = exprnd(meanISI, 1, Nmin); % inter-spike -intervals
Isi = Isi(Isi>Trefrac); % remove small intervals
SPT = cumsum(Isi);
SPT = SPT(2:end);
SPT = SPT(SPT<Dur);
Nspike = numel(SPT);
SpikeType = randomint(2,1,Nspike);

[t, Amp, Width, Skew] = deal([]);
for ii=1:Nspike,
    spt = SPT(ii);
    if isequal(1, SpikeType(ii)),
        t = [t, spt+[0, 1.3 2.5]/3];
        Amp = [Amp, 2*[1 1.2 -0.5]];
        Width = [Width, [1 1.1 4]/3];
        Skew = [Skew, 2 2 2];
    else,
        t = [t, spt];
        Amp = [Amp, 2];
        Width = [Width, 1];
        Skew = [Skew, 4];
    end
end
Wv = spike_waveform(T, t, Amp, Width, Skew, 0.15);

HP = Gnoise(5000, 12000, 0, Dur+dt, 0, nan, 0, 1e3*Fsam);
LP = Gnoise(1, 10, 0, Dur+dt, 1, nan, 0, 1e3*Fsam);

% plot([LP HP]);
% figure; ;

dsize(LP.data', HP.data', Wv);
Wv = Wv + 1.3*LP.data' + 0.2*HP.data';
%plot(T, Wv);
sys3write(0.1*Wv, 'Samples', Dev);
sys3run(Dev);







