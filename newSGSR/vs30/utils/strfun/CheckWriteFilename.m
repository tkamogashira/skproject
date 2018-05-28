function FN = CheckWriteFilename(eh, Defdir, defExt, defExtisMust, ...
*************difficult!   
fileDescript, prompt, browse);
% CheckWriteFilename - get filename to write from edit control or browse and check it
ignoreExt = isequal(-1, defExtisMust);
defdirIsMust = 1;
defdir = Defdir; % need to keep Defdir for recursive call below
try, 
   if defdir(1)=='~',
      defdir = defdir(2:end);
      defdirIsMust = 0;
   end
end
if nargin<7, browse=0; end;
fileDescript(1) = upper(fileDescript(1));
FN = '';
textcolors; 
if browse,
   [fn fp] = uiputfile([defdir '\*' defext], prompt);
   if fn==0, return; end; % user cancelled
   if ignoreExt, fn = removeFileExtension([fp fn]); end;
else,
   if ishandle(eh),
      fn = getstring(eh);
      set(eh,'foregroundcolor', BLACK);
   else, fn = input([prompt ' '],'s');
      if isempty(fn), return; end; % do not bug user twice
   end
   fn = fullFileName(fn, defdir, defExt);
   if ignoreExt, fn = RemoveFileExtension(fn); end;
end
[pp ff ee] = fileparts(fn);
mess = '';
% check filename
if isempty(ff), % nothing specified: recursive call with browse
   FN = CheckWriteFilename(eh, Defdir, defExt, defExtisMust, prompt, 1);
elseif ~isValidFilename(ff),
   mess = ['Invalid filename ''' fn ''''];
elseif ~isSamePath(defdir, pp) & defdirIsMust, 
   mess = strvcat('Invalid directory:',...
      ['''' pp ''''], ...
      [fileDescript ' must be saved in the directory:'],...
      ['''' defdir '''']);
elseif ~isValidFilename(ff),
elseif exist([fn defExt],'file'),
   mess = strvcat([FilDescr ' named:'], ['''' fn '.*'''], ...
      'already exist.', ...
      'Choose a different filename',...
      'or delete existing file ');
end
if ~isempty(mess), % display error and return emptyness
   if ~browse,
      if ishandle(eh),
         set(eh,'foregroundcolor', RED);
         drawnow;
      end
   end
   eh = errordlg(mess, 'Error in filename specification');
else, % update edit, return full filename w/o extension
   if ishandle(eh), setstring(eh, ff); end;
   FN = fullfile(pp, ff);
end
%---------------



