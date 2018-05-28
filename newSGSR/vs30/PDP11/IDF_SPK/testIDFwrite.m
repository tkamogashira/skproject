% script to test writing idf files
% first call idfreadall to make this thing work

fid = fopen('testw', 'w', 'ieee-le');
% modify # seqs
hh = idf1.header;
hh.num_seqs = 2;
idfHeaderWrite(fid, hh);

idfWriteStim(fid, idf1.sequence{12})
idfWriteStim(fid, idf2.sequence{19})

fclose(fid);

% read it back
rb = [];
fid = fopen('testw', 'r', 'ieee-le');
rb = idfread('testw');
