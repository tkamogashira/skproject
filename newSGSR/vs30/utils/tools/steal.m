function steal(fromDir, toDir, prefix);
% copy non-licensed mfiles and adapt copyright statement

if nargin<3, prefix = ''; end;

fList = dir([fromDir '\' prefix '*.m']);
allnames = {fList.name};
for ii=1:length(allnames); end;

for ii=1:length(fList),
   fname = fList(ii).name
   fromName = [fromDir '\' fname];
   toName = [toDir '\' fname];
   if isequal('regress.m', lower(fname)),
      toName = [toDir '\qregress.m'];
   end
   fid0 = fopen(fromName, 'rt');
   fid1 = fopen(toName, 'wt');
   while 1
      tline = fgetl(fid0);
      if ~ischar(tline), break, end
      tline = strSubst(tline, 'MathWorks', 'MashWorks');
      tline = strSubst(tline, 'Copyright', 'Copyleft');
      tline = strSubst(tline, 'regress', 'qregress');
      tline = strSubst(tline, 'REGRESS(', 'QREGRESS(');
      tline = strSubst(tline, 'REGRESS ', 'QREGRESS ');
      tline = strSubst(tline, 'qregression', 'regression');
      fprintf(fid1, '%s\n', tline);
      Nreg = length(findstr('regress', lower(tline)));
      Nqreg = length(findstr('qregress', lower(tline)));
      if ~isequal(Nreg,Nqreg),
         disp(tline)
         disp -------------------------------------
      end
   end
   fclose(fid0);
   fclose(fid1);
end


 


