function headrec=IDFheaderRead(fid)

% function headrec=IDFheaderRead(fid);
% IDF file must be opened with
%      fid = fopen(idfname, 'r', 'ieee-le')
% reads 256 bytes and puts variables read in
% corresponding fields
% if fid is string, file [fid '.IDF'] is opened and closed

if nargin<1, error('no file id specified'); end;

CloseFile = 0;
if ischar(fid)
   fid = FullFileName(fid, datadir, 'IDF', 'IDF file');
   fid = fopen(fid, 'r', 'ieee-le');
   CloseFile = 1;
end

% reset idf file
if fseek(fid, 0, 'bof')
    error(ferror(fid));
end

dump = freadVAXD(fid,16,'bit1');
headrec.recent_version = abs(dump(1:2).');
% headrec.recent_version(1) = freadVAXD(fid,2,'int8');
% headrec.recent_version = freadVAXD(fid,2,'int8');
headrec.current_version = freadVAXD(fid,1,'single');
headrec.num_seqs = freadVAXD(fid,1,'uint8');

if fseek(fid, 256, 'bof')
    error(ferror(fid));
end

if CloseFile
    fclose(fid);
end
