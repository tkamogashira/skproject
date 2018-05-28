function N = length(Stk)
%LENGTH  returns length of stack object
%   N = LENGTH(Stk)
%   Input parameter
%   Stk : Stack object.
%
%   Output parameter
%   N   : Number of elements on the stack
%
%   See also ISEMPTY

%B. Van de Sande 14-10-2003

N = Stk.NItems;