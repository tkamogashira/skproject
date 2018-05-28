function SPKwriteLocation(fid, loc)

% function SPKwritelocation(fid, loc);

if isempty(loc) % aligment for bug fix
   loc = struct('recnum',0,'entry',0);
end

fwriteVAXD(fid, loc.recnum, 'uint16');
fwriteVAXD(fid, loc.entry, 'uint16');
