function IDFheaderWrite(fid, headrec)

% function headrec=IDFheaderWrite(fid, header);
% IDF file must be opened with
%      fid = fopen(idfname, 'w', 'ieee-le')
% writes header block to idf file.

if nargin<1
    error('no file id specified');
end
if nargin<2
    error('no header record specified');
end

% reset idf file
if fseek(fid, 0, 'bof')
    error(ferror(fid));
end

fwriteVAXD(fid, headrec.recent_version, 'bit1'); % two bits
fwriteVAXD(fid, zeros(1,14), 'bit1'); % 14 align bits
fwriteVAXD(fid, headrec.current_version, 'single');
fwriteVAXD(fid, headrec.num_seqs, 'uint8');
IDFfillToNextBlock(fid);
