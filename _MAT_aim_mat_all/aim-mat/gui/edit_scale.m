% procedure for 'aim-mat'
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function handles=edit_scale(hObject, eventdata, handles)


curval=get(hObject,'String');
curval=str2num(curval);
handles.slideredit_scale=...
	slidereditcontrol_set_raweditvalue(handles.slideredit_scale,curval);


return



% strval=str2double(get(hObject,'String'));
% von=handles.data.min_scale;
% bis=handles.data.max_scale;
% if strval>bis
%     strval=bis;
% end
% if strval<von
%     strval=von;
% end
% val=f2f(strval,von,bis,0,1,'loglin');
% val=fround(val,3);
% set(handles.slider1,'Value',val);
