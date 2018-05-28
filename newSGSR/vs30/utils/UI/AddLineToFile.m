function AddLineToFile(str, fn);
% AddLineToFile - append line of text to file
%  syntax: AddLineToFile(str, fn);

fid = fopen(fn,'at');
for ii=1:size(str,1),
   fprintf(fid,'%s\n',str(ii,:));
end
fclose(fid);