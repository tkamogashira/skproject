function [Stk, Data] = pop(Stk)
%POP  pop item from stack object
%   [Stk, Data] = POP(Stk)
%   Input parameter
%   Stk  : Stack object.
%
%   Output parameter
%   Data : Data popped from stack.
%   Stk  : Stack object.
%
%   See also PUSH

if nargin ~= 1, error('Wrong number of input arguments.'); end
if ~isa(Stk, 'stack'), error('Argument should be stack object,'); end

if isempty(Stk), error('Empty stack cannot be popped.'); end

NItems = Stk.NItems;

Data = Stk.Data{NItems};
Stk.Data{NItems} = [];
Stk.NItems = NItems - 1;