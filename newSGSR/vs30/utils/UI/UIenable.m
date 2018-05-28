function UIenable(h,enab);
% UIenable - enable or disable uicontrol
%  enab = (0,1,i) = (off,on,inactive); default is 1=on
if nargin<2, enab=1; end;
if isequal(0,enab), set(h,'enable','off');
elseif isequal(i,enab), set(h,'enable','inactive');
else, set(h,'enable','on');
end