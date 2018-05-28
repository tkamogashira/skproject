function SPKwriteStimInfo(fid, subseqInfo, offset)

% function spkWriteStimInfo(fid, subseqInfo, offset);
% writes a single 'stiminfo record' to SPK file
% file must be opened with fopen(fname, 'a', 'ieee-le')
% offset+1 is the first subseq entry to be written to this block

if rem(ftell(fid), 256)
   error('file position not at start of 256-byte block'); 
end

stim_info_len = 10;
firstSubseq = offset+1;
lastSubseq = min(offset+stim_info_len, length(subseqInfo));

fwriteVAXD(fid, 2, 'uint8'); % stim_info_record type
fwriteVAXD(fid, 0, 'uint8'); % alignment

for ii=firstSubseq:lastSubseq
   fwriteVAXD(fid, subseqInfo{ii}.var1, 'single'); 
   fwriteVAXD(fid, subseqInfo{ii}.var2, 'single');
   fwriteVAXD(fid, subseqInfo{ii}.uet_status, 'int16');
end
IDFfillToNextBlock(fid);
