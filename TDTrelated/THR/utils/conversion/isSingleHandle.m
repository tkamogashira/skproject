function ii=isSingleHandle(h, Type);
% isSingleHandle - test if argument is a single handle
%   isSingleHandle(H) returns 1 if H is a single handle of
%   an existing graphics handle, 0 otherwise.
%
%  isSingleHandle(H, 'Type') also tests whether H belongs to the right
%  type, e.g. 'figure' or 'uicontrol'. The type may be abbreviated (See GET).
%
%   Note: isSingleHandle([])==0 whereas ishandle([])==[].
%
%   See also ISHANDLE, GET.

ii = 0;
if ~isnumeric(h), return;
elseif ~isequal(1,numel(h)), return;
elseif ~isreal(h), return;
end
ii = ishandle(h);

if ii && (nargin>1),
    ii = ~isempty(strmatch(lower(Type), get(h, 'type')));
end


