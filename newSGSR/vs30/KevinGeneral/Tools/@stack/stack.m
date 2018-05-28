function s = stack(varargin)
%STACK  stack object
%   Stk = STACK(Stk)
%   Stk = STACK({MaxNItems})
%   Input parameter
%   Stk       : If stack object is given as input parameter, it is simply passed as an output argument.
%   MaxNItems : Maximum number of items in stack. {Inf} 
%
%   Output parameter
%   Stk       : Stack object
%
%   See also PUSH, POP

switch nargin
case 0
    s.NItems    = 0;
    s.MaxNItems = Inf;
    s.Data      = cell(0);
case 1
    switch class(varargin{1})
    case 'stack', s = varargin{1};
    case 'double'
        MaxNItems = varargin{1};
        
        if ~isscalar(MaxNItems) | ~isinteger(MaxNItems) | (MaxNItems < 0) | isnan(MaxNItems), error('Maximum number of items must be positive integer.'); end
        
        s.NItems    = 0;
        s.MaxNItems = MaxNItems;
        s.Data      = cell(0);
    otherwise, error('Argument can be stack object or maximum number of items in stack.'); end    
otherwise, error('Wrong number of input arguments.'); end

s = class(s, 'stack');