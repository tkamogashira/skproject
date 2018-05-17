% procedure for 'aim-mat'
% 
%   INPUT VALUES:
% 
%   RETURN VALUE:
%	
% 
% helping function, that sets the sliders to their current values. This is
% a little bit preliminary, since I unfortunatly hadnt time to do this
% properly. Mercy!! If anyone has a few hours, he can fix this. Otherwise
% it works in most circumstances, however not very elegant...
% 
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org



function handles=aim_set_current_slider(handles)
% sets the slider values and range according to the settings in handles


sig=handles.data.signal;
len=getlength(sig);
% if we switched from pre-sai to sai the slider has to change from time to
% frame number
if handles.info.old_current_plot<6 & handles.info.current_plot>=6	&& handles.info.old_current_plot~=0
	% fiddle with the sliders	% the frame number is the default
	handles.slideredit_start=handles.currentslidereditcombi; % save for later
	handles.currentslidereditcombi=handles.slideredit_frames;
	nr_frames=length(handles.data.sai);
	
	handles.currentslidereditcombi.maxvalue=nr_frames;
	handles.currentslidereditcombi.minvalue=1;
	handles.currentslidereditcombi.nreditdigits=0;
	handles.currentslidereditcombi.editscaler=1;

	% calculate the current frame number:
	current_start_time=slidereditcontrol_get_value(handles.slideredit_start);
	framelen=getcurrentframestarttime(handles.data.sai{2})-getcurrentframestarttime(handles.data.sai{1});
	current_frame_nr=round((current_start_time-getminimumtime(sig))/framelen)+1;
	current_frame_nr=min(nr_frames,current_frame_nr);
	current_frame_nr=max(1,current_frame_nr);
	
	handles.currentslidereditcombi=slidereditcontrol_set_value(handles.currentslidereditcombi,current_frame_nr);
	handles.currentslidereditcombi=slidereditcontrol_set_range(handles.currentslidereditcombi,10);	% the duration
 	handles.info.old_current_plot=handles.info.current_plot;

% and set the duration slider to a start time slider
	handles.info.oldduration=slidereditcontrol_get_value(handles.slideredit_duration); % save for later
	handles.slideredit_duration.minvalue=0;
	handles.slideredit_duration.maxvalue=framelen*(nr_frames-1)+getminimumtime(sig);
	handles.slideredit_duration.current_value=getcurrentframestarttime(handles.data.sai{current_frame_nr});
	handles.slideredit_duration=slidereditcontrol_set_value(handles.slideredit_duration,current_frame_nr*framelen);
end
% other way: if switched from to sai pre-sai : go from frame number to time
if handles.info.old_current_plot>=6 & handles.info.current_plot<6	
	% the start time is the default
	handles.slideredit_frames=handles.currentslidereditcombi; % save for later
	if isfield(handles.info,'oldduration')
		dur=handles.info.oldduration;
	else
		dur=0.04;
	end
	dur=min(dur,handles.slideredit_duration.maxvalue);
	
	siglen=getlength(sig);
	start_time=handles.all_options.signal.start_time;
	duration=handles.all_options.signal.duration;
	curdur=slidereditcontrol_get_value(handles.slideredit_duration);
	current_start_time=slidereditcontrol_get_value(handles.slideredit_start);
	handles.slideredit_start.minvalue=start_time;
	handles.slideredit_start.maxvalue=start_time+siglen-curdur;
% 	handles.slideredit_start=slidereditcontrol_set_value(handles.slideredit_start,curstart);
% 	handles.slideredit_start=slidereditcontrol_set_range(handles.slideredit_start,curdur);
	
	
	handles.slideredit_duration.minvalue=0.001;
	handles.slideredit_duration.maxvalue=siglen;
	handles.slideredit_duration=slidereditcontrol_set_value(handles.slideredit_duration,curdur);
	handles.slideredit_duration=slidereditcontrol_set_range(handles.slideredit_duration,duration/10);

	
	% 	dur=slidereditcontrol_get_value(handles.slideredit_duration); % thats the starttime at the moment
% 	current_frame_number=round(handles.currentslidereditcombi.current_value);
% 	current_start_time=getcurrentframestarttime(handles.data.sai{current_frame_number});
	% set the new control to the floating control
	handles.currentslidereditcombi=handles.slideredit_start;

% 	handles.currentslidereditcombi.maxvalue=len;
% 	handles.currentslidereditcombi.minvalue=0;
% 	handles.currentslidereditcombi.nreditdigits=1;
% 	handles.currentslidereditcombi.editscaler=1000;

	handles.currentslidereditcombi=slidereditcontrol_set_range(handles.currentslidereditcombi,dur);	% the duration
	current_start_time=min(current_start_time,len-dur);
	current_start_time=max(current_start_time,0);
	handles.currentslidereditcombi=slidereditcontrol_set_value(handles.currentslidereditcombi,current_start_time);
	
 	handles.slideredit_duration=slidereditcontrol_set_value(handles.slideredit_duration,dur);
 	handles.info.old_current_plot=handles.info.current_plot;

	% and set the duration slider back to the duration
	handles.slideredit_duration.minvalue=0.001;
	handles.slideredit_duration.maxvalue=len;
	handles.slideredit_duration=slidereditcontrol_set_value(handles.slideredit_duration,dur);

end

% second run
if handles.info.old_current_plot==0
	cstart=slidereditcontrol_get_value(handles.currentslidereditcombi);
	handles.currentslidereditcombi=slidereditcontrol_set_value(handles.currentslidereditcombi,cstart);
	cdur=slidereditcontrol_get_value(handles.slideredit_duration);
	handles.slideredit_duration=slidereditcontrol_set_value(handles.slideredit_duration,cdur);
	cscale=slidereditcontrol_get_value(handles.slideredit_scale);
	handles.slideredit_scale=slidereditcontrol_set_value(handles.slideredit_scale,cscale);
	if handles.info.current_plot>=6
		handles.currentslidereditcombi=slidereditcontrol_set_range(handles.currentslidereditcombi,10);	% the duration
	else
		handles.currentslidereditcombi=slidereditcontrol_set_range(handles.currentslidereditcombi,cdur);	% the duration
	end
end


% checking for unforseen errors. Can happen in unlucky circumstances:
if handles.info.current_plot>=6 % this should be in frame mode: check limits
	nr_frames=length(handles.data.sai);
	cur_nr=slidereditcontrol_get_value(handles.currentslidereditcombi);
	if cur_nr > nr_frames
		handles.currentslidereditcombi=slidereditcontrol_set_value(handles.currentslidereditcombi,nr_frames);
		handles.currentslidereditcombi=slidereditcontrol_set_range(handles.currentslidereditcombi,10);	% the duration
		framelen=getcurrentframestarttime(handles.data.sai{2})-getcurrentframestarttime(handles.data.sai{1});
		handles.slideredit_duration=slidereditcontrol_set_value(handles.slideredit_duration,nr_frames*framelen);
	end
	handles.currentslidereditcombi.maxvalue=nr_frames;
	handles.currentslidereditcombi.minvalue=1;

else
	stval=slidereditcontrol_get_value(handles.currentslidereditcombi);
	if stval<getminimumtime(sig);
		handles.currentslidereditcombi=slidereditcontrol_set_value(handles.currentslidereditcombi,getminimumtime(sig));
	end
	if stval>getmaximumtime(sig)-0.001;
		handles.currentslidereditcombi=slidereditcontrol_set_value(handles.currentslidereditcombi,getmaximumtime(sig)-0.04);
	end
	handles.slideredit_duration.minvalue=0;
	handles.slideredit_duration.maxvalue=getlength(sig);
	
	durval=slidereditcontrol_get_value(handles.slideredit_duration);
	if durval<0.001
		handles.slideredit_duration=slidereditcontrol_set_value(handles.slideredit_duration,0.001);
	end
	if durval>getlength(sig);
		handles.slideredit_duration=slidereditcontrol_set_value(handles.slideredit_duration,getlength(sig)-stval);
	end
		

end


% set the text over the sliders accordingly

duration=handles.all_options.signal.duration;
start_time=handles.all_options.signal.start_time;
sr=handles.all_options.signal.samplerate;

if duration>1
	set(handles.displayduration,'String',num2str(fround(duration,2)));
	set(handles.text20,'String','sec');
else
	set(handles.displayduration,'String',num2str(fround(duration*1000,0)));
	set(handles.text20,'String','ms');
end
% samplerate
set(handles.text25,'String',num2str(fround(sr/1000,1)));
% offset
if start_time>0
	set(handles.text29,'String',num2str(fround(start_time*1000,1)));
	set(handles.text28,'Visible','on');
	set(handles.text29,'Visible','on');
	set(handles.text30,'Visible','on');
else
	set(handles.text28,'Visible','off');
	set(handles.text29,'Visible','off');
	set(handles.text30,'Visible','off');
end



% if handles.info.current_plot>=6
	

% handles.slideredit_start=slidereditcontrol_set_value(handles.slideredit_start,start_time);
% handles.slideredit_start=slidereditcontrol_set_range(handles.slideredit_start,duration/10);
% 
% handles.slideredit_duration=slidereditcontrol_set_value(handles.slideredit_duration,0.04);
% handles.slideredit_duration.maxvalue=duration;
% handles.slideredit_duration=slidereditcontrol_set_range(handles.slideredit_duration,duration/10);
% 
% handles.currentslidereditcombi=handles.slideredit_start;



