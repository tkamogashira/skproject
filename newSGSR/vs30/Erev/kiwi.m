function kiwi(MM,cDelay);
% kiwi - plot pre-processed BN data (see mandarin)
if inUtrecht, F2POS = [5   131   380   393]; end;

if nargin<2, cDelay = MM.cDelay; end;

% alignBNdata(MM.Seq, MM.Nsig, cDelay);
[GC Offsets] = alignBNdata(MM.Seq, MM.Nsig, cDelay);
% ----------
f2; clf;
HasCar = isfield(MM.Seq{1}, 'CarPhase')
if HasCar,
   Nsubplot = 3;
else,
   Nsubplot = 2;
end
Nsubplot
for iseq=1:length(MM.Seq),
   seq = MM.Seq{iseq};
   sel = seq.Reliable;
   fr = seq.Freq(sel);
   % gain
   subplot(Nsubplot,1,1); hold on;
   plot(fr, seq.Gain(sel), [ploco(iseq) ploma(iseq) '-']);
   ylabel('Gain (dB)');
   grid on;
   % phase
   subplot(Nsubplot,1,2); hold on;
   phc = fr*(cDelay-seq.compdelay);
   plot(fr, phc+seq.Phase(sel)', [ploco(iseq) ploma(iseq) '-']);
   ylabel('Phase (cyc)');
   grid on;
   % carphase
   if HasCar,
      csel = find(seq.CarIsSign);
      cfr = seq.Freq(csel);
      subplot(Nsubplot,1,3); hold on;
      phc = cfr*(cDelay-seq.compdelay);
      plot(cfr, phc+seq.CarPhase(csel), [ploco(iseq) ploma(iseq) '-']);
      ylabel('Phase (cyc)');
      grid on;
   end
end
subplot(Nsubplot,1,1);
title(['Exp ' seq.FN ' --- cell ' seq.iCell ' --- cdelay = ' num2str(cDelay) ' ms']);
set(2,'pos',F2POS);






