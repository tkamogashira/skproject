function sp = sgsrpar(DataFile,iSeq);
% SGSRPAR - stimulus parameters of SGSR sequence
%   SGSRPAR(FN,I) returns the stimulus parameters of sequence # I of file FN
%   in a struct.
%
%   See also getSGSRdata

if iscell(iSeq), % recursive call
   for ii=1:length(iSeq),
      sp{ii} = sgsrpar(DataFile,iSeq{ii});
   end
   return;
end
if length(iSeq)>1, % recursive call
   for ii=1:length(iSeq),
      sp(ii) = sgsrpar(DataFile,iSeq(ii));
   end
   return;
end
% single seq from here   
Inp = CollectInstruct(DataFile,iSeq);
sp = FromCacheFile('SGSRpar', Inp);
if isempty(sp),
   qq = getSGSRdata(DataFile,iSeq);
   sp = qq.Header.StimParams;
   ToCacheFile('SGSRpar', -1e3, Inp, sp);
end
sp.i_____Seq = iSeq;
