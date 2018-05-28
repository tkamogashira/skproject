function Data = showtop(Stk)
%SHOWTOP    get top item from stack object, without popping
%   Data = SHOWTOP(Stk)
%   Input parameter
%   Stk  : Stack object.
%
%   Output parameter
%   Data : Top item of stack.
%
%   See also PUSH, POP

if nargin ~= 1, error('Wrong number of input arguments.'); end
if ~isa(Stk, 'stack'), error('Argument should be stack object,'); end

if isempty(Stk), Data = []; return; end

NItems = Stk.NItems;
Data = Stk.Data{NItems};
