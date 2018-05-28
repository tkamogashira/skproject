function OK = ReportNsubseq(Nsubseq);

OK = 0;
global StimMenuStatus
maxNsubSeq = 1e3;



rhandle = [];
if isfield(StimMenuStatus,'handles'),
   if isfield(StimMenuStatus.handles,'NseqInfo'),
      rhandle = StimMenuStatus.handles.NseqInfo;
   end
end
if ishandle(rhandle),
   setstring(rhandle,['subseqs: ' num2str(Nsubseq)]);
end;

if Nsubseq>maxNsubSeq,
   mess = strvcat('Too many subsequences:', num2str(Nsubseq));
   UIerror(mess);
   return;
end

OK = 1;