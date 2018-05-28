function fastErevAnaD(FN, iSeq, binWidth,plotArg);
% different tokens

if nargin<4,
   plotArg='b';
   if ishandle(1), delete(1); end;
   if ishandle(1), delete(2); end;
   f1; 
   f2;
   if ~inUtrecht, 
      fpos = get(1,'position');
      set(1,'position',fpos+[0 400 0 0]);
   end
else,
   f1; hold on;
   f2; hold on;
end

Ntok = listSGSRdata(FN, iSeq, 'StimParams.Ntoken');
Ntok = Ntok(find(Ntok~=0));
if length(unique(Ntok))>1, error('unequal ntokens'); end
RS = listSGSRdata(FN, iSeq, 'StimParams.Rseed');
RS = RS(find(RS~=0));
if length(unique(RS))~=length(iSeq), error('equal random seeds'); end
Ntok = max(Ntok);
YY = 0;
for itok=1:Ntok,
   for iseq=iSeq,
      [XX, Freq, Sel] = erevanalyze2(FN, iseq, itok, binWidth);
      Sel = Sel(2:end-2);
      YY = YY + XX(Sel)/(binWidth*Ntok);
   end
end
freq = Freq(Sel)/1e3;
global Ptilt
if ~isempty(Ptilt),
   Ptilt
   pha = Ptilt*freq;
   YY = YY.*exp(2*pi*i*pha);
end

f1; plot(freq, a2db(abs(YY)),plotArg);
title(['file ' FN ' --- seqs ' trimspace(num2str(iSeq))])
xlabel('Frequency (kHz)');
ylabel('Gain (dB)');
f2; plot(freq, (1/2/pi)*unwrap(angle(YY)),plotArg);
title(['file ' FN ' --- seqs ' trimspace(num2str(iSeq))])
xlabel('Frequency (kHz)');
ylabel('Phase (cycles)')



