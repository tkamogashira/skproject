% generating function for 'aim-mat'
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




function gen_screen_movie(data,options)
% just produce the movie from the basilar membrane

handles=options.handles;
handles.info.domovie=1;

si=get(0,'ScreenSize');
waithand=waitbar(0,'generating movie');
set(waithand,'Units','Pixel');
si2=get(waithand,'Position');
si2(1)=110;
si2(2)=si(4)-si2(4)-25;
set(waithand,'Position',si2);

moviefilename=options.moviename;
soundfilename=options.soundfilename;
[sounddata,samplerate,bits] = wavread(soundfilename);

oldfig=gcf;
% if there has never been a figure, create a new one
options.figure_handle=figure;
newfig=options.figure_handle;


MakeQTMovie('start',moviefilename);
MakeQTMovie('size', [options.movie_width options.movie_height]);
MakeQTMovie('quality', options.quality);    % reduces the size

% bmm movie
% first get bmm-data
currentdata=data.bmm;
handles=options.handles;
len=getlength(data.signal);
% pic_wide=handles.slideredit_duration.current_value;
pic_wide=options.show_bmm_duration;
handles.slideredit_duration=slidereditcontrol_set_value(handles.slideredit_duration,pic_wide);
mov_len=len-pic_wide;

nr_frames=mov_len*options.physical_frames_per_second;
frame_duration=1/options.physical_frames_per_second;
for ii=1:nr_frames
	waitbar(ii/nr_frames,waithand);

	figure(newfig);
	set(gca,'Position',[0 0.1 0.93 0.9]);
	
    start_time=(ii-1)*frame_duration;
    
    if options.use_nap_instead==0
        handles.info.current_plot=3; % the bmm
    elseif options.use_nap_instead==1
        handles.info.current_plot=4; % the nap
    end        
	if handles.with_graphic==1
		handles.currentslidereditcombi=slidereditcontrol_set_value(handles.currentslidereditcombi,start_time);
%         handles.slideredit_start=slidereditcontrol_set_value(handles.slideredit_start,start_time);
	else
		handles.current_frame_nr=ii;
	end
	
	% plot the graphic with the standard method in the new window:
	handles=aim_replotgraphic(handles,options);
	
	drawnow;
	
	MakeQTMovie('addframe');    % and add it to the movie
end

% put the same picture at the end, so often, till the movie is finished
nr_additional=pic_wide/frame_duration;
for ii=1:nr_additional
    MakeQTMovie('addframe');    % and add it to the movie  
end

% add one, to fill the last picture (the sound is longer than n*nr_frames)
MakeQTMovie('addframe');

% Optional slowmotion of the movie for MIs without sound
MakeQTMovie('framerate',options.shown_frames_per_second);

MakeQTMovie('finish');
MakeQTMovie('cleanup');
figure(oldfig);
close(newfig);

close(waithand);
