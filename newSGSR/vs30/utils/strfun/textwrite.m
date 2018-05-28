function textwrite(fid, TXT);
% textwrite - write text matrix to open textfile; deblank each line of text

Nline = size(TXT,1);
for iline=1:Nline,
   lin = deblank(TXT(iline,:));
   fprintf(fid, '%s\n', lin);
end
