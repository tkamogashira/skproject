function SPLplot(FN, iSeq, Rfreq, C);
% SPLplot - fast plot of RC curve (SPL, NSPL, CSPL) or sync curve
if nargin<3, Rfreq=0; end;
idf = IDFget(FN, iSeq);
st = idf.stimcntrl.stimtype;
% 2 = spl; 25 = nspl; 27 = cspl
if ~ismember(st,[2 25 27]),
   error('not an RC curve');
end
Nrec = idf.stimcntrl.max_subseq;
Nrep = idf.stimcntrl.repcount;
if nargin<4,
   C =  idf.stimcntrl.activechan;
end
if C==0, C = idf.stimcntrl.limitchan; end; 
if C==0, C = 1; end; 
if st==2,
   carfreq = idf.indiv.stim{C}.freq;
   modfreq = idf.indiv.stim{C}.modfreq;
elseif ischar(Rfreq),
   error(['Option ''' Rfreq ''' is invalid for stim type ''' idfstimname(st) '''.']);
end

spk = SPKget(FN, iSeq);
if st==2,
   endBurst = idf.indiv.stim{C}.duration;
elseif st==25,
   endBurst = idf.indiv.stim{C}.duration;
else, % 27: cspl
   endBurst = idf.indiv.stim{C}.burst_duration;
end
% endBurst
for isub=1:Nrec,
   SPL(isub) = spk.subseqInfo{isub}.var1(C);
   spt = cat(2,spk.spikeTime{isub,:});
   spt = spt(find(spt<endBurst));
   if isequal(Rfreq,0),
      Ystr = 'Spike rate (sp/s)';
      Y(isub) = length(spt)/Nrep/(1e-3*endBurst);
   elseif isequal(lower(Rfreq(1)),'c'),
      Ystr = 'R @ car freq';
      Y(isub) = abs(vectorStrength(spt, carfreq));
   elseif isequal(lower(Rfreq(1)),'m'),
      Ystr = 'R @ mod freq';
      Y(isub) = abs(vectorStrength(spt, modfreq));
   elseif isnumeric(Rfreq),
      Ystr = ['R @ ' num2str(Rfreq) ' Hz'];
      Y(isub) = abs(vectorStrength(spt, Rfreq));
   else,
      error('invalid R-freq value')
   end
end
SPL = SPL(:);
% stimname = idfstimname();
if (st==25) | (st==27),
   IDstr = trimspace(idf.indiv.stim{2}.noise_data_set);
   if ~isempty(findstr(IDstr,'RHO')),
      minSPL = idf.indiv.stim{C}.total_pts;
      SPL = minSPL + (max(SPL)-SPL); % atten->SPL (dubious)
   else,
      SPL = 120-SPL;
   end
end

figure;
plot(SPL, Y);
hold on;
plot(SPL, Y,'o');
xlabel('Level (dB SPL)')
ylabel(Ystr);
PXJid = id2iseq;
if ~isempty(PXJid), PXJid = ['<' PXJid '>'];
else, PXJid = upper(idfstimname(st)); 
end
title(['File: ' FN ' ---  Seq: ' num2str(iSeq) '  ' PXJid]);
XLI = get(gca,'Xlim');
YLI = get(gca,'Ylim');
set(gca,'ylim', [0 YLI(2)]);
YLI = get(gca,'Ylim');
Xtext = XLI(1) + 0.1*(XLI(2)-XLI(1));
Ytext = YLI(1) + 0.8*(YLI(2)-YLI(1));
Pstr = ['burst: '  num2str(endBurst)  ' ms'];
grid on;
if st==2,
   freq = idf.indiv.stim{C}.freq;
   freqStr = ['freq: ' num2str(freq) ' Hz'];
   Pstr = strvcat(Pstr, freqStr);
end
text(Xtext, Ytext, Pstr);
% (burst dur: ' num2str(endBurst) ' ms)


