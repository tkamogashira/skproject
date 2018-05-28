function SPKplotSpikes(spk, iseq, fignum)

if nargin<1 % plot most recently measured seq of this session
   spk = dataFile;
   iseq = inf;
end

% function SPKplotSpikes(spk, isubseq);
if nargin<3
    fignum=1;
end

if isnumeric(spk) % interprete as index of test set file
   spk = PDPtestsetName(spk);
end
if ischar(spk) % filename - read spk file
   spk = spkread(spk);
end

if isinf(iseq) % take last sequence
   iseq = length(spk.dir);
end

Seq = SPKget(spk, iseq);

Nsub = size(Seq.spikeTime, 1);
Nrep = size(Seq.spikeTime, 2);

figure(fignum);
clf;
colors='rbgmck'; 
hold on;
icol = 1;
for isub=1:Nsub
   col = colors(1+rem(isub-1,length(colors)));
   for irep=1:Nrep
      spikes = Seq.spikeTime{isub,irep};
      Nspikes = length(spikes);
      Y = isub+0.6*(irep/Nrep-0.5);
      plot(spikes, Y+zeros(1,Nspikes),[col '.']);
   end
end
[pp fn] = fileparts(spk.filename);
title([upper(fn) ': spike arrival times of seq ' num2str(iseq)]);
xlabel('spike arrival time (ms)');
ylabel('seq #')
interval = Seq.seqInfo.stim_info.interval; % dur of interval in ms
set(gca, 'XLim', [0 interval]);
set(gca, 'YLim', [0.5 Nsub+0.5]);
set(gca, 'YTick', 1:Nsub);
hold off;
