function boolean = isempty(Stk)
%ISEMPTY    check if stack object is empty
%   ISEMPTY(Stk)
%   Input parameter
%   Stk : Stack object.
%
%   See also PUSH, POP

boolean = (Stk.NItems == 0);