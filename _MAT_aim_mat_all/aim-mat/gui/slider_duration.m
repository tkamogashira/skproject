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



function handles=slider_duration(hObject, eventdata, handles)


curval=get(hObject,'Value');
handles.slideredit_duration=...
	slidereditcontrol_set_rawslidervalue(handles.slideredit_duration,curval);


% check range
start=slidereditcontrol_get_value(handles.currentslidereditcombi);
dur=slidereditcontrol_get_value(handles.slideredit_duration);
sig=handles.data.signal;
siglen=getmaximumtime(sig);
% siglen=getlength(sig);
if start+dur>siglen
	dur=siglen-start;
	handles.slideredit_duration=...
		slidereditcontrol_set_value(handles.slideredit_duration,dur);
end

% set the range of the start_slider accordingly
curstart=slidereditcontrol_get_value(handles.currentslidereditcombi);
dur=slidereditcontrol_get_value(handles.slideredit_duration);
handles.slideredit_start.maxvalue=siglen-dur;
handles.slideredit_start=slidereditcontrol_set_value(handles.slideredit_start,curstart);	% the duration
handles.slideredit_start=slidereditcontrol_set_range(handles.slideredit_start,dur);	% the duration

if handles.info.current_plot<6
	handles.currentslidereditcombi=handles.slideredit_start;
end

return
