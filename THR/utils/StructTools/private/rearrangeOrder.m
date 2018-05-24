function rearrangeOrder(ParentHdl, ChildrenHdls, Direction)
%REARRANGEORDER rearrange display order of handle graphics objects
%   REARRANGEORDER(ParentHdl, ChildrenHdls, Direction) rearranges to display
%   order of the children of the supplied handle graphics object ParentHdl.
%   If the supplied direction is 'foreground' then the set of given handles
%   to children objects is displayed later, thus they are moved to the 
%   foreground. A supplied direction is 'background' moves the set of 
%   children handles to the background.

%B. Van de Sande 08-07-2005

%Checking input arguments ...
if (nargin ~= 3), error('Wrong number of input arguments.'); end
if ~ishandle(ParentHdl), error('First argument must be handle.'); end
AllChildrenHdls = get(ParentHdl, 'children');
if ~all(ishandle(ChildrenHdls)) | ~all(ismember(ChildrenHdls, AllChildrenHdls)),
    error('Second argument should be vector with handles to children.');
end
if ~ischar(Direction) | ~any(strncmpi(Direction, {'background', 'foreground'}, 1)),
    error('Third argument should be ''foreground'' or ''background''.');
end

%Rearranging order of children ...
idx = find(ismember(AllChildrenHdls, ChildrenHdls));
ChildrenHdls = AllChildrenHdls(idx);
AllChildrenHdls(idx) = [];
if strncmpi(Direction, 'b', 1), AllChildrenHdls = [AllChildrenHdls(:); ChildrenHdls(:)];
else, AllChildrenHdls = [ChildrenHdls(:); AllChildrenHdls(:)]; end
set(ParentHdl, 'children', AllChildrenHdls);