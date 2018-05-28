function Fstr = erevList(FN, seqs);
% list of erev parameters
StimNames = listsgsrdata(FN,seqs,'StimName',1);
OKseqs = [];
for seq=seqs,
   if isequal(trimspace(StimNames(seq,:)),'erev'),
      OKseqs = [OKseqs, seq];
   end;
end
SP = listsgsrdata(FN,OKseqs,'StimParams',1);
superfluous = {'dummy','AdaptDur', 'active', 'SpecType', 'RampDur','NoiseRep'};
FNS = fieldnames(rmfield(SP(1),superfluous));
FNS = {'  Seq' FNS{:}};
tit = ''; llen = 0;
for ifn=1:length(FNS),
   FN = FNS{ifn};
   tit = [tit, ' ', FN];
   llen(ifn) = length(FN)+1;
end
Fstr = tit;
lastseq = OKseqs(1)-1;
for seq=OKseqs,
   if seq>lastseq+1, Fstr = strvcat(Fstr,tit); end; lastseq = seq;
   lin = fixlenstr(num2str(seq),llen(1),1);
   for ifn=2:length(FNS),
      fval = getfield(SP(seq),FNS{ifn});
      fstr = num2str(fval);
      lin = [lin fixlenstr(fstr,llen(ifn), 1)];
   end
   Fstr = strvcat(Fstr, lin);
end


