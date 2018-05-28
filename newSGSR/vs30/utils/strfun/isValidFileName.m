function iv = isValidFileName(fn);
% isvalidFilename - check if string is valid filename (path not included)
iv = 0;
try,
   fid = fopen([tempdir '\' fn],'w');
   if ~isequal(-1,fid), % seems to be OK
      fclose(fid);
      iv = 1;
   end
end
