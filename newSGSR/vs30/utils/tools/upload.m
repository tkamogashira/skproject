function upload(fn, varargin);
% upload - upload named functions in path to development computer
%   usage: upload foo1 foo2 ...

if atbigscreen,
    error('Cannot upload from master computer to master computer.');
end

more off;
if nargin>1,
   upload(fn);
   for ii=2:nargin,
      upload(varargin{ii-1});
   end
   return;
end
% single arg from here....

src = which(fn);
if exist(fn,'dir') & ~isequal('backup', fn), % all mfiles in directory PLUS methods in @foo subdirs!
   qq = what(fn);
   if ~isempty(qq),
      upload(qq.m{:});
      for ii=1:length(qq.classes),
         cl = qq.classes{ii};
         qqc = what([fn '/' cl]);
         methods = qqc.m;
         for im=1:length(methods),
            methodfile = [qqc.path '\' methods{im}];
            upload(methodfile);
         end
      end
      ww=dir(qq.path);
      ww = ww([ww.isdir]);
      for ii=1:length(ww),
         subdir = ww(ii).name;
         if ismember(subdir(1), '@.'), continue; end % skip @XXX and . and ..
         disp(['-------' subdir '-------']);
         if isempty(what(subdir)),
            warning(['Subdirectory ''' subdir ''' not in path.']);
         else,
            upload(subdir);
         end
      end
      return
   end
   error(['"' fn '" not found in path.']); 
end;

% single file from here
if inUtrecht, % just testing
   disp(fn);
   return;
end
src;
ivs = strfind(src, '\vs');
destPostfix = ['sgsrdevelop\sgsr' src(ivs:end)];
if b_is_bigscreen,
    destPrefix = 'B:\';
else,
    destPrefix = '\\oog\C\';
end
dest = [destPrefix destPostfix];

destDir = fileparts(dest);
if ~exist(destDir, 'dir'),
   error(['Destination folder "' destDir '" not found.']);
end

curdir = cd;
cd(tempdir); % hack to avoid crash of copyfile on non-UNS current dir
try,
[status, mess] = copyfile(src, dest);
cd(curdir);
catch,
   status = 0;
   mess = lasterr;
   cd(curdir);
end
if ~status,
   error(['Unable to copy to destination folder "' destDir '"', ...
         char(13), 'MatLab message: [' mess ']']);
end

disp([fn '            uploaded'])

