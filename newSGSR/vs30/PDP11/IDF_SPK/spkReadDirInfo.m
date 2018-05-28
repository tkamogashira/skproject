function rec = spkReadDirInfo(fid)

dir_size = 24;

rec.data_rec_kind = 1; % directory_record
rec.version              =  freadVAXD(fid, 1, 'single');
rec.blocks_used          =  freadVAXD(fid, 1, 'uint16');
rec.num_data_sets        =  freadVAXD(fid, 1, 'uint16');
rec.num_directory_blocks =  freadVAXD(fid, 1, 'uint16');

% rec.directory = cell(1,dir_size);

rec.directory = spkReadDirEntry(fid, dir_size);

%for ii=1:dir_size, % read one directory entry
%   rec.directory{ii} = spkReadDirEntry(fid);
%end
