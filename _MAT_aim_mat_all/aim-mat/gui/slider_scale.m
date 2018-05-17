% procedure for 'aim-mat'
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function handles=slider_scale(hObject, eventdata, handles)

curval=get(hObject,'Value');
handles.slideredit_scale=...
	slidereditcontrol_set_rawslidervalue(handles.slideredit_scale,curval);

return

