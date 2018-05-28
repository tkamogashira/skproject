function varargout = StereoVar(varargin);
% stereoVar - force width of variable to 2
%   stereoVar(X), where X is a column vector, returns [X X].
%   Nx2 matrices are left alone. Other widths of X, including
%   zero-widths, result in errors.
%
%   [Xs, Ys, ...] = stereoVar(X,Y...) is equivalent to
%   X = stereoVar(X); Y = stereoVar(Y) ...

for ii=1:nargin,
   Width = size(varargin{ii},2);
   if (Width>2) | (Width<1), 
      error('Width of argument to StereoVar must be 1 or 2.');
   else, varargout{ii} = [varargin{ii}(:,1) varargin{ii}(:,end)];
   end
end






