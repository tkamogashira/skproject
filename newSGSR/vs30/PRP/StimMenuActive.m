function a=StimMenuActive;
% StimMenuActive - is there a stimmenu active?
%  returns:
%   0: no stimmenu opened
%   1: stimmenu opened & visible
%  -1: stimmenu opened but not visible
% Note: uses function messagehandle

h = messagehandle;
if isempty(messagehandle), 
   a = 0;
elseif isequal(get(get(h,'parent'), 'visible'),'on'),
   a = 1;
else,
   a = -1;
end