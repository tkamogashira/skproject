function [FREQ, Y] = FSplot(FN, iSeq, plotR, shiftWin);
% FSplot - fast plot of FS rate curve 

if nargin<3, plotR=''; end; % not a vector strength plot
if nargin<4 shiftWin=0; end;
Nseq = length(iSeq);
if Nseq>1,
   iSeq = unique(iSeq);
   Nseq = length(iSeq);
   for ii = 1:Nseq,
      subplot(Nseq,3,3*ii-2);
      set(gca, 'FontSize',6);
      FSplot(FN,iSeq(ii));
      subplot(Nseq,3,3*ii-1);
      set(gca, 'FontSize',6);
      FSplot(FN,iSeq(ii),'mod');
      subplot(Nseq,3,3*ii);
      set(gca, 'FontSize',6);
      FSplot(FN,iSeq(ii),'qmod');
   end
   return
end

idf = IDFget(FN, iSeq);
st = idf.stimcntrl.stimtype;
% 0 = fs
if ~ismember(st,[0 13]),
   error('not an FS/FSlog curve');
end

Nrec = idf.stimcntrl.max_subseq;
Nrep = idf.stimcntrl.repcount;
C =  idf.stimcntrl.activechan;
if C==0, C = 1; end; % use left channel for abcissa
MODFREQ = idf.indiv.stim{C}.modfreq;

spk = SPKget(FN, iSeq);
endBurst = idf.indiv.stim{C}.duration;
for isub=1:Nrec,
   FREQ(isub) = spk.subseqInfo{isub}.var1(C);
   spt = cat(2,spk.spikeTime{isub,:}) -shiftWin;
   spt = spt(find(spt<endBurst)); % select within-burst spikes
   NSPK(isub) = length(spt);
   if isempty(plotR),
   else,
      if isequal(plotR(1),'c'), % carrier freq
         cycfreq = FREQ(isub);
         BFstr = 'car freq';
      elseif isequal(plotR(1),'m') | isequal(plotR(1),'q'), % modulation freq
         cycfreq = MODFREQ;
         BFstr = 'mod freq';
         if (MODFREQ==0) | idf.indiv.stim{C}.modpercent==0,
            error('stimulus not modulated');
         end
      else, cycfreq = plotR;
         BFstr = [num2str(cycfreq) ' Hz'];
      end
      R(isub) = abs(vectorStrength(spt, cycfreq));
   end
end

if isempty(plotR),
   Y = NSPK/Nrep/(1e-3*endBurst); % spike rate
   Yunit = ' sp/s ';
   Ylab = 'Spike Rate (sp/s)';
elseif isequal(plotR(1),'q'),
   Y = R.*NSPK/Nrep/(1e-3*endBurst); % vector strength times #spikes
   Yunit = ' ';
   Ylab = ['unnorm. R @ ' BFstr];
else,
   Y = R; % vector strength
   Yunit = ' ';
   Ylab = ['Vector Str @ ' BFstr];
end

[maxY II] = max(Y);
Fmax = round(FREQ(II));
MaxStr = ['max : ' num2str(maxY,3)  Yunit '@ ' num2str(Fmax)  ' Hz'];


FREQ = FREQ/1e3; % Hz->kHz
% figure;
plot(FREQ, Y);
hold on;
plot(FREQ, Y,'o');
plot(Fmax/1e3,maxY,'x');
xlabel('carrier freq (kHz)');
ylabel(Ylab);
% grid on;
IDstr = id2iseq; 
if isempty(IDstr), IDstr = upper(idfstimname(st));
else, IDstr = ['<' IDstr '>'];
end
title(['File: ' FN ' ---  Seq: ' num2str(iSeq) '  ' IDstr]);
XLI = get(gca,'Xlim');
YLI = get(gca,'Ylim');
Xtext = XLI(1) + 0.3*(XLI(2)-XLI(1));
Ytext = YLI(1) + 0.8*(YLI(2)-YLI(1));
if st==13,
   if XLI(2)>10*XLI(1),
      set(gca,'XScale','log');
      XLI = get(gca,'Xlim');
      Xtext = 1.5*XLI(1);
      % Ytext = YLI(1) + 0.5*(YLI(2)-YLI(1));
   end
end
Pstr = strvcat(MaxStr, ['burst: '  num2str(endBurst)  ' ms']);
SPL = idf.indiv.stim{C}.spl;
SPLstr = ['level: ' num2str(SPL) ' dB SPL'];
Pstr = strvcat(Pstr, SPLstr);
text(Xtext, Ytext, Pstr,'FontSize',6);
% (burst dur: ' num2str(endBurst) ' ms)


