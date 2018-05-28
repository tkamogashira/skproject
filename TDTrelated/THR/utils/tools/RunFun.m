function varargout = RunFun(Fname, varargin);
% RunFun - run function that is not in the MatLab path.
%   [a,b,..]=RunFun('dir\foo', x,y,z..) is equivalent to 
%   [a,b,..] = foo(x,y,z..)
%
%   See also Run.

Fname = fullFileName(Fname,'','.m');
CurDir = cd;
if ~isequal(2,exist(Fname)),
   error(['Function "' Fname '" not found.']);
end

if nargout==0, varargout = cell(1); 
else, varargout = cell(1,nargout); 
end;

try,
   [Folder Name] = fileparts(Fname);
   if ~isempty(Folder), cd(Folder); end;
   eval(['[varargout{:}] = ' Name '(varargin{:});']);
   cd(CurDir);
catch,
   cd(CurDir);
   error(['Error while running extraneous function "' Fname '": ' char(13) lasterr]);
end

