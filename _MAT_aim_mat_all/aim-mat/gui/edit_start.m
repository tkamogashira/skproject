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



function handles=edit_start(hObject, eventdata, handles)

curval=get(hObject,'String');
curval=str2num(curval);
handles.currentslidereditcombi=...
	slidereditcontrol_set_raweditvalue(handles.currentslidereditcombi,curval);

if handles.info.current_plot>=6 %sai has additionally the start time below:
	sai=handles.data.sai;
	cval=slidereditcontrol_get_value(handles.currentslidereditcombi);
	cval=round(cval);
	start_time=getcurrentframestarttime(sai{cval});
	set(handles.edit2,'String',num2str(cval));
	set(handles.edit3,'String',num2str(fround(start_time*1000,1)));
else
	% range check: 
	start=slidereditcontrol_get_value(handles.currentslidereditcombi);
	start=max(start,0);
	dur=slidereditcontrol_get_value(handles.slideredit_duration);
	sig=handles.data.signal;
	siglen=getmaximumtime(sig);
	if start+dur>siglen
		start=siglen-dur;
	end
	handles.currentslidereditcombi=...
		slidereditcontrol_set_value(handles.currentslidereditcombi,start);
% 	% and set a new range
% 	handles.slideredit_start=slidereditcontrol_set_range(handles.slideredit_start,dur);	% the duration
	
end