function newPos = SPKwriteHeader(fid, header)

% function newPos = SPKwriteHeader(fid, header);

% move to begin of file + 2 (for record-ID info)
if fseek(fid,2,'bof')
    error(ferror(fid));
end

fwriteVAXD(fid, header.version, 'single');
fwriteVAXD(fid, header.blocks_used, 'uint16');
fwriteVAXD(fid, header.num_data_sets, 'uint16');
fwriteVAXD(fid, header.num_directory_blocks, 'uint16');
