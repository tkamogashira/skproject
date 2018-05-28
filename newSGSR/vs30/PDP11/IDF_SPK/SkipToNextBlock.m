function NewPos= SkipToNextBlock(fid, NbytesInBlock)

if nargin<2
    NbytesInBlock=256;
end

where = ftell(fid);
offset = rem(where,NbytesInBlock);
if offset>0
   nBytesToSkip = NbytesInBlock-offset;
   fseek(fid,nBytesToSkip,'cof');
end
