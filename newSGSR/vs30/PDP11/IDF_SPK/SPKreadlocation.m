function loc = SPKreadlocation(fid)

% function loc = SPKreadlocation(fid);

loc.recnum = freadVAXD(fid, 1, 'uint16');
loc.entry = freadVAXD(fid, 1, 'uint16');
