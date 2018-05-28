function fn = FullFileName(fn, defDir, defExt, prpr)
% FullFileName - add default extension and/or dir to filename if has none 
%   FullFileName(Foo, defDir, defExt) returns the full path of file
%   named Foo. Any directory specification in Foo is respected, but
%   If Foo does not contain a directory, defDir is prepended. 
%   Likewise defExt is appended only if Foo has no extension of its own.
%   defDir may or may no end with a backslash. defExt may or may not start
%   with a period.
%
%   FullFileName(Foo, defDir, defExt, 'mustExist') will produce an error 
%   if the file does not exist.

[pp nn ee] = fileparts(fn);
if isempty(ee)
   if ~isempty(defExt) % supply leading period if needed
      if ~isequal('.',defExt(1))
         defExt = ['.' defExt];
      end
   end
   fn = [fn defExt]; 
end
if isempty(pp)
   if defDir(end)=='\'
       defDir=defDir(1:end-1);
   end
   fn = [defDir '\' fn ]; 
end
if nargin>3
   if ~exist(fn)
      error([prpr ' ''' fn ''' not found']);
   end
end
