function varargout=sp(varargin);
% SP - shorthand for stimparam
if nargout==0, % this stupid .. cannot why the second version does not always work
   stimparam(varargin{:});
else,
   varargout = cell(1,nargout);
   varargout{:} = stimparam(varargin{:});
end
