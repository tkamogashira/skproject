function SPKwriteRepInfo(fid, reprec)

% function SPKwriteRepInfo(fid, reprec);
% writes rep info to SPK file
% only to be called from spkAddSeqToFile

if rem(ftell(fid), 256)
   error('not at begin of 256-byte block');
end

rep_info_len = 42;

fwriteVAXD(fid, 3, 'uint8'); % rep_info_record ID
fwriteVAXD(fid, 0, 'uint8'); % alignment

for ii=1:rep_info_len
   if isempty(reprec{ii}) % non-existent loc are empty
       break
   end
   SPKwriteLocation(fid, reprec{ii}.loc);
   fwriteVAXD(fid, reprec{ii}.spkcount, 'uint16');
end
IDFfillToNextBlock(fid);
