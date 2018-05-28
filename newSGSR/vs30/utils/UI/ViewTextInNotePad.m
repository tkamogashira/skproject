function ViewTextInNotePad(Fname, infoStr, MenuHandle);

if nargin<3, MenuHandle=-pi; end;

global DEFDIRS;
Fname = FullFileName(Fname, DEFDIRS.Export, 'txt');

if ishandle(MenuHandle),
   set(MenuHandle, 'visible', 'off');
end

try,
   fid = fopen(Fname,'wt');
   for ii = 1:size(infoStr,1),
      fprintf(fid, '%s\n',[infoStr(ii,:)']);
   end
   fclose(fid);
   evalstr = ['!notepad ' Fname];
   eval(evalstr);
catch
   errordlg(lasterr, 'Error (ViewTextInNotePad)', 'modal');
end

if ishandle(MenuHandle),
   set(MenuHandle, 'visible', 'on');
end
