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


function handles=slider_start(hObject, eventdata, handles)
% controls the bahaoviour of the top slider 
% normaly its the start time of the displayed signal, but in case of sai, 
% the current frame number is displayed

curval=get(hObject,'Value');
handles.currentslidereditcombi=...
	slidereditcontrol_set_rawslidervalue(handles.currentslidereditcombi,curval);

if handles.info.current_plot>=6 %sai has additionally the start time below:
	sai=handles.data.sai;
	cval=round(slidereditcontrol_get_value(handles.currentslidereditcombi));
	start_time=getcurrentframestarttime(sai{cval});
	set(handles.edit3,'String',num2str(fround(start_time*1000,1)));
else
	% range check: 
	start=slidereditcontrol_get_value(handles.currentslidereditcombi);
	dur=slidereditcontrol_get_value(handles.slideredit_duration);
	sig=handles.data.signal;
	siglen=getmaximumtime(sig);
	if start+dur>siglen
		start=siglen-dur;
		handles.currentslidereditcombi=...
			slidereditcontrol_set_value(handles.currentslidereditcombi,start);
	end
% 	% and set a new range
% 	handles.slideredit_start=slidereditcontrol_set_range(handles.slideredit_start,dur);	% the duration
	
end



return
