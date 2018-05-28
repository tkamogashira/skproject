function SPKwriteUETinfo(fid,uet)

% function SPKwriteUETinfo(fid,uet);

fwriteVAXD(fid, uet.numactive, 'int16');
fwriteVAXD(fid, -uet.activelist,'bit1');
fwriteVAXD(fid, uet.tdecade, 'int16');
fwriteVAXD(fid, uet.tmult, 'int16');
fwriteVAXD(fid, -uet.triglist, 'bit1');
fwriteVAXD(fid, uet.startchan, 'int8');
fwriteVAXD(fid, uet.stopchan, 'int8');
