function Stk = push(Stk, Data)
%PUSH   push item on stack object
%   Stk = PUSH(Stk, Data)
%   Input parameter
%   Stk  : Stack object.
%   Data : Data to be pushed.
%
%   Output parameter
%   Stk  : Stack object.
%
%   See also POP

if nargin ~= 2, error('Wrong number of input arguments.'); end
if ~isa(Stk, 'stack'), error('First argument should be stack object.'); end

NItems = Stk.NItems + 1;
if NItems > Stk.MaxNItems, error('Stack overflow.'); end

Stk.NItems = NItems;
Stk.Data{NItems} = Data;