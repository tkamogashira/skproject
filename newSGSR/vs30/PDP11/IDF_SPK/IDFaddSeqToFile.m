function IDFaddSeqToFile(fname, idfSeq)

% function IDFaddSeqToFile(fname, idfSeq);

ffname = [fname '.IDF'];
if ~exist(ffname, 'file')
   warning(['file ' ffname ' does not exist - I will create it']);
   IDFinitFile(fname);
end

BlockSize = 256;

% read header to know how many seqs are in the IDF file
fid = fopen(ffname, 'r', 'ieee-le');
header = idfHeaderRead(fid);
fclose(fid);
Nseq = header.num_seqs;
iSeq = Nseq + 1;
% modify sequence number in idfSeq
idfSeq.stimcntrl.seqnum = iSeq;
% open IDF file for writing (not in append mode since empty
% block might be present due to PDP11 size conventions)
fid = fopen(ffname, 'r+', 'ieee-le');
% move to end of last sequence in file (+1 due to header block)
if fseek(fid, (Nseq+1)*BlockSize,'bof'),
   error(ferror(fid));
end

% write the sequence
IDFwriteStim(fid, idfSeq);
% update and write the header
header.num_seqs = iSeq;
IDFheaderWrite(fid, header);
% close the IDF file
fclose(fid);
