function PDPaddSeqToFiles(fname, idfSeq, spkSeq)

% function PDPaddSeqToFiles(fname, idfSeq, spkSeq);

% check for existence of idf and spk files
idfExists = exist([fname '.IDF'], 'file');
spkExists = exist([fname '.SPK'], 'file');

if (~idfExists) && (spkExists)
   error([fname ': SPK file exists but IDF does not']);
end
if (idfExists) && (~spkExists)
   error([fname ': IDF file exists but SPK does not']);
end
% if neither exists, generate both
if (~idfExists) && (~spkExists)
   IDFinitFile(fname);
   SPKinitFile(fname);
end

% check for number of sequences present in IDF and SPK files
idfHeader = IDFheaderRead(fname);
spkHeader = SPKreadBlock(fname, 1);

idfNseq = idfHeader.num_seqs;
spkNseq = spkHeader.num_data_sets;
if ~isequal(idfNseq, spkNseq)
   error([fname ': IDF and SPK files contain different number of seqs']);
end

if IDFSPKfullFile(fname)
   error(['Cannot save data to file ' fname '; IDF/SPK files are full.']);
end

% enough checking for now. Add the sequences to both files
IDFaddSeqToFile(fname, idfSeq);
SPKaddSeqToFile(fname, spkSeq);
