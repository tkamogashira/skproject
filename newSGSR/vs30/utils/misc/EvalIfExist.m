function varargout = EvalIfExist(fnc,varargin);
% EvalIfExist - eval/feval if the 1st arg is existing function
varargout = cell(1,nargout); % gotta tell'm somethin'
XST = exist(fnc);
if (XST~=2) & (XST~=5), return; end;
if nargin==1,
   if nargout==0, eval(fnc);
   else    [varargout{:}] = eval(fnc);
   end
else,
   if nargout==0, feval(fnc,varargin{:});
   else,  [varargout{:}] = feval(fnc,varargin{:});
   end
end
