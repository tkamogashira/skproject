function uet = SPKreadUETinfo(fid)

% function uet = SPKreadUETinfo(fid);

uet.numactive = freadVAXD(fid, 1, 'int16');
uet.activelist = -freadVAXD(fid, 16, 'bit1').';
uet.tdecade = freadVAXD(fid, 1, 'int16');
uet.tmult = freadVAXD(fid, 1, 'int16');
uet.triglist = -freadVAXD(fid, 16, 'bit1').';
uet.startchan = freadVAXD(fid, 1, 'int8');
uet.stopchan = freadVAXD(fid, 1, 'int8');
