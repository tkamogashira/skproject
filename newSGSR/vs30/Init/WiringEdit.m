function FileText=WiringEdit;
global WiringMenuStatus DEFDIRS
hh = WiringMenuStatus.handles;
FileText = get(hh.printText,'string');
Fname = [DEFDIRS.Export '\wiring.txt'];
fid = fopen(Fname,'wt');
for ii = 1:size(FileText,1),
   fprintf(fid, '%s\n',[FileText(ii,:)']);
end
fclose(fid);
evalstr = ['!notepad ' Fname];
eval(evalstr);
