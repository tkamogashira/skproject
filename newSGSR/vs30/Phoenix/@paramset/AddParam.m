function S = AddParam(S, varargin);
% paramset/AddParam - define new parameter of paramset object
%   S = AddParam(S, ...) defines a new parameter of paramset object S.
%   The ellipses indicate all input arguments following S, which are 
%   passed to the constructor function parameter/parameter.
%
%   See also InitParamGroup, parameter/parameter.

% create new parameter by calling parameter constructor.

if  nargout<1, 
   error('No output argument using AddParam. Syntax is: ''S = AddParam(S,...)''.');
end

newpar = Parameter(varargin{:});

if isvoid(S),
   error('Parameters may not be added to a void paramset object.');
elseif isvoid(newpar),
   error('Paramset objects may not contain void parameters.');
elseif hasparam(S, newpar.name),
   error(['Paramset already contains a parameter named ''' newpar.name '''; remove it using syntax ''S.' newpar.name ' = []''.']);
end

S.Stimparam = [S.Stimparam newpar];




